import UIKit
import SnapKit

final class PriceView: UIView {
    
    let integerFont: UIFont = .preferredFont(forTextStyle: .largeTitle, compatibleWith: UITraitCollection(legibilityWeight: .bold))
    let decimalFont: UIFont = .preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))
    
    var value: Float = 0 {
        didSet {
            label.text = "\(value)"
            makePriceText(integerFont: integerFont, decimalFont: decimalFont)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        addSubview(label)
        
        self.snp.makeConstraints {
            $0.size.equalTo(label)
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func makePriceText(integerFont: UIFont, decimalFont: UIFont) {
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
        label.attributedText = integer
    }
}
