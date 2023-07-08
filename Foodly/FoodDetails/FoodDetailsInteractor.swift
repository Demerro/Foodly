import FirebaseFirestore
import FirebaseAuth

protocol FoodDetailsBusinessLogic: AnyObject {
    func addFoodToCart(_ request: FoodDetailsModels.AddToCartAction.Request)
}

class FoodDetailsInteractor {
    var cartWorker: CartWorkerLogic?
    var presenter: FoodDetailsPresentationLogic?
}

// MARK: - FoodDetailsBusinessLogic
extension FoodDetailsInteractor: FoodDetailsBusinessLogic {
    func addFoodToCart(_ request: FoodDetailsModels.AddToCartAction.Request) {
        Task {
            do {
                try await cartWorker?.addToCart(item: request.cartItem)
                
                let response = FoodDetailsModels.AddToCartAction.Response()
                presenter?.presentFoodAddedToCart(response)
            } catch {
                print(error)
            }
        }
    }
}
