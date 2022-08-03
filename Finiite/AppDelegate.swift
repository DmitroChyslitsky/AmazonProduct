//
//  AppDelegate.swift
//  Finiite
//
//  Created by Dmytro on 2/22/21.
//  Copyright © 2021 Dmytro. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Amplify
import AmplifyPlugins
import LoginWithAmazon
import FBSDKLoginKit
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let service = ServiceFacade()
        service.registerDefaultService()
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // Add AppsFlyer
        AppsFlyerLib.shared().appsFlyerDevKey = "vSQ2kQkFz2oBMpeNHSZST7"
        AppsFlyerLib.shared().appleAppID = "id1556299903"
        //  Set isDebug to true to see AppsFlyer debug logs
        AppsFlyerLib.shared().delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) { window?.overrideUserInterfaceStyle = .light }
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let rootNC = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify configured with storage plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
        FiniiteProducts.store.requestProducts { (true, products) in

        }
        
        return true
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        if url.absoluteString.contains("google") {
            return GIDSignIn.sharedInstance().handle(url)
        } else if (url.absoluteString.contains("fb")) {
            return ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        } else {
            return AMZNAuthorizationManager.handleOpen(url, sourceApplication: nil)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppsFlyerLib.shared().start()
        AppsFlyerLib.shared().start(completionHandler: { (dictionary, error) in
                    if (error != nil){
                        print(error ?? "")
                        return
                    } else {
                        print(dictionary ?? "")
                        return
                    }
                })
    }

}
extension AppDelegate: AppsFlyerLibDelegate {
     
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        
        print("onConversionDataSuccess data:")
        for (key, value) in data {
            print(key, ":", value)
        }
        
        if let status = data["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = data["media_source"],
                    let campaign = data["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = data["is_first_launch"] as? Bool,
                is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print("\(error)")
    }
}

