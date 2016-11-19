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


class SavedLocationsTableViewController: UITableViewController,UISearchBarDelegate, UISearchResultsUpdating, CLLocationManagerDelegate {
    let store = ForecastDataStore.sharedInstance
    
    @IBOutlet weak var searchBar: UISearchBar!
    var savedLocations = [SavedLocation]()
    var searchController: UISearchController!
    var resultsController = UITableViewController()
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var latitude = Double()
    var longitude = Double()
    var locationName = String()
    var seenError: Bool = false
    
    var searchResults = [String]()
    var shouldShowSearchResults: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchData()
        configureSearchController()
        
        savedLocations = store.savedLocations
        locationManager.delegate = self
        //triggers system prompting the user to authorize access to location services if they hadn't yet explicitly approved or denied the app, make sure to add NSLocationWhenInUseUsageDescription key to Info.plist:
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        self.tableView.reloadData()
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        store.fetchData()
        savedLocations = store.savedLocations
        self.tableView.reloadData()
    }
    
    func configureSearchController() {
        
        self.searchController = UISearchController(searchResultsController: resultsController)
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchResultsUpdater = self
        self.searchController.searchResultsController?.modalInPopover = true
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.placeholder = "Search Location ..."
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        definesPresentationContext = true
        
        //self.tableView.tableHeaderView = self.searchController.searchBar
        // self.definesPresentationContext = true
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
         let searchString = searchController.searchBar.text
        
        //        searchController.searchResultsUpdater?.updateSearchResultsForSearchController(searchController)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            
            self.store.locationResults.removeAll()
            
            if searchBar.text != nil {
                geocoder.geocodeAddressString(searchBar.text!) { (placemarks, error) in
                    
                    guard let unwrappedPlacemarks = placemarks else {return}
                    
                    if error == nil {
                        guard let placemark = unwrappedPlacemarks.first else {return}
                        
                        self.latitude = (placemark.location?.coordinate.latitude)!
                        self.longitude = (placemark.location?.coordinate.longitude)!
                        
                        self.store.getForecastResultsWithCompletion(self.latitude, searchedLongitude: self.longitude) { (success) in
                            if success {
                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                    self.searchController.searchResultsController?.loadView()
                                     self.tableView.reloadData()
                                    print(self.latitude, self.longitude, placemark)
                                })
                            }
                        }
                        self.tableView.reloadData()
                    } else {
                        
                        print("Geocode failed with error:\(error)")
                    }
                }
            } else {
                locationManager.startUpdatingLocation()
            }
        }
        
        searchController.searchBar.resignFirstResponder()
        
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
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
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        
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
                self.locationName = "\(placemark.subAdministrativeArea)"
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
                self.locationName = "\(placemark.subAdministrativeArea)"
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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedLocations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("savedLocationCell") as! SavedLocationTableViewCell
        
        let savedCity = self.savedLocations[indexPath.row]
        
        //        cell.configureSavedCityCell(savedCity)
        
        cell.savedCityLabel.text = savedCity.locationName
        //        print(cell.savedCityLabel.text)
        
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
        performSegueWithIdentifier("savedLocationToWeather", sender: tableView.cellForRowAtIndexPath(indexPath))
        self.tableView.cellForRowAtIndexPath(indexPath)?.highlighted = true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC = segue.destinationViewController as! ForecastViewController
        
        if segue.identifier == "savedLocationToWeather" {
            
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
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        let newSavedLocation = SavedLocation()
        savedLocations.append(newSavedLocation)
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
