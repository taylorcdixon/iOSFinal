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
    //var numerOfRowsInSection: [Int]
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        
        //permission
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted: Bool, error: NSError?) -> Void in
            
            if granted{
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
    
    //SEGUE PREP
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destNavVC = segue.destinationViewController as! UINavigationController
        let newReminderVC = destNavVC.topViewController as! AddReminder
        newReminderVC.eventStore = eventStore
    }
    
    //LOAD REMINDERS
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0{
//            return "Today"
//        }
//        else {
//            return "Later"
//        }
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell")
        let reminder:EKReminder! = reminders![indexPath.row]
        cell.textLabel?.text = reminder.title
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        if let dueDate = reminder.dueDateComponents?.date{
            cell.detailTextLabel?.text = formatter.stringFromDate(dueDate)
        }else{
            cell.detailTextLabel?.text = "no due date"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let reminder: EKReminder = reminders[indexPath.row]
        do{
            try eventStore.removeReminder(reminder, commit: true)
            self.reminders.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }catch{
            print("An error occurred while removing the reminder from the Calendar database: \(error)")
        }
    }
    
    
    //SWIPE DELETE
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let reminder: EKReminder = reminders[indexPath.row]
        do{
            try eventStore.removeReminder(reminder, commit: true)
            self.reminders.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }catch{
            print("An error occurred while removing the reminder from the Calendar database: \(error)")
        }
    }
    
    
}
