import Foundation

/// ViewModel, который отвечает за получение и подготовку данных постов с авторами.
/// Реализует пагинацию и обновление данных.
final class PostFeedViewModel {
    
    /// Замыкание, вызываемое при обновлении списка постов (для обновления UI)
    var onPostsUpdated: (() -> Void)?
    
    /// Коллбэк, вызываемый при ошибках загрузки (для отображения ошибки)
    var onError: ((Error) -> Void)?
    
    /// Размер страницы — сколько постов загружается за один запрос
    private let pagePostSize = 20
    
    /// Текущая странциа
    private var currentPage = 1
    
    /// Флаг, что загрузка сейчас в процессе (чтобы не запускать несколько запросов одновременно)
    private var isLoadingPage = false
    
    /// Флаг, что есть посты для загрузки
    private var canLoadMorePages = true
    
    private let postService = PostService()
    private let userService = UserService()
    
    /// Массив постов с данными авторов
    private var postsWithAuthors: [PostWithAuthor] = [] {
        didSet { onPostsUpdated?() }
    }
    
    /// Массив пользователей
    private var users: [User]? {
        didSet { mergePostsAndUsers() }
    }
    
    /// Массив постов
    private var posts: [Post]? {
        didSet { mergePostsAndUsers() }
    }
    
    /// Перезагружает все посты — сбрасывает состояние пагинации и загружает заново.
    func reloadPosts() {
        currentPage = 1
        canLoadMorePages = true
        postsWithAuthors = []
        fetchData()
    }
    
    /// Начинает загрузку данных: сначала пользователей, потом постов
    func fetchData() {
        fetchUsers()
    }
    
    /// Возвращает количество постов.
    func numberOfPosts() -> Int {
        postsWithAuthors.count
    }
    
    /// Возвращает пост с авторами по индексу.
    func post(at index: Int) -> PostWithAuthor {
        postsWithAuthors[index]
    }
    
    /// Загружает пользователей из сети
    private func fetchUsers() {
        userService.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.fetchPosts(page: 1)
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
        
    /// Загружает посты с сервера с пагинацией.
    func fetchPosts(page: Int = 1) {
        guard !isLoadingPage, canLoadMorePages else { return }
        isLoadingPage = true // Загрузка идёт.
        
        postService.fetchPosts(page: page, limit: pagePostSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingPage = false // Загрузка закончилась.
            
            switch result {
            case .success(let newPosts):
                if newPosts.count < self.pagePostSize {
                    self.canLoadMorePages = false
                }
                
                if page == 1 {
                    // Если первая страница — заменяет посты
                    self.posts = newPosts
                } else {
                    // Если следующая страница — добавляет новые посты к старым
                    self.posts? += newPosts
                }
                
                // Увеличивает номер страницы для следующей загрузки
                self.currentPage = page + 1
                
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    /// Проверяет, нужно ли загружать следующую страницу, исходя из текущей позиции
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard currentIndex >= (postsWithAuthors.count - 5) else { return }
        fetchPosts(page: currentPage)
    }
    
    /// Объединяет посты и пользователей в один массив `postsWithAuthors`, чтобы отображать авторов, посты и аватарки
    private func mergePostsAndUsers() {
        guard let users = users, let posts = posts else { return }
        
        let postsWithAuthors = posts.compactMap { post -> PostWithAuthor? in
            guard let user = users.first(where: { $0.id == post.userId }),
                  let avatarURL = ImageURLService.shared.fetchURL(for: post.userId) else {
                return nil
            }
            return PostWithAuthor(id: post.id, title: post.title, body: post.body, author: user.name, avatar: avatarURL)
        }
        
        // Обновляет массив
        self.postsWithAuthors = postsWithAuthors
    }
}
