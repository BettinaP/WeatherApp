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


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource {
    //add searchBar for location
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentlyImageView: UIImageView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todayMaxLabel: UILabel!
    @IBOutlet weak var todayMinLabel: UILabel!
    
    var dailyResultsWithoutToday: [DailyWeather] = []
    var store = ForecastDataStore.sharedInstance
    
    
    
    //figure out how separate or not include today's info (1st in daily array)  from  daily table and display outside of table 
    //add search bar for location, then calculate timezone to show appropriate weather by time
    //have background be a cool image? look for an api
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        
    
        
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
        
   
                self.hourlyCollectionView.reloadData()
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
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.hourlyResults.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let hourlyCell = hourlyCollectionView.dequeueReusableCellWithReuseIdentifier("hourlyDetailsCell", forIndexPath: indexPath) as! HourlyCollectionViewCell
        
        let hour = self.store.hourlyResults[indexPath.item]
        print("hourly in VC cell for item: \(self.store.hourlyResults.count)")
        hourlyCell.configureHourlyCell(hour)
        print("HOUR in vc collection cell for row: \(hour)")
        
        return hourlyCell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

