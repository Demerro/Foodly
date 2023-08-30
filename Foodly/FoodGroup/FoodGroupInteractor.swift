import FirebaseFirestore

protocol FoodGroupBusinessLogic: AnyObject {
    func getFoodByCategory(_ request: FoodGroupModels.GetFoodAction.Request)
    func addFoodToCart(_ request: FoodGroupModels.AddFoodToCartAction.Request)
}

class FoodGroupInteractor {
    var presenter: FoodGroupPresentationLogic?
    var cartWorker: CartWorkerLogic?
}

// MARK: - FoodGroupBusinessLogic
extension FoodGroupInteractor: FoodGroupBusinessLogic {
    func getFoodByCategory(_ request: FoodGroupModels.GetFoodAction.Request) {
        let collection = Firestore.firestore().collection(request.foodCategory.name.rawValue)
        
        Task {
            do {
                let snapshots = try await collection.getDocuments().documents
                let response = FoodGroupModels.GetFoodAction.Response(snapshots: snapshots, foodCategory: request.foodCategory)
                presenter?.presentGetFoodByCategory(response)
            } catch {
                print(error)
            }
        }
    }
    
    func addFoodToCart(_ request: FoodGroupModels.AddFoodToCartAction.Request) {
        Task {
            do {
                let food = request.food
                let item = CartItem(amount: 1, oneItemPrice: food.price, foodReference: food.documentReference!, food: food)
                try await cartWorker?.addToCart(item: item)
                
                let response = FoodGroupModels.AddFoodToCartAction.Response()
                presenter?.presentAddFoodToCart(response)
            } catch {
                print(error)
            }
        }
    }
}
