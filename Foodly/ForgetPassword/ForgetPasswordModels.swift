struct ForgetPasswordModels {
    struct SendPasswordReset {
        struct Request {
            let email: String
        }
        
        struct Response { }
        
        struct ViewModelFailure {
            let errorMessage: String
        }
    }
}
