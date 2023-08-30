import FirebaseFirestoreSwift
import FirebaseFirestore

struct CartItem: Codable, Identifiable {
    @DocumentID var id: String?
    var amount: Int
    var oneItemPrice: Float
    var totalPrice: Float { Float(amount) * oneItemPrice }
    let dateAdded = Date()
    let foodReference: DocumentReference
    var food: Food?
    
    private enum CodingKeys: String, CodingKey {
        case id, amount, oneItemPrice, dateAdded, foodReference
    }
}
