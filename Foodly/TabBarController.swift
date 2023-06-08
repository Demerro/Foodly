import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeFactory = DefaultHomeFactory()
        homeFactory.homeConfigurator = HomeDefaultConfigurator()
        
        let viewControllers = [
            getNavigationController(
                rootViewController: homeFactory.makeScene(),
                tabBarItem: UITabBarItem(title: String(localized: "tabBar.title.home"), image: UIImage(systemName: "house"), tag: 0)
            ),
            getNavigationController(
                rootViewController: ProfileViewController(),
                tabBarItem: UITabBarItem(title: String(localized: "tabBar.title.profile"), image: UIImage(systemName: "person"), tag: 0)
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
