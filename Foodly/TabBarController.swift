import UIKit

enum Page: Int {
    case home = 0
    case cart = 1
    case profile = 2
}

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeFactory = DefaultHomeFactory()
        homeFactory.homeConfigurator = HomeDefaultConfigurator()
        
        let viewControllers = [
            getNavigationController(
                rootViewController: homeFactory.makeScene(),
                tabBarItem: UITabBarItem(title: String(localized: "tabBar.title.home"), image: UIImage(systemName: "house"), tag: Page.home.rawValue)
            ),
            getNavigationController(
                rootViewController: CartViewController(),
                tabBarItem: UITabBarItem(title: String(localized: "tabBar.title.cart"), image: UIImage(systemName: "cart"), tag: Page.cart.rawValue)
            ),
            getNavigationController(
                rootViewController: ProfileViewController(),
                tabBarItem: UITabBarItem(title: String(localized: "tabBar.title.profile"), image: UIImage(systemName: "person"), tag: Page.profile.rawValue)
            )
        ]
        
        setViewControllers(viewControllers, animated: false)
    }
    
    private func getNavigationController(rootViewController: UIViewController, tabBarItem: UITabBarItem) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = tabBarItem
        return navController
    }
}
