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
    
    /// Создаёт и настраивает UINavigationController с корневым контроллером, заголовком и элементом вкладки.
    ///
    /// - Parameters:
    ///   - vc: UIViewController — корневой контроллер для навигационного контроллера.
    ///   - title: String — заголовок, который будет отображаться в навигационной панели и в таб-баре.
    ///   - icon: String — имя системной иконки (SF Symbols) для элемента таб-бара.
    ///   - tag: Int — числовой идентификатор для элемента таб-бара.
    /// - Returns: UINavigationController, настроенный с указанным корневым контроллером и элементом таб-бара.
    private func setupNavigationController(vc: UIViewController, title: String, icon: String, tag: Int) -> UINavigationController {
        let vc = UINavigationController(rootViewController: vc)
        vc.title = title
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), tag: tag)
        return vc
    }
}
