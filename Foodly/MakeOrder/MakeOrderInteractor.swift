import FirebaseFirestore
import FirebaseAuth

protocol MakeOrderBusinessLogic: AnyObject {
    func makeOrder(_ request: MakeOrderModels.MakeOrderAction.Request)
}

class MakeOrderInteractor: MakeOrderBusinessLogic {
    
    var presenter: MakeOrderPresentationLogic?
    
    func makeOrder(_ request: MakeOrderModels.MakeOrderAction.Request) {
        let collection = Firestore.firestore().collection("orders")
        let userID = Auth.auth().currentUser!.uid
        let order = MakeOrderModels.Order(
            items: request.items,
            userID: userID,
            street: request.street,
            apartment: request.apartment,
            entrance: request.entrance,
            floor: request.floor
        )
        var response = MakeOrderModels.MakeOrderAction.Response()
        
        do {
            try collection.addDocument(from: order)
            presenter?.presentMakeOrder(response)
        } catch {
            print(error)
            response.error = error
            presenter?.presentMakeOrder(response)
        }
    }
    
}
