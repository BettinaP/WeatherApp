//
//  LocationWeather.swift
//  WeatherApp
//
//  Created by Bettina on 10/10/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct DailyWeather {
    
    var dailyIcon: String
    var sunriseTime: Double
    var sunsetTime: Double
    var dailyTime: Double
    var dailyTempMin: Int
    var dailyTempMax: Int
    
    
}

struct HourlyWeather {
    
    var hourlyIcon = String()
    var hourlyTime = Double()
    var hourlyTemp = Int()
    
    
}


class LocationWeather {
    var summary = String()
    var icon = String()
    var precipProbability = String()
    var timezone = String()
    var time = Double()
    var temperature = Int()
    var apparentTemp = Int()
    
    var dailyDataArray = [JSON]()
    var hourlyDataArray = [JSON]()
    
    var dailyWeatherArray = [DailyWeather]()
    var hourlyWeatherArray = [HourlyWeather]()
    
    var todayDetails = [DailyWeather]()
    var today = NSDate()
    var convertedDailyDate = NSDate()
    
    
    init(currentWeather: JSON){
        
        self.timezone = currentWeather["timezone"].stringValue
        
        self.time = currentWeather["currently"]["time"].doubleValue //must convert UNIX  stamp
        self.summary = currentWeather["currently"]["summary"].stringValue
        self.icon = currentWeather["currently"]["icon"].stringValue
        self.temperature = currentWeather["currently"]["temperature"].intValue
        self.apparentTemp = currentWeather["currently"]["apparentTemperature"].intValue
        self.precipProbability = currentWeather["currently"]["precipProbability"].stringValue
        
        
        hourlyDataArray = currentWeather["hourly"]["data"].arrayValue
        for hourlyData in hourlyDataArray {
            let hourlyTime = hourlyData["time"].doubleValue
            let hourlyIcon = hourlyData["icon"].stringValue
            let hourlyTemp = hourlyData["temperature"].intValue
            
            
            let hourlyWeather = HourlyWeather(hourlyIcon: hourlyIcon, hourlyTime: hourlyTime, hourlyTemp: hourlyTemp)
            
            self.hourlyWeatherArray.append(hourlyWeather)
        }
        
        
        dailyDataArray = currentWeather["daily"]["data"].arrayValue
        for dailyData in dailyDataArray {
            
            let sunriseTime = dailyData["sunriseTime"].doubleValue
            let sunsetTime = dailyData["sunsetTime"].doubleValue
            let dailyTime = dailyData["time"].doubleValue
            let dailyIcon = dailyData["icon"].stringValue
            let dailyTempMin = dailyData["temperatureMin"].intValue
            let dailyTempMax = dailyData["temperatureMax"].intValue
            
            let dailyWeather = DailyWeather(dailyIcon: dailyIcon, sunriseTime: sunriseTime, sunsetTime: sunsetTime, dailyTime: dailyTime,  dailyTempMin: dailyTempMin, dailyTempMax: dailyTempMax)
            
            
            //trying to figure out how to exclude today's date from the weekday array since updates of current day will be displayed hourly
          
            self.dailyWeatherArray.append(dailyWeather)
            
            if today == NSDate(timeIntervalSince1970:dailyWeatherArray[0].dailyTime) {
            
                self.dailyWeatherArray.removeAtIndex(0)
//                self.dailyWeatherArray.removeFirst()
            }
            
//            convertedDailyDate = NSDate(timeIntervalSince1970: dailyWeather.dailyTime)
            //
            //            if today == convertedDailyDate {
            //
            //                let todaysDetails = dailyWeather
            //                print(todaysDetails)
            //                print("TODAY: \(today)")
            //                print("DAILYWEATHER.DAILYTIME: \(convertedDailyDate)")
            //                print("DAILY TIME: \(dailyTime)")
            //
            //            } else {
            //
            //                self.dailyWeatherArray.append(dailyWeather)
            //
            //            }
            
//            if today != convertedDailyDate {
//                
//                self.dailyWeatherArray.append(dailyWeather)
//                
//            } else {
//                
//                let todayAsCurrentDay = dailyWeather
//                
//                self.todayDetails.append(todayAsCurrentDay)
//                print(todayDetails)
//                print("TODAY: \(today)")
//                print("DAILYWEATHER.DAILYTIME: \(convertedDailyDate)")
//                print("DAILY TIME: \(dailyTime)")
//                
//                
//            }
        }
    }
}




