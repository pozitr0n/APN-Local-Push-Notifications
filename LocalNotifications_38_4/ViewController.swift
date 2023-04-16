//
//  ViewController.swift
//  LocalNotifications_38_4
//
//  Created by Raman Kozar on 17/04/2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var mainStepper: UIStepper!
    @IBOutlet weak var mainButton: UIButton!
    
    var currentStepperValue: Int = 0
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStepper.stepValue = 1
        mainStepper.minimumValue = 0
    
    }

    @IBAction func startLocalPushButton(_ sender: Any) {
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            guard granted else { return }
            
            self.center.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
            }
            
        }
        
        center.delegate = self
        pushLocalNotification(currentStepperValue)
        
    }
    
    @IBAction func changeStepper(_ sender: Any) {
        
        currentStepperValue = Int(mainStepper.value)
        indexLabel.text = String(currentStepperValue)
        
    }
    
    func pushLocalNotification(_ currentStepperValue: Int) {
        
        let content = UNMutableNotificationContent()
        content.badge = 1
        content.title = "Test local push"
        content.body = "Test local push-notification in \(currentStepperValue) seconds"
        content.sound = UNNotificationSound.default
        
        let myTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(currentStepperValue), repeats: false)
        let myGUIDString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: myGUIDString, content: content, trigger: myTrigger)
        
        center.add(request) { error in
            print(error?.localizedDescription as Any)
        }
        
    }

}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(#function)
    }
    
}

