//
//  DarkSkyAPIClient.swift
//  WeatherApp
//
//  Created by Bettina on 10/9/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


class DarkSkyAPIClient {
    
    class func getForecast(latitude: Double, longitude: Double, completion: LocationWeather -> ()) {

//    class func getForecast(latitude: Double, longitude: Double, completion:(JSON) -> () ){
//        
    
        Alamofire.request(.GET, "https://api.darksky.net/forecast/\(Secrets.key)/\(latitude),\(longitude)").validate().responseJSON { (response) in
        
            switch response.result {
            
            case .Success: // case .Success(let value): let json = JSON(value)
                
                if let value = response.result.value {
                    let json = JSON(value) //like unwrappedData in NSURLSession...turning value (anyObject) into a JSONObject (basically a giant dictionary)
                    
                    let locationWeatherObject = LocationWeather(currentWeather: json)
                    print("api call")
                    completion(locationWeatherObject)
//                    completion(json)
                }
                
            case .Failure(let error):
                print(error)
            }
        }
//        
//        var jsonData = JSON(data:unwrappedData)
//        var locationWeatherObject = LocationWeather(currentWeather: jsonData)
//        
//        completion(locationWeatherObject)
        
        
        
////        let urlString = "https://api.darksky.net/forecast/\(Secrets.key)/\(latitude),\(longitude)"
//
//        let url = NSURL(string: urlString)
//        guard let unwrappedURL = url else {fatalError("Invalid URL")}
//        let skySession = NSURLSession.sharedSession()
//        
//        let dataTask = skySession.dataTaskWithURL(unwrappedURL) { (data, response, error) in
//            guard let unwrappedData = data else {print(error?.localizedDescription) ; return}
//            
//            do {
//                
//                let dictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options:
//                    NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
//                
//                completion(dictionary)
//            } catch {
//            
//                print("error in dataTask : \(error)")
//            }
//            
//        }
//        dataTask.resume()
    }
}
