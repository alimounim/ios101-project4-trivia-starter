//
//  AppDelegate.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//  Updated for Project 4 - Networking/Decoding
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Lightweight URL cache helpful for repeated OpenTDB calls.
    let memory = 8 * 1024 * 1024   // 8 MB
    let disk   = 32 * 1024 * 1024  // 32 MB
    URLCache.shared = URLCache(memoryCapacity: memory, diskCapacity: disk, diskPath: "TriviaURLCache")


    return true
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    // No-op
  }
}

