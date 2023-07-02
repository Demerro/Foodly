import UIKit

protocol FoodDetailsDisplayLogic: AnyObject {
    func displayFoodAddedToCart(_ viewModel: FoodDetailsModels.AddToCartAction.ViewModel)
}

final class FoodDetailsViewController: UIViewController {
    
    var food: Food! {
        didSet {
            foodDetailsView.foodImageView.kf.setImage(with: URL(string: food.imageURL))
            foodDetailsView.foodLabel.text = food.name
            foodDetailsView.foodDescriptionLabel.text = food.description
            foodDetailsView.caloriesLabel.text = String(localized: "view.foodDetails.label.foodCalories.\(food.calories)")
            foodDetailsView.priceView.value = food.price
        }
    }
    
    private let foodDetailsView = FoodDetailsView()
    private var interactor: FoodDetailsBusinessLogic?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        self.view = foodDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodDetailsView.stepper.delegate = self
        
        foodDetailsView.addToCartButton.addAction(UIAction { [weak self] _ in
            self?.addToCart()
        }, for: .touchUpInside)
    }
    
    private func setup() {
        let viewController = self
        let interactor = FoodDetailsInteractor()
        let presenter = FoodDetailsPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func addToCart() {
        let cartItem = CartItem(food: food, amount: foodDetailsView.stepper.value)
        let request = FoodDetailsModels.AddToCartAction.Request(cartItem: cartItem)
        interactor?.addFoodToCart(request)
    }
}

// MARK: - StepperDelegate
extension FoodDetailsViewController: StepperDelegate {
    func valueDidChange(_ value: Int) {
        foodDetailsView.priceView.value = Float(value) * food.price
    }
}

// MARK: - FoodDetailsDisplayLogic
extension FoodDetailsViewController: FoodDetailsDisplayLogic {
    func displayFoodAddedToCart(_ viewModel: FoodDetailsModels.AddToCartAction.ViewModel) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
