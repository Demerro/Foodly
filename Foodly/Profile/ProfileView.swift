import UIKit
import SnapKit
import Kingfisher

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
        container.addSubview(headerChangeImageView)
        
        headerStackView.addArrangedSubview(headerImageView)
        headerStackView.addArrangedSubview(headerNameLabel)
        headerStackView.addArrangedSubview(headerEmailLabel)
        
        headerStackView.snp.makeConstraints {
            $0.center.equalTo(container)
        }
        
        headerImageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
        
        headerChangeImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.trailing.bottom.equalTo(headerImageView)
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
        imageView.kf.indicatorType = .activity
        imageView.image = UIImage(named: "ProfilePlaceholder")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    let headerChangeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.circle")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGroupedBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
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
        stackView.isUserInteractionEnabled = true
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
}
