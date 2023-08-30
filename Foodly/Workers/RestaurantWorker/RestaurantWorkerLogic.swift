import MapKit

protocol RestaurantsWorkerLogic: AnyObject {
    func getNearbyRestaurants(_ coordinate: CLLocationCoordinate2D) async throws -> [MKMapItem]
}
