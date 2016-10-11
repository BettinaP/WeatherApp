//
//  DarkSkyAPIClient.swift
//  WeatherApp
//
//  Created by Bettina on 10/9/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import Foundation


class DarkSkyAPIClient {
    
    class func getForecast(latitude: Double, longitude: Double, completion: [String: AnyObject] -> ()) {
        
        let urlString = "https://api.darksky.net/forecast/\(Secrets.key)/\(latitude),\(longitude)"
        
        let url = NSURL(string: urlString)
        guard let unwrappedURL = url else {fatalError("Invalid URL")}
        let skySession = NSURLSession.sharedSession()
        
        let dataTask = skySession.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let unwrappedData = data else {print(error?.localizedDescription) ; return}
            
            do {
                
                let dictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options:
                    NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                
                completion(dictionary)
            } catch {
            
                print("error in dataTask : \(error)")
            }
            
            
        }
        dataTask.resume()
    }
}
