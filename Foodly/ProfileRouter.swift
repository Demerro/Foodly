final class ProfileRouter: Router {
    func navigateToPreferences() {
        let preferencesViewController = PreferencesViewController()
        viewController?.navigationController?.pushViewController(preferencesViewController, animated: true)
    }
}
