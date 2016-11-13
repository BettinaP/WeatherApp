//
//  RootViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/25/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var rootToolbar: UIToolbar!
    @IBOutlet weak var rootAddBarButton: UIBarButtonItem!
    
    
    var pageController =  UIPageViewController()
    var store = ForecastDataStore.sharedInstance
    var locationPages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchData()
        
        rootToolbar.backgroundColor = UIColor.clearColor()
        pageController =   self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
 
        
        pageController.dataSource = self
        pageController.delegate = self
        
        for savedLocation in store.savedLocations {
            
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
            
            locationPage.savedLocationPassed = locationToPass
            self.locationPages.append(locationPage)
            
        }
        
        guard let weatherPage = self.locationPages.first else { return }
         
        pageController.setViewControllers([weatherPage], direction: .Forward, animated: false, completion: nil)
        
        pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        self.pageController.didMoveToParentViewController(self)
        self.view.bringSubviewToFront(rootToolbar)
        
//        pageController.toolbarItems?.append(rootAddBarButton)
//        pageController.toolbarItems?.append(pageControlItem)
        
        
        

        
        //        addButton.frame = CGRectMake(0, 0, 25, 25)
        //
        //        self.view.addSubview(addButton)
        //
        //
        //createContentPages()
         
    }
    
    
    
    func viewControllerAtIndex(index: Int) -> ForecastViewController {
//        
//        if store.savedLocations.count == 0 || index >= store.savedLocations.count {
//            return nil
//        }
        
        let weatherContentVC = (self.storyboard?.instantiateViewControllerWithIdentifier("WeatherContentViewController"))! as! ForecastViewController
        
        //let weatherContentVC = ForecastViewController()
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
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return store.savedLocations.count
    }
   
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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
