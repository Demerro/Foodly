import UIKit

class ForgetPasswordViewController: UIViewController {
    
    private let forgetPasswordView = ForgetPasswordView()
    
    override func loadView() {
        view = forgetPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String(localized: "viewController.forgetPassword.title")
    }
}
