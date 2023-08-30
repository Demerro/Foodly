import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseFoodWorker: FoodWorkerLogic {
    func getTrendingFood() async throws -> [Food] {
        let references = try await getTrendingFoodReferences()
        
        let snapshots = try await withThrowingTaskGroup(of: DocumentSnapshot.self, returning: [DocumentSnapshot].self) { taskGroup in
            for reference in references {
                taskGroup.addTask { try await reference.getDocument() }
            }
            
            var snapshots = [DocumentSnapshot]()
            for try await result in taskGroup {
                snapshots.append(result)
            }
            
            return snapshots
        }
        
        return try snapshots.compactMap { snapshot in
            var food = try snapshot.data(as: Food.self)
            food.documentReference = snapshot.reference
            return food
        }
    }
    
    func getFood(by category: FoodCategoryName) async throws -> [Food] {
        let collection = Firestore.firestore().collection(category.rawValue)
        
        return try await collection.getDocuments().documents.map { snapshot in
            var food = try snapshot.data(as: Food.self)
            food.documentReference = snapshot.reference
            food.category = category
            return food
        }
    }
    
    func getAllFood() async throws -> [Food] {
        return try await withThrowingTaskGroup(of: [Food].self) { group in
            FoodCategoryName.allCases.forEach { category in
                group.addTask { [weak self] in
                    try await self?.getFood(by: category) ?? []
                }
            }
            
            var food = [Food]()
            for try await result in group {
                food.append(contentsOf: result)
            }
            
            return food
        }
    }
    
    private func getTrendingFoodReferences() async throws -> [DocumentReference] {
        let trendingFoodCollection = Firestore.firestore().collection("trendingNow")
        
        return try await trendingFoodCollection.getDocuments().documents.compactMap {
            $0.data()["food"] as? DocumentReference
        }
    }
}
