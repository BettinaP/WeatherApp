//
//  RootViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/25/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CLLocationManagerDelegate {
    
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
    
    var umbrellaButton = UIButton()
    var isAnimating = false
    
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
        
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
            //requestWhenInUseAuthorization()
        }
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
        
        umbrellaReminderButton.action = #selector(umbrellaReminderButtonTapped)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.userLocation = locations[0]
        self.longitude = userLocation.coordinate.longitude
        self.latitude = userLocation.coordinate.latitude
        
    }
    
    func umbrellaReminderButtonTapped() {
        //        let today = NSDate()
        //        let hour = getHour(date)
        //
        //performSegueWithIdentifier("rootToSetUmbrellaReminder", sender: self)
        store.getForecastResultsWithCompletion(self.latitude, searchedLongitude: self.longitude) { (success) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                for hour in self.store.hourlyResults {
                    if hour.hourlyIcon == "drizzle" || hour.hourlyIcon == "rain" || hour.hourlyIcon == "sleet" {
                        self.presentReminderSetMessage("Anticipate some rain today!")
                        //                            print("notification printing inside API call inside of switchOn bool: \(self.notification)")
                        self.umbrellaReminderButton.tintColor = UIColor.blueColor()
                        
                        print("hourlyIcon phrase:\(hour.hourlyTime),\(hour.hourlyIcon)")
                    }
                    //                    else {
                    //                        self.presentReminderSetMessage("All clear!")
                    //                        self.umbrellaReminderButton.tintColor = UIColor.blackColor()
                    //                    }
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

extension UIView {
    
    func addBorderUtility(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    func addBorderTop(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
//    
//    var gradient = CAGradientLayer()
//    
//    
//    func addGradientWithColor(color: UIColor) {
//        gradient.frame = self.view.bounds
//        //    gradient.colors = [UIColor.clearColor().CGColor, color.CGColor]
//        //    self.view.layer.insertSublayer(gradient, atIndex: 0)
//        //myImageView.addGradientWIthColor(UIColor.blue)
//        
//        
//    }
    
    
    
    
    
    
    //    func shakeView() {
    //        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    //        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    //        animation.duration = 0.6
    //        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
    //        layer.addAnimation(animation, forKey: "shake")
    //    }
    
    
    
}

enum Color {
    //  Sky, Submerged, Emergency, Lilac, Brittany, Sunrise, MidSunriseAndWarm, EarlySunrise,
    case  Sky, BlazingHot, Hot,  Warm, Warmish, Coolish, Cool, Cold, Freezing, Frigid

}

extension CAGradientLayer {
    
    
    func generateColor(color: Color) -> CAGradientLayer {
        
        var topColor = UIColor()
        var bottomColor = UIColor()
        
        
        switch color {
            
        case .BlazingHot: //95+
            topColor = UIColor(red: (255/255.0), green: (0/255.0), blue: (0/255.0), alpha: 1)
            bottomColor = UIColor(red: (255/255.0), green: (129/255.0), blue: (10/255.0), alpha: 1)
            
        case .Hot:  // 80-94
            topColor = UIColor(red: (240/255.0), green: (59/255.0), blue: (38/255.0), alpha: 1)
            bottomColor = UIColor(red: (250/255.0), green: (230/255.0), blue: (0/255.0), alpha: 1)
        
        case .Warm: //70-79
            topColor = UIColor(red: (255/255.0), green: (139/255.0), blue: (10/255.0), alpha: 1)
            bottomColor = UIColor(red: (250/255.0), green: (230/255.0), blue: (0/255.0), alpha: 1)
            
        case .Warmish: //61-69
            topColor = UIColor(red: (240/255.0), green: (139/255.0), blue: (50/255.0), alpha: 1)
            bottomColor = UIColor(red: (229/255.0), green: (253/255.0), blue: (255/255.0), alpha: 1)
            
        case .Coolish: //55-60
            topColor = UIColor(red: (255/255.0), green: (220/255.0), blue: (10/255.0), alpha: 1)
            bottomColor = UIColor(red: (51/255.0), green: (155/255.0), blue: (240/255.0), alpha: 1)
            
        case .Cool: //45 - 54
            topColor = UIColor(red: (50/255.0), green: (100/255.0), blue: (239/255.0), alpha: 1)
            bottomColor = UIColor(red: (129/255.0), green: (243/255.0), blue: (253/255.0), alpha: 1)
            
        case .Cold: //25 - 44
            topColor = UIColor(red: (70/255.0), green: (180/255.0), blue: (230/255.0), alpha: 1)
            bottomColor = UIColor(red: (255/255.0), green: (250/255.0), blue: (255/255.0), alpha: 1)
            
        case .Freezing: //0-24 degrees
            topColor = UIColor(red: (200/255.0), green: (230/255.0), blue: (255/255.0), alpha: 0.8)
            bottomColor = UIColor(red: (250/255.0), green: (250/255.0), blue: (255/255.0), alpha: 1)
            
            
        case .Frigid: //below 0 degrees
            topColor = UIColor(red: (230/255.0), green: (240/255.0), blue: (255/255.0), alpha: 0.8)
            bottomColor = UIColor(red: (254/255.0), green: (254/255.0), blue: (254/255.0), alpha: 1)
            
        case .Sky: //default
            topColor = UIColor(red: (29/255.0), green: (119/255.0), blue: (239/255.0), alpha: 1)
            bottomColor = UIColor(red: (129/255.0), green: (243/255.0), blue: (253/255.0), alpha: 1)
            

        }
        
        
        let gradientColors: [AnyObject] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.toValue = [topColor, bottomColor]
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        gradientLayer.addAnimation(animation, forKey: "colors")
        
//        let view = UIView()
//        
//        view.layer.addSublayer(gradientLayer)
        
        return gradientLayer
  
    }
    
//    func addGradientAnimation() {
//        var topColor = UIColor()
//        var bottomColor = UIColor()
//    
//     var gradient: CAGradientLayer = CAGradientLayer.layer
//    gradient.frame = self.view.frame;
//    gradient.colors = @[(id)color1.CGColor, (id)color2.CGColor, (id)color2.CGColor];
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
//    animation.toValue = @[(id)color3.CGColor, (id)color1.CGColor, (id)color1.CGColor];
//    animation.duration = 3.0;
//    animation.autoreverses = YES;
//    animation.repeatCount = HUGE_VALF;
//    
//    [gradient addAnimation:animation forKey:@"colors"];
//    
//    [self.view.layer addSublayer:gradient];
//    }
}
