import MapKit

final class MapKitRestaurantsWorker: RestaurantsWorkerLogic {
    func getNearbyRestaurants(_ coordinate: CLLocationCoordinate2D) async throws -> [MKMapItem] {
        let searcher = PointOfInterestSearcher()
        
        let searchResult = try await searcher.search(
            coordinate: coordinate,
            including: [.restaurant, .cafe, .bakery],
            radius: 300
        )
        
        return searchResult
    }
}
