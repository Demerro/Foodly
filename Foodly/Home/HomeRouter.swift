import UIKit

protocol HomeRoutingLogic: AnyObject {
    func routeToFoodDetails(food: Food)
    func routeToFoodGroup(category: FoodCategory)
}

final class HomeRouter: HomeRoutingLogic {
    
    weak var viewController: UIViewController?
    
    func routeToFoodDetails(food: Food) {
        let viewController = FoodDetailsViewController()
        let closeButton = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in viewController.dismiss(animated: true) })
        
        viewController.navigationItem.rightBarButtonItem = closeButton
        viewController.food = food
        self.viewController?.present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    func routeToFoodGroup(category: FoodCategory) {
        let viewController = FoodGroupViewController()
        
        viewController.category = category
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
