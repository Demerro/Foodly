import UIKit
import SnapKit

final class CollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "CollectionViewHeader"
    
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
        
        label.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
    
    func configureView(text: String) {
        label.text = text
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2, compatibleWith: UITraitCollection(legibilityWeight: .bold))
        return label
    }()
}
