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
                let query = cart.whereField("foodReference", isEqualTo: request.cartItem.foodReference).limit(to: 1)
                let documents = try await query.getDocuments().documents
                
                if documents.isEmpty {
                    try cart.addDocument(from: request.cartItem)
                } else {
                    let document = try documents.first!.data(as: CartItem.self)
                    let data: [String: Any] = [
                        "amount": document.amount + request.cartItem.amount,
                        "totalPrice": document.totalPrice + request.cartItem.totalPrice
                    ]
                    try await cart.document(document.id!).updateData(data)
                }
            } catch {
                print(error)
            }
            
            let response = FoodDetailsModels.AddToCartAction.Response()
            presenter?.presentFoodAddedToCart(response)
        }
    }
}
