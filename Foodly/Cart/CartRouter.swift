import UIKit

protocol CartRoutingLogic: AnyObject {
    func goToMap(items: [CartItem])
}

final class CartRouter: CartRoutingLogic {
    
    var viewController: UIViewController?
    
    func goToMap(items: [CartItem]) {
        let viewController = MakeOrderViewController()
        viewController.cartItems = items
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
