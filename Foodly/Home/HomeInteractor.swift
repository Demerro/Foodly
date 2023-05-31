protocol HomeBusinessLogic: AnyObject {
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request)
}

class HomeInteractor {
    var presenter: HomePresentationLogic?
}

// MARK: - HomeBusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request) {
        let searcher = PointOfInterestSearcher()
        
        Task {
            do {
                let searchResult = try await searcher.search(
                    coordinate: request.coordinate,
                    including: [.restaurant, .cafe, .bakery],
                    radius: 300
                )
                
                let response = HomeModels.RestaurantsAction.Response(mapItems: searchResult)
                presenter?.presentNearbyRestaurants(response)
            } catch {
                print(error)
            }
        }
    }
}
