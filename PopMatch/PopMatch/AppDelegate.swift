//
//  AppDelegate.swift
//  PopMatch
//
//  Created by Eden Avivi on 2/15/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        /*Reset User info if exists*/
        let uid = Auth.auth().currentUser?.uid ?? ""
        let db = FirebaseFirestore.Firestore.firestore()
        if uid != "" {
        /*Delete fields of current match for myself*/
        db.collection("users").document(uid).collection("matches").document("current match").delete()
        db.collection("users").document(uid).collection("matches").document("previous matches").delete()
        /* set is on call to false*/
        db.collection("users").document(uid).getDocument{(document, error) in
            if let document = document, document.exists {
                document.reference.updateData([
                    "isOnCall": "false"
                ])
            }
        }
    }
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        // Override point for customization after application launch.
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
