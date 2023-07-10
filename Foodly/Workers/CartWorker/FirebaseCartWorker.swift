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
    
    func getCartItem(id: String) async throws -> CartItem {
        let document = try await cart.getDocuments().documents.first { $0.documentID == id }!
        var cartItem = try document.data(as: CartItem.self)
        cartItem.food = try await cartItem.foodReference.getDocument(as: Food.self)
        
        return cartItem
    }
    
    func addToCart(item: CartItem) async throws {
        let query = cart.whereField(K.Field.foodReference, isEqualTo: item.foodReference).limit(to: 1)
        let documents = try await query.getDocuments().documents
        
        if documents.isEmpty {
            try cart.addDocument(from: item)
            return
        }
        
        try await changeCartItemAmount(item: item, difference: 1)
    }
    
    func removeCartItem(id: String) async throws {
        try await cart.document(id).delete()
    }
    
    func changeCartItemAmount(item: CartItem, difference: Int) async throws {
        let query = cart.whereField(K.Field.foodReference, isEqualTo: item.foodReference).limit(to: 1)
        let documents = try await query.getDocuments().documents
        
        let _ = try await Firestore.firestore().runTransaction { transaction, errorPointer in
            do {
                let document = documents.first!
                let cartItem = try document.data(as: CartItem.self)
                let newAmount = cartItem.amount + difference
                
                let data: [String: Any] = [
                    K.Field.amount: newAmount,
                    K.Field.totalPrice: item.food!.price * Float(newAmount)
                ]
                
                transaction.updateData(data, forDocument: document.reference)
            } catch let error as NSError {
                errorPointer?.pointee = error
            }
            
            return
        }
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
