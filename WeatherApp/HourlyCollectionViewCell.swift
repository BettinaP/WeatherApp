//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Bettina on 10/16/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var hourlyTimeLabel: UILabel!
    @IBOutlet weak var hourlyIconImageView: UIImageView!
    @IBOutlet weak var hourlyTempLabel: UILabel!
    
    
    func configureHourlyCell(hourlyForecast:HourlyWeather) {
        
        
        self.hourlyIconImageView.image = UIImage(named: hourlyForecast.hourlyIcon)
        
        if hourlyForecast.hourlyIcon == "clear-day"{
            
            self.hourlyIconImageView.tintColor = UIColor.yellowColor()
        }
        
       
        let date = NSDate(timeIntervalSince1970: hourlyForecast.hourlyTime)
        print(date)
        
        let hour = getHour(date)
        
        print("hour config in custom cell: \(hour)")
//        let date = NSDate(timeIntervalSince1970: dailyForecast.dailyTime)
//        print(date)
//        let dayOfWeek = getDayNameBy(date)
//        print(dayOfWeek)
//        
        self.hourlyTimeLabel.text = String(hour)
        self.hourlyTempLabel.text = String(hourlyForecast.hourlyTemp)
       
    }
}


func getHour(date: NSDate) -> String {
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.dateFormat = "h a"
    dateFormatter.timeZone = NSTimeZone()
    
    return dateFormatter.stringFromDate(date)
}