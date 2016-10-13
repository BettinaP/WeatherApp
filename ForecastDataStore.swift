//
//  ForecastDataStore.swift
//  WeatherApp
//
//  Created by Bettina on 10/10/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import Foundation

class ForecastDataStore {

    var todayResults: [LocationWeather] = []
    var hourlyResults: [LocationWeather] = []
    var dailyResults: [[String : [String]]] = []
    
    static let sharedInstance = ForecastDataStore()
    private init() {}
    
    func getForecastResultsWithCompletion(searchedLatitude: Double, searchedLongitude: Double, completion: (Bool) ->()) {
        
        DarkSkyAPIClient.getForecast(searchedLatitude, longitude: searchedLongitude) { (forecastDictionary) in
           
            let day = [forecastDictionary.dailyTime : [forecastDictionary.dailyIcon, forecastDictionary.dailyTempMax, forecastDictionary.dailyTempMin]]
            self.dailyResults.append(day)
            
            // need hourly data :time, icon, temp as an array?
            // need daily data: day, icon, maxtemp , min temp as array?
          
           completion(true)
        }
    
    }
    
}