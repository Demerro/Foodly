import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

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
                try await cartWorker?.removeCartItem(id: request.id)
                let response = CartModels.RemoveCartItemAction.Response()
                presenter?.presentRemoveFood(response)
            } catch {
                print(error)
            }
        }
    }
    
    func changeCartFoodAmount(_ request: CartModels.ChangeCartItemAmountAction.Request) {
        guard let worker = cartWorker else { return }
        Task {
            do {
                try await worker.changeCartItemAmount(item: request.cartItem, difference: request.difference)
                let updatedCartItem = try await worker.getCartItem(id: request.cartItem.id!)
                
                let response = CartModels.ChangeCartItemAmountAction.Response(
                    indexPath: request.indexPath,
                    updatedCartItem: updatedCartItem
                )
                presenter?.presentCartItemAmountChange(response)
            } catch {
                print(error)
            }
        }
    }
}
