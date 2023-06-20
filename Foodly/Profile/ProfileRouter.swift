import UIKit

protocol ProfileRoutingLogic: AnyObject {
    func navigateToPreferences()
}

final class ProfileRouter: ProfileRoutingLogic {
    
    weak var viewController: UIViewController?
    
    func navigateToPreferences() {
        let preferencesViewController = PreferencesViewController()
        self.viewController?.navigationController?.pushViewController(preferencesViewController, animated: true)
    }
}
