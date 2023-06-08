import UIKit

final class PreferencesViewController: UIViewController {
    
    private var rows = [Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Preferences"
        
        self.view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        addRows()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = self.view.bounds
    }
    
    private func addRows() {
        rows += [
            Row(
                title: String(localized: "view.preferences.tableView.row.accountInformation.title"),
                subtitle: String(localized: "view.preferences.tableView.row.accountInformation.subtitle"),
                image: UIImage(systemName: "person")!,
                handler: { }
            ),
            Row(
                title: String(localized: "view.preferences.tableView.row.password.title"),
                subtitle: String(localized: "view.preferences.tableView.row.password.subtitle"),
                image: UIImage(systemName: "eye")!,
                handler: { }
            ),
            Row(
                title: String(localized: "view.preferences.tableView.row.deliveryLocations.title"),
                subtitle: String(localized: "view.preferences.tableView.row.deliveryLocations.subtitle"),
                image: UIImage(systemName: "mappin.and.ellipse")!,
                handler: { }
            )
        ]
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

// MARK: - UITableViewDataSource
extension PreferencesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let model = rows[indexPath.row]
        var config = cell.defaultContentConfiguration()
        
        config.text = model.title
        config.secondaryText = model.subtitle
        config.image = model.image
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rows[indexPath.row].handler()
    }
}
