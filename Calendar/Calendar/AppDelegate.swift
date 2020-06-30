//
//  AppDelegate.swift
//  Calendar
//
//  Created by hyperactive on 15/05/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
        (didAllow, error) in
        if !didAllow {
            print("User has declined notifications")
            }}
        notificationCenter.delegate = self
        return true
    }
    
    func scheduleNotification(title: String, date: Date, identifier: String) {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = "this i a notification"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        
        let identifier = identifier
        let request = UNNotificationRequest(identifier: "roflCopterLol", content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

