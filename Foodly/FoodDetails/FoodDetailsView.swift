import UIKit
import SnapKit

final class FoodDetailsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(named: "SecondaryColor")!
        
        caloriesStackView.addArrangedSubview(caloriesImageView)
        caloriesStackView.addArrangedSubview(caloriesLabel)
        
        priceStackView.addArrangedSubview(priceView)
        priceStackView.addArrangedSubview(stepper)
        
        stackView.addArrangedSubview(foodLabel)
        stackView.addArrangedSubview(caloriesStackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(foodDescriptionLabel)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(priceStackView)
        stackView.addArrangedSubview(addToCartButton)
        
        foodContainer.addSubview(stackView)
        
        addSubview(foodContainer)
        addSubview(foodImageView)
        
        foodContainer.snp.makeConstraints {
            $0.width.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        foodImageView.snp.makeConstraints {
            $0.size.equalTo(250)
            $0.centerY.equalTo(foodContainer.snp.top).offset(-50)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(foodImageView.snp.bottom)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        [priceStackView, addToCartButton].forEach { $0.snp.makeConstraints(widthHeightConstraints) }
    }
    
    private let widthHeightConstraints: (ConstraintMaker) -> Void = {
        $0.width.equalToSuperview()
        $0.height.equalTo(50)
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let foodContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    private let caloriesStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let foodImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let foodLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = String(localized: "view.foodDetails.label.foodDescription")
        
        return label
    }()
    
    let foodDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private let caloriesImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "flame.fill")!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let caloriesLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    let priceView: PriceView = {
        let view = PriceView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let stepper: Stepper = {
        let stepper = Stepper()
        
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.isPositiveOnly = true
        
        return stepper
    }()
    
    let addToCartButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = String(localized: "view.foodDetails.button.addToCart").uppercased()
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}
