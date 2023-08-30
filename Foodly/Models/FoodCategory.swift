import UIKit

struct FoodCategory: Hashable {
    let localizedName: String
    let name: FoodCategoryName
    let color: UIColor
    let image: UIImage
}

enum FoodCategoryName: String, CaseIterable {
    case burgers = "burgers"
    case pizzas = "pizzas"
    case cakes = "cakes"
    case tacos = "tacos"
}
