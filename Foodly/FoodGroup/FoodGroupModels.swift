import FirebaseFirestore

struct FoodGroupModels {
    
    struct GetFoodAction {
        struct Request {
            let foodCategory: FoodCategory
        }
        
        struct Response {
            let snapshots: [DocumentSnapshot]
            let foodCategory: FoodCategory
        }
        
        struct ViewModel {
            let food: [Food]
        }
    }
    
    struct AddFoodToCartAction {
        struct Request {
            let food: Food
        }
        
        struct Response {}
        struct ViewModel {}
    }
    
}
