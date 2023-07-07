import FirebaseFirestoreSwift
import FirebaseFirestore

struct CartItem: Codable, Identifiable {
    @DocumentID var id: String?
    let amount: Int
    let dateAdded = Date()
    let foodReference: DocumentReference
    var food: Food?
    
    private enum CodingKeys: String, CodingKey {
        case id, amount, dateAdded, foodReference
    }
}
