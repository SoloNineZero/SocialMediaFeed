import UIKit

/// Сервис для загрузки изображений по URL с кэшированием и защитой от одновременных повторных загрузок одного и того же изображения.
final class ImageLoaderService {
    
    /// Кэш загруженных изображений, чтобы избежать повторной загрузки.
    private static var cache = NSCache<NSURL, UIImage>()
    
    /// Словарь текущих загрузок (при повторных запросах одного и того же изображения не начинать загрузку заново).
    private static var inProgressRequests: [NSURL: [(UIImage?) -> Void]] = [:]
    
    /// Замок для синхронизации доступа к `inProgressRequests` (предотвращение гонки потоков).
    private static let lock = NSLock() // Защита от гонок

    /// Загружает изображение по URL.
    ///
    /// - Parameters:
    ///   - url: Адрес изображения.
    ///   - completion: Замыкание, вызываемое при завершении загрузки (или извлечении из кэша).
    static func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let nsUrl = url as NSURL

        // 1. Проверка: если изображение уже есть в кэше — сразу возвращаем.
        if let cachedImage = cache.object(forKey: nsUrl) {
            completion(cachedImage)
            return
        }

        lock.lock()
        defer { lock.unlock() }

        // 2. Если изображение уже загружается — добавляет замыкание в очередь.
        if inProgressRequests[nsUrl] != nil {
            inProgressRequests[nsUrl]?.append(completion)
            return
        } else {
            // 3. Если загрузка не начата — создаёт массив для хранения замыканий.
            inProgressRequests[nsUrl] = [completion]
        }

        // 4. Загрузка изображения в фоновом потоке.
        DispatchQueue.global().async {
            var loadedImage: UIImage? = nil

            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                cache.setObject(image, forKey: nsUrl)
                loadedImage = image
            }

            // 5. После завершения загрузки — извлекает и очищает список подписчиков.
            lock.lock()
            let completions = inProgressRequests[nsUrl]
            inProgressRequests[nsUrl] = nil
            lock.unlock()

            // 6. Вызывает все замыкания на главном потоке.
            DispatchQueue.main.async {
                completions?.forEach { $0(loadedImage) }
            }
        }
    }
}
