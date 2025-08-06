import Foundation

final class PostFeedViewModel {
    
    var onPostsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let postService = PostService()
    private let userService = UserService()
    
    private var postsWithAuthors: [PostWithAuthor] = [] {
        didSet { onPostsUpdated?() }
    }
    
    private var users: [User]? {
        didSet { mergePostsAndUsers() }
    }
    
    private var posts: [Post]? {
        didSet { mergePostsAndUsers() }
    }
    
    func fetchData() {
        fetchUsers()
        fetchPosts()
    }
    
    func numberOfPosts() -> Int {
        postsWithAuthors.count
    }
    
    func post(at index: Int) -> PostWithAuthor {
        postsWithAuthors[index]
    }
    
    private func fetchUsers() {
        userService.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    private func fetchPosts() {
        postService.fetchPost { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    private func mergePostsAndUsers() {
        guard let users = users, let posts = posts else { return }
        
        let postsWithAuthors = posts.compactMap { post -> PostWithAuthor? in
            guard let user = users.first(where: { $0.id == post.userId }),
                  let avatarURL = ImageService.shared.fetchURL(for: post.userId) else {
                return nil
            }
            return PostWithAuthor(id: post.id, title: post.title, body: post.body, author: user.name, avatar: avatarURL)
        }
        
        self.postsWithAuthors = postsWithAuthors
        onPostsUpdated?()
    }
}
