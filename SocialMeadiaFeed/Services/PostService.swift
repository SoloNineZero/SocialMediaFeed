import Alamofire

final class PostService {
    let networkManager = NetworkManager.shared
    
    func fetchPost(completion: @escaping (Result<[Post], AFError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        networkManager.request(url: url, completion: completion)
    }
}
