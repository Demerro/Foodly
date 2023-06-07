import UIKit
import CoreLocation

protocol HomeDisplayLogic: AnyObject {
    func displayTrendingFood(_ viewModel: HomeModels.TrendingFoodAction.ViewModel)
    func displayRestaurants(_ viewModel: HomeModels.RestaurantsAction.ViewModel)
}

final class HomeViewController: UIViewController {
    
    var interactor: HomeBusinessLogic?
    
    private let homeView = HomeView()
    private let locationManager = CLLocationManager()
    private var sections = [HomeModels.HomeSections]()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
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
    
    private func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(homeView.locationView)
        
        navBar.addConstraints([
            homeView.locationView.widthAnchor.constraint(equalTo: navBar.widthAnchor, constant: -40),
            homeView.locationView.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
    }
    
    private func addNews() {
        sections.append(.news([
            HomeModels.News(image: UIImage(named: "TopDeals")!)
        ]))
    }
    
    private func addCategories() {
        sections.append(.foodCategories([
            HomeModels.FoodCategory(
                name: String(localized: "cell.foodCategory.title.burgers"),
                color: UIColor(named: "AccentColor")!,
                image: UIImage(named: "Burger")!
            ),
            HomeModels.FoodCategory(
                name: String(localized: "cell.foodCategory.title.pizzas"),
                color: .systemOrange,
                image: UIImage(named: "Pizza")!),
            HomeModels.FoodCategory(
                name: String(localized: "cell.foodCategory.title.cakes"),
                color: .systemBlue,
                image: UIImage(named: "Cake")!
            ),
            HomeModels.FoodCategory(
                name: String(localized: "cell.foodCategory.title.tacos"),
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
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarkName = placemarks?.first?.name else { return }
            
            homeView.locationView.setLocation(placemarkName)
            
            let request = HomeModels.RestaurantsAction.Request(coordinate: location.coordinate)
            interactor?.getNearbyRestaurants(request)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
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
            cell.configureView(title: category.name, color: category.color, image: category.image)
            
            return cell
        case let .trendingFood(trendingFood):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            
            let food = trendingFood[indexPath.row]
            cell.configureView(imageURL: URL(string: food.imageURL), name: food.name, price: food.price)
            
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
}
