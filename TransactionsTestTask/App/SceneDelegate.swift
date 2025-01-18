//
//  SceneDelegate.swift
//  TransactionsTestTask
//
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var coordinator: AppCoordinator!

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            coordinator = AppCoordinator(scene: windowScene)
            coordinator.start()
    }
}
