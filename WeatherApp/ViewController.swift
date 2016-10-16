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


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource, UII {
    //add searchBar for location
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentlyImageView: UIImageView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    
    //    var temperatures : [Double] = []
    
    var dailyResultsWithoutToday: [DailyWeather] = []
    var store = ForecastDataStore.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
    
        
        //     west & south are - , east & north +
        //     New York  google:  40.7128° N, 74.0059° W // according to forecast.io 40.7142,-74.0064
        //     LA  google:34.0522° N, 118.2437° W  darkSky: 47.20296790272209, -123.41670367098749
        
        //Montreal 45.5017° N, 73.5673° W, -73.5673
        //paris 48.8566° N, 2.3522° E
        
        let latitude = 40.7142
        let longitude = -74.0064
        
        
        
        store.getForecastResultsWithCompletion(latitude, searchedLongitude: longitude) { (success) in

            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                self.cityName.text = self.store.currentTimezone
                
//                if self.store.currentTimezone.containsString("America/"){
                self.currentTempLabel.text = "\(self.store.currentTemperature)°"
//                    
//                    print("in fahrenheit: \(self.currentTempLabel.text)")
//                
//                } else {                   
//                    let celsiusTemp = (self.store.currentTemperature - 32) * (5/9)
//                    self.currentTempLabel.text = "\(celsiusTemp)°"
//                    print("in celsius: \(self.currentTempLabel.text)")
//                }

                
                self.currentlyImageView.image = UIImage(named: self.store.currentIcon)
                if self.store.currentIcon == "clear-day"{
                    
                    self.currentlyImageView.tintColor = UIColor.yellowColor()
                }
        
   
                
                self.dailyTableView.reloadData()
            })
        
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return store.dailyResults.count
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("weekday", forIndexPath: indexPath) as! DailyTableViewCell
        
        let day = self.store.dailyResults[indexPath.row]
        
        cell.configureDailyCell(day)
//        print("DAY in vc cell for row: \(day)")
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

