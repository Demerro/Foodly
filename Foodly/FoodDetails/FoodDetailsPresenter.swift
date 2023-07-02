protocol FoodDetailsPresentationLogic: AnyObject {
    func presentFoodAddedToCart(_ response: FoodDetailsModels.AddToCartAction.Response)
}

class FoodDetailsPresenter {
    weak var viewController: FoodDetailsViewController?
}

// MARK: - FoodDetailsPresentationLogic
extension FoodDetailsPresenter: FoodDetailsPresentationLogic {
    func presentFoodAddedToCart(_ response: FoodDetailsModels.AddToCartAction.Response) {
        let viewModel = FoodDetailsModels.AddToCartAction.ViewModel()
        viewController?.displayFoodAddedToCart(viewModel)
    }
}
