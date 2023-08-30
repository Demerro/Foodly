protocol SearchResultsBusinessLogic: AnyObject {
    func getAllFood(_ request: SearchResultsModels.AllFoodAction.Request)
    func getNearbyRestaurants(_ request: SearchResultsModels.RestaurantsAction.Request)
}

class SearchResultsInteractor: SearchResultsBusinessLogic {
    
    var presenter: SearchResultsPresentationLogic?
    var foodWorker: FoodWorkerLogic?
    var restaurantsWorker: RestaurantsWorkerLogic?
    
    func getAllFood(_ request: SearchResultsModels.AllFoodAction.Request) {
        Task {
            do {
                guard let food = try await foodWorker?.getAllFood() else { return }
                let response = SearchResultsModels.AllFoodAction.Response(food: food)
                presenter?.presentAllFood(response)
            } catch {
                print(error)
            }
        }
    }
    
    func getNearbyRestaurants(_ request: SearchResultsModels.RestaurantsAction.Request) {
        Task {
            do {
                guard let mapItems = try await restaurantsWorker?.getNearbyRestaurants(request.coordinate) else { return }
                let response = SearchResultsModels.RestaurantsAction.Response(mapItems: mapItems)
                presenter?.presentNearbyRestaurants(response)
            } catch {
                print(error)
            }
        }
    }
    
}
