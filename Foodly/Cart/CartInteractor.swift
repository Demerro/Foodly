import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CartBusinessLogic: AnyObject {
    func getCartFood(_ request: CartModels.GetFoodAction.Request)
    func removeCartFood(_ request: CartModels.RemoveFoodAction.Request)
}

class CartInteractor {
    var presenter: CartPresentationLogic?
    var cartWorker: CartWorkerLogic?
}

// MARK: - CartBusinessLogic
extension CartInteractor: CartBusinessLogic {
    func getCartFood(_ request: CartModels.GetFoodAction.Request) {
        Task {
            do {
                let cartItems = try await cartWorker?.getCartItems() ?? []
                let response = CartModels.GetFoodAction.Response(cartItems: cartItems)
                presenter?.presentCartFood(response)
            } catch {
                print(error)
            }
        }
    }
    
    func removeCartFood(_ request: CartModels.RemoveFoodAction.Request) {
        Task {
            do {
                try await cartWorker?.removeCartItem(id: request.id)
                let response = CartModels.RemoveFoodAction.Response()
                presenter?.presentRemoveFood(response)
            } catch {
                print(error)
            }
        }
    }
}
