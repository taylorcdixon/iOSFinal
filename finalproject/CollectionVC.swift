//
//  CollectionVC.swift
//  finalproject
//
//  Created by Taylor Dixon on 4/25/16.
//  Copyright © 2016 USU. All rights reserved.
//

import UIKit
import EventKit


class CollectionVC: UICollectionViewController{
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    
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
                        self.collectionView!.reloadData()
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
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView!.dequeueReusableCellWithReuseIdentifier("CVCell", forIndexPath: indexPath) as! CVCell
    
        cell.reminder = reminders[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let reminder: EKReminder = reminders[indexPath.row]
        do{
            try eventStore.removeReminder(reminder, commit: true)
            self.reminders.removeAtIndex(indexPath.row)
            collectionView.deleteItemsAtIndexPaths([indexPath])
        }catch{
            print("An error occurred while removing the reminder from the Calendar database: \(error)")
        }
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath){
        swap(&reminders[sourceIndexPath.row], &reminders[destinationIndexPath.row])
    }
}