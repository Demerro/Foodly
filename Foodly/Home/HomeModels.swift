import MapKit

struct HomeModels {
    enum HomeSection: Hashable {
        case news
        case foodCategories
        case trendingFood
        case nearbyRestaurants
        
        var title: String {
            switch self {
            case .trendingFood:
                return String(localized: "view.home.sections.trendingFood.header")
            case .nearbyRestaurants:
                return String(localized: "view.home.sections.nearbyRestaurants.header")
            default:
                return ""
            }
        }
    }
    
    struct TrendingFoodAction {
        struct Request { }
        
        struct Response {
            let food: [Food]
        }
        
        struct ViewModel {
            let food: [Food]
        }
    }
    
    struct RestaurantsAction {
        struct Request {
            let coordinate: CLLocationCoordinate2D
        }
        
        struct Response {
            let mapItems: [MKMapItem]
        }
        
        struct ViewModel {
            let restaurants: [Restaurant]
        }
    }
    
    struct AddFoodToCartAction {
        struct Request {
            let food: Food
        }
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    struct News: Hashable {
        let image: UIImage
    }
}
