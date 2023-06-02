import UIKit
import SnapKit

final class FoodCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FoodCategoryCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    func configureView(title: String, color: UIColor, image: UIImage) {
        self.backgroundColor = color.withAlphaComponent(0.2)
        
        titleLabel.text = title
        titleLabel.textColor = color
        
        categoryImageView.image = image
    }
    
    private func setupView() {
        self.layer.cornerRadius = 15
        
        addSubview(titleLabel)
        addSubview(categoryImageView)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        return label
    }()
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
