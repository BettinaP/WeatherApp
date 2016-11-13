//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Bettina on 11/11/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit

extension NSDate {

    func getWeekOfDayString() -> String {
        let dateFormatter  = NSDateFormatter()
        
        dateFormatter.dateFormat = "EEEE" // use dateFormat each time to specify what format you want to receive the date as ...can  be used multiple times within function
        return dateFormatter.stringFromDate(self);
    }
    
    func getHour() -> String {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = NSTimeZone()
        
        return dateFormatter.stringFromDate(self)
    }
    
    func getDayStamp() -> String {
        let dateFormatter  = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.stringFromDate(self);
    }
    
}
