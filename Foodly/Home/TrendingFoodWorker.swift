import FirebaseFirestore

protocol TrendingFoodWorkerLogic: AnyObject {
    func getTrendingFood() async throws -> HomeModels.TrendingFoodAction.Response
}

class TrendingFoodWorker: TrendingFoodWorkerLogic {
    
    func getTrendingFood() async throws -> HomeModels.TrendingFoodAction.Response {
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
        
        return HomeModels.TrendingFoodAction.Response(snapshots: snapshots)
    }
    
    private func getTrendingFoodReferences() async throws -> [DocumentReference] {
        let trendingFoodCollection = Firestore.firestore().collection("trendingNow")
        
        return try await trendingFoodCollection.getDocuments().documents.compactMap {
            $0.data()["food"] as? DocumentReference
        }
    }
}
