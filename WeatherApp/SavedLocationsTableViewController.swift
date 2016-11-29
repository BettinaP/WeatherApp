//
//  SavedLocationsTableViewController.swift
//  WeatherApp
//
//  Created by Bettina on 10/21/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class SavedLocationsTableViewController: UITableViewController,UISearchBarDelegate,CLLocationManagerDelegate {
    let store = ForecastDataStore.sharedInstance
    
    var savedLocations = [SavedLocation]()
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var latitude = Double()
    var longitude = Double()
    var locationName = String()
    var seenError: Bool = false
    
    var searchBar = UISearchBar()
    var searchResults = [String]()
    var newBounds = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        store.fetchData()
        savedLocations = store.savedLocations
        locationManager.delegate = self
        //triggers system prompting the user to authorize access to location services if they hadn't yet explicitly approved or denied the app, make sure to add NSLocationWhenInUseUsageDescription key to Info.plist:
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh), forControlEvents:.ValueChanged)
        self.tableView.reloadData()
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        savedLocations = store.savedLocations
        store.fetchData()
        
        newBounds = self.tableView.bounds
        newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height
        self.tableView.bounds = newBounds
        
        let refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh), forControlEvents:.ValueChanged)
        
        self.tableView.reloadData()
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height * 0.11)
        searchBar.placeholder = "Search Location ..."
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.setShowsCancelButton(true, animated: false)
        self.tableView.tableHeaderView = searchBar
        
    }
    
    
    //self.nav.initvc.pushController, ifselected, initialize pageVC
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if searchBar.text != nil {
            geocoder.geocodeAddressString(searchBar.text!) { (placemarks, error) in
                
                guard let unwrappedPlacemarks = placemarks else {return}
                
                if error == nil {
                    guard let placemark = unwrappedPlacemarks.first else {return}
                    guard let location = placemark.location else {return}
                    
                    self.latitude =  location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    
                    self.store.getForecastResultsWithCompletion(self.latitude, searchedLongitude: self.longitude) { (success) in
                        if success {
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                
                                let savedSearchedLocation = NSEntityDescription.insertNewObjectForEntityForName(SavedLocation.entityName, inManagedObjectContext: self.store.managedObjectContext) as! SavedLocation
                                
                                savedSearchedLocation.locationName = placemark.locality
                                savedSearchedLocation.latitude = self.latitude
                                savedSearchedLocation.longitude = self.longitude
                                
                                print("inside searchBarSearchButtonClicked: saved location name: \(savedSearchedLocation.locationName), placemark name: \(placemark.subAdministrativeArea)")
                                self.store.savedLocations.append(savedSearchedLocation)
                                self.store.saveContext()
                                
                                self.tableView.reloadData()
                                self.viewWillAppear(true) 
                            })
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    print("Geocode failed with error:\(error)")
                }
            }
        } else {
            //            self.tableView.reloadData()
            locationManager.startUpdatingLocation()
        }
        self.tableView.reloadData()
        self.viewWillAppear(true)
        //        searchController.searchBar.resignFirstResponder()
        
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        viewWillAppear(true)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        locationManager.stopUpdatingLocation()
        print("Failed to find user's location: \(error)")
        //        if error  {
        //            if seenError == false {
        //                seenError == true
        //                print(error)
        //            }
        //        }
    }
    
    /* This happens asynchronously, the app can’t start using location services immediately. Instead, one must implement the locationManager:didChangeAuthorizationStatus delegate method, which fires any time the authorization status changes based on user input.
     
     If the user has previously given permission to use location services, this delegate method will also be called after the location manager is initialized and has its delegate set with the appropriate authorization status.*/
    
    func locationManager(manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.requestLocation() //not sure if needed here or should be called elsewhere. When put in viewDidLoad(), assertionFailure error of delegate not responding to didUpdateLocation triggered even though I've configured the function. Is it mainly if using MapKit and trying to set default location as user's current location? error message: *** Assertion failure in -[CLLocationManager requestLocation], /BuildRoot/Library/Caches/com.apple.xbs/Sources/CoreLocationFramework_Sim/CoreLocation-1861.3.25.49/Framework/CoreLocation/CLLocationManager.m:820
            //            2016-11-14 18:08:23.263 WeatherApp[61739:4389660] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Delegate must respond to locationManager:didUpdateLocations:'
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocation locations:[AnyObject]){
        
        let userLocation: CLLocation = locations[0] as! CLLocation
        
        locationManager.stopUpdatingLocation()
        
        //        let long = userLocation.coordinate.longitude
        //        let lat = userLocation.coordinate.latitude
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            
            if error == nil {
                guard let placemark = placemarks?.first else {return}
                self.locationName = "\(placemark.locality)"
                print("locationName:\(self.locationName)")
                print("userLocation in updateLocation function:\(userLocation)")
            } else {
                print("reverseGeocode failed with error:\(error)")
                
            }
        }
        
    }
    
    //func shouldShowSearchResults() { }
    
    
    //The geocoder object parses the information you give it and if it finds a match, returns some number of placemark objects.  The completion handler block you pass to the geocoder should be prepared to handle multiple placemarks, as shown below.
    
    //find a way to insert selected data result into savedLocations array to be displayed
    
    func getLocationNameFromCoordinates(location: CLLocation) {
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error == nil {
                guard let placemark = placemarks?.first else {return}
                self.locationName = "\(placemark.locality)"
                print("in reverseGeocoding function to get location name, it is: \(self.locationName)")
            } else {
                print("reverseGeocode failed with error:\(error)")
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if savedLocations.count != 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return 1
            
        } else {
            
            let pullToSearchMessageLabel: UILabel = UILabel.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            pullToSearchMessageLabel.textColor = UIColor.blackColor()
            pullToSearchMessageLabel.numberOfLines = 0
            pullToSearchMessageLabel.textAlignment = .Center
            pullToSearchMessageLabel.font = UIFont.init(name: "Helvetica-Neue", size: 24.0)
            pullToSearchMessageLabel.sizeToFit()
            
            self.tableView.backgroundView = pullToSearchMessageLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("savedLocationCell") as! SavedLocationTableViewCell
        
        let savedCity = self.savedLocations[indexPath.row]
        
        cell.savedCityLabel.text = savedCity.locationName
        cell.configureSavedCityCell(savedCity)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let savedLocation = savedLocations[indexPath.row]
            store.managedObjectContext.deleteObject(savedLocation)
            savedLocations.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            store.saveContext()
            store.fetchData()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedLocation = store.savedLocations[indexPath.row]
        store.savedLocations.removeAtIndex(indexPath.row)
        store.savedLocations.insert(selectedLocation, atIndex: 0)
        performSegueWithIdentifier("savedLocationToRootVC", sender: tableView.cellForRowAtIndexPath(indexPath))
        self.tableView.cellForRowAtIndexPath(indexPath)?.highlighted = true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "savedLocationToWeather" {
            let destinationVC = segue.destinationViewController as! ForecastViewController
            
            let selectedCell = sender as! UITableViewCell
            let selectedSavedLocation = self.tableView.indexPathForCell(selectedCell)
            let savedLocation = self.savedLocations[selectedSavedLocation!.row]
            let locationToPass = LocationWeather()
            
            if let unwrappedSavedName = savedLocation.locationName {
                locationToPass.locationName = unwrappedSavedName
            }
            
            guard let unwrappedSavedLatitude = savedLocation.latitude as? Double else {return}
            locationToPass.latitude = unwrappedSavedLatitude
            
            
            guard let unwrappedSavedLongitude = savedLocation.longitude as? Double else {return}
            locationToPass.longitude = unwrappedSavedLongitude
            
            destinationVC.locationPassed = locationToPass
        }
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
