import UIKit
import SnapKit
import Kingfisher

final class FoodTableViewCell: UITableViewCell {
    
    static let identifier = NSStringFromClass(FoodTableViewCell.self)
    
    var imageURL: String! {
        didSet { foodImageView.kf.setImage(with: URL(string: imageURL)) }
    }
    
    var name: String! {
        didSet { foodNameLabel.text = name }
    }
    
    var price: Float! {
        didSet { priceLabel.text = String(format: "%.2f", price) }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        [foodNameLabel, priceLabel].forEach { [textStackView] in textStackView.addArrangedSubview($0) }
        [foodImageView, textStackView].forEach { [horizontalStackView] in horizontalStackView.addArrangedSubview($0) }
        contentView.addSubview(horizontalStackView)
        
        foodImageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.size.equalToSuperview().offset(-20)
            $0.center.equalToSuperview()
        }
    }
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        
        return imageView
    }()
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
}
