import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewsCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
    }
    
    func configureView(image: UIImage) {
        imageView.image = image
    }
    
    private func setupView() {
        addSubview(imageView)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
}
