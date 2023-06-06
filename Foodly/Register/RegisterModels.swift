struct RegisterModels {
    struct RegisterAction {
        struct Request {
            let name: String
            let email: String
            let password: String
        }
        
        struct Response { }
        
        struct ViewModelFailure {
            let errorMessage: String
        }
    }
}
