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
    
    
    func configureHourlyCell(_ hourlyForecast:HourlyWeather) {
        
        
        self.hourlyIconImageView.image = UIImage(named: hourlyForecast.hourlyIcon)
        
        if hourlyForecast.hourlyIcon == "clear-day"{
            
            self.hourlyIconImageView.tintColor = UIColor.yellow
        }
        
       
        let date = Date(timeIntervalSince1970: hourlyForecast.hourlyTime)
        
        let hour = getHour(date)
        
        self.hourlyTimeLabel.text = String(hour)
        self.hourlyTempLabel.text = "\(hourlyForecast.hourlyTemp)°"
       
    }
}


func getHour(_ date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.short
    dateFormatter.dateFormat = "h a"
    dateFormatter.timeZone = TimeZone()
    
    return dateFormatter.string(from: date)
}
