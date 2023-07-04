import FirebaseFirestoreSwift

struct CartItem: Identifiable {
    var id: String?
    let food: Food
    let amount: Int
}