/*
 
 class LocationWeather {
 
 //Location's overall weather dictionary based of provided latitude, longitude
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
 var datapointIcon = String()
 var time = Int()
 var overallSummary = String ()
 var datapointSummary = String ()
 var data = [[String : AnyObject]]()
 var nearestStormDistance = Int()
 var precipIntensity = Double()
 var precipProbability = Int()
 var precipType = String()
 var temperature = Double()
 var temperatureMin = Double()
 var temperatureMax = Double()
 var apparentTemperature = Double()
 var apparentTemperatureMin = Double()
 var apparentTemperatureMax = Double()
 var dewPoint = Double()
 var humidity = Double()
 var windSpeed = Double()
 var visibility = Double()
 var cloudCover = Double()
 var pressure = Double ()
 var ozone = Double()
 var sunriseTime = Int()
 var sunsetTime = Int()
 var moonPhase = Double()
 
 init?(weatherDictionary: NSDictionary) {
 
 guard let
 locLatitude = weatherDictionary["latitude"] as? Double,
 locLongitude = weatherDictionary["longitude"] as? Double,
 locTimeZone = weatherDictionary["timezone"] as? String,
 locCurrently = weatherDictionary["currently"] as? [String : AnyObject],
 locMinutely = weatherDictionary["minutely"] as? [String : AnyObject],
 locHourly = weatherDictionary["hourly"] as? [String : AnyObject],
 locDaily = weatherDictionary["daily"] as? [String : AnyObject],
 locAlerts = weatherDictionary["alerts"] as? [[String : AnyObject]],
 locFlags = weatherDictionary["flags"] as? [String : AnyObject]
 
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
 
 func updateForecastDetails(forecastDictionary: NSDictionary) {
 
 for forecastKey in (forecastDictionary.allKeys as! [String]) {
 
 guard let dictionary = forecastDictionary[forecastKey] else {return}
 
 if forecastKey == "currently" {
 
 if let  unwrappedIcon =  dictionary["icon"] as? String {
 self.icon = unwrappedIcon
 } //dictionary["icon"] as? String ?? nil
 
 if let unwrappedTime = dictionary["time"] as? Int {
 
 self.time = unwrappedTime
 }
 
 if let unwrappedSummary = dictionary["summary"] as? String {
 
 self.datapointSummary = unwrappedSummary
 }
 
 if let unwrappedPrecipInt = dictionary["precipIntensity"]as? Double {
 
 self.precipIntensity = unwrappedPrecipInt
 
 }
 
 if let unwrappedPrecipProb = dictionary["precipProbability"] as? Int {
 
 self.precipProbability = unwrappedPrecipProb
 }
 
 if let unwrappedTemperature = dictionary["temperature"] as? Double {
 self.temperature = unwrappedTemperature
 
 }
 
 if let unwrappedApparentTemp = dictionary["apparentTemperature"] as? Double {
 
 self.apparentTemperature = unwrappedApparentTemp
 }
 
 if let unwrappedDewPoint = dictionary["dewPoint"] as? Double {
 self.dewPoint = unwrappedDewPoint
 }
 
 if let unwrappedHumidity = dictionary["humidity"] as? Double {
 
 self.humidity = unwrappedHumidity
 }
 
 if let  unwrappedWindSpeed = dictionary["windSpeed"] as? Double {
 self.windSpeed = unwrappedWindSpeed
 }
 
 if let unwrappedCloudCover = dictionary["cloudCover"] as? Double {
 self.cloudCover = unwrappedCloudCover
 }
 
 if let unwrappedPressure = dictionary["pressure"] as? Double {
 
 self.pressure = unwrappedPressure
 
 }
 
 if let unwrappedOzone = dictionary["ozone"] as? Double {
 
 self.ozone = unwrappedOzone
 }
 
 
 } else if forecastKey == "hourly" {
 
 if let unwrappedOverallSummary = dictionary["summary"] as? String {
 
 self.overallSummary = unwrappedOverallSummary
 
 }
 
 if let unwrappedIcon = dictionary["icon"] as? String {
 self.icon = unwrappedIcon
 
 }
 
 
 if let unwrappedData = dictionary["data"] as? [[String : AnyObject]] {
 
 self.data = unwrappedData
 
 for datapoint in self.data {
 
 
 if let unwrappedTime = datapoint["time"] as? Int {
 
 self.time = unwrappedTime
 }
 
 if let unwrappedSummary = datapoint["summary"] as? String {
 
 self.datapointSummary = unwrappedSummary
 }
 
 
 if let unwrappedDatapointIcon = datapoint["icon"] as? String {
 
 self.datapointIcon = unwrappedDatapointIcon
 }
 
 if let unwrappedPrecipInt = datapoint["precipIntensity"]as? Double {
 
 self.precipIntensity = unwrappedPrecipInt
 
 }
 
 if let unwrappedPrecipProb = datapoint["precipProbability"] as? Int {
 
 self.precipProbability = unwrappedPrecipProb
 }
 
 if let unwrappedTemperature = datapoint["temperature"] as? Double {
 self.temperature = unwrappedTemperature
 
 }
 
 if let unwrappedApparentTemp = datapoint["apparentTemperature"] as? Double {
 
 self.apparentTemperature = unwrappedApparentTemp
 }
 
 if let unwrappedDewPoint = datapoint["dewPoint"] as? Double {
 self.dewPoint = unwrappedDewPoint
 }
 
 if let unwrappedHumidity = datapoint["humidity"] as? Double {
 
 self.humidity = unwrappedHumidity
 }
 
 if let  unwrappedWindSpeed = datapoint["windSpeed"] as? Double {
 self.windSpeed = unwrappedWindSpeed
 }
 
 if let unwrappedCloudCover = datapoint["cloudCover"] as? Double {
 self.cloudCover = unwrappedCloudCover
 }
 
 if let unwrappedPressure = datapoint["pressure"] as? Double {
 
 self.pressure = unwrappedPressure
 
 }
 
 if let unwrappedOzone = datapoint["ozone"] as? Double {
 
 self.ozone = unwrappedOzone
 }
 
 
 }
 
 }
 
 } else if forecastKey == "daily" {
 
 if let unwrappedOverallSummary = dictionary["summary"] as? String {
 
 self.overallSummary = unwrappedOverallSummary
 
 }
 
 if let unwrappedIcon = dictionary["icon"] as? String {
 self.icon = unwrappedIcon
 
 }
 
 
 if let unwrappedData = dictionary["data"] as? [[String : AnyObject]] {
 
 self.data = unwrappedData
 
 for datapoint in self.data {
 
 
 if let unwrappedTime = datapoint["time"] as? Int {
 
 self.time = unwrappedTime
 }
 
 if let unwrappedSummary = datapoint["summary"] as? String {
 
 self.datapointSummary = unwrappedSummary
 }
 
 if let unwrappedDatapointIcon = datapoint["icon"] as? String {
 
 self.datapointIcon = unwrappedDatapointIcon
 }
 
 
 if let unwrappedSunriseTime = datapoint["sunriseTime"] as? Int {
 
 self.sunriseTime = unwrappedSunriseTime
 }
 
 
 if let unwrappedSunsetTime = datapoint["sunsetTime"] as? Int {
 
 self.sunsetTime = unwrappedSunsetTime
 }
 
 if let unwrappedMoonPhase = datapoint["moonPhase"] as? Double {
 
 self.moonPhase = unwrappedMoonPhase
 
 }
 
 if let unwrappedPrecipInt = datapoint["precipIntensity"]as? Double {
 
 self.precipIntensity = unwrappedPrecipInt
 
 }
 
 //precipIntensityMax maybe needed
 
 if let unwrappedPrecipProb = datapoint["precipProbability"] as? Int {
 
 self.precipProbability = unwrappedPrecipProb
 }
 
 if let unwrappedTempMin = datapoint["temperatureMin"] as? Double {
 
 self.temperatureMin = unwrappedTempMin
 }
 
 
 if let unwrappedTempMax = datapoint["temperatureMax"] as? Double {
 
 self.temperatureMax = unwrappedTempMax
 }
 
 
 if let unwrappedApparentTempMin = datapoint["apparentTemperatureMin"] as? Double {
 
 self.apparentTemperatureMin = unwrappedApparentTempMin
 }
 
 
 if let unwrappedApparentTempMax = datapoint["apparentTemperatureMax"] as? Double {
 
 self.apparentTemperatureMax = unwrappedApparentTempMax
 }
 
 if let unwrappedDewPoint = datapoint["dewPoint"] as? Double {
 self.dewPoint = unwrappedDewPoint
 }
 
 if let unwrappedHumidity = datapoint["humidity"] as? Double {
 
 self.humidity = unwrappedHumidity
 }
 
 if let  unwrappedWindSpeed = datapoint["windSpeed"] as? Double {
 self.windSpeed = unwrappedWindSpeed
 }
 // appMaxTempTime & appTempMinTime may be needed
 // maybe windBearing needed
 
 if let unwrappedCloudCover = datapoint["cloudCover"] as? Double {
 self.cloudCover = unwrappedCloudCover
 }
 
 if let unwrappedPressure = datapoint["pressure"] as? Double {
 
 self.pressure = unwrappedPressure
 
 }
 
 if let unwrappedOzone = datapoint["ozone"] as? Double {
 
 self.ozone = unwrappedOzone
 }
 
 }
 
 }
 
 
 }
 
 }
 
 }
 //
 //        var icon : String
 //        var time : Int
 //        var summary : String
 //        var data : [[String : AnyObject]]
 //        var nearestStormDistance : Int
 //        var precipIntensity : Double
 //        var precipProbability : Int
 //        var precipType : String
 //        var temperature: String
 //        var temperatureMin: Double
 //        var temperatureMax: Double
 //        var apparentTemperature: Double
 //        var apparentTemperatureMin: Double
 //        var apparentTemperatureMax: Double
 //        var dewPoint: Double
 //        var humidity: Double
 //        var windSpeed: Double
 //        var visibility: Double
 //        var cloudCover: Double
 //        var pressure: Double
 //        var ozone: Double
 //        var sunriseTime: Int
 //        var sunsetTime : Int
 //        var moonPhase : Double
 //
 
 
 
 
 
 
 //alerts dictionary--do i initialize keys here as well or later if need be "title", "time", "expires", "description", "uri"
 
 
 
 
 }
 
 
 */