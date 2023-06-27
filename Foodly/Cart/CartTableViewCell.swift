import UIKit
import SnapKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {
    
    static let identifier = "CartTableViewCell"
    
    var imageURL: URL! {
        didSet {
            foodImageView.kf.setImage(with: imageURL)
        }
    }
    
    var foodName: String! {
        didSet {
            foodNameLabel.text = foodName
        }
    }
    
    var price: Float! {
        didSet {
            priceLabel.text = "$\(price.formatted())"
        }
    }
    
    var amount: Int! {
        didSet {
            amountLabel.text = amount.formatted()
        }
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
        self.selectionStyle = .none
        self.backgroundColor = .secondarySystemGroupedBackground
        
        textStackView.addArrangedSubview(foodNameLabel)
        textStackView.addArrangedSubview(priceLabel)
        
        buttonsStackView.addArrangedSubview(decreaseButton)
        buttonsStackView.addArrangedSubview(amountLabel)
        buttonsStackView.addArrangedSubview(increaseButton)
        
        addSubview(foodImageView)
        addSubview(textStackView)
        addSubview(buttonsStackView)
        
        foodImageView.snp.makeConstraints {
            $0.height.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(100)
        }
        
        amountLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.leading.equalTo(foodImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(buttonsStackView.snp.leading)
            $0.centerY.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
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
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private let decreaseButton: UIButton = {
        var config = UIButton.Configuration.borderedTinted()
        config.image = UIImage(systemName: "minus")!
        config.buttonSize = .mini
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let increaseButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.image = UIImage(systemName: "plus")!
        config.buttonSize = .mini
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}
