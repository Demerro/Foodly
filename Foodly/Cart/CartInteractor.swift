import FirebaseAuth
import FirebaseFirestore

protocol CartBusinessLogic: AnyObject {
    func getCartFood(_ request: CartModels.GetFoodAction.Request)
    func removeCartFood(_ request: CartModels.RemoveFoodAction.Request)
}

class CartInteractor {
    var presenter: CartPresentationLogic?
}

// MARK: - CartBusinessLogic
extension CartInteractor: CartBusinessLogic {
    func getCartFood(_ request: CartModels.GetFoodAction.Request) {
        let userID = Auth.auth().currentUser!.uid
        let cart = Firestore.firestore().collection("users").document(userID).collection("cart").order(by: "dateAdded", descending: true)
        
        Task {
            var products = [CartItem]()
            
            do {
                let cartDocuments = try await cart.getDocuments().documents
                
                for document in cartDocuments {
                    let foodReference = document.data()["foodReference"] as! DocumentReference
                    var food = try await foodReference.getDocument().data(as: Food.self)
                    food.documentReference = foodReference
                    let amount = document.data()["amount"] as! Int
                    
                    products.append(CartItem(id: document.documentID, food: food, amount: amount))
                }
            } catch {
                print(error)
            }
            
            let response = CartModels.GetFoodAction.Response(cartItems: products)
            presenter?.presentCartFood(response)
        }
    }
    
    func removeCartFood(_ request: CartModels.RemoveFoodAction.Request) {
        let userID = Auth.auth().currentUser!.uid
        let cart = Firestore.firestore().collection("users").document(userID).collection("cart")
        
        Task {
            do {
                try await cart.document(request.id).delete()
            } catch {
                print(error)
            }
            
            let response = CartModels.RemoveFoodAction.Response()
            presenter?.presentRemoveFood(response)
        }
    }
}
