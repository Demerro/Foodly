import Foundation

struct CartModels {
    struct GetCartItemsAction {
        struct Request { }
        
        struct Response {
            let cartItems: [CartItem]
        }
        
        struct ViewModel {
            let cartItems: [CartItem]
        }
    }
    
    struct RemoveCartItemAction {
        struct Request {
            let id: String
        }
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    struct ChangeCartItemAmountAction {
        struct Request {
            let cartItem: CartItem
            let difference: Int
            let indexPath: IndexPath
        }
        
        struct Response {
            let indexPath: IndexPath
            let updatedCartItem: CartItem
        }
        
        struct ViewModel {
            let indexPath: IndexPath
            let updatedCartItem: CartItem
        }
    }
}
