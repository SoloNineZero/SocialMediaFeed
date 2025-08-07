import UIKit

final class PostFeedVC: UIViewController {

    // MARK: - Private properties
    private let viewModel = PostFeedViewModel()
    private var isLoading = true
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.register(ShimmerPostCell.self, forCellReuseIdentifier: ShimmerPostCell.reuseIdentifier)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Лента постов"
        setupSubviews()
        setupConstraints()
        bindViewModel()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.fetchData()
//
//        viewModel.onPostsUpdated = { [weak self] in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                self?.tableView.reloadData()
//            }
//        }
//        
//        viewModel.onError = { error in
//            print("Ошибка \(error.localizedDescription)")
//        }
        
        viewModel.onPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing() // <--- здесь останавливаем refresh
            }
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing() // останавливаем и при ошибке
                print("Ошибка \(error.localizedDescription)")
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc
    private func handleRefresh() {
        viewModel.reloadPosts()
    }
}

// MARK: - UITableViewDataSource
extension PostFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isLoading ? 5 : viewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShimmerPostCell.reuseIdentifier, for: indexPath) as? ShimmerPostCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as? PostCell else { return UITableViewCell() }
            let post = viewModel.post(at: indexPath.row)
            cell.configure(post: post)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextPageIfNeeded(currentIndex: indexPath.row)
    }
}

// MARK: - UITableViewDelegate
extension PostFeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

