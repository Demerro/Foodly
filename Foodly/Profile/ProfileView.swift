import UIKit
import SnapKit

final class ProfileView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureTableViewHeader()
    }
    
    private func setupView() {
        self.backgroundColor = .systemGroupedBackground
        
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
    
    private func configureTableViewHeader() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width / 2))
        container.addSubview(headerStackView)
        
        headerStackView.addArrangedSubview(headerImageView)
        headerStackView.addArrangedSubview(headerNameLabel)
        headerStackView.addArrangedSubview(headerEmailLabel)
        
        headerStackView.snp.makeConstraints {
            $0.center.equalTo(container.snp.center)
        }
        
        headerImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        
        tableView.tableHeaderView = container
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ProfilePlaceholder")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let headerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        return label
    }()
    
    let headerEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
}
