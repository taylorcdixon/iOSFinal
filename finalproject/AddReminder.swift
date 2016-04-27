//
//  Reminder.swift
//  finalproject
//
//  Created by Taylor Dixon on 4/23/16.
//  Copyright © 2016 USU. All rights reserved.
//

import EventKit
import UIKit

class AddReminder: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var reminderTextField: UITextField!
    
    var eventStore: EKEventStore!
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action:#selector(AddReminder.addDate), forControlEvents: UIControlEvents.ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateTextField.inputView = datePicker
        reminderTextField.becomeFirstResponder()
    }

    func addDate(){
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        let dueDate = self.datePicker.date
        self.dateTextField.text = formatter.stringFromDate(dueDate)
    }
    
    @IBAction func save(sender: AnyObject) {
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = reminderTextField.text!
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dueDateComponents = appDelegate.dateComponentFromNSDate(self.datePicker.date)
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        
        do {
            try self.eventStore.saveReminder(reminder, commit: true)
            dismissViewControllerAnimated(true, completion: nil)
        }catch{
            print("Error creating and saving new reminder : \(error)")
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
