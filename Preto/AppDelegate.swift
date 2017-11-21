//
//  AppDelegate.swift
//  Preto
//
//  Created by apple on 06/07/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import FBSDKLoginKit
import CoreLocation
import GoogleMaps
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var isConnectedToNetwork = true
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    var nibContents: [Any]?
    var latitude:Double = 0
    var longitude:Double = 0
    var userAddress = ""
    let locationManager = CLLocationManager()
    var languageBundle = Bundle()
    let gcmMessageIDKey = "gcm.message_id"
    var jungleBoxImagesArray = NSArray()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        fetchLanguageBundle()
        
        GMSServices.provideAPIKey(googleMapSdkApiKey)
        fetchCurrentLocation()
        
        // checking internet connectivity
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            if String(describing: status) == "notReachable"{
                self.isConnectedToNetwork = false
            }
            else{
                self.isConnectedToNetwork = true
            }
        }
        manager?.startListening()
        
        // loading xib files
        nibContents = Bundle.main.loadNibNamed("activityIndicatorView", owner: nil, options: nil)
        
        
        // checking login
        
        let loginCheck = userDefault.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if(loginCheck){
            let homeVcObj = storyboard.instantiateViewController(withIdentifier: "homeVc")as! HomeVC
            (self.window?.rootViewController as! UINavigationController).pushViewController(homeVcObj, animated: false)
        }
        
        
        
        /////////////--------------- firebase--------------//////////////////
        
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        
        /////////////////////////////////////////////////////////////////////
        
        
        
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }

    
    func fetchLanguageBundle() {
        var languageIdentifier = ""
        let currentLanguage = getCurrentLanguage()
        if currentLanguage == "en" {
            languageIdentifier = "Base"
        }
        else{
            languageIdentifier = currentLanguage
        }
        
        if let path = Bundle.main.path(forResource: languageIdentifier, ofType: "lproj") {
        languageBundle = Bundle(path: path)!
        }
        else{
            print("path not found")
        }
    }
    
    
    // MARK: Fetching User Location
    
    func fetchCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        let latestLocation:CLLocation = locations.last!
        print(latestLocation)
        applicationDelegate.latitude = latestLocation.coordinate.latitude
        applicationDelegate.longitude = latestLocation.coordinate.longitude
        locationManager.delegate = nil
        // reverseGeoCode(latitude:  applicationDelegate.latitude, longitude: applicationDelegate.longitude)
    }
    
    func reverseGeoCode(latitude: Double, longitude: Double) {
        let clGeocoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude:latitude, longitude: longitude)
        clGeocoder.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    print("completeAddress is \(addressString)")
                    self.userAddress = pm.locality ?? ""
                }
        })
        
    }
    
    // MARK: - Activity indicator view functions
    
    func showActivityIndicatorView(){
        let nibMainview = nibContents![0] as! UIView
        let activityIndicator = (nibMainview.viewWithTag(2)! as! UIActivityIndicatorView)
        activityIndicator.startAnimating()
        self.window?.rootViewController?.view.addSubview(nibMainview)
        nibMainview.center = (self.window?.rootViewController?.view.center)!
    }
    
    func hideActivityIndicatorView(){
        let nibMainview = nibContents![0] as! UIView
        nibMainview.removeFromSuperview()
    }
    
    func application(_ application: UIApplication,open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        
        if(url.scheme!.isEqual("fb1971397719794758")) {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                         open: url,
                                                                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                                         annotation: options [UIApplicationOpenURLOptionsKey.annotation])
        }
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Preto")
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
    
        
    func randomString(length: Int) -> String {
//        let letters : NSString = "0123456789"
//        let len = UInt32(letters.length)
//        var randomString = ""
//        for _ in 0 ..< length {
//            let rand = arc4random_uniform(len)
//            var nextChar = letters.character(at: Int(rand))
//            randomString += NSString(characters: &nextChar, length: 1) as String
//        }
        
        let rand = arc4random_uniform(UInt32(jungleBoxImagesArray.count))
        print(rand)
        return rand.description
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        userDefault.set(fcmToken, forKey: USER_DEFAULT_FireBaseToken)
        
//        let loginCheck = userDefault.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key)
//        if(loginCheck){
//            hitRegisterTokenApi(token: fcmToken)
//        }
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

extension NSArray {
    func at(index: Int) -> Element? {
        if index < 0 || index > self.count - 1 {
            return nil
        }
        return self[index]
    }
}

