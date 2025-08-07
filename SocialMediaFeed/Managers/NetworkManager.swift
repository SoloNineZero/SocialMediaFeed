import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(url: String, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
