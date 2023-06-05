protocol HomeConfigurator {
    func configure(_ viewController: HomeViewController)
}

final class HomeDefaultConfigurator: HomeConfigurator {
    func configure(_ viewController: HomeViewController) {
        let trendingFoodWorker = TrendingFoodWorker()
        let restaurantsWorker = RestaurantsWorker()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        interactor.restaurantsWorker = restaurantsWorker
        interactor.trendingFoodWorker = trendingFoodWorker
    }
}
