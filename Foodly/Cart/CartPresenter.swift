protocol CartPresentationLogic: AnyObject {
    func presentCartFood(_ response: CartModels.GetCartItemsAction.Response)
    func presentRemoveFood(_ response: CartModels.RemoveCartItemAction.Response)
    func presentCartItemAmountChange(_ response: CartModels.ChangeCartItemAmountAction.Response)
}

class CartPresenter {
    weak var viewController: CartDisplayLogic?
}

// MARK: - CartPresentationLogic
extension CartPresenter: CartPresentationLogic {
    func presentCartFood(_ response: CartModels.GetCartItemsAction.Response) {
        let viewModel = CartModels.GetCartItemsAction.ViewModel(cartItems: response.cartItems)
        viewController?.displayCartFood(viewModel)
    }
    
    func presentRemoveFood(_ response: CartModels.RemoveCartItemAction.Response) {
        let viewModel = CartModels.RemoveCartItemAction.ViewModel(indexPath: response.indexPath)
        viewController?.displayRemoveFood(viewModel)
    }
    
    func presentCartItemAmountChange(_ response: CartModels.ChangeCartItemAmountAction.Response) {
        let viewModel = CartModels.ChangeCartItemAmountAction.ViewModel(
            indexPath: response.indexPath,
            updatedCartItem: response.updatedCartItem
        )
        viewController?.displayCartItemAmountChange(viewModel)
    }
}
