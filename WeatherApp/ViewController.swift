//
//  ViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/9/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//     west & south are - , east & north +
//     New York  google:  40.7128° N, 74.0059° W // according to forecast.io 40.7142,-74.0064
//     LA  google:34.0522° N, 118.2437° W  darkSky: 47.20296790272209, -123.41670367098749
        let latitude = 40.7128
        let longitude = -74.0059
        
        DarkSkyAPIClient.getForecast(latitude, longitude: longitude) { (dictionary) in
            
//            for dictionary in array {
                 print("\(dictionary)")
                
            
//            }
//            guard let currently = dictionary["currently"] else {print("unwrapping currently failed"); return}
//            let timeZone = currently["timezone"]
//            print("calling api from VC closure")
           
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

