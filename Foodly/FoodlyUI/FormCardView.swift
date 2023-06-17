import UIKit
import SnapKit

final class FormCardView: UIView {
    
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .secondarySystemGroupedBackground
        configureCorners()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .secondarySystemGroupedBackground
        configureCorners()
        addSubviews()
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageContainerView.layer.cornerRadius = imageContainerView.bounds.height / 2
    }
    
    private func configureCorners() {
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 15
    }
    
    private func addSubviews() {
        imageContainerView.addSubview(imageView)
        addSubview(imageContainerView)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        addSubview(labelStackView)
    }
    
    private func addConstraints() {
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
        view.layer.cornerCurve = .continuous
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
