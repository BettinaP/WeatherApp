//
//  SavedLocationTableViewCell.swift
//  WeatherApp
//
//  Created by Bettina on 10/24/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit

class SavedLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var savedTimeLabel: UILabel!
    @IBOutlet weak var savedCityLabel: UILabel!
    @IBOutlet weak var savedCurrentTemp: UILabel!
    @IBOutlet weak var savedWeatherIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func getHour(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = NSTimeZone()
        
        return dateFormatter.stringFromDate(date)
    }
    
    func configureSavedCityCell(cityCurrentForecast:SavedLocation) {
        let store = ForecastDataStore.sharedInstance
        
        let locationToPass = LocationWeather()
        
        if let unwrappedSavedCityName = cityCurrentForecast.locationName {
            locationToPass.locationName = unwrappedSavedCityName
        }
        
        guard let unwrappedSavedCityLatitude = cityCurrentForecast.latitude as? Double else {return}
        locationToPass.latitude = unwrappedSavedCityLatitude
        
        guard let unwrappedSavedCityLongitude = cityCurrentForecast.longitude as? Double else {return}
        locationToPass.longitude = unwrappedSavedCityLongitude
        
        DarkSkyAPIClient.getForecast(locationToPass.latitude, longitude: locationToPass.longitude) { (forecast) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                self.savedWeatherIcon.image = UIImage(named:forecast.icon)
                
                self.savedCurrentTemp.text = "\(forecast.temperature)°"
                
                let date = NSDate(timeIntervalSince1970: forecast.time)
                let hour = self.getHour(date)
                self.savedTimeLabel.text = String(hour)
            })
        }
        //
        //            self.savedWeatherIcon.image = UIImage(named: cityCurrentForecast.icon)
        //
        //            self.savedCityLabel.text = cityCurrentForecast.timezone
        //
        //            self.savedCurrentTemp.text = String(cityCurrentForecast.temperature)
        //
        //            let date = NSDate(timeIntervalSince1970: cityCurrentForecast.time)
        //
        //            let hour = getHour(date)
        //
        //            print("saved time config in custom saved City cell: \(hour)")
        //            //        let date = NSDate(timeIntervalSince1970: dailyForecast.dailyTime)
        //            //        print(date)
        //            //        let dayOfWeek = getDayNameBy(date)
        //            //        print(dayOfWeek)
        //            //
        //            self.savedTimeLabel.text = String(hour)
        
    }
}
