import UIKit
import SnapKit

final class OnboardingViewController: UIPageViewController {

    private let pages: [UIViewController] = [
        OnboardingPageViewController(
            image: UIImage(named: "WavyBuddiesChoosingFood")!,
            title: String(localized: "view.onboardingPage.title.0"),
            subtitle: String(localized: "view.onboardingPage.subtitle.0")
        ),
        OnboardingPageViewController(
            image: UIImage(named: "WavyBuddiesDeliveryOnTheWay")!,
            title: String(localized: "view.onboardingPage.title.1"),
            subtitle: String(localized: "view.onboardingPage.subtitle.1")
        ),
        LastOnboardingPageViewController(
            image: UIImage(named: "WavyBuddiesDelivering")!,
            title: String(localized: "view.onboardingPage.title.2"),
            subtitle: String(localized: "view.onboardingPage.subtitle.2")
        )
    ]
    
    private let initialPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        delegate = self
        dataSource = self
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview().multipliedBy(0.95)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.top.equalTo(skipButton.snp.top)
            $0.bottom.equalTo(skipButton.snp.bottom)
        }
    }
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPageIndicatorTintColor = UIColor(named: "AccentColor")
        pageControl.pageIndicatorTintColor = .lightGray
        
        return pageControl
    }()
    
    private let skipButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = String(localized: "view.onboarding.button.skip")
        
        let button = UIButton(primaryAction: UIAction { _ in
            UserDefaults.standard.setValue(true, forKey: "hasSeenOnboarding")
        })
        button.configuration = config
        
        return button
    }()
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        return currentIndex != 0 ? pages[currentIndex - 1] : nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        return currentIndex != pages.count - 1 ? pages[currentIndex + 1] : nil
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}
