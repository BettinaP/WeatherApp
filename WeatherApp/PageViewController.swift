//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/20/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    //UIPageViewControllerDelegate, UIPageViewControllerDataSource
//    var weatherPages = [UIViewController]()
//    let store = ForecastDataStore.sharedInstance
////    let addButton = UIButton()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.dataSource = self
//        self.delegate = self
//        
//        
//        self.view.backgroundColor = UIColor.whiteColor()
//        store.fetchData()
//        
//        for savedLocation in store.savedLocations {
//            
//            let locationPage = (storyboard?.instantiateViewControllerWithIdentifier("WeatherContentViewController"))! as! ForecastViewController
//            
//            let locationToPass = LocationWeather()
//            
//            if let unwrappedSavedName = savedLocation.locationName {
//                locationToPass.locationName = unwrappedSavedName
//            }
//            
//            guard let unwrappedSavedLatitude = savedLocation.latitude as? Double else {return}
//            locationToPass.latitude = unwrappedSavedLatitude
//            
//            
//            guard let unwrappedSavedLongitude = savedLocation.longitude as? Double else {return}
//            locationToPass.longitude = unwrappedSavedLongitude
//            
//            print("longitude passed in segue: \(locationToPass.longitude)")
//        
//            locationPage.savedLocationPassed = locationToPass
//            self.weatherPages.append(locationPage)
//           
//                setViewControllers([locationPage], direction: .Forward, animated: false, completion: nil)
//        }
//        
////       guard let weatherPage = self.weatherPages.first else { return }
////        
////        setViewControllers([weatherPage], direction: .Forward, animated: false, completion: nil)
//    
//        
////        addButton.frame = CGRectMake(0, 0, 25, 25)
////        
////        self.view.addSubview(addButton)
////        
// 
//        
//    }
//    
//
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = weatherPages.indexOf(viewController) else {return nil}
//        
//        if currentIndex == 0 {
//            return nil
//        }
//        
//        let previousIndex = abs((currentIndex - 1) % weatherPages.count)
//        
//        return weatherPages[previousIndex]
//    }
//    
//    //viewControllerAtIndex
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = weatherPages.indexOf(viewController) else {return nil}
//        
//        if currentIndex == weatherPages.count - 1 {
//            return nil
//        }
//        
//        let nextIndex = abs((currentIndex + 1) % weatherPages.count)
//        return weatherPages[nextIndex]
//    }
//    
//    
//    // dots to display and which dot is selected at the beginning
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return store.savedLocations.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
//    
//    // func viewControllerAtIndex
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
