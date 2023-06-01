import UIKit
import SnapKit
import Kingfisher

final class FoodCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FoodCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(cartButton)
        
        rootStackView.addArrangedSubview(nameLabel)
        rootStackView.addArrangedSubview(priceStackView)
        
        backgroundContainerView.addSubview(rootStackView)
        addSubview(backgroundContainerView)
        addSubview(foodImageView)
        
        backgroundContainerView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.6)
            $0.width.equalToSuperview()
        }
        
        foodImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.centerY.equalTo(backgroundContainerView.snp.top).offset(-25)
            $0.width.height.equalTo(150)
        }
        
        rootStackView.snp.makeConstraints {
            $0.top.equalTo(foodImageView.snp.bottom)
            $0.leading.equalTo(backgroundContainerView).offset(10)
            $0.bottom.trailing.equalTo(backgroundContainerView).offset(-10)
        }
    }
    
    func configure(imageURL: URL?, name: String, price: Float) {
        foodImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "fork.knife"))
        nameLabel.text = name
        priceLabel.attributedText = makePriceText(
            value: price,
            integerFont: .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold)),
            decimalFont: .preferredFont(forTextStyle: .callout, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        )
    }
    
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSAttributedString()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cartButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.image = UIImage(systemName: "cart")
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func makePriceText(value: Float, integerFont: UIFont, decimalFont: UIFont) -> NSAttributedString {
        let stringPrice = String(format: "%.2f", value)
        let dotIndex = stringPrice.range(of: ".")!.upperBound
        
        let integer = NSMutableAttributedString(
            string: "$\(stringPrice[..<dotIndex])",
            attributes: [
                .font: integerFont,
                .foregroundColor: UIColor.label
            ]
        )
        
        let decimal = NSAttributedString(
            string: "\(stringPrice[dotIndex...])",
            attributes: [
                .font: decimalFont,
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        
        integer.append(decimal)
        return integer
    }
}
