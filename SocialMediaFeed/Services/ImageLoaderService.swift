import UIKit

final class ImageLoaderService {
    private static var cache = NSCache<NSURL, UIImage>()
    private static var inProgressRequests: [NSURL: [(UIImage?) -> Void]] = [:]
    private static let lock = NSLock() // Защита от гонок

    static func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let nsUrl = url as NSURL

        // 1. Проверка кэша
        if let cachedImage = cache.object(forKey: nsUrl) {
            completion(cachedImage)
            return
        }

        lock.lock()
        defer { lock.unlock() }

        // 2. Проверяет идёт ли загрузка
        if inProgressRequests[nsUrl] != nil {
            // Если грузится - добавляет completion
            inProgressRequests[nsUrl]?.append(completion)
            return
        } else {
            // Начинает новую загрузку
            inProgressRequests[nsUrl] = [completion]
        }

        // 3. Загружает в фоне
        DispatchQueue.global().async {
            var loadedImage: UIImage? = nil

            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                cache.setObject(image, forKey: nsUrl)
                loadedImage = image
            }

            lock.lock()
            let completions = inProgressRequests[nsUrl]
            inProgressRequests[nsUrl] = nil
            lock.unlock()

            // 4. Вызывает все completion
            DispatchQueue.main.async {
                completions?.forEach { $0(loadedImage) }
            }
        }
    }
}
