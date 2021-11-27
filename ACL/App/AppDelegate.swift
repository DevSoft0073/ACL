//
//  AppDelegate.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import IQKeyboardManager
import GooglePlaces
import GoogleMaps
import CoreData
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        IQKeyboardManager.shared().isEnabled = true
        SwiftLoader.setACLConfig()
        GMSPlacesClient.provideAPIKey("AIzaSyAg75Ekm-fJV3fmMWULmwxp-z3E5P0p3RM")
        GMSServices.provideAPIKey("AIzaSyAg75Ekm-fJV3fmMWULmwxp-z3E5P0p3RM")

        sleep(3)
        
//        if DataManager.shared.userId != nil {
//            if DataManager.shared.isGuestUser{
//                gotoLoginViewController()
//            }else{
                moveToLandingPage()
//            }
//        } else {
//            gotoLoginViewController()
//        }
        
        registerForPushNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }

    
    
        func registerForPushNotifications() {
          UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) {
              [weak self] granted, error in
              print("Permission granted: \(granted)")
              
              guard granted else { return }
              self?.getNotificationSettings()
          }
    
      }
    
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
           InstanceID.instanceID().instanceID { (result, error) in
                 if let error = error {
                     print("Error fetching remote instance ID: \(error)")
                 } else if let result = result {
                     print("Remote instance ID token: \(result.token)")
                    DataManager.shared.token = result.token
                     //userObj.device_token = result.token
//                    self.updateFireBaseToken()
                 }
             }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
               Messaging.messaging().apnsToken = deviceToken

       }
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          completionHandler([.alert,.badge,.sound])
        }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if AudioPlayer.shared.isPlaying {
            if Singleton.sharedInstance.isNeedPlayback == true{

            }else{
                AudioPlayer.shared.pause()

            }
              }
//        if AudioPlayer.shared.isPlaying {
//                AudioPlayer.shared.pause()
//            }
              
        

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
        if Singleton.sharedInstance.remainSignIn == false{
            DataManager.shared.clear()
            print("data cleared")
        }
    }

    func moveToLandingPage() {
        let landingViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController")
        let navigationController = UINavigationController(rootViewController: landingViewController)
        navigationController.navigationBar.isHidden = true
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    // Move to login screen
    func gotoLoginViewController() {
        let loginViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true
        
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    /// Move to main view controller
    func gotoMainViewController() {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isHidden = true
        // chenge root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
    // MARK: - Core Data stack
       
       lazy var persistentContainer: NSPersistentContainer = {
           /*
            The persistent container for the application. This implementation
            creates and returns a container, having loaded the store for the
            application to it. This property is optional since there are legitimate
            error conditions that could cause the creation of the store to fail.
            */
           let container = NSPersistentContainer(name: "SearchData")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   
                   /*
                    Typical reasons for an error here include:
                    * The parent directory does not exist, cannot be created, or disallows writing.
                    * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                    * The device is out of space.
                    * The store could not be migrated to the current model version.
                    Check the error message to determine what the actual problem was.
                    */
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
       
       // MARK: - Core Data Saving support
       
       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
    
    
}

