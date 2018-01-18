//
//  ViewController.swift
//  LocalNotificationDemo
//
//  Created by Ashwinkumar Mangrulkar on 18/01/18.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var messageSubtitle = "messageSubtitle"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
//            // Handle Error
//        })
        UNUserNotificationCenter.current().delegate = self
    }

    @IBAction func fireNotificationAction(_ sender: Any) {
        sendNotification()
    }
    
    func sendNotification()
    {
        // Swift
        let content = UNMutableNotificationContent()
        content.title = "Meeting Reminder"
        content.subtitle = messageSubtitle
        content.body = "Don't forget to bring coffee."
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                // Handle error
        })
        
        let repeatAction = UNNotificationAction(identifier:"repeat",
                                                title:"Repeat",options:[])
        let changeAction = UNTextInputNotificationAction(identifier:
            "change", title: "Change Message", options: [])
        
        let category = UNNotificationCategory(identifier: "actionCategory",
                                              actions: [repeatAction, changeAction],
                                              intentIdentifiers: [], options: [])
        
        content.categoryIdentifier = "actionCategory"
        
        UNUserNotificationCenter.current().setNotificationCategories(
            [category])
    }
    
    //MARK:- Delegate methods
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "repeat":
            self.sendNotification()
        case "change":
            let textResponse = response
                as! UNTextInputNotificationResponse
            messageSubtitle = textResponse.userText
            self.sendNotification()
        default:
            break
        }
        completionHandler()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

