import MapKit

public final class PointOfInterestSearcher {
    /**
     Searches for points of interest on the map around the `coordinate` by the given array of `categories` within the given `radius`.
     
     - Parameters:
        - coordinate: Coordinate around which to search.
        - categories: Array of categories to search for.
        - radius: Search radius in meters.
     */
    public func search(coordinate: CLLocationCoordinate2D, including categories: [MKPointOfInterestCategory], radius: Double) async throws -> [MKMapItem] {
        let spanDiameter = radius * 2
        let span = createRectangleSpan(width: spanDiameter, height: spanDiameter)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let request = MKLocalPointsOfInterestRequest(coordinateRegion: region)
        
        let filter = MKPointOfInterestFilter(including: categories)
        request.pointOfInterestFilter = filter
        
        let search = MKLocalSearch(request: request)
        return try await search.start().mapItems
    }
    
    /**
     Creates a rectangular span.
     ```
     let span = createRectangleSpan(
         width: 200,
         height: 100
     ) // longitudeDelta: 0.0018, latitudeDelta: 0.0009
     ```
     
     - Parameters:
        - width: Span width in meters.
        - height: Span height in meters.
     */
    private func createRectangleSpan(width: Double, height: Double) -> MKCoordinateSpan {
        let metersInOneDegree = 111000.0
        let latitudeDelta = height / metersInOneDegree
        let longitudeDelta = width / metersInOneDegree
        return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
}
