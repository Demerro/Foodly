import FirebaseFirestoreSwift

protocol FoodGroupPresentationLogic: AnyObject {
    func presentGetFoodByCategory(_ response: FoodGroupModels.GetFoodAction.Response)
    func presentAddFoodToCart(_ response: FoodGroupModels.AddFoodToCartAction.Response)
}

class FoodGroupPresenter {
    weak var viewController: FoodGroupDisplayLogic?
}

// MARK: - FoodGroupPresentationLogic
extension FoodGroupPresenter: FoodGroupPresentationLogic {
    func presentGetFoodByCategory(_ response: FoodGroupModels.GetFoodAction.Response) {
        do {
            let food = try response.snapshots.map {
                var item = try $0.data(as: Food.self)
                item.documentReference = $0.reference
                item.category = response.foodCategory.name
                
                return item
            }
            
            let viewModel = FoodGroupModels.GetFoodAction.ViewModel(food: food)
            viewController?.displayGetFoodByCategory(viewModel)
        } catch {
            print(error)
        }
    }
    
    func presentAddFoodToCart(_ response: FoodGroupModels.AddFoodToCartAction.Response) {
        let viewModel = FoodGroupModels.AddFoodToCartAction.ViewModel()
        viewController?.displayAddFoodToCart(viewModel)
    }
}
