import UIKit
import SnapKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {
    
    static let identifier = NSStringFromClass(CartTableViewCell.self)
    
    var imageURL: String! {
        didSet {
            foodImageView.kf.setImage(with: URL(string: imageURL))
        }
    }
    
    var foodName: String! {
        didSet {
            foodNameLabel.text = foodName
        }
    }
    
    var price: Float! {
        didSet {
            priceLabel.text = String(format: "%.2f", price)
        }
    }
    
    var amount: Int! {
        didSet {
            amountLabel.text = amount.formatted()
        }
    }
    
    var increaseAction: (() -> Void)?
    var decreaseAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .secondarySystemGroupedBackground
        
        [foodNameLabel, priceLabel].forEach { [textStackView] in textStackView.addArrangedSubview($0) }
    
        [foodImageView, textStackView, buttonsStackView].forEach { [contentView] in contentView.addSubview($0) }
        
        foodImageView.snp.makeConstraints {
            $0.height.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(100)
        }
        
        textStackView.snp.makeConstraints {
            $0.leading.equalTo(foodImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(contentView.snp.trailing)
        }
        
        [decreaseButton, amountLabel, increaseButton].forEach { [buttonsStackView] in
            buttonsStackView.addArrangedSubview($0)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        setupButtonActions()
    }
    
    private func setupButtonActions() {
        increaseButton.addAction(UIAction { [weak self] _ in
            self?.increaseAction?()
        }, for: .touchUpInside)
        
        decreaseButton.addAction(UIAction { [weak self] _ in
            self?.decreaseAction?()
        }, for: .touchUpInside)
    }
    
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
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var decreaseButton: UIButton = {
        var config = UIButton.Configuration.borderedTinted()
        config.image = UIImage(systemName: "minus")!
        config.buttonSize = .mini
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var increaseButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.image = UIImage(systemName: "plus")!
        config.buttonSize = .mini
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
}
