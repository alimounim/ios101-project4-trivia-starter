//
//  SceneDelegate.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//  Updated for Project 4 - Networking/Decoding
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // If using Storyboard, this is enough
        guard let _ = (scene as? UIWindowScene) else { return }

        // ✅ Optional: make sure the root view controller is set up
        // (normally storyboard does this automatically)
        if window == nil, let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateInitialViewController()
            window.rootViewController = rootVC
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene moved to active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene moves from active to inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called when the scene transitions from background to foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called when the scene transitions to background.
        // Save data or state here if needed.
    }
}
