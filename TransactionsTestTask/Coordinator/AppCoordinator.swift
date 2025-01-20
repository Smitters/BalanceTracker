//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    let navigationController: UINavigationController
    
    lazy var servicesAssembler = ServicesAssembler()
    
    init(scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        navigationController = UINavigationController()
        window.rootViewController = navigationController
    }
    
    func start() {
        let interactor = BalanceInteractor(
            bitcoinService: servicesAssembler.bitcoinRateService,
            balanceService: servicesAssembler.balanceService,
            persistanceManager: servicesAssembler.persistenceManager)
        let presenter = BalancePresenter(router: self, interactor: interactor)
        let balanceViewController = BalanceViewController(viewEventsHandler: presenter)
        presenter.view = balanceViewController
        interactor.output = presenter
        navigationController.setViewControllers([balanceViewController], animated: false)
        window.makeKeyAndVisible()
    }
}
