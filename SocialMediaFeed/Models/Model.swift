import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct User: Decodable {
    let id: Int
    let name: String
}

struct PostWithAuthor {
    let id: Int
    let title: String
    let body: String
    let author: String
    let avatar: Data
}
