import FirebaseFirestore
import MapKit

struct HomeModels {
    enum HomeSections {
        case news([News])
        case foodCategories([FoodCategory])
        case trendingFood([Food])
        case nearbyRestaurants([Restaurant])
        
        var count: Int {
            switch self {
            case let .news(news):
                return news.count
            case let .foodCategories(categories):
                return categories.count
            case let .trendingFood(food):
                return food.count
            case let .nearbyRestaurants(restaurants):
                return restaurants.count
            }
        }
        
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
            let snapshots: [DocumentSnapshot]
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
    
    struct News {
        let image: UIImage
    }
    
    struct FoodCategory {
        let name: String
        let color: UIColor
        let image: UIImage
    }
    
    struct Food: Decodable {
        let name: String
        let description: String
        let imageURL: String
        let calories: Int
        let price: Float
    }
    
    struct Restaurant {
        let name: String
        let location: String
        let type: String
        let color: UIColor
    }
}
