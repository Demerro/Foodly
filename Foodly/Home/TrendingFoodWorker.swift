import FirebaseFirestore

protocol TrendingFoodWorkerLogic: AnyObject {
    func getTrendingFood() async throws -> HomeModels.TrendingFoodAction.Response
}

class TrendingFoodWorker: TrendingFoodWorkerLogic {
    
    private let database = Firestore.firestore()
    
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
        try await database.collection("trendingNow").getDocuments().documents.compactMap {
            return $0.data().values.first as? DocumentReference
        }
    }
}
