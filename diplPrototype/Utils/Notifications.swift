//
//  Notifications.swift
//  diplPrototype
//
//  Created by Luka Sonjic on 28/06/2018.
//  Copyright © 2018 Luka Sonjic. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationsDelegate()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

class Notifications {
    
    static let shared = Notifications()
    
    let center = UNUserNotificationCenter.current()
    
    let options: UNAuthorizationOptions = [.alert, .sound]
    var content = UNMutableNotificationContent()
    var trigger: UNCalendarNotificationTrigger?
    
    func requestAuthorization(){
        self.center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Odbijeno korištenje notifikacija.")
            } else {
                self.getNotificationsSettings()
            }
        }
    }
    
    func getNotificationsSettings() {
        self.center.getNotificationSettings {
            (settings) in
            if settings.authorizationStatus != .authorized {
                //notifikacije nisu dozvoljene
            } else {
                self.setContent(hour: nil)
            }
        }
    }
    
    func setContent(hour: Int?){
        self.content.title = "Cancer Monitor"
        self.content.body = "Unesite dnevno stanje"
        self.content.sound = UNNotificationSound.default()
       
        self.setTriggers(hour: hour)
    }
    
    func setTriggers(hour: Int?){
        var triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        triggerDaily.minute = 0
        triggerDaily.second = 0
        triggerDaily.hour = (hour != nil) ? hour : 20
        self.trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerDaily, repeats: true)
        self.requestNotification()
    }
    
    func changeTime(hour: Int){
        self.removeAll()
        self.setContent(hour: hour)
    }
    
    func requestNotification(){
        let request = UNNotificationRequest(identifier: "Notification", content: self.content, trigger: trigger!)
        self.center.add(request) {
            (error) in
            if error != nil {
                print(error.debugDescription)
            }
        }
    }
    
    func removeAll(){
        self.center.removeAllPendingNotificationRequests()
    }
    
    func printSettings() {
        self.center.getPendingNotificationRequests {
            (requests) in
            print(requests)
            for req in requests {
                print(req)
            }
        }
    }
}

