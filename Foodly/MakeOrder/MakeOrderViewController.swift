import UIKit
import CoreLocation
import MapKit
import Combine

protocol MakeOrderDisplayLogic: AnyObject {
    func displayMakeOrderSuccess(_ viewModel: MakeOrderModels.MakeOrderAction.ViewModelSuccess)
    func displayMakeOrderFailure(_ viewModel: MakeOrderModels.MakeOrderAction.ViewModelFailure)
}

final class MakeOrderViewController: UIViewController {
    
    private let makeOrderView = MakeOrderView()
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var interactor: MakeOrderBusinessLogic?
    
    var cartItems = [CartItem]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        view = makeOrderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = String(localized: "view.makeOrder.title")
        
        makeOrderView.streetTextField.delegate = self
        setupKeyboardObservers()
        setupLocationManager()
        setupToolbar()
        setupButtonAction()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .sink { [weak self] notification in
                self?.keyboardWillShow(notification: notification)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .sink { [weak self] notification in
                self?.keyboardWillHide(notification: notification)
            }
            .store(in: &cancellables)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", primaryAction: UIAction { [view] _ in
            view?.endEditing(true)
        })
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        [makeOrderView.apartmentTextField, makeOrderView.entranceTextField, makeOrderView.floorTextField].forEach {
            $0.inputAccessoryView = toolbar
        }
    }
    
    private func setupButtonAction() {
        makeOrderView.makeOrderButton.addAction(UIAction { [weak self] _ in
            guard
                let self,
                let street = makeOrderView.streetTextField.text,
                let apartment = Int(makeOrderView.apartmentTextField.text ?? ""),
                let entrance = Int(makeOrderView.entranceTextField.text ?? ""),
                let floor = Int(makeOrderView.floorTextField.text ?? "")
            else  {
                return
            }
            
            let request = MakeOrderModels.MakeOrderAction.Request(
                items: cartItems, street: street, apartment: apartment, entrance: entrance, floor: floor
            )
            
            interactor?.makeOrder(request)
        }, for: .touchUpInside)
    }
    
    private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    private func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func setup() {
        let viewController = self
        let interactor = MakeOrderInteractor()
        let presenter = MakeOrderPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MakeOrderViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        makeOrderView.mapView.setRegion(region, animated: true)
        
        geocoder.reverseGeocodeLocation(location) { [makeOrderView] placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarkName = placemarks?.first?.name else { return }
            makeOrderView.streetTextField.text = placemarkName
        }
    }
}

// MARK: - UITextFieldDelegate
extension MakeOrderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - MakeOrderDisplayLogic
extension MakeOrderViewController: MakeOrderDisplayLogic {
    func displayMakeOrderSuccess(_ viewModel: MakeOrderModels.MakeOrderAction.ViewModelSuccess) {
        let title = String(localized: "view.makeOrder.alert.title.success")
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.view.tintColor = UIColor(named: "AccentColor")
        alert.addAction(UIAlertAction(title: String(localized: "view.makeOrder.alert.dismiss"), style: .default) { [weak self] _ in
            DispatchQueue.main.async { self?.navigationController?.popViewController(animated: true) }
        })
        
        self.present(alert, animated: true)
    }
    
    func displayMakeOrderFailure(_ viewModel: MakeOrderModels.MakeOrderAction.ViewModelFailure) {
        let title = String(localized: "view.makeOrder.alert.title.failure")
        let alert = UIAlertController(title: title, message: viewModel.error.localizedDescription, preferredStyle: .alert)
        
        alert.view.tintColor = UIColor(named: "AccentColor")
        alert.addAction(UIAlertAction(title: String(localized: "view.makeOrder.alert.dismiss"), style: .default) { [weak self] _ in
            DispatchQueue.main.async { self?.navigationController?.popViewController(animated: true) }
        })
        
        self.present(alert, animated: true)
    }
}
