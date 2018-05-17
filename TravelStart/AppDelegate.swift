//
//  AppDelegate.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        setupRootViewController()
        setupNaviTheme()
        setupThirdPartySettings()
    
        return true
    }

}

extension AppDelegate {
    func setupRootViewController() {
        let touristSitesStoryboard = UIStoryboard(name: "TouristSites", bundle: nil)
        let touristSiteListViewController = touristSitesStoryboard.instantiateViewController(withIdentifier: "TouristSiteListViewController")
        let navigationViewController = UINavigationController(rootViewController: touristSiteListViewController)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func setupNaviTheme() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor.Theme.navigationBarColor
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBarAppearace.barStyle = .black
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    func setupThirdPartySettings() {
        // SDWebImage
        SDWebImageDownloader.shared().shouldDecompressImages = false
        
        // SVProgressHUD
        SVProgressHUD.setDefaultStyle(.dark)
    }
}

