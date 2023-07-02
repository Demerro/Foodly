struct CartModels {
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
