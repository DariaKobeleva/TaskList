//
//  SceneDelegate.swift
//  TaskList
//
//  Created by Дарья Кобелева on 28.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()//Окно становится основным и видимым
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController()) //Присваиваем стартовому экрану viewcontroller
        
    }

   

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

