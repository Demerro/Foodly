import MapKit
import FirebaseFirestoreSwift

protocol HomePresentationLogic: AnyObject {
    func presentTrendingFood(_ response: HomeModels.TrendingFoodAction.Response)
    func presentNearbyRestaurants(_ response: HomeModels.RestaurantsAction.Response)
}

class HomePresenter {
    weak var viewController: HomeDisplayLogic?
}

// MARK: - HomePresentationLogic
extension HomePresenter: HomePresentationLogic {
    func presentTrendingFood(_ response: HomeModels.TrendingFoodAction.Response) {
        let trendingFood = response.snapshots.compactMap { snapshot in
            do {
                return try snapshot.data(as: HomeModels.Food.self)
            } catch {
                print(error)
            }
            
            return nil
        }
        
        let viewModel = HomeModels.TrendingFoodAction.ViewModel(food: trendingFood)
        viewController?.displayTrendingFood(viewModel)
    }
    
    func presentNearbyRestaurants(_ response: HomeModels.RestaurantsAction.Response) {
        let restaurants: [HomeModels.Restaurant] = response.mapItems.compactMap {
            guard let name = $0.placemark.name else { return nil }
            guard let location = $0.placemark.title else { return nil }
            var color: UIColor = .clear
            var type: String = ""
            
            switch $0.pointOfInterestCategory {
            case MKPointOfInterestCategory.restaurant:
                color = UIColor(named: "AccentColor")!
                type = String(localized: "cell.restaurant.restaurant")
                
            case MKPointOfInterestCategory.cafe:
                color = .systemBlue
                type = String(localized: "cell.restaurant.cafe")
                
            case MKPointOfInterestCategory.bakery:
                color = .systemYellow
                type = String(localized: "cell.restaurant.bakery")
                
            default:
                break
            }
            
            return HomeModels.Restaurant(name: name, location: location, type: type, color: color)
        }
        
        let viewModel = HomeModels.RestaurantsAction.ViewModel(restaurants: restaurants)
        viewController?.displayRestaurants(viewModel)
    }
}
