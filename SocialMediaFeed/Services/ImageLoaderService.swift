import UIKit

final class ImageLoaderService {
    private static var cache = NSCache<NSURL, UIImage>()
    private static var inProgressRequests: [NSURL: [(UIImage?) -> Void]] = [:]
    private static let lock = NSLock() // Защита от гонок

    static func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let nsUrl = url as NSURL

        // 1. Проверяем кэш
        if let cachedImage = cache.object(forKey: nsUrl) {
            completion(cachedImage)
            return
        }

        lock.lock()
        defer { lock.unlock() }

        // 2. Проверяем, загружается ли уже
        if inProgressRequests[nsUrl] != nil {
            // Уже загружается — просто добавим ещё один completion
            inProgressRequests[nsUrl]?.append(completion)
            return
        } else {
            // Начинаем новую загрузку
            inProgressRequests[nsUrl] = [completion]
        }

        // 3. Загружаем в фоне
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

            // 4. Вызываем все completion'ы
            DispatchQueue.main.async {
                completions?.forEach { $0(loadedImage) }
            }
        }
    }
}
