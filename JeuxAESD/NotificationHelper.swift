//
//  NotificationHelper.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-06.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation
import UIKit

class NotificationHelper {
    static func register() {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    static func schedule(id: String, message: String, triggerAt: Date) -> Bool {
        Logger.debug("Attempting to schedule notification")
        
        if (get(id: id) != nil) {
            cancel(id: id)
        }
        
        guard let settings = UIApplication.shared.currentUserNotificationSettings else {
            return false
        }
        
        // check if we are allowed to schedule a notification
        if (!UIApplication.shared.isRegisteredForRemoteNotifications && (settings.types.contains(.alert) || settings.types.contains(.badge) || settings.types.contains(.sound))) {
            // init notification
            let notification = UILocalNotification()
            
            // set values
            notification.fireDate = triggerAt
            notification.alertBody = message
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["id": id]
            
            // schedule notification
            UIApplication.shared.scheduleLocalNotification(notification)
            
            Logger.info("Successfully scheduled notification")
            
            // return success
            return true
        }
        
        Logger.info("Failed to schedule notification")
        
        return false
    }
    
    static func cancel(id: String) {
        // make sure notification exists
        guard let notification = get(id: id) else {
            return
        }
        
        // cancel notification
        UIApplication.shared.cancelLocalNotification(notification)
    }
    
    static func get(id: String) -> UILocalNotification? {
        Logger.info("Getting notification for id \(id)")
        
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else {
            return nil
        }
        
        Logger.debug("Found \(notifications.count) notifications")
        
        for notification in notifications {
            guard let userInfo = notification.userInfo else {
                Logger.warn("No userInfo")
                continue
            }
            
            guard let notificationId = userInfo["id"] as? String else {
                Logger.warn("Failed to get ID from userInfo")
                continue
            }
            
            Logger.info(notificationId + " " + id)
            
            if notificationId == id {
                return notification
            }
        }
        
        return nil
    }
    
    static func cancelAll() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
}
