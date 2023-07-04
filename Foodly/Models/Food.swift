import FirebaseFirestore
import FirebaseFirestoreSwift

struct Food: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let description: String
    let imageURL: String
    let calories: Int
    let price: Float
    var documentReference: DocumentReference?
    
    private enum CodingKeys: String, CodingKey {
        case name, description, imageURL, calories, price
    }
}
