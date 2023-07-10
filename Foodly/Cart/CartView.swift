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
        
        tableView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsSelection = false
        
        return tableView
    }()
}
