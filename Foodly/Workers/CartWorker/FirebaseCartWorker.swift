import FirebaseFirestore
import FirebaseAuth

struct FirebaseCartWorker: CartWorkerLogic {
    
    private let cart = Firestore.firestore()
        .collection(K.Collection.users)
        .document(Auth.auth().currentUser!.uid)
        .collection(K.Collection.cart)
    
    func getCartItems() async throws -> [CartItem] {
        let orderedCart = cart.order(by: K.Field.dateAdded, descending: true)
        var products = [CartItem]()
        
        let cartDocuments = try await orderedCart.getDocuments().documents
        for document in cartDocuments {
            var item = try document.data(as: CartItem.self)
            item.food = try await item.foodReference.getDocument(as: Food.self)
            products.append(item)
        }
        
        return products
    }
    
    func addToCart(item: CartItem) async throws {
        let query = cart.whereField(K.Field.foodReference, isEqualTo: item.foodReference).limit(to: 1)
        let documents = try await query.getDocuments().documents
        
        if documents.isEmpty {
            try cart.addDocument(from: item)
            return
        }
        
        let _ = try await Firestore.firestore().runTransaction { transaction, errorPointer in
            do {
                let document = documents.first!
                let cartItem = try document.data(as: CartItem.self)
                
                let data: [String: Any] = [
                    K.Field.amount: cartItem.amount + item.amount,
                    K.Field.totalPrice: cartItem.totalPrice + item.totalPrice
                ]
                
                transaction.updateData(data, forDocument: document.reference)
            } catch let error as NSError {
                errorPointer?.pointee = error
            }
            
            return
        }
    }
    
    func removeCartItem(id: String) async throws {
        try await cart.document(id).delete()
    }
    
    // MARK: - Constants
    struct K {
        struct Collection {
            static let users = "users"
            static let cart = "cart"
        }
        
        struct Field {
            static let dateAdded = "dateAdded"
            static let foodReference = "foodReference"
            static let amount = "amount"
            static let totalPrice = "totalPrice"
        }
    }
}
