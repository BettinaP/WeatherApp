//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Bettina on 10/12/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit 


class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dailyIconImageView: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureDailyCell(dailyForecast:DailyWeather) {
       
       
        self.dailyIconImageView.image = UIImage(named: dailyForecast.dailyIcon)
        if dailyForecast.dailyIcon == "clear-day"{
        
            self.dailyIconImageView.tintColor = UIColor.yellowColor()
        }
    
        let date = NSDate(timeIntervalSince1970: dailyForecast.dailyTime)
        print(date)
        let dayOfWeek = getDayNameBy(date)
        print(dayOfWeek)
        self.weekDayLabel.text = String(dayOfWeek)
        self.maxTempLabel.text = String(dailyForecast.dailyTempMax)
        self.minTempLabel.text = String(dailyForecast.dailyTempMin)
 
    }
    
    
    func getDayNameBy(date: NSDate) -> String {
        let df  = NSDateFormatter()
        df.dateFormat = "EEEE" // use dateFormat each time to specify what format you want to receive the date as ...can  be used multiple times within function
        return df.stringFromDate(date);
    }
 
}
