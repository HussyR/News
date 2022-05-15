//
//  SceneDelegate.swift
//  News
//
//  Created by Данил on 04.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let viewController = ViewController()
        viewController.articles = DataManager.loadData() ?? []
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        save()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    //
    //MARK: ЧТобы не перегружать ViewController не стал сохранять данные при каждом их изменении,
    //MARK: вместо этого данные сохраняются только при выходе из приложения
    
    func save() {
        guard let window = window else {return}
        let navigation = window.rootViewController as? UINavigationController
        guard let vc = navigation?.viewControllers[0] as? ViewController else {return}
        DataManager.saveData(articles: vc.articles)
    }
    
    


}

