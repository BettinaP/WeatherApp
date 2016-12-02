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
    
    let store = ForecastDataStore.sharedInstance
    
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
    }
    
    override func didMoveToSuperview() {
        
        let gradientLayer = CAGradientLayer()
        
        var background = CAGradientLayer().generateColor(.Sky)
        
        let currentTempBackground = self.store.currentTemperature
        
        switch currentTempBackground {
            
        case 95...200:
            background = CAGradientLayer().generateColor(.BlazingHot)
        case 80...94:
            background = CAGradientLayer().generateColor(.Hot)
        case 70...79:
            background = CAGradientLayer().generateColor(.Warm)
        case 61...69:
            background = CAGradientLayer().generateColor(.Warmish)
        case 55...60:
            background = CAGradientLayer().generateColor(.Coolish)
        case 45...54:
            background = CAGradientLayer().generateColor(.Cool)
        case 25...44:
            background = CAGradientLayer().generateColor(.Cold)
        case 1...24:
            background = CAGradientLayer().generateColor(.Freezing)
        case -100...0:
            background = CAGradientLayer().generateColor(.Frigid)
        default:
            background = CAGradientLayer().generateColor(.Sky)
        }
//        
//        gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
//        gradientLayer.locations = [0.6, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, below: self.savedWeatherIcon.layer)
    }
}
