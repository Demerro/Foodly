import UIKit

protocol ItemWrapper {
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func filter(section: SearchResultsModels.Section, query: String) -> Bool
}

struct FoodItemWrapper: ItemWrapper {
    
    var food: Food
    
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.identifier, for: indexPath) as! FoodTableViewCell
        cell.imageURL = food.imageURL
        cell.name = food.name
        cell.price = food.price
        return cell
    }
    
    func filter(section: SearchResultsModels.Section, query: String) -> Bool {
        if section != .food {
            return false
        }
        
        return query.isEmpty || food.name.localizedCaseInsensitiveContains(query)
    }
    
}

struct RestaurantItemWrapper: ItemWrapper {
    
    var restaurant: Restaurant
    
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as! RestaurantTableViewCell
        cell.configureView(with: restaurant)
        return cell
    }
    
    func filter(section: SearchResultsModels.Section, query: String) -> Bool {
        if section != .restaurants {
            return false
        }
        
        return query.isEmpty || restaurant.name.localizedCaseInsensitiveContains(query)
    }
    
}
