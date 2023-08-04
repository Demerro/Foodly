import UIKit
import CoreLocation

protocol HomeDisplayLogic: AnyObject {
    func displayTrendingFood(_ viewModel: HomeModels.TrendingFoodAction.ViewModel)
    func displayRestaurants(_ viewModel: HomeModels.RestaurantsAction.ViewModel)
    func displayAddFoodToCart(_ viewModel: HomeModels.AddFoodToCartAction.ViewModel)
}

final class HomeViewController: UIViewController {
    
    var interactor: HomeBusinessLogic?
    var router: HomeRouter?
    
    private let homeView = HomeView()
    private let locationManager = CLLocationManager()
    private var sections = [HomeModels.HomeSections]()
    
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
        
        setupCollectionViewLayout()
        registerCollectionViewCells()
        registerCollectionViewSupplementaryElements()
        
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        
        addNews()
        addCategories()
        addTrendingFood()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        clearNavBar()
    }
    
    private func configure() {
        let trendingFoodWorker = TrendingFoodWorker()
        let restaurantsWorker = RestaurantsWorker()
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
        interactor.trendingFoodWorker = trendingFoodWorker
        interactor.cartWorker = cartWorker
    }
    
    private func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(homeView.locationView)
        
        navBar.addConstraints([
            homeView.locationView.widthAnchor.constraint(equalTo: navBar.widthAnchor, constant: -40),
            homeView.locationView.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }
    
    private func clearNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func addNews() {
        sections.append(.news([
            HomeModels.News(image: UIImage(named: "TopDeals")!)
        ]))
    }
    
    private func addCategories() {
        sections.append(.foodCategories([
            FoodCategory(
                localizedName: String(localized: "cell.foodCategory.title.burgers"),
                name: .burgers,
                color: UIColor(named: "AccentColor")!,
                image: UIImage(named: "Burger")!
            ),
            FoodCategory(
                localizedName: String(localized: "cell.foodCategory.title.pizzas"),
                name: .pizzas,
                color: .systemOrange,
                image: UIImage(named: "Pizza")!),
            FoodCategory(
                localizedName: String(localized: "cell.foodCategory.title.cakes"),
                name: .cakes,
                color: .systemBlue,
                image: UIImage(named: "Cake")!
            ),
            FoodCategory(
                localizedName: String(localized: "cell.foodCategory.title.tacos"),
                name: .tacos,
                color: .systemGreen,
                image: UIImage(named: "Taco")!
            )
        ]))
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
            guard let self = self else { return nil }
            let layoutCreator = SectionLayoutCreator()
            
            switch sections[sectionIndex] {
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

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case let .foodCategories(categories):
            router?.routeToFoodGroup(category: categories[indexPath.row])
            
        case let .trendingFood(food):
            router?.routeToFoodDetails(food: food[indexPath.row])
            
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case let .news(news):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            
            cell.configureView(image: news[indexPath.row].image)
            
            return cell
            
        case let .foodCategories(categories):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCategoryCollectionViewCell.identifier, for: indexPath) as! FoodCategoryCollectionViewCell
            
            let category = categories[indexPath.row]
            cell.configureView(title: category.localizedName, color: category.color, image: category.image)
            
            return cell
        case let .trendingFood(trendingFood):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            
            let food = trendingFood[indexPath.row]
            cell.imageURL = URL(string: food.imageURL)!
            cell.name = food.name
            cell.price = food.price
            cell.buttonAction = UIAction { [interactor] _ in
                let request = HomeModels.AddFoodToCartAction.Request(food: food)
                interactor?.addFoodToCart(request)
            }
            
            return cell
        case let .nearbyRestaurants(restaurants):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as! RestaurantCollectionViewCell
            
            let restaurant = restaurants[indexPath.row]
            cell.configureView(name: restaurant.name, location: restaurant.location, badgeTitle: restaurant.type, badgeColor: restaurant.color)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as! CollectionViewHeader
            
            header.configureView(text: sections[indexPath.section].title)
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayTrendingFood(_ viewModel: HomeModels.TrendingFoodAction.ViewModel) {
        sections.insert(.trendingFood(viewModel.food), at: 2)
        
        DispatchQueue.main.async {
            self.homeView.collectionView.insertSections(IndexSet(integer: 2))
        }
    }
    
    func displayRestaurants(_ viewModel: HomeModels.RestaurantsAction.ViewModel) {
        let index = sections.firstIndex {
            if case .nearbyRestaurants = $0 {
                return true
            } else {
                return false
            }
        }
        
        if let index = index {
            updateRestaurants(sectionIndex: index, restaurants: viewModel.restaurants)
        } else {
            addRestaurantsToEnd(restaurants: viewModel.restaurants)
        }
    }
    
    private func updateRestaurants(sectionIndex: Int, restaurants: [HomeModels.Restaurant]) {
        sections[sectionIndex] = .nearbyRestaurants(restaurants)
        
        DispatchQueue.main.async { [homeView] in
            homeView.collectionView.reloadSections(IndexSet(integer: sectionIndex))
        }
    }
    
    private func addRestaurantsToEnd(restaurants: [HomeModels.Restaurant]) {
        sections.append(.nearbyRestaurants(restaurants))
        
        DispatchQueue.main.async {
            self.homeView.collectionView.insertSections(IndexSet(integer: self.sections.count - 1))
        }
    }
    
    func displayAddFoodToCart(_ viewModel: HomeModels.AddFoodToCartAction.ViewModel) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
