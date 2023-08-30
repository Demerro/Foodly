import UIKit
import SnapKit

final class CartView: UIView {
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
        
        tableView.snp.makeConstraints { $0.size.equalToSuperview() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createTableViewFooter()
    }
    
    private func createTableViewFooter() {
        let container = UIStackView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150))
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 10
        
        [totalPriceView, mapButton].forEach { container.addArrangedSubview($0) }
        
        let horizontalConstraints: (ConstraintMaker) -> Void = {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        totalPriceView.snp.makeConstraints(horizontalConstraints)
        
        mapButton.snp.makeConstraints {
            horizontalConstraints($0)
            $0.height.equalTo(50)
        }
        
        tableView.tableFooterView = container
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    let totalPriceView: TotalPriceView = {
        let view = TotalPriceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mapButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = String(localized: "view.cart.button.goToMap").uppercased()
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}
