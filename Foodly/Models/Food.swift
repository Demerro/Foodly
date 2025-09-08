import FirebaseFirestore

struct Food: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let name: String
    let description: String
    let imageURL: String
    let calories: Int
    let price: Float
    var category: FoodCategoryName?
    var documentReference: DocumentReference?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, imageURL, calories, price
    }
}
