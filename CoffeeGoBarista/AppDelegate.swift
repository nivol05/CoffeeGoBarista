//
//  AppDelegate.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 28.06.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Firebase
import Tamamushi
import UserNotifications
import Firebase
import FirebaseMessaging
import SwiftMessages


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    //static var isMenuVC = true
    static var app: UIApplication!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppDelegate.app = application
//        TMGradientNavigationBar().setInitialBarGradientColor(direction: .vertical, startColor: .init(red: 1, green: 127/255, blue: 0, alpha: 1), endColor: .init(red: 1, green: 111/255, blue: 0, alpha: 1))
        // Override point for customization after application launch.
            let settings : UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
            FirebaseApp.configure()
            
            
            UIApplication.shared.statusBarStyle = .lightContent
            Messaging.messaging().delegate = self

        
        keyboard()
        
        
//        print(Messaging.messaging().apnsToken)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        if notif{
            //        isOrdered = true
            //                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "Bar")
            //                self.window?.rootViewController = homePage
            // Print full message.
            print("pesun \(userInfo)")
            
            guard
                let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
                let alert = aps["alert"] as? NSDictionary,
                let body = alert["body"] as? String,
                let title = alert["title"] as? String
                //            let aps2 = userInfo[AnyHashable("data1")] as? String
                
                else {
                    // handle any error here
                    return
            }
            
            //        print(aps2)
            
            
            if isNotifsEnabled(){
                notification(title: title, body: body)
            }
            
            completionHandler(UIBackgroundFetchResult.newData)
        }

    }
    
    func notification(title : String, body : String){
        let view = MessageView.viewFromNib(layout: .cardView)

        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "Bar")
        // Theme message elements with the warning style.
        //        view.configureTheme(.warning)
        view.configureTheme(.info)

        // Add a drop shadow.
        view.configureDropShadow()

        view.button?.isHidden = true

        if orderVCVisible{
            print("FORDANA")
//            isOrdered = true
            self.window?.rootViewController = homePage

        }

        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        let iconText = [""].sm_random()!
        view.configureContent(title: title, body: body, iconText: iconText)

        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)

        // Reduce the corner radius (applicable to layouts featuring rounded corners).


        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10


        var config = SwiftMessages.Config()
        //
        //        // Slide up from the bottom.
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)


        // Display in a window at the specified window level: UIWindow.Level.statusBar
        // displays over the status bar while UIWindow.Level.normal displays under.
        view.tapHandler = { _ in
//            isOrdered = true

            self.window?.rootViewController = homePage
            SwiftMessages.hide()
        }

        SwiftMessages.show(config : config , view: view)

    }
    
    
    
    static func dissableNotif(){
        app.unregisterForRemoteNotifications()
    }
    
    static func enableNotif(){
        app.registerForRemoteNotifications()
    }
    
    func keyboard(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Готово"
        //        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}

