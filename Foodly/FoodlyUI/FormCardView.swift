import UIKit
import SnapKit

final class FormCardView: UIView {
    
    let title: String
    let subtitle: String?
    let image: UIImage
    
    init(title: String, subtitle: String? = nil, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 15
        
        addSubviews()
        configureViews()
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        imageContainerView.snp.makeConstraints {
            $0.width.height.equalTo(self.snp.height).multipliedBy(0.7)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        labelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageContainerView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageContainerView.layer.cornerRadius = imageContainerView.bounds.height / 2
    }
    
    private func addSubviews() {
        imageContainerView.addSubview(imageView)
        addSubview(imageContainerView)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        addSubview(labelStackView)
    }
    
    private func configureViews() {
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "AccentColor")!.withAlphaComponent(0.2)
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
}
