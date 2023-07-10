import FirebaseFirestoreSwift
import FirebaseFirestore

struct CartItem: Codable, Identifiable {
    @DocumentID var id: String?
    var amount: Int
    let totalPrice: Float
    let dateAdded = Date()
    let foodReference: DocumentReference
    var food: Food?
    
    private enum CodingKeys: String, CodingKey {
        case id, amount, totalPrice, dateAdded, foodReference
    }
}
