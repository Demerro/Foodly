import MapKit

struct HomeModels {
    enum HomeSections {
        case news
//        case foodCategories
//        case trendingFood
        case restaurants([Restaurant])
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
    
    struct Restaurant {
        let name: String
        let location: String
        let type: String
        let color: UIColor
    }
}
