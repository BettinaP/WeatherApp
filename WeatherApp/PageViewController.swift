//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/20/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var locationPages = [UIViewController]()
//    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let locationPage: UIViewController = (storyboard?.instantiateViewControllerWithIdentifier("WeatherContentViewController"))!
        
        locationPages.append(locationPage)
        
        
        setViewControllers([locationPage], direction: .Forward, animated: false, completion: nil)
        
//        addButton.frame = CGRectMake(0, 0, 25, 25)
//        
//        self.view.addSubview(addButton)
//        
//       
        //createContentPages()
        
    }
    

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = locationPages.indexOf(viewController) else {return nil}
        
        if currentIndex == 0 {
            return nil
        }
        
        let previousIndex = abs((currentIndex - 1) % locationPages.count)
        
        return locationPages[previousIndex]
    }
    
    //viewControllerAtIndex
    
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
        return locationPages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
     func createContentPages(){
     var = []()
     for i in ... {
     
     let  "" = ""
     "".append(let)
     
     
     }
     }
     */
    
    // func viewControllerAtIndex
    
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
