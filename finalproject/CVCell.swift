//
//  CVCell.swift
//  finalproject
//
//  Created by Taylor Dixon on 4/25/16.
//  Copyright © 2016 USU. All rights reserved.
//

import UIKit
import EventKit

class CVCell: UICollectionViewCell{
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var reminder: EKReminder!
    {
        didSet
        {
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "dd"
            
            if let dueDate = reminder.dueDateComponents?.date{
                self.dayLabel.text = formatter.stringFromDate(dueDate)
            }else{
                self.dayLabel.text? = reminder.title
            }
            formatter.dateFormat = "MMM"
            if let dueDate = reminder.dueDateComponents?.date{
                self.monthLabel.text = formatter.stringFromDate(dueDate)
            }else{
                self.monthLabel.text? = reminder.title
            }
            
            descriptionLabel.text? = reminder.title
            
        }
    }
}
