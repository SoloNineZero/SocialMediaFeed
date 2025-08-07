import Alamofire

final class UserService {
    private let networkManager = NetworkManager.shared
    
    func fetchUsers(completion: @escaping (Result<[User], AFError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/users"
        networkManager.request(url: url, completion: completion)
    }
}
