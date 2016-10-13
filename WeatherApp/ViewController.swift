//
//  ViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/9/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //searchBar for location
    
    var temperatures : [Double] = []
    var store = ForecastDataStore.sharedInstance
    
    @IBOutlet weak var dailyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        self.dailyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "weekday")
        
//     west & south are - , east & north +
//     New York  google:  40.7128° N, 74.0059° W // according to forecast.io 40.7142,-74.0064
//     LA  google:34.0522° N, 118.2437° W  darkSky: 47.20296790272209, -123.41670367098749
        let latitude = 40.7128
        let longitude = -74.0059
        
        DarkSkyAPIClient.getForecast(latitude, longitude: longitude) { (locationWeatherObject) in
            
            print("in VC:\(locationWeatherObject)")
//            print(locationWeatherObject.summary)

           
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.store.dailyResults.count
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("weekday", forIndexPath: indexPath) as! DailyTableViewCell
        
        let day = self.store.dailyResults[indexPath.row]
        
        cell.textLabel?.text = day
        
        return cell
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

