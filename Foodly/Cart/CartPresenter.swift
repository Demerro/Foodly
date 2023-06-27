protocol CartPresentationLogic: AnyObject {
    func presentCartFood(_ response: CartModels.FoodAction.Response)
}

class CartPresenter {
    weak var viewController: CartDisplayLogic?
}

// MARK: - CartPresentationLogic
extension CartPresenter: CartPresentationLogic {
    func presentCartFood(_ response: CartModels.FoodAction.Response) {
        let viewModel = CartModels.FoodAction.ViewModel(cartItems: response.cartItems)
        viewController?.displayCartFood(viewModel)
    }
}
