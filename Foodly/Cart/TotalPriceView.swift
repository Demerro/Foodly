import UIKit
import SnapKit

final class TotalPriceView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    func configureView(subtotalPrice: Float, deliveryPrice: Float) {
        subtotalPriceLabel.text = "$\(String(format: "%.2f", subtotalPrice))"
        deliveryPriceLabel.text = "$\(String(format: "%.2f", deliveryPrice))"
        totalPriceLabel.text = "$\(String(format: "%.2f", subtotalPrice + deliveryPrice))"
    }
    
    private func setupView() {
        addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { $0.size.equalToSuperview() }
        
        setupSecondaryRow(title: String(localized: "view.totalPrice.subtotal"), priceLabel: subtotalPriceLabel)
        setupSecondaryRow(title: String(localized: "view.totalPrice.delivery"), priceLabel: deliveryPriceLabel)
        setupPrimaryRow(title: String(localized: "view.totalPrice.total"), priceLabel: totalPriceLabel)
    }
    
    private func setupSecondaryRow(title: String, priceLabel: UILabel) {
        let stackView = createHorizontalStackView()
        let titleLabel = Self.createSecondaryLabel()
        
        titleLabel.text = title
        priceLabel.text = "$\(String(format: "%.2f", 0))"
        [titleLabel, UIView(), priceLabel].forEach { stackView.addArrangedSubview($0) }
        
        verticalStackView.addArrangedSubview(stackView)
    }
    
    private func setupPrimaryRow(title: String, priceLabel: UILabel) {
        let stackView = createHorizontalStackView()
        let titleLabel = Self.createPrimaryLabel()
        
        titleLabel.text = title
        priceLabel.text = "$\(String(format: "%.2f", 0))"
        [titleLabel, UIView(), priceLabel].forEach { stackView.addArrangedSubview($0) }
        
        verticalStackView.addArrangedSubview(stackView)
    }
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let subtotalPriceLabel: UILabel = {
        return createSecondaryLabel()
    }()
    
    private let deliveryPriceLabel: UILabel = {
        return createSecondaryLabel()
    }()
    
    private let totalPriceLabel: UILabel = {
        return createPrimaryLabel()
    }()
    
    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }
    
    private static func createPrimaryLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private static func createSecondaryLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }
    
}
