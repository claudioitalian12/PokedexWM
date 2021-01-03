//
//  AppDelegate.swift
//  Pokedex
//
//  Created by claudio cavalli on 27/12/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let splitViewController = UISplitViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setup()
        self.style()
        
        return true
    }
    
    private func setup() {
        let pokemonListViewController = PokemonListViewController()
        let navController = UINavigationController(rootViewController: pokemonListViewController)
        
        let pokemonDetailViewController = PokemonDetailViewController()
        
        splitViewController.viewControllers = [navController, pokemonDetailViewController]
        splitViewController.delegate = self
        
        self.window = UIWindow()
        self.window?.rootViewController = splitViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func style() {
        splitViewController.preferredDisplayMode = .allVisible
        
        if #available(iOS 13.0, *) { window?.overrideUserInterfaceStyle = .light }
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        true
    }
}
