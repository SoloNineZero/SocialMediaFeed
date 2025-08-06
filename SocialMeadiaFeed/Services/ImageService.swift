import Foundation
import Alamofire

final class ImageService {
    static let shared = ImageService()
    
    private init() {}
    
    func fetchURL(for userId: Int) -> URL? {
        URL(string: "https://picsum.photos/seed/\(userId)/50")
    }
}
