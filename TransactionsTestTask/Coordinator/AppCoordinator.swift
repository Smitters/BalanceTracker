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
    
    init(scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        navigationController = UINavigationController()
        window.rootViewController = navigationController
    }
    
    func start() {
        let balanceViewController = BalanceViewController(navigationDelegate: self)
        navigationController.setViewControllers([balanceViewController], animated: false)
        window.makeKeyAndVisible()
    }
}
