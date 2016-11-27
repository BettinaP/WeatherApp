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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        //createContentPages()
        
    }
    
    
    
    func setupViews(){
        
        print(store.savedLocations.count)
        if store.savedLocations.count == 0 {
            store.fetchData()
        }
        //store.fetchData()
        
        rootToolbar.backgroundColor = UIColor.clear
        pageController =   self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        
        pageController.dataSource = self
        pageController.delegate = self
        //find a way to get whatever city is selected to front of savelocations array
        
        for savedLocation in store.savedLocations {
            print(savedLocation.locationName)
            let locationPage = (storyboard?.instantiateViewController(withIdentifier: "WeatherContentViewController"))! as! ForecastViewController
            
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
        
        pageController.setViewControllers([weatherPage], direction: .forward, animated: false, completion: nil)
        
        pageController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        self.pageController.didMove(toParentViewController: self)
        self.view.bringSubview(toFront: rootToolbar)
    }
    
    
    
    func viewControllerAtIndex(_ index: Int) -> ForecastViewController {
        //
        //        if store.savedLocations.count == 0 || index >= store.savedLocations.count {
        //            return nil
        //        }
        
        let weatherContentVC = (self.storyboard?.instantiateViewController(withIdentifier: "WeatherContentViewController"))! as! ForecastViewController
        
        weatherContentVC.pageIndex = index
        
        return weatherContentVC
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = locationPages.index(of: viewController) else {return nil}
        
        if currentIndex == 0 || currentIndex == NSNotFound {
            return nil
        }
        
        let previousIndex = abs((currentIndex - 1) % locationPages.count)
        
        return locationPages[previousIndex]
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = locationPages.index(of: viewController) else {return nil}
        
        if currentIndex == locationPages.count - 1 {
            return nil
        }
        
        let nextIndex = abs((currentIndex + 1) % locationPages.count)
        return locationPages[nextIndex]
    }
    
    
    // dots to display and which dot is selected at the beginning
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return store.savedLocations.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "forecastToSavedLocations", sender: rootAddBarButton)
        
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
