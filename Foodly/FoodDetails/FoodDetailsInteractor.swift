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
        let data: [String: Any] = [
            "amount": request.cartItem.amount,
            "foodReference": request.cartItem.food.documentReference!
        ]
        
        Task {
            do {
                try await cart.addDocument(data: data)
            } catch {
                print(error)
            }
            
            let response = FoodDetailsModels.AddToCartAction.Response()
            presenter?.presentFoodAddedToCart(response)
        }
    }
}
