import UIKit
import CoreLocation

protocol SearchResultsDisplayLogic {
    func displayAllFood(_ viewModel: SearchResultsModels.AllFoodAction.ViewModel)
    func displayNearbyRestaurants(_ viewModel: SearchResultsModels.RestaurantsAction.ViewModel)
}

final class SearchResultsViewController: UIViewController {
    
    private var itemStore = [String: ItemWrapper]()
    private var currentSection: SearchResultsModels.Section = .food
    
    private var searchText = "" {
        didSet { updateSnapshot() }
    }
    
    private let searchResultsView = SearchResultsView()
    private var interactor: SearchResultsBusinessLogic?
    private var router: HomeRoutingLogic?
    private let locationManager = CLLocationManager()
    
    private var dataSource: UITableViewDiffableDataSource<SearchResultsModels.Section, String>!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        self.view = searchResultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsView.tableView.delegate = self
        setupDataSource()
        setupSegmentedControl()
        setupLocationManager()
        requestFood()
    }
    
    private func setupDataSource() {
        dataSource = .init(tableView: searchResultsView.tableView) { [weak self] tableView, indexPath, id in
            return self?.itemStore[id]?.cellForRowAt(tableView, indexPath: indexPath)
        }
    }
    
    private func setupSegmentedControl() {
        let segmentedControl = searchResultsView.segmentedControl
        segmentedControl.addAction(UIAction { [weak self] action in
            guard let self else { return }
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                currentSection = .food
            case 1:
                currentSection = .restaurants
            default:
                return
            }
            
            updateSnapshot()
        }, for: .valueChanged)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func requestFood() {
        let request = SearchResultsModels.AllFoodAction.Request()
        interactor?.getAllFood(request)
    }
    
    private func setupSnapshot(identifiers: [String], toSection section: SearchResultsModels.Section) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultsModels.Section, String>()
        snapshot.appendSections([section])
        snapshot.appendItems(identifiers, toSection: section)
        dataSource.apply(snapshot)
    }
    
    private func updateSnapshot() {
        var identifiers = [String]()
        
        itemStore.forEach { key, value in
            if value.filter(section: currentSection, query: searchText) {
                identifiers.append(key)
            }
        }
        setupSnapshot(identifiers: identifiers, toSection: currentSection)
        
        UIView.animate(withDuration: 0.2) { [searchResultsView] in
            searchResultsView.noResultsFoundView.alpha = identifiers.isEmpty ? 1 : 0
        }
    }
    
    private func setup() {
        let viewController = self
        let interactor = SearchResultsInteractor()
        let presenter = SearchResultsPresenter()
        let router = HomeRouter()
        
        router.viewController = viewController
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        interactor.foodWorker = FirebaseFoodWorker()
        interactor.restaurantsWorker = MapKitRestaurantsWorker()
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        
        if view.window != nil {
            searchText = searchController.searchBar.text ?? ""
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let wrapperID = dataSource.itemIdentifier(for: indexPath),
            let wrapper = itemStore[wrapperID] as? FoodItemWrapper
        else {
            return
        }
        
        router?.routeToFoodDetails(food: wrapper.food)
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchResultsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [interactor] placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let coordinate = placemarks?.first?.location?.coordinate else { return }
            let request = SearchResultsModels.RestaurantsAction.Request(coordinate: coordinate)
            interactor?.getNearbyRestaurants(request)
        }
    }
}

// MARK: - SearchResultsDisplayLogic
extension SearchResultsViewController: SearchResultsDisplayLogic {
    func displayAllFood(_ viewModel: SearchResultsModels.AllFoodAction.ViewModel) {
        var identifiers = [String]()
        viewModel.food.forEach { food in
            if let id = food.id {
                itemStore[id] = FoodItemWrapper(food: food)
                identifiers.append(id)
            }
        }
        
        DispatchQueue.main.async { [self] in
            setupSnapshot(identifiers: identifiers, toSection: .food)
        }
    }
    
    func displayNearbyRestaurants(_ viewModel: SearchResultsModels.RestaurantsAction.ViewModel) {
        viewModel.restaurants.forEach { restaurant in
            let id = restaurant.id.uuidString
            itemStore[id] = RestaurantItemWrapper(restaurant: restaurant)
        }
    }
}
