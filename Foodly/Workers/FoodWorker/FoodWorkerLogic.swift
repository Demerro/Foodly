protocol FoodWorkerLogic: AnyObject {
    func getTrendingFood() async throws -> [Food]
    func getFood(by category: FoodCategoryName) async throws -> [Food]
    func getAllFood() async throws -> [Food]
}
