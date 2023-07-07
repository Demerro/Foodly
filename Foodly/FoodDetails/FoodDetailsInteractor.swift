import FirebaseFirestore
import FirebaseAuth

protocol FoodDetailsBusinessLogic: AnyObject {
    func addFoodToCart(_ request: FoodDetailsModels.AddToCartAction.Request)
}

class FoodDetailsInteractor {
    var presenter: FoodDetailsPresentationLogic?
}

// MARK: - FoodDetailsBusinessLogic
extension FoodDetailsInteractor: FoodDetailsBusinessLogic {
    func addFoodToCart(_ request: FoodDetailsModels.AddToCartAction.Request) {
        let userID = Auth.auth().currentUser!.uid
        let cart = Firestore.firestore().collection("users").document(userID).collection("cart")
        
        Task {
            do {
                try cart.addDocument(from: request.cartItem)
            } catch {
                print(error)
            }
            
            let response = FoodDetailsModels.AddToCartAction.Response()
            presenter?.presentFoodAddedToCart(response)
        }
    }
}
