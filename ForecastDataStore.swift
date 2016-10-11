//
//  ForecastDataStore.swift
//  WeatherApp
//
//  Created by Bettina on 10/10/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import Foundation

class ForecastDataStore {

    static let sharedInstance = ForecastDataStore()
    private init() {}
    
    func getForecastResultsWithCompletion(searchedLatitude: Double, searchedLongitude: Double, completion: (Bool) ->()) {
        
        DarkSkyAPIClient.getForecast(searchedLatitude, longitude: searchedLongitude) { (forecastDictionary) in
          
            for dictionary in forecastDictionary {
            
                if let result = dictionary as? NSDictionary {
                    
                    let forecast = LocationWeather(weatherDictionary: result)
                }
            }
            
           completion(true)
        }
    
    }
    
}