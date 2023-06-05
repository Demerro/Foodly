import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeFactory = DefaultHomeFactory()
        homeFactory.homeConfigurator = HomeDefaultConfigurator()
        
        let viewControllers = [
            getNavigationController(rootViewController: homeFactory.makeScene())
        ]
        
        setViewControllers(viewControllers, animated: false)
    }
    
    private func getNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        return navController
    }
}
