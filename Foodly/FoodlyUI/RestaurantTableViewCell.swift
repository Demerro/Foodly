import UIKit
import SnapKit

final class RestaurantTableViewCell: UITableViewCell {
    
    static let identifier = NSStringFromClass(RestaurantTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        badgeContainer.addSubview(badgeLabel)
        [nameLabel, locationLabel, badgeContainer].forEach { stackView.addArrangedSubview($0) }
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().offset(-20)
        }
        
        badgeContainer.snp.makeConstraints {
            $0.size.equalTo(badgeLabel).offset(20)
        }
        
        badgeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configureView(with restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        locationLabel.text = restaurant.location
        
        badgeLabel.text = restaurant.type
        badgeLabel.textColor = restaurant.color
        badgeContainer.backgroundColor = restaurant.color.withAlphaComponent(0.2)
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let badgeContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
