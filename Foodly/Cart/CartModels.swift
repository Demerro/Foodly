struct CartModels {
    struct GetFoodAction {
        struct Request { }
        
        struct Response {
            let cartItems: [CartItem]
        }
        
        struct ViewModel {
            let cartItems: [CartItem]
        }
    }
    
    struct RemoveFoodAction {
        struct Request {
            let id: String
        }
        
        struct Response {}
        
        struct ViewModel {}
    }
}
