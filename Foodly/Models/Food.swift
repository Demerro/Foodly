import FirebaseFirestore
import FirebaseFirestoreSwift

struct Food: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let description: String
    let imageURL: String
    let calories: Int
    let price: Float
    var category: FoodCategory?
    var documentReference: DocumentReference?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, imageURL, calories, price
    }
}
