struct MakeOrderModels {
    struct MakeOrderAction {
        struct Request {
            let items: [CartItem]
            let street: String
            let apartment: Int
            let entrance: Int
            let floor: Int
        }
        
        struct Response {
            var error: Error? = nil
        }
        
        struct ViewModelSuccess { }
        
        struct ViewModelFailure {
            let error: Error
        }
    }
    
    struct Order: Codable {
        let items: [CartItem]
        let userID: String
        let street: String
        let apartment: Int
        let entrance: Int
        let floor: Int
    }
}
