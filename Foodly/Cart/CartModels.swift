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
            let indexPath: IndexPath
        }
        
        struct Response {
            let indexPath: IndexPath
        }
        
        struct ViewModel {
            let indexPath: IndexPath
        }
    }
    
    struct ChangeCartItemAmountAction {
        struct Request {
            let cartItem: CartItem
            let difference: Int
            let indexPath: IndexPath
        }
        
        struct Response {
            var error: Error?
            let indexPath: IndexPath
            let difference: Int
        }
        
        struct ViewModelSuccess {}
        
        struct ViewModelFailure {
            let indexPath: IndexPath
            let difference: Int
        }
    }
}
