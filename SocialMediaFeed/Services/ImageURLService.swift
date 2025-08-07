import Foundation
import Alamofire

/// Сервис для генерации URL аватарок пользователей.
final class ImageURLService {
    static let shared = ImageURLService()
    
    private init() {}
    
    /// Генерирует URL изображения (аватара) для заданного `userId`.
    ///
    /// - Parameter userId: Уникальный идентификатор пользователя.
    /// - Returns: Сформированный URL изображения размером 50x50, или `nil`, если строка URL некорректна.
    func fetchURL(for userId: Int) -> URL? {
        URL(string: "https://picsum.photos/seed/\(userId)/50")
    }
}
