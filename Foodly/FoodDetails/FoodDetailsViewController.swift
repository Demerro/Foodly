import UIKit

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
    
    override func loadView() {
        self.view = foodDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodDetailsView.stepper.delegate = self
    }
}

extension FoodDetailsViewController: StepperDelegate {
    func valueDidChange(_ value: Int) {
        foodDetailsView.priceView.value = Float(value) * food.price
    }
}
