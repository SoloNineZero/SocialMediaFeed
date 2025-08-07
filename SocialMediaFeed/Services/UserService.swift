import Alamofire

/// Сервис для получения данных пользователей.
final class UserService {
    private let networkManager = NetworkManager.shared
    
    /// Загружает список пользователей с сервера.
    ///
    /// - Parameter completion: Замыкание, вызываемое после получения ответа.
    ///   Возвращает результат с массивом `User` при успехе или ошибку `AFError` при неудаче.
    func fetchUsers(completion: @escaping (Result<[User], AFError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/users"
        networkManager.request(url: url, completion: completion)
    }
}
