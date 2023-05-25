import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let locationManager = CLLocationManager()
    
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
            
            switch sectionIndex {
            case 0:
                return createNewsSection()
            case 1:
                return createFoodCategoriesSection()
            case 2:
                return createTrendingFoodSectionLayout()
            case 3:
                return createRestaurantsSectionLayout()
            default:
                return nil
            }
        }
        
        homeView.collectionView.collectionViewLayout = layout
    }
    
    private func registerCollectionLayoutCells() {
        homeView.collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            self?.homeView.locationView.setLocation(placemark.name ?? "")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath)
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
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.2)),
            subitems: [item]
        )
        
        return createLayoutSection(group: group, scrollBehavior: .continuous)
    }
    
    private func createTrendingFoodSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.2)),
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
        
        return section
    }
}
