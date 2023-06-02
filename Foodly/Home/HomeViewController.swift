import UIKit
import CoreLocation

protocol HomeDisplayLogic: AnyObject {
    func displayTrendingFood(_ viewModel: HomeModels.TrendingFoodAction.ViewModel)
    func displayRestaurants(_ viewModel: HomeModels.RestaurantsAction.ViewModel)
}

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let locationManager = CLLocationManager()
    private var sections = [HomeModels.HomeSections]()
    private var interactor: HomeBusinessLogic?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupLocationManager()
        
        setupCollectionViewLayout()
        registerCollectionLayoutCells()
        
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        
        sections.append(.news)
        sections.append(.foodCategories([
            HomeModels.FoodCategory(name: "Burgers", color: UIColor(named: "AccentColor")!, image: UIImage(named: "Burger")!),
            HomeModels.FoodCategory(name: "Pizzas", color: .systemOrange, image: UIImage(named: "Pizza")!),
            HomeModels.FoodCategory(name: "Cakes", color: .systemBlue, image: UIImage(named: "Cake")!),
            HomeModels.FoodCategory(name: "Tacos", color: .systemGreen, image: UIImage(named: "Taco")!)
        ]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = HomeModels.TrendingFoodAction.Request()
        interactor?.getTrendingFood(request)
    }
    
    private func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(homeView.locationView)
        
        navBar.addConstraints([
            homeView.locationView.widthAnchor.constraint(equalTo: navBar.widthAnchor, constant: -40),
            homeView.locationView.centerXAnchor.constraint(equalTo: navBar.centerXAnchor)
        ])
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
            
            switch sections[sectionIndex] {
            case .news:
                return createNewsSection()
            case .foodCategories:
                return createFoodCategoriesSection()
            case .trendingFood:
                return createTrendingFoodSectionLayout()
            case .restaurants:
                return createRestaurantsSectionLayout()
            }
        }
        
        homeView.collectionView.collectionViewLayout = layout
    }
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func registerCollectionLayoutCells() {
        homeView.collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        homeView.collectionView.register(FoodCategoryCollectionViewCell.self, forCellWithReuseIdentifier: FoodCategoryCollectionViewCell.identifier)
        homeView.collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        homeView.collectionView.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: RestaurantCollectionViewCell.identifier)
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
        switch sections[section] {
        case .news:
            return 1
        case let .foodCategories(categories):
            return categories.count
        case let .trendingFood(food):
            return food.count
        case let .restaurants(restaurants):
            return restaurants.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .news:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            
            cell.configureView(image: UIImage(named: "TopDeals")!)
            
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
        case let .restaurants(restaurants):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as! RestaurantCollectionViewCell
            
            let restaurant = restaurants[indexPath.row]
            cell.configureView(name: restaurant.name, location: restaurant.location, badgeTitle: restaurant.type, badgeColor: restaurant.color)
            
            return cell
        }
    }
}

// MARK: - CollectionViewLayout Sections
extension HomeViewController {
    private func createNewsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .none)
    }
    
    private func createFoodCategoriesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.15)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .continuous)
    }
    
    private func createTrendingFoodSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.3)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .continuous)
    }
    
    private func createRestaurantsSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.2)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .continuous)
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollBehavior
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 20
        
        return section
    }
}

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayTrendingFood(_ viewModel: HomeModels.TrendingFoodAction.ViewModel) {
        sections.append(.trendingFood(viewModel.food))
        
        DispatchQueue.main.async {
            self.homeView.collectionView.insertSections(IndexSet(integer: self.sections.count - 1))
        }
    }
    
    func displayRestaurants(_ viewModel: HomeModels.RestaurantsAction.ViewModel) {
        let index = sections.firstIndex {
            if case .restaurants = $0 {
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
        sections[sectionIndex] = .restaurants(restaurants)
        
        DispatchQueue.main.async {
            self.homeView.collectionView.reloadSections(IndexSet(integer: sectionIndex))
        }
    }
    
    private func addRestaurantsToEnd(restaurants: [HomeModels.Restaurant]) {
        sections.append(.restaurants(restaurants))
        
        DispatchQueue.main.async {
            self.homeView.collectionView.insertSections(IndexSet(integer: self.sections.count - 1))
        }
    }
}
