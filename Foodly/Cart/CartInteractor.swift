import FirebaseAuth
import FirebaseFirestore
import os

protocol CartBusinessLogic: AnyObject {
    func getCartFood(_ request: CartModels.FoodAction.Request)
}

class CartInteractor {
    var presenter: CartPresentationLogic?
}

// MARK: - CartBusinessLogic
extension CartInteractor: CartBusinessLogic {
    func getCartFood(_ request: CartModels.FoodAction.Request) {
        let userID = Auth.auth().currentUser!.uid
        let cart = Firestore.firestore().collection("users").document(userID).collection("cart")
        
        Task {
            var products = [CartModels.CartItem]()
            
            do {
                let cartDocuments = try await cart.getDocuments().documents
                
                for document in cartDocuments {
                    let foodReference = document.data()["foodReference"] as! DocumentReference
                    let food = try await foodReference.getDocument().data(as: Food.self)
                    let amount = document.data()["amount"] as! Int
                    
                    products.append(CartModels.CartItem(food: food, amount: amount))
                }
            } catch {
                print(error)
            }
            
            let response = CartModels.FoodAction.Response(cartItems: products)
            presenter?.presentCartFood(response)
        }
    }
}
