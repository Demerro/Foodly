import FirebaseFirestore
import MapKit

struct HomeModels {
    enum HomeSections {
        case news
//        case foodCategories
        case trendingFood([Food])
        case restaurants([Restaurant])
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
