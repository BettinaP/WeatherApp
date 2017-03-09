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
 //import Hue
 
 
 class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, CLLocationManagerDelegate {
   
    
    @IBOutlet weak var backgroundToCurrentView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentlyImageView: UIImageView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var todayMaxLabel: UILabel!
    @IBOutlet weak var todayMinLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    var pageIndex = Int()
    var dailyResultsWithoutToday: [DailyWeather] = []
    var store = ForecastDataStore.sharedInstance
    var locationPassed = LocationWeather()
    
   // let locationManager = CLLocationManager()
    //add search bar for location, then calculate timezone to show appropriate weather by time
    //have background be a cool image? look for an image api
    //fix current temp and icon and city constraints
    
    override func viewDidLoad() {
        print("entering FVC viewDidLoad")
        super.viewDidLoad()
        
        print("FVC viewDidLoad")
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.allowsSelection = false
        dailyTableView.showsVerticalScrollIndicator = false
        dailyTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        
        
        store.getForecastResultsWithCompletion(locationPassed.latitude, searchedLongitude: locationPassed.longitude) { (success) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                self.cityName.text = self.locationPassed.locationName
                
                //                if self.store.currentTimezone.containsString("America/"){
                self.currentTempLabel.text = "\(self.store.currentTemperature)°"
               // self.initGradientAppearance()
                
                //                var currentTempBackground = self.store.currentTemperature
                //
                //                switch currentTempBackground {
                //                case currentTempBackground >= 95:
                //                    initGradientAppearance()
                //
                //                }
                //                print("in fahrenheit: \(self.currentTempLabel.text)")
                //
                //                } else {
                //                    let celsiusTemp = (self.store.currentTemperature - 32) * (5/9)
                //                    self.currentTempLabel.text = "\(celsiusTemp)°"
                //                    print("in celsius: \(self.currentTempLabel.text)")
                //                }
                let today = self.store.todaysDate.getWeekOfDayString()
                self.dayLabel.text = today
                self.currentlyImageView.image = UIImage(named: self.store.currentIcon)
                
                self.initGradientAppearance()
                
                if self.store.currentIcon == "clear-day"{
                    
                    self.currentlyImageView.tintColor = UIColor.yellowColor()
                }
                
                self.todayMaxLabel.text = "\(self.store.todaysMaxTemp)°"
                self.todayMinLabel.text = "\(self.store.todaysMinTemp)°"
                
                self.hourlyCollectionView.reloadData()
                self.dailyTableView.reloadData()
                
                print("current temp in FVC viewDidLoad store.API call: cityName\(self.cityName.text), locationNamePassed: \(self.locationPassed.locationName), currentTemp: \(self.currentTempLabel.text)")
            })
        }
        print("end of FVC viewDidLoad")
    }
    
    
    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(true)
      dailyTableView.addBorderTop(size: 1.0, color: UIColor.lightGrayColor())
     backgroundToCurrentView.addBorderBottom(size: 1.0, color: UIColor.lightGrayColor())
      
    }
    
    
    func initGradientAppearance() {
        
        var background = CAGradientLayer()
//        var background = CAGradientLayer().generateColor(.Sky)
        
        let currentTempBackground = self.store.currentTemperature
        
        switch currentTempBackground {
            
        case 95...200:
            background = CAGradientLayer().generateColor(.BlazingHot)
            print("blazing hot 95-200")
        case 80...94:
            background = CAGradientLayer().generateColor(.Hot)
            print("hot 80-94")
        case 70...79:
            background = CAGradientLayer().generateColor(.Warm)
            print("warm 70-79")
        case 61...69:
            background = CAGradientLayer().generateColor(.Warmish)
            print("warmish 61-69")
        case 55...60:
            background = CAGradientLayer().generateColor(.Coolish)
            print("coolish 55-60")
        case 45...54:
            background = CAGradientLayer().generateColor(.Cool)
            print("cool 45-54")
        case 25...44:
            background = CAGradientLayer().generateColor(.Cold)
            print("cold 25-44")
        case 1...24:
            background = CAGradientLayer().generateColor(.Freezing)
            print("freezing 1-24")
        case -100...0:
            background = CAGradientLayer().generateColor(.Frigid)
            print("frigid 0 and under")
        default:
            background = CAGradientLayer().generateColor(.Sky)
            print("Default color")
        }
        
        print("\(self.cityName.text) background temp after switch case in initgradient Forecast VC method: \(currentTempBackground)")
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
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
        hourlyCell.configureHourlyCell(hour)
        return hourlyCell
        
    }
    
    
    //    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
    //           performSegueWithIdentifier("forecastBackToPageVC", sender: self)
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
 //
 //extension UIView {
 //
 //    func layerGradient(){
 //
 //    lazy var gradient: CAGradientLayer = [
 //
 //        UIColor(hex:"#FD4340"),
 //        UIColor(hex:"#CE2BAE")
 //        ].gradient { gradient in
 //            gradient.speed = 0
 //            gradient.timeOffset = 0
 //
 //            return gradient
 //    }
 //
 //    lazy var animation: CABasicAnimation = { [unowned self] in
 //
 //        let animation = CABasicAnimation(keyPath: "colors")
 //        animation.duration = 1.0
 //        animation.isRemovedCompletion = false
 //
 //        return animation
 //        }()
 //
 //        gradient.frame.size = self.frame.size
 //
 //        gradient.insertSublayer(gradient, atIndex: 0)
 //    }
 //
 //
 //
 //    convenience init(title: String){
 //        self.init()
 //        self.title = title
 //
 //        animation.fromValue = gradient.colors
 //        animation.toValue = [
 //            UIColor(hex:"#8D24FF").cgColor,
 //            UIColor(hex:"#23A8F9").cgColor
 //        ]
 //    }
 //
 //     func viewDidLoad(){
 //
 //        super.viewDidLoad()
 //
 //        dispatch(queue: .interactive) { [weak self] in
 //            self?.updateViewColor()
 //            //self?.update { $0.component.items = UIViewController.generateItems(0, to: 50) }
 //        }
 //    }
 //
 ////    override func viewDidAppear(_ animated: Bool) {
 ////        super.viewDidAppear(animated)
 ////
 ////        guard let navigationController = navigationController else { return }
 ////
 ////        navigationController.view.layer.insertSublayer(gradient, at: 0)
 ////        gradient.timeOffset = 0
 ////        gradient.bounds = navigationController.view.bounds
 ////        gradient.frame = navigationController.view.bounds
 ////        gradient.add(animation, forKey: "Change Colors")
 ////    }
 //
 ////    override func scrollViewDidScroll(scrollView: UIScrollView) {
 ////        updateGradient()
 ////    }
 //
 ////     private func updateGradient() {
 //////        let offset = self.view.contentOffset.y / self.view.contentSize.height
 ////
 ////        if offset >= 0 && offset <= CGFloat(animation.duration) {
 ////            gradient.timeOffset = CFTimeInterval(offset)
 ////        } else if offset >= CGFloat(animation.duration) {
 ////            gradient.timeOffset = CFTimeInterval(animation.duration)
 ////        }
 ////
 //////        updateNavigationBarColor()
 ////    }
 //
 //     private func updateViewColor() {
 ////        guard let navigationBar = navigationController?.navigationBar else { return }
 //
 //        //if let gradientLayer = gradient.presentationLayer(),
 //        if let gradientLayer = self.gradient as! CAGradientLayer,
 //             let colors = gradientLayer.
 ////            let colors = gradientLayer.value(forKey: "colors") as? [CGColor],
 //            let firstColor = colors.first {
 //            view.backgroundColor = UIColor.clearColor()
 //
 //                //view.backgroundColor = UIColor(CGColor: firstColor)
 ////            navigationBar.barTintColor = UIColor(cgColor: firstColor)
 //        } else if let color = gradient.colors as? [CGColor],
 //            let firstColor = color.first {
 //            
 //            view.backgroundColor = UIColor.clearColor()
 //            
 ////            view.backgroundColor = UIColor(cgColor: firstColor)
 //        }
 //    }
 //    
 //    
 //}
 //
  
  
