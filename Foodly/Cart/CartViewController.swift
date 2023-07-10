import UIKit

protocol CartDisplayLogic: AnyObject {
    func displayCartFood(_ viewModel: CartModels.GetCartItemsAction.ViewModel)
    func displayRemoveFood(_ viewModel: CartModels.RemoveCartItemAction.ViewModel)
    func displayCartItemAmountChange(_ viewModel: CartModels.ChangeCartItemAmountAction.ViewModel)
}

final class CartViewController: UIViewController {
    
    var interactor: CartBusinessLogic?
    
    private let cartView = CartView()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCartFood()
    }
    
    private func setup() {
        let viewController = self
        let interactor = CartInteractor()
        let presenter = CartPresenter()
        let cartWorker = FirebaseCartWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        interactor.cartWorker = cartWorker
    }
    
    private func getCartFood() {
        let request = CartModels.GetCartItemsAction.Request()
        interactor?.getCartFood(request)
    }
    
    private func removeCartFood(at indexPath: IndexPath) {
        if let id = cartItems[indexPath.row].id {
            let request = CartModels.RemoveCartItemAction.Request(id: id, indexPath: indexPath)
            interactor?.removeCartFood(request)
        }
    }
    
    private func setCartBadgeValue() {
        let cartPageTag = Page.cart.rawValue
        guard let cartItem = tabBarController?.tabBar.items?[cartPageTag] else { return }
        
        cartItem.badgeValue = "\(cartItems.count)"
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
        cell.foodName = food!.name
        cell.imageURL = food!.imageURL
        cell.price = food!.price
        
        cell.increaseButtonTappedAction = { [interactor] in
            let request = CartModels.ChangeCartItemAmountAction.Request(cartItem: item, difference: 1, indexPath: indexPath)
            interactor?.changeCartFoodAmount(request)
        }
        cell.decreaseButtonTappedAction = { [interactor] in
            guard item.amount > 1 else { return }
            
            let request = CartModels.ChangeCartItemAmountAction.Request(cartItem: item, difference: -1, indexPath: indexPath)
            interactor?.changeCartFoodAmount(request)
        }
        
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
            removeCartFood(at: indexPath)
        }
    }
}

// MARK: - CartDisplayLogic
extension CartViewController: CartDisplayLogic {
    func displayCartFood(_ viewModel: CartModels.GetCartItemsAction.ViewModel) {
        cartItems = viewModel.cartItems
        
        DispatchQueue.main.async {
            self.cartView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            self.setCartBadgeValue()
        }
    }
    
    func displayRemoveFood(_ viewModel: CartModels.RemoveCartItemAction.ViewModel) {
        DispatchQueue.main.async {
            self.cartItems.remove(at: viewModel.indexPath.row)
            self.cartView.tableView.deleteRows(at: [viewModel.indexPath], with: .automatic)
        }
    }
    
    func displayCartItemAmountChange(_ viewModel: CartModels.ChangeCartItemAmountAction.ViewModel) {
        DispatchQueue.main.async {
            self.cartItems[viewModel.indexPath.row] = viewModel.updatedCartItem
            self.cartView.tableView.reloadRows(at: [viewModel.indexPath], with: .none)
        }
    }
}
