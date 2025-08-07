import UIKit

final class MainTabBar: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Setup
    private func setupTabBar() {
        viewControllers = [
            setupNavigationController(
                vc: PostFeedVC(),
                title: "Лента",
                icon: "list.bullet",
                tag: 0
            ),
            setupNavigationController(
                vc: FavoritePostVC(),
                title: "Избранное",
                icon: "heart",
                tag: 1
            )
        ]
    }
    
    private func setupNavigationController(vc: UIViewController, title: String, icon: String, tag: Int) -> UINavigationController {
        let vc = UINavigationController(rootViewController: vc)
        vc.title = title
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), tag: tag)
        return vc
    }
}
