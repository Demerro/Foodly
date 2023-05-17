import UIKit

class RegisterViewController: UIViewController {
    
    private let registerView = RegisterView()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String(localized: "viewController.register.title")
    }
}
