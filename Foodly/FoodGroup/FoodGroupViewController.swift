import UIKit

protocol FoodGroupDisplayLogic: AnyObject {
    func displayGetFoodByCategory(_ viewModel: FoodGroupModels.GetFoodAction.ViewModel)
    func displayAddFoodToCart(_ viewModel: FoodGroupModels.AddFoodToCartAction.ViewModel)
}

final class FoodGroupViewController: UIViewController {
    
    var category: FoodCategory!
    
    private let foodGroupView = FoodGroupView()
    private var interactor: FoodGroupBusinessLogic?
    private var foodItems = [Food]()
    private var filteredFoodItems = [Food]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        self.view = foodGroupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category.localizedName
        
        setupSearchController()
        
        foodGroupView.collectionView.dataSource = self
        foodGroupView.collectionView.delegate = self
        
        foodGroupView.collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        
        let request = FoodGroupModels.GetFoodAction.Request(foodCategory: category)
        interactor?.getFoodByCategory(request)
    }
    
    private func setup() {
        let viewController = self
        let presenter = FoodGroupPresenter()
        let interactor = FoodGroupInteractor()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        interactor.cartWorker = FirebaseCartWorker()
    }
    
    private func setupSearchController() {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        self.navigationItem.searchController = controller
    }
    
}

// MARK: - UICollectionViewDataSource
extension FoodGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFoodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
        
        let foodItem = filteredFoodItems[indexPath.row]
        cell.configureView(with: foodItem)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FoodGroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = FoodDetailsViewController()
        let closeButton = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in viewController.dismiss(animated: true) })
        
        viewController.navigationItem.rightBarButtonItem = closeButton
        viewController.food = filteredFoodItems[indexPath.row]
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FoodGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 30, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - UISearchResultsUpdating
extension FoodGroupViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        filteredFoodItems = text.isEmpty ? foodItems : foodItems.filter { $0.name.localizedCaseInsensitiveContains(text) }
        
        DispatchQueue.main.async {
            self.foodGroupView.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

// MARK: - FoodGroupDisplayLogic
extension FoodGroupViewController: FoodGroupDisplayLogic {
    func displayGetFoodByCategory(_ viewModel: FoodGroupModels.GetFoodAction.ViewModel) {
        foodItems = viewModel.food
        filteredFoodItems = viewModel.food
        
        DispatchQueue.main.async {
            self.foodGroupView.collectionView.reloadData()
        }
    }
    
    func displayAddFoodToCart(_ viewModel: FoodGroupModels.AddFoodToCartAction.ViewModel) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
