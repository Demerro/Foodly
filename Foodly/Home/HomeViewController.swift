import UIKit
import CoreLocation

protocol HomeDisplayLogic: AnyObject {
    func displayTrendingFood(_ viewModel: HomeModels.TrendingFoodAction.ViewModel)
    func displayRestaurants(_ viewModel: HomeModels.RestaurantsAction.ViewModel)
    func displayAddFoodToCart(_ viewModel: HomeModels.AddFoodToCartAction.ViewModel)
}

final class HomeViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<HomeModels.HomeSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeModels.HomeSection, AnyHashable>
    
    var interactor: HomeBusinessLogic?
    var router: HomeRouter?
    
    private let homeView = HomeView()
    private let locationManager = CLLocationManager()
    
    private lazy var dataSource = DataSource(collectionView: homeView.collectionView) { collectionView, indexPath, hashable in
        switch hashable {
        case let news as HomeModels.News:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            cell.configureView(image: news.image)
            return cell
            
        case let category as FoodCategory:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.identifier, for: indexPath) as! FoodCategoryCollectionViewCell
            cell.configureView(title: category.localizedName, color: category.color, image: category.image)
            return cell
            
        case let food as Food:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            cell.configureView(with: food)
            return cell
            
        case let restaurant as Restaurant:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as! RestaurantCollectionViewCell
            cell.configureView(with: restaurant)
            return cell
            
        default:
            fatalError("Unknown hashable type.")
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
        setupSearchController()
        
        registerCollectionViewCells()
        registerCollectionViewSupplementaryElements()
        setupSections()
        setupCollectionViewLayout()
        setupSupplementaryViewProvider()
        
        homeView.collectionView.delegate = self
        
        addNews()
        addCategories()
        addTrendingFood()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addLocationView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeLocationView()
    }
    
    private func configure() {
        let foodWorker = FirebaseFoodWorker()
        let restaurantsWorker = MapKitRestaurantsWorker()
        let cartWorker = FirebaseCartWorker()
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        viewController.router = router
        
        interactor.restaurantsWorker = restaurantsWorker
        interactor.foodWorker = foodWorker
        interactor.cartWorker = cartWorker
    }
    
    private func addLocationView() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(homeView.locationView)
        
        UIView.animate(withDuration: 0.3) {
            self.homeView.locationView.alpha = 1
        }
        
        navBar.addConstraints([
            homeView.locationView.widthAnchor.constraint(equalTo: navBar.widthAnchor, constant: -40),
            homeView.locationView.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }
    
    private func removeLocationView() {
        guard let navBar = navigationController?.navigationBar,
              let locationView = navBar.subviews.first(where: { $0 is LocationView })
        else { return }
        
        UIView.animate(withDuration: 0.3) {
            locationView.alpha = 0
        } completion: { _ in
            locationView.removeFromSuperview()
        }
    }
    
    private func setupSearchController() {
        let searchResultsViewController = SearchResultsViewController()
        let controller = UISearchController(searchResultsController: searchResultsViewController)
        controller.searchResultsUpdater = searchResultsViewController
        controller.searchBar.delegate = self
        self.navigationItem.searchController = controller
    }
    
    private func addNews() {
        let news = [HomeModels.News(image: UIImage(named: "TopDeals")!)]
        var snapshot = dataSource.snapshot(for: .news)
        snapshot.append(news)
        dataSource.apply(snapshot, to: .news)
    }
    
    private func addCategories() {
        let categories = [
            FoodCategory(
                localizedName: String(localized: "foodCategory.burgers"),
                name: .burgers,
                color: UIColor(named: "AccentColor")!,
                image: UIImage(named: "Burger")!
            ),
            FoodCategory(
                localizedName: String(localized: "foodCategory.pizzas"),
                name: .pizzas,
                color: .systemOrange,
                image: UIImage(named: "Pizza")!),
            FoodCategory(
                localizedName: String(localized: "foodCategory.cakes"),
                name: .cakes,
                color: .systemBlue,
                image: UIImage(named: "Cake")!
            ),
            FoodCategory(
                localizedName: String(localized: "foodCategory.tacos"),
                name: .tacos,
                color: .systemGreen,
                image: UIImage(named: "Taco")!
            )
        ]
        var snapshot = dataSource.snapshot(for: .foodCategories)
        snapshot.append(categories)
        dataSource.apply(snapshot, to: .foodCategories)
    }
    
    private func addTrendingFood() {
        let request = HomeModels.TrendingFoodAction.Request()
        interactor?.getTrendingFood(request)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            
            let layoutCreator = SectionLayoutCreator()
            let section = dataSource.sectionIdentifier(for: sectionIndex)!

            switch section {
            case .news:
                return layoutCreator.createNewsSection()
            case .foodCategories:
                return layoutCreator.createFoodCategoriesSection()
            case .trendingFood:
                return layoutCreator.createTrendingFoodSectionLayout()
            case .nearbyRestaurants:
                return layoutCreator.createRestaurantsSectionLayout()
            }
        }

        homeView.collectionView.collectionViewLayout = layout
    }
    
    private func registerCollectionViewCells() {
        homeView.collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        homeView.collectionView.register(FoodCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FoodCategoryCollectionViewCell.identifier)
        homeView.collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        homeView.collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: RestaurantCollectionViewCell.identifier)
    }
    
    private func registerCollectionViewSupplementaryElements() {
        homeView.collectionView.register(
            CollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewHeader.identifier
        )
    }
    
    private func setupSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.news, .foodCategories, .trendingFood])
        dataSource.apply(snapshot)
    }
    
    private func setupSupplementaryViewProvider() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as! CollectionViewHeader
            guard let self else { return header }
            
            let section = dataSource.sectionIdentifier(for: indexPath.section)!
            header.configureView(text: section.title)
            
            return header
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [homeView, interactor] placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarkName = placemarks?.first?.name else { return }
            homeView.locationView.location = placemarkName
            
            let request = HomeModels.RestaurantsAction.Request(coordinate: location.coordinate)
            interactor?.getNearbyRestaurants(request)
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        removeLocationView()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        addLocationView()
        return true
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case let category as FoodCategory:
            router?.routeToFoodGroup(category: category)

        case let food as Food:
            router?.routeToFoodDetails(food: food)

        default:
            break
        }
    }
}

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayTrendingFood(_ viewModel: HomeModels.TrendingFoodAction.ViewModel) {
        var snapshot = dataSource.snapshot(for: .trendingFood)
        snapshot.append(viewModel.food)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, to: .trendingFood)
        }
    }
    
    func displayRestaurants(_ viewModel: HomeModels.RestaurantsAction.ViewModel) {
        var snapshot = dataSource.snapshot(for: .nearbyRestaurants)
        snapshot.deleteAll()
        snapshot.append(viewModel.restaurants)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, to: .nearbyRestaurants)
        }
    }
    
    func displayAddFoodToCart(_ viewModel: HomeModels.AddFoodToCartAction.ViewModel) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
