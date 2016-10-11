//
//  LocationWeather.swift
//  WeatherApp
//
//  Created by Bettina on 10/10/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import Foundation


class LocationWeather {
    
    //Location's overall basic dictionary based of provided latitude, longitude
    var latitude: Double
    var longitude: Double
    var timezone: String
    var currently: [String: AnyObject]
    var minutely: [String : AnyObject]
    var hourly: [String : AnyObject]
    var daily : [String : AnyObject]
    var alerts : [[String: AnyObject]]
    var flags: [String : AnyObject]
    
    // details in nested dictionary
    
    var icon = String()
    var time = Int()
    var overallSummary = String ()
    var datapointSummary = String ()
    var data = [[String : AnyObject]]()
    var nearestStormDistance : Int
    var precipIntensity : Double
    var precipProbability : Int
    var precipType : String
    var temperature: String
    var temperatureMin: Double
    var temperatureMax: Double
    var apparentTemperature: Double
    var apparentTemperatureMin: Double
    var apparentTemperatureMax: Double
    var dewPoint: Double
    var humidity: Double
    var windSpeed: Double
    var visibility: Double
    var cloudCover: Double
    var pressure: Double
    var ozone: Double
    var sunriseTime: Int
    var sunsetTime : Int
    var moonPhase : Double
    
    init?(basicDictionary: NSDictionary) {
        
        guard let
            locLatitude = basicDictionary["latitude"] as? Double,
            locLongitude = basicDictionary["longitude"] as? Double,
            locTimeZone = basicDictionary["timezone"] as? String,
            locCurrently = basicDictionary["currently"] as? [String : AnyObject],
            locMinutely = basicDictionary["minutely"] as? [String : AnyObject],
            locHourly = basicDictionary["hourly"] as? [String : AnyObject],
            locDaily = basicDictionary["daily"] as? [String : AnyObject],
            locAlerts = basicDictionary["alerts"] as? [[String : AnyObject]],
            locFlags = basicDictionary["flags"] as? [String : AnyObject]
            
            else {return nil}
        
        self.latitude = locLatitude
        self.longitude = locLongitude
        self.timezone = locTimeZone
        self.currently = locCurrently
        self.minutely = locMinutely
        self.hourly = locHourly
        self.daily = locDaily
        self.alerts = locAlerts
        self.flags = locFlags
        
    }
    
    
    //to access and update currently dictionary, hourly dictionary, daily dictionary
    
    func updateForecastDetails(forecastDictionary: NSDictionary){
        
        for forecastKey in (forecastDictionary.allKeys as! [String]) {
            
            if let dictionary = forecastDictionary[forecastKey] {
            
            if forecastKey == "currently" {
                
                self.icon = dictionary["icon"] as? String ?? nil
                self.time = dictionary["time"] as? Int ?? nil
                self.summary = dictionary["summary"] as? String ?? nil
                self.precipIntensity = dictionary["precipIntensity"]as? Double ?? nil
                self.precipProbability = dictionary["precipProbability"] as? Int ?? nil
                self.temperature = dictionary["temperature"] as? String ?? nil
                self.apparentTemperature = dictionary["apparentTemperature"] as? Double ?? nil
                self.dewPoint = dictionary["dewPoint"] as? Double ?? nil
                self.humidity = dictionary["humidity"] as? Double ?? nil
                self.windSpeed = dictionary["windSpeed"] as? Double ?? nil
                self.cloudCover = dictionary["cloudCover"] as? Double ?? nil
                self.pressure = dictionary["pressure"] as? Double ?? nil
                self.ozone = dictionary["ozone"] as? Double ?? nil
                
            } else if forecastKey == "hourly" {
                
                
                self.overallSummary = dictionary["summary"]
                self.icon = dictionary["icon"]
                
                self.data = dictionary["data"] as? [[String : AnyObject]] ?? nil
                
                for datapoint in data {
                    self.time = datapoint["time"]
                    self.datapointSummary = datapoint["summary"]
                    
                    
                }
                
                
            } else if forecastKey == "daily" {
                
                
            } else{
                
                
            }
            
            }
            
        }
        
        var icon : String
        var time : Int
        var summary : String
        var data : [[String : AnyObject]]
        var nearestStormDistance : Int
        var precipIntensity : Double
        var precipProbability : Int
        var precipType : String
        var temperature: String
        var temperatureMin: Double
        var temperatureMax: Double
        var apparentTemperature: Double
        var apparentTemperatureMin: Double
        var apparentTemperatureMax: Double
        var dewPoint: Double
        var humidity: Double
        var windSpeed: Double
        var visibility: Double
        var cloudCover: Double
        var pressure: Double
        var ozone: Double
        var sunriseTime: Int
        var sunsetTime : Int
        var moonPhase : Double
        
        
        
        
        
    }
    
    //alerts dictionary--do i initialize keys here as well or later if need be "title", "time", "expires", "description", "uri"
    
    
    
    
}