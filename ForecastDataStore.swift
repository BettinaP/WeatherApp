//
//  ForecastDataStore.swift
//  WeatherApp
//
//  Created by Bettina on 10/10/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import Foundation

class ForecastDataStore {
 
    var hourlyResults: [HourlyWeather] = []
    var dailyResults: [DailyWeather] = []
    var currentSummary = String()
    var currentIcon = String()
    var currentTime = Double()
    var currentTimezone = String()
    var currentTemperature = Int()
    var currentApparentTemp = Int()
    var currentPrecipProbability = String()
   
    
    static let sharedInstance = ForecastDataStore()
    private init() {}
    
    func getForecastResultsWithCompletion(searchedLatitude: Double, searchedLongitude: Double, completion: (Bool) ->()) {
        
        DarkSkyAPIClient.getForecast(searchedLatitude, longitude: searchedLongitude) { (forecast) in
           
             self.dailyResults = forecast.dailyWeatherArray
             self.hourlyResults = forecast.hourlyWeatherArray
             self.currentSummary = forecast.summary
             self.currentIcon = forecast.icon
             self.currentTime = forecast.time
             self.currentTimezone = forecast.timezone
             self.currentTemperature = forecast.temperature
             self.currentApparentTemp = forecast.apparentTemp
             self.currentPrecipProbability = forecast.precipProbability
            
            print("hourly results array in store: \(self.hourlyResults.count)")
//            print("datastore, daily results array: \(self.dailyResults)")
//            print("datastore, todays results:\()")
            completion(true)
            
                        
            
//            for dailyData in forecast.dailyDataArray {
//                let day = LocationWeather(currentWeather: dailyData)
//                
//                self.dailyResults.append(day)
//                print("in store, printing dailyRESULTS: \(self.dailyResults.count)")
//                print("in store, printing dailyRESULTS: \(self.dailyResults)")
//            }
            
            
//            let dailyJSONArray = forecastJSON["daily"]
//             print("in datastore printing dailyJSON: \(dailyJSONArray)")
//          
//            let dailyDataArray = dailyJSONArray["data"]
//            
//            for dailyData in  dailyDataArray {
//                
//                let day = LocationWeather(currentWeather: dailyData)
//                
//                self.dailyResults.append(day)
//                
//                print("in datastore printing day from dailyJSON:\(day)")
//                
//                print("daily results count in store: \(self.dailyResults.count)")
//            }
//
            
//            let day = [forecastDictionary.dailyTime : [forecastDictionary.dailyIcon, forecastDictionary.dailyTempMax, forecastDictionary.dailyTempMin]]
//            self.dailyResults.append(day)
//            
            // need hourly data :time, icon, temp as an array?
            // need daily data: day, icon, maxtemp , min temp as array?
            
        }
        
        
        
    
    }
    
}