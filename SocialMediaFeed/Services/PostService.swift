import Alamofire

/// Сервис для получения данных постов.
final class PostService {
    
    /// Загружает список постов с сервера с поддержкой пагинации.
    ///
    /// - Parameters:
    ///   - page: Номер страницы (начиная с 1), используется для постраничной загрузки данных.
    ///   - limit: Количество постов на одной странице.
    ///   - completion: Замыкание, вызываемое после получения ответа. Возвращает результат с массивом `Post` при успехе или ошибку `AFError` при неудаче.
    func fetchPosts(page: Int, limit: Int, completion: @escaping (Result<[Post], AFError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        let parameters: [String: Any] = [
            "_page": page,
            "_limit": limit
        ]
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: [Post].self) { response in
                completion(response.result)
            }
    }
}
