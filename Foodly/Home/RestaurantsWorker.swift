protocol RestaurantsWorkerLogic: AnyObject {
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request) async throws -> HomeModels.RestaurantsAction.Response
}

class RestaurantsWorker: RestaurantsWorkerLogic {
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request) async throws -> HomeModels.RestaurantsAction.Response {
        let searcher = PointOfInterestSearcher()
        
        let searchResult = try await searcher.search(
            coordinate: request.coordinate,
            including: [.restaurant, .cafe, .bakery],
            radius: 300
        )
        
        return HomeModels.RestaurantsAction.Response(mapItems: searchResult)
    }
}
