import Foundation

final class PostFeedViewModel {
    
    var onPostsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private var currentPage = 1
    private let pagePostSize = 20
    private var isLoadingPage = false
    private var canLoadMorePages = true
    
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
//        fetchPosts()
    }
    
    func numberOfPosts() -> Int {
        postsWithAuthors.count
    }
    
    func post(at index: Int) -> PostWithAuthor {
        postsWithAuthors[index]
    }
    
//    private func fetchUsers() {
//        userService.fetchUsers { [weak self] result in
//            switch result {
//            case .success(let users):
//                self?.users = users
//            case .failure(let error):
//                self?.onError?(error)
//            }
//        }
//    }
    
    private func fetchUsers() {
        userService.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.fetchPosts(page: 1) // первая страница после загрузки пользователей
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
//    private func fetchPosts() {
//        postService.fetchPost { [weak self] result in
//            switch result {
//            case .success(let posts):
//                self?.posts = posts
//            case .failure(let error):
//                self?.onError?(error)
//            }
//        }
//    }
    
    func fetchPosts(page: Int = 1) {
        guard !isLoadingPage, canLoadMorePages else { return }
        isLoadingPage = true
        
        postService.fetchPosts(page: page, limit: pagePostSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingPage = false
            
            switch result {
            case .success(let newPosts):
                if newPosts.count < self.pagePostSize {
                    self.canLoadMorePages = false
                }
                
                if page == 1 {
                    self.posts = newPosts
                } else {
                    self.posts? += newPosts
                }
                
                self.currentPage = page + 1
                
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard currentIndex >= (postsWithAuthors.count - 5) else { return }
        fetchPosts(page: currentPage)
    }
    
    private func mergePostsAndUsers() {
        guard let users = users, let posts = posts else { return }
        
        let postsWithAuthors = posts.compactMap { post -> PostWithAuthor? in
            guard let user = users.first(where: { $0.id == post.userId }),
                  let avatarURL = ImageURLService.shared.fetchURL(for: post.userId) else {
                return nil
            }
            return PostWithAuthor(id: post.id, title: post.title, body: post.body, author: user.name, avatar: avatarURL)
        }
        
        self.postsWithAuthors = postsWithAuthors
    }
}
