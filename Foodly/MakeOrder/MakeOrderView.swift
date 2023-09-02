import UIKit
import MapKit
import SnapKit

final class MakeOrderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        [apartmentTextField, entranceTextField, floorTextField].forEach { horizontalStackView.addArrangedSubview($0) }
        
        [streetTextField, horizontalStackView, makeOrderButton].forEach { view in
            verticalStackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
            }
        }
        
        [mapView, verticalStackView].forEach { addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(verticalStackView.snp.top).offset(-20)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(4.5)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        makeOrderButton.snp.makeConstraints { $0.height.equalTo(50) }
    }
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let streetTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = UIColor(named: "AccentColor")
        textField.borderStyle = .roundedRect
        textField.placeholder = "Delivery address"
        textField.keyboardType = .alphabet
        return textField
    }()
    
    let apartmentTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = UIColor(named: "AccentColor")
        textField.borderStyle = .roundedRect
        textField.placeholder = "Apartment"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let entranceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = UIColor(named: "AccentColor")
        textField.borderStyle = .roundedRect
        textField.placeholder = "Entrance"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let floorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = UIColor(named: "AccentColor")
        textField.borderStyle = .roundedRect
        textField.placeholder = "Floor"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let makeOrderButton: UIButton = {
        var config = UIButton.Configuration.borderedProminent()
        config.title = "MAKE ORDER"
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}
