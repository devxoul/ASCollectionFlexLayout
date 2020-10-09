//
//  AppDelegate.swift
//  ASCollectionFlexLayoutExample
//
//  Created by Suyeol Jeon on 2020/10/10.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .black
    window.rootViewController = UINavigationController(rootViewController: ExampleViewController())
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
