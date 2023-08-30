import MapKit
import UIKit

protocol SearchResultsPresentationLogic: AnyObject {
    func presentAllFood(_ response: SearchResultsModels.AllFoodAction.Response)
    func presentNearbyRestaurants(_ response: SearchResultsModels.RestaurantsAction.Response)
}

class SearchResultsPresenter: SearchResultsPresentationLogic {
    
    var viewController: SearchResultsDisplayLogic?
    
    func presentAllFood(_ response: SearchResultsModels.AllFoodAction.Response) {
        let viewModel = SearchResultsModels.AllFoodAction.ViewModel(food: response.food)
        viewController?.displayAllFood(viewModel)
    }
    
    func presentNearbyRestaurants(_ response: SearchResultsModels.RestaurantsAction.Response) {
        let restaurants = response.mapItems.compactMap(makeRestaurant)
        let viewModel = SearchResultsModels.RestaurantsAction.ViewModel(restaurants: restaurants)
        viewController?.displayNearbyRestaurants(viewModel)
    }
    
    private func makeRestaurant(mapItem: MKMapItem) -> Restaurant? {
        guard let name = mapItem.placemark.name,
              let location = mapItem.placemark.title
        else { return nil }
        
        var color: UIColor = .clear
        var type: String = ""
        
        switch mapItem.pointOfInterestCategory {
        case MKPointOfInterestCategory.restaurant:
            color = UIColor(named: "AccentColor")!
            type = String(localized: "cell.restaurant.restaurant")
            
        case MKPointOfInterestCategory.cafe:
            color = .systemBlue
            type = String(localized: "cell.restaurant.cafe")
            
        case MKPointOfInterestCategory.bakery:
            color = .systemOrange
            type = String(localized: "cell.restaurant.bakery")
            
        default:
            break
        }
        
        return Restaurant(name: name, location: location, type: type, color: color)
    }
}
