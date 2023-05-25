import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FoodCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(rectangle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // TODO: Remove inset
        rectangle.frame = self.bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    private let rectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        return view
    }()
}
