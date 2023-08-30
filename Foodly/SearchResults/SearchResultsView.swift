import UIKit
import SnapKit

final class SearchResultsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        addSubview(tableView)
        addSubview(noResultsFoundView)
        tableView.tableHeaderView = segmentedControl
        
        tableView.snp.makeConstraints { $0.size.equalToSuperview() }
        segmentedControl.snp.makeConstraints { $0.top.centerX.equalToSuperview() }
        noResultsFoundView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-60)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview()
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 120
        tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.identifier)
        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        return tableView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            String(localized: "view.searchResults.segmentedControl.food"),
            String(localized: "view.searchResults.segmentedControl.restaurants")
        ])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor(named: "AccentColor")
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return segmentedControl
    }()
    
    let noResultsFoundView: NoResultsFoundView = {
        let view = NoResultsFoundView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        return view
    }()
    
}
