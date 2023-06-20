protocol HomeConfigurator {
    func configure(_ viewController: HomeViewController)
}

final class HomeDefaultConfigurator: HomeConfigurator {
    func configure(_ viewController: HomeViewController) {
        let trendingFoodWorker = TrendingFoodWorker()
        let restaurantsWorker = RestaurantsWorker()
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
    }
}
