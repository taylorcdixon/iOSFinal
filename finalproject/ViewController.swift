//
//  ViewController.swift
//  finalproject
//
//  Created by Taylor Dixon on 3/1/16.
//  Copyright © 2016 USU. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    let eventStore = EKEventStore()
    var reminders: [EKReminder]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        checkAuthorizationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            requestCalendarAccess()
            
        case EKAuthorizationStatus.Authorized:
            print ("already authorized")
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            print ("access has been denied")
            
            
        }
        
        let status2 = EKEventStore.authorizationStatusForEntityType(EKEntityType.Reminder)
        
        switch (status2) {
        case EKAuthorizationStatus.NotDetermined:
            requestReminderAccess()
            
        case EKAuthorizationStatus.Authorized:
            print ("already authorized")
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            print ("access has been denied")
            
        }
    }
    
    
    func requestCalendarAccess() {
        
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(),{
                    print ("access granted")
                })
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    print("access denied")
                })
            }
        })
    }
    
    func requestReminderAccess(){
        eventStore.requestAccessToEntityType(EKEntityType.Reminder, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(),{
                    print ("access granted")
                })
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    print("access denied")
                })
            }
        })
    }
    
    
}

