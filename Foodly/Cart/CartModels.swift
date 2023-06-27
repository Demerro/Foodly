struct CartModels {
    struct CartItem {
        let food: Food
        let amount: Int
    }
    
    struct FoodAction {
        struct Request { }
        
        struct Response {
            let cartItems: [CartItem]
        }
        
        struct ViewModel {
            let cartItems: [CartItem]
        }
    }
}
