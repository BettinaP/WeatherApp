//
//  RootViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/25/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var rootToolbar: UIToolbar!
    @IBOutlet weak var rootAddBarButton: UIBarButtonItem!
    
    @IBOutlet weak var umbrellaReminderButton: UIBarButtonItem!
    
    var pageController =  UIPageViewController()
    var store = ForecastDataStore.sharedInstance
    var locationPages = [UIViewController]()
    
    
    
    let locationManager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
    var locationName = String()
    var userLocation = CLLocation()
    
    var notification = UILocalNotification()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupViews(){
        
        if store.savedLocations.count == 0 {
            store.fetchData()
        }
        
        rootToolbar.backgroundColor = UIColor.clearColor()
        
        pageController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        
        //find a way to get whatever city is selected to front of savelocations array
        
        for savedLocation in store.savedLocations {
            print(savedLocation.locationName)
            let locationPage = (storyboard?.instantiateViewControllerWithIdentifier("WeatherContentViewController"))! as! ForecastViewController
            
            let locationToPass = LocationWeather()
            
            if let unwrappedSavedName = savedLocation.locationName {
                locationToPass.locationName = unwrappedSavedName
            }
            
            guard let unwrappedSavedLatitude = savedLocation.latitude as? Double else {return}
            locationToPass.latitude = unwrappedSavedLatitude
            
            guard let unwrappedSavedLongitude = savedLocation.longitude as? Double else {return}
            locationToPass.longitude = unwrappedSavedLongitude
            
            print("longitude passed in segue: \(locationToPass.longitude)")
            
            locationPage.locationPassed = locationToPass
            
            //            if self.locationPages.contains(locationPage){
            //                continue
            //                print("locationPages count inside RootVC view did load, if page already instantiated: \(locationPages.count)")
            //            } else {
            self.locationPages.append(locationPage)
            print("locationPages count inside RootVC view did load, if page not already instantiated: \(locationPages.count)")
            //            }
            
        }
        
        guard let weatherPage = self.locationPages.first else { return }
        
        pageController.setViewControllers([weatherPage], direction: .Forward, animated: false, completion: nil)
        
        pageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        self.pageController.didMoveToParentViewController(self)
        self.view.bringSubviewToFront(rootToolbar)
    }
    
    
    @IBAction func setUmbrellaReminderButtonTapped(sender: AnyObject) {
        //performSegueWithIdentifier("rootToSetUmbrellaReminder", sender: self)
         
        store.getForecastResultsWithCompletion(self.latitude, searchedLongitude: self.longitude) { (success) in
            
            print("location: \(self.latitude), \(self.longitude)")
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                for hour in self.store.hourlyResults {
                    if hour.hourlyIcon == "drizzle" || hour.hourlyIcon == "rain" || hour.hourlyIcon == "sleet" {
                        self.presentReminderSetMessage("Anticipate some rain today!")
                        //                            print("notification printing inside API call inside of switchOn bool: \(self.notification)")
                        print("hourlyIcon phrase:\(hour.hourlyTime),\(hour.hourlyIcon)")
                    }
                }
            })
        }
        
    }
    
    func presentReminderSetMessage(message: String) {
        let alertController = UIAlertController.init(title: "Grab Umbrella Reminder", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func viewControllerAtIndex(index: Int) -> ForecastViewController {
        //
        //        if store.savedLocations.count == 0 || index >= store.savedLocations.count {
        //            return nil
        //        }
        
        let weatherContentVC = (self.storyboard?.instantiateViewControllerWithIdentifier("WeatherContentViewController"))! as! ForecastViewController
        
        weatherContentVC.pageIndex = index
        
        return weatherContentVC
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = locationPages.indexOf(viewController) else {return nil}
        
        if currentIndex == 0 || currentIndex == NSNotFound {
            return nil
        }
        
        let previousIndex = abs((currentIndex - 1) % locationPages.count)
        
        return locationPages[previousIndex]
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = locationPages.indexOf(viewController) else {return nil}
        
        if currentIndex == locationPages.count - 1 {
            return nil
        }
        
        let nextIndex = abs((currentIndex + 1) % locationPages.count)
        return locationPages[nextIndex]
    }
    
    
    // dots to display and which dot is selected at the beginning
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return store.savedLocations.count
    }
    
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        
        performSegueWithIdentifier("forecastToSavedLocations", sender: rootAddBarButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
