import UIKit

final class LastOnboardingPageViewController: OnboardingPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.addArrangedSubview(getStartedButton)
        
        getStartedButton.addAction(UIAction { [weak self] _ in
            UserDefaults.standard.setValue(true, forKey: "hasSeenOnboarding")
            
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            navigationController.navigationBar.prefersLargeTitles = true
            self?.view.window?.switchRootViewController(navigationController)
        }, for: .touchUpInside)
    }
    
    private let getStartedButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = String(localized: "view.onboardingPage.button.getStarted")
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .preferredFont(forTextStyle: .title2, compatibleWith: UITraitCollection(legibilityWeight: .bold))
            return outgoing
        }
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}
