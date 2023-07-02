import UIKit

protocol CartDisplayLogic: AnyObject {
    func displayCartFood(_ viewModel: CartModels.FoodAction.ViewModel)
}

final class CartViewController: UIViewController {
    
    private let cartView = CartView()
    private var interactor: CartBusinessLogic?
    private var cartItems = [CartItem]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        self.view = cartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartView.tableView.dataSource = self
        cartView.tableView.delegate = self
        
        cartView.tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        
        let request = CartModels.FoodAction.Request()
        interactor?.getCartFood(request)
    }
    
    private func setup() {
        let viewController = self
        let interactor = CartInteractor()
        let presenter = CartPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as! CartTableViewCell
        let item = cartItems[indexPath.row]
        
        let food = item.food
        let amount = item.amount
        
        cell.amount = amount
        cell.foodName = food.name
        cell.imageURL = food.imageURL
        cell.price = food.price
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - CartDisplayLogic
extension CartViewController: CartDisplayLogic {
    func displayCartFood(_ viewModel: CartModels.FoodAction.ViewModel) {
        cartItems = viewModel.cartItems
        
        DispatchQueue.main.async {
            self.cartView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}
