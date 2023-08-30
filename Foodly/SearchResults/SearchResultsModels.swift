import MapKit

struct SearchResultsModels {
    enum Section {
        case food
        case restaurants
    }
    
    struct AllFoodAction {
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
}
