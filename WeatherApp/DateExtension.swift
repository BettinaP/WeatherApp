//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Bettina on 11/11/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit

extension Date {

    func getWeekOfDayString() -> String {
        let dateFormatter  = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE" // use dateFormat each time to specify what format you want to receive the date as ...can  be used multiple times within function
        return dateFormatter.string(from: self);
    }
    
    func getHour() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = TimeZone()
        
        return dateFormatter.string(from: self)
    }
    
    func getDayStamp() -> String {
        let dateFormatter  = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self);
    }
    
}
