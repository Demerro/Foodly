import UIKit
import SnapKit

protocol StepperDelegate: AnyObject {
    func valueDidChange(_ value: Int)
}

final class Stepper: UIView {
    
    var delegate: StepperDelegate?
    
    var value: Int = 1 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }
    
    var isPositiveOnly = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        valueLabel.text = "\(value)"
        
        stackView.addArrangedSubview(decreaseButton)
        stackView.addArrangedSubview(leftDivider)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(rightDivider)
        stackView.addArrangedSubview(increaseButton)
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        decreaseButton.snp.makeConstraints {
            $0.width.equalTo(increaseButton)
        }
        
        increaseButton.snp.makeConstraints {
            $0.width.equalTo(decreaseButton)
        }
        
        [leftDivider, rightDivider].forEach { $0.snp.makeConstraints(dividerConstraints) }
        
        setupButtonActions()
    }
    
    private let dividerConstraints: (ConstraintMaker) -> Void = {
        $0.width.equalTo(1)
        $0.height.equalToSuperview().offset(-15)
    }
    
    private func setupButtonActions() {
        decreaseButton.addAction(UIAction { [weak self] _ in
            guard let self = self,
                  !(isPositiveOnly && value == 1)
            else {
                return
            }
            
            value -= 1
            delegate?.valueDidChange(value)
        }, for: .touchUpInside)
        
        increaseButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            value += 1
            delegate?.valueDidChange(value)
        }, for: .touchUpInside)
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        stackView.layer.cornerCurve = .continuous
        stackView.layer.cornerRadius = 10
        stackView.layer.borderColor = UIColor.separator.cgColor
        stackView.layer.borderWidth = 1
        
        return stackView
    }()
    
    private let decreaseButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "minus")
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let increaseButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus")
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let leftDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
    private let rightDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
}
