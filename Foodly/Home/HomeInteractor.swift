import Firebase

protocol HomeBusinessLogic: AnyObject {
    func getTrendingFood(_ request: HomeModels.TrendingFoodAction.Request)
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request)
    func addFoodToCart(_ request: HomeModels.AddFoodToCartAction.Request)
}

class HomeInteractor {
    var presenter: HomePresentationLogic?
    var foodWorker: FoodWorkerLogic?
    var restaurantsWorker: RestaurantsWorkerLogic?
    var cartWorker: CartWorkerLogic?
}

// MARK: - HomeBusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func getTrendingFood(_ request: HomeModels.TrendingFoodAction.Request) {
        Task {
            do {
                if let food = try await foodWorker?.getTrendingFood() {
                    let response = HomeModels.TrendingFoodAction.Response(food: food)
                    presenter?.presentTrendingFood(response)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request) {
        Task {
            do {
                guard
                    let mapItems = try await restaurantsWorker?.getNearbyRestaurants(request.coordinate)
                else {
                    return
                }
                
                let response = HomeModels.RestaurantsAction.Response(mapItems: mapItems)
                presenter?.presentNearbyRestaurants(response)
            } catch {
                print(error)
            }
        }
    }
    
    func addFoodToCart(_ request: HomeModels.AddFoodToCartAction.Request) {
        Task {
            do {
                let food = request.food
                let item = CartItem(amount: 1, oneItemPrice: food.price, foodReference: food.documentReference!, food: food)
                try await cartWorker?.addToCart(item: item)
                
                let response = HomeModels.AddFoodToCartAction.Response()
                presenter?.presentAddFoodToCart(response)
            } catch {
                print(error)
            }
        }
    }
}
