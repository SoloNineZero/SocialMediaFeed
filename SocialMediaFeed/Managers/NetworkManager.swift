import Foundation
import Alamofire

/// Сетевйо сервис для запросов с использованием Alamofire.
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    /// Выполняет GET-запрос по URL и декодирует результат в переданный тип `T`.
    ///
    /// - Parameters:
    ///   - url: Строка с адресом запроса.
    ///   - completion: Замыкание с результатом типа `Result<T, AFError>`, где `T` — это ожидаемый тип, соответствующий `Decodable`.
    func request<T: Decodable>(url: String, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
