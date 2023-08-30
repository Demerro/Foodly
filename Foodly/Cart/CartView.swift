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
        let container = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        container.addSubview(totalPriceView)
        tableView.tableFooterView = container
        totalPriceView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
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
    
}
