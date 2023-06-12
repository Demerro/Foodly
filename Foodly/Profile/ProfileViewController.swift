import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displayUserProfileImage(_ viewModel: ProfileModels.GetUserProfileImageAction.ViewModel)
    func displayUserName(_ viewModel: ProfileModels.UserNameAction.ViewModel)
    func displayUserEmail(_ viewModel: ProfileModels.UserEmailAction.ViewModel)
    func displayLogout(_ viewModel: ProfileModels.LogoutAction.ViewModel)
}

final class ProfileViewController: UIViewController {
    
    private let profileView = ProfileView()
    private let imagePicker = UIImagePickerController()
    private var interactor: ProfileBusinessLogic?
    private var router: ProfileRouter?
    private var rows = [Row]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        
        profileView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        configureHeader()
        addRows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureHeader() {
        interactor?.getUserProfileImage(ProfileModels.GetUserProfileImageAction.Request())
        interactor?.getUserName(ProfileModels.UserNameAction.Request())
        interactor?.getUserEmail(ProfileModels.UserEmailAction.Request())
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap))
        profileView.headerStackView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func addRows() {
        rows += [
            Row(
                title: String(localized: "view.profile.tableView.row.preferences"),
                image: UIImage(systemName: "gearshape")!,
                handler: { [router] in router?.navigateToPreferences() }
            ),
            Row(
                title: String(localized: "view.profile.tableView.row.logout"),
                image: UIImage(systemName: "rectangle.portrait.and.arrow.right")!,
                handler: { [interactor] in interactor?.logout(ProfileModels.LogoutAction.Request()) }
            )
        ]
    }
    
    private func setup() {
        let viewController = self
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    @objc private func handleHeaderTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: profileView.headerStackView)
        if profileView.headerImageView.frame.contains(location) || profileView.headerChangeImageView.frame.contains(location) {
            self.present(imagePicker, animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let model = rows[indexPath.row]
        var config = cell.defaultContentConfiguration()
        
        config.text = model.title
        config.image = model.image
        
        cell.contentConfiguration = config
        
        if indexPath.row != rows.count - 1 {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rows[indexPath.row].handler()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        profileView.headerImageView.image = image
        
        let request = ProfileModels.SetUserProfileImageAction.Request(image: image)
        interactor?.setUserProfileImage(request)
        
        self.dismiss(animated: true)
    }
}

// MARK: - ProfileDisplayLogic
extension ProfileViewController: ProfileDisplayLogic {
    func displayUserProfileImage(_ viewModel: ProfileModels.GetUserProfileImageAction.ViewModel) {
        profileView.headerImageView.kf.setImage(with: viewModel.imageURL)
    }
    
    func displayUserName(_ viewModel: ProfileModels.UserNameAction.ViewModel) {
        profileView.headerNameLabel.text = viewModel.name
    }
    
    func displayUserEmail(_ viewModel: ProfileModels.UserEmailAction.ViewModel) {
        profileView.headerEmailLabel.text = viewModel.email
    }
    
    func displayLogout(_ viewModel: ProfileModels.LogoutAction.ViewModel) {
        self.view.window?.switchRootViewController(LoginViewController())
    }
}
