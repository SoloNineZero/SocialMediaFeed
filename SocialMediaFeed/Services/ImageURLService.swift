import Foundation
import Alamofire

final class ImageURLService {
    static let shared = ImageURLService()
    
    private init() {}
    
    func fetchURL(for userId: Int) -> URL? {
        URL(string: "https://picsum.photos/seed/\(userId)/50")
    }
}
