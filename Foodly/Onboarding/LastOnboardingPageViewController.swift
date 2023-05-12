import UIKit

final class LastOnboardingPageViewController: OnboardingPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.addArrangedSubview(getStartedButton)
    }
    
    private let getStartedButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = String(localized: "view.onboardingPage.button.getStarted")
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .preferredFont(forTextStyle: .title2, compatibleWith: UITraitCollection(legibilityWeight: .bold))
            return outgoing
        }
        
        let button = UIButton(primaryAction: UIAction { _ in
            UserDefaults.standard.setValue(true, forKey: "hasSeenOnboarding")
        })
        button.configuration = config
        
        return button
    }()
}
