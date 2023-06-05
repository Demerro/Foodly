import FirebaseFirestore

protocol HomeBusinessLogic: AnyObject {
    func getTrendingFood(_ request: HomeModels.TrendingFoodAction.Request)
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request)
}

class HomeInteractor {
    var presenter: HomePresentationLogic?
    var trendingFoodWorker: TrendingFoodWorkerLogic?
    var restaurantsWorker: RestaurantsWorkerLogic?
}

// MARK: - HomeBusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func getTrendingFood(_ request: HomeModels.TrendingFoodAction.Request) {
        Task {
            do {
                if let response = try await trendingFoodWorker?.getTrendingFood() {
                    presenter?.presentTrendingFood(response)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request) {
        let searcher = PointOfInterestSearcher()
        
        Task {
            do {
                if let response = try await restaurantsWorker?.getNearbyRestaurants(request) {
                    presenter?.presentNearbyRestaurants(response)
                }
            } catch {
                print(error)
            }
        }
    }
}
