//
//  listViewController.swift
//  finalproject
//
//  Created by Taylor Dixon on 4/8/16.
//  Copyright © 2016 USU. All rights reserved.
//

import UIKit
import EventKit

class ListViewController: UITableViewController {
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // 1
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted: Bool, error: NSError?) -> Void in
            
            if granted{
                // 2
                let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
                self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [EKReminder]?) -> Void in
                    
                    self.reminders = reminders
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                })
            }else{
                print("not authorized")
            }
        }
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.reminders![indexPath.row].title
        
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
}