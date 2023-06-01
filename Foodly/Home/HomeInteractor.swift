import FirebaseFirestore

protocol HomeBusinessLogic: AnyObject {
    func getTrendingFood(_ request: HomeModels.TrendingFoodAction.Request)
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request)
}

class HomeInteractor {
    
    private let database = Firestore.firestore()
    
    var presenter: HomePresentationLogic?
}

// MARK: - HomeBusinessLogic
extension HomeInteractor: HomeBusinessLogic {
    func getTrendingFood(_ request: HomeModels.TrendingFoodAction.Request) {
        Task {
            do {
                let references = try await getTrendingFoodReferences()
                
                let trendingFoodSnapshots = try await withThrowingTaskGroup(of: DocumentSnapshot.self, returning: [DocumentSnapshot].self) { taskGroup in
                    for reference in references {
                        taskGroup.addTask { try await reference.getDocument() }
                    }
                    
                    var snapshots = [DocumentSnapshot]()
                    for try await result in taskGroup {
                        snapshots.append(result)
                    }
                    
                    return snapshots
                }
                
                let response = HomeModels.TrendingFoodAction.Response(snapshots: trendingFoodSnapshots)
                presenter?.presentTrendingFood(response)
            } catch {
                print(error)
            }
        }
    }
    
    private func getTrendingFoodReferences() async throws -> [DocumentReference] {
        try await database.collection("trendingNow").getDocuments().documents.compactMap {
            return $0.data().values.first as? DocumentReference
        }
    }
    
    func getNearbyRestaurants(_ request: HomeModels.RestaurantsAction.Request) {
        let searcher = PointOfInterestSearcher()
        
        Task {
            do {
                let searchResult = try await searcher.search(
                    coordinate: request.coordinate,
                    including: [.restaurant, .cafe, .bakery],
                    radius: 300
                )
                
                let response = HomeModels.RestaurantsAction.Response(mapItems: searchResult)
                presenter?.presentNearbyRestaurants(response)
            } catch {
                print(error)
            }
        }
    }
}
