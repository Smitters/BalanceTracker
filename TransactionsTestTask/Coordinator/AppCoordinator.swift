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
        navigationController = UINavigationController(rootViewController: BalanceViewController())
        window.rootViewController = navigationController
    }
    
    func start() {
        window.makeKeyAndVisible()
    }
}
