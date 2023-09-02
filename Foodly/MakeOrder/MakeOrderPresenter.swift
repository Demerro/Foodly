protocol MakeOrderPresentationLogic: AnyObject {
    func presentMakeOrder(_ response: MakeOrderModels.MakeOrderAction.Response)
}

class MakeOrderPresenter: MakeOrderPresentationLogic {
    
    weak var viewController: MakeOrderDisplayLogic?
    
    func presentMakeOrder(_ response: MakeOrderModels.MakeOrderAction.Response) {
        if let error = response.error {
            let viewModel = MakeOrderModels.MakeOrderAction.ViewModelFailure(error: error)
            viewController?.displayMakeOrderFailure(viewModel)
            return
        }
        
        let viewModel = MakeOrderModels.MakeOrderAction.ViewModelSuccess()
        viewController?.displayMakeOrderSuccess(viewModel)
    }
    
}
