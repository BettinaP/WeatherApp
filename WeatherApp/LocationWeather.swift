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
    var latitude = Double()
    var longitude = Double()
    var locationName = String()
    
    var summary = String()
    var icon = String()
    var precipProbability = String()
    var timezone = String()
    var time = Double()
    var temperature = Int()
    var apparentTemp = Int()
    
    
    var hourlyDataArray = [JSON]()
    var dailyDataArray = [JSON]()
    
    var hourlyWeatherArray = [HourlyWeather]()
    var dailyWeatherArray = [DailyWeather]()
    
    var todayDetails = [DailyWeather]()
    var today = NSDate()
    var convertedDailyDate = NSDate()
    
    
    init(currentWeather: JSON){
        
        self.latitude = currentWeather["latitude"].doubleValue
        self.longitude = currentWeather["longitude"].doubleValue
        self.timezone = currentWeather["timezone"].stringValue
        self.time = currentWeather["currently"]["time"].doubleValue //must convert UNIX stamp
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
    
    
    init() {
        
        self.latitude = 0.0
        self.longitude = 0.0
        self.timezone = "N/A"
        self.locationName = "N/A"
        
//        self.summary = "N/A"
//        self.icon = "N/A"
//        self.precipProbability = "N/A"
//        self.time = 0.0
//        self.temperature = 0
//        self.apparentTemp = 0
    
    }
}


