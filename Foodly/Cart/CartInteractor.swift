import Firebase

protocol CartBusinessLogic: AnyObject {
    func getCartFood(_ request: CartModels.GetCartItemsAction.Request)
    func removeCartFood(_ request: CartModels.RemoveCartItemAction.Request)
    func changeCartFoodAmount(_ request: CartModels.ChangeCartItemAmountAction.Request)
}

class CartInteractor {
    var presenter: CartPresentationLogic?
    var cartWorker: CartWorkerLogic?
}

// MARK: - CartBusinessLogic
extension CartInteractor: CartBusinessLogic {
    func getCartFood(_ request: CartModels.GetCartItemsAction.Request) {
        Task {
            do {
                let cartItems = try await cartWorker?.getCartItems() ?? []
                let response = CartModels.GetCartItemsAction.Response(cartItems: cartItems)
                presenter?.presentCartFood(response)
            } catch {
                print(error)
            }
        }
    }
    
    func removeCartFood(_ request: CartModels.RemoveCartItemAction.Request) {
        Task {
            do {
                try await cartWorker?.removeCartItem(id: request.cartItem.id!)
                let response = CartModels.RemoveCartItemAction.Response(
                    indexPath: request.indexPath,
                    cartItem: request.cartItem
                )
                presenter?.presentRemoveFood(response)
            } catch {
                print(error)
            }
        }
    }
    
    func changeCartFoodAmount(_ request: CartModels.ChangeCartItemAmountAction.Request) {
        Task {
            let response: CartModels.ChangeCartItemAmountAction.Response
            
            do {
                try await cartWorker?.changeCartItemAmount(item: request.cartItem, difference: request.difference)
                response = CartModels.ChangeCartItemAmountAction.Response(
                    indexPath: request.indexPath,
                    difference: request.difference
                )
            } catch {
                print(error)
                response = CartModels.ChangeCartItemAmountAction.Response(
                    error: error,
                    indexPath: request.indexPath,
                    difference: request.difference
                )
            }
            
            presenter?.presentCartItemAmountChange(response)
        }
    }
}
