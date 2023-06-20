import UIKit

protocol HomeRoutingLogic {
    func routeToFoodDetails()
}

final class HomeRouter {
    
    weak var viewController: UIViewController?
    
    func navigateToFoodDetails(food: Food) {
        let viewController = FoodDetailsViewController()
        let closeButton = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in viewController.dismiss(animated: true) })
        
        viewController.navigationItem.rightBarButtonItem = closeButton
        viewController.food = food
        self.viewController?.present(UINavigationController(rootViewController: viewController), animated: true)
    }
}
