import Foundation
import UIKit

struct ProfileModels {
    struct GetUserProfileImageAction {
        struct Request { }
        
        struct Response {
            let imageURL: URL
        }
        
        struct ViewModel {
            let imageURL: URL
        }
    }
    
    struct UserNameAction {
        struct Request { }
        
        struct Response {
            let name: String
        }
        
        struct ViewModel {
            let name: String
        }
    }
    
    struct UserEmailAction {
        struct Request { }
        
        struct Response {
            let email: String
        }
        
        struct ViewModel {
            let email: String
        }
    }
    
    struct SetUserProfileImageAction {
        struct Request {
            let image: UIImage
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    struct LogoutAction {
        struct Request { }
        
        struct Response { }
        
        struct ViewModel { }
    }
}
