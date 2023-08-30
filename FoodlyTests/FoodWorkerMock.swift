@testable import Foodly

class FoodWorkerMock: FoodWorkerLogic {
    func getTrendingFood() async throws -> [Foodly.Food] {
        return [
            Food(name: "name1", description: "desc1", imageURL: "url1", calories: 1, price: 1),
            Food(name: "name2", description: "desc2", imageURL: "url2", calories: 2, price: 2),
            Food(name: "name3", description: "desc3", imageURL: "url3", calories: 3, price: 3)
        ]
    }
    
    func getFood(by category: Foodly.FoodCategoryName) async throws -> [Foodly.Food] {
        return [
            Food(name: "name1", description: "desc1", imageURL: "url1", calories: 1, price: 1),
            Food(name: "name2", description: "desc2", imageURL: "url2", calories: 2, price: 2),
            Food(name: "name3", description: "desc3", imageURL: "url3", calories: 3, price: 3)
        ]
    }
    
    func getAllFood() async throws -> [Foodly.Food] {
        return [
            Food(name: "name1", description: "desc1", imageURL: "url1", calories: 1, price: 1),
            Food(name: "name2", description: "desc2", imageURL: "url2", calories: 2, price: 2),
            Food(name: "name3", description: "desc3", imageURL: "url3", calories: 3, price: 3)
        ]
    }
}
