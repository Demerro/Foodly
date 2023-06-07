import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    private let profileView = ProfileView()
    
    private let rows = [
        Row(title: "Customer support", image: UIImage(systemName: "questionmark.circle")!, handler: {})
    ]
    
    override func loadView() {
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        
        profileView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        configureHeader()
    }
    
    private func configureHeader() {
        profileView.headerNameLabel.text = Auth.auth().currentUser!.displayName
        profileView.headerEmailLabel.text = Auth.auth().currentUser!.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
