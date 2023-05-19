import UIKit

class Router {
    
    weak var viewController: UIViewController?
    
    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
