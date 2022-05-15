//
//  NotficationHandler.swift
//  TV Show App
//
//  Created by AJ Glodowski on 5/14/22.
//

import Foundation
import UserNotifications

func requestAuth() {
    
    UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
        if (notificationSettings.authorizationStatus != .authorized) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if (success) { print("Notifications Authorized") }
                else if let error = error {  print(error.localizedDescription) }
            }
        }
    }
}

func pushNotfication(shows: [Show]) {
    var airingToday = false
    var message = "Shows with new episodes today are "
    let weekday = Calendar.current.component(.weekday, from: Date())
    let airing = shows.filter { $0.status == Status.CurrentlyAiring }
    for show in airing {
        if (show.airdate.id+1 == weekday) {
            airingToday = true
            message = message + show.name + ", "
        }
    }
    if (!airingToday) { return }
    message = String(message.dropLast(2))
    let content = UNMutableNotificationContent()
    content.title = "New Episodes Today"
    content.body = message
    print(message)
    content.sound = UNNotificationSound.default
    
    /*
    // Testing notfications
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
    */
    
    var datComp = DateComponents()
    datComp.hour = 8
    datComp.minute = 0
    let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
        if let theError = error {
            print(theError.localizedDescription)
        }
    }
     
    
}
