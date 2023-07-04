protocol CartPresentationLogic: AnyObject {
    func presentCartFood(_ response: CartModels.GetFoodAction.Response)
    func presentRemoveFood(_ response: CartModels.RemoveFoodAction.Response)
}

class CartPresenter {
    weak var viewController: CartDisplayLogic?
}

// MARK: - CartPresentationLogic
extension CartPresenter: CartPresentationLogic {
    func presentCartFood(_ response: CartModels.GetFoodAction.Response) {
        let viewModel = CartModels.GetFoodAction.ViewModel(cartItems: response.cartItems)
        viewController?.displayCartFood(viewModel)
    }
    
    func presentRemoveFood(_ response: CartModels.RemoveFoodAction.Response) {
        let viewModel = CartModels.RemoveFoodAction.ViewModel()
        viewController?.displayRemoveFood(viewModel)
    }
}
