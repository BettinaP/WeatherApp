//
//  UmbrellaReminderTableViewController.swift
//  WeatherApp
//
//  Created by Bettina on 11/29/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//

import UIKit
import CoreLocation

class UmbrellaReminderTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var umbrellaReminderSwitch: UISwitch!
    @IBOutlet weak var editTimeButton: UIButton!
    @IBOutlet weak var reminderTimePicker: UIDatePicker!
    
    @IBOutlet weak var cancelReminderButton: UIBarButtonItem!
    
    @IBOutlet weak var saveReminderButton: UIBarButtonItem!
    
    
    @IBOutlet weak var repeatDailySwitch: UISwitch!
    
    
    let locationManager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
    var locationName = String()
    var userLocation = CLLocation()
    
    var notification = UILocalNotification()
    
    let store = ForecastDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
            //requestWhenInUseAuthorization()
        }
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        //if no time set then show picker with current time{
        reminderTimePicker.date = NSDate()
        //}
        //        //nsuserdefaults  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        self.speed = [defaults integerForKey:kUYLSettingsSpeedKey];
        //        self.volume = [defaults integerForKey:kUYLSettingsVolumeKey];
        // use switch case
        //did selectRow to lead to settings VC for repetition and alert
        //grabUmbrellaSwitchToggled
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.userLocation = locations[0]
        
        self.longitude = userLocation.coordinate.longitude
        self.latitude = userLocation.coordinate.latitude
     
    }
    // MARK: - Table view data source
    @IBAction func umbrellaSwitchToggled(sender: AnyObject) {
        if umbrellaReminderSwitch.on {
            store.getForecastResultsWithCompletion(self.latitude, searchedLongitude: self.longitude) { (success) in
                
                print("location: \(self.latitude), \(self.longitude)")
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    for hour in self.store.hourlyResults {
                        if hour.hourlyIcon == "drizzle" || hour.hourlyIcon == "rain" || hour.hourlyIcon == "sleet" {
                            self.scheduleLocalNotification(self.reminderTimePicker.date)
//                            print("notification printing inside API call inside of switchOn bool: \(self.notification)")
                            print("hourlyIcon phrase:\(hour.hourlyTime),\(hour.hourlyIcon)")
                        }
                    }
                })
            }
            
            
        } else {
            
            print("switch is off")
        }
        
    }
    
    @IBAction func editTimeButtonTapped(sender: AnyObject) {
        
        print("edit button tapped")
    }
    
    
    @IBAction func reminderSaveButtonTapped(sender: AnyObject) {
        self.scheduleLocalNotification(reminderTimePicker.date)
        self.presentReminderSetMessage("Reminder set.")
        print("save button tapped")
    }
    
    
    @IBAction func cancelReminderButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        self.presentReminderSetMessage("Reminder cancelled.")
        
        print("cancel button tapped")
    }
    
    func scheduleLocalNotification(fireTime: NSDate){
        
        
        notification.fireDate = fireTime
        notification.alertBody =  "Don't forget your umbrella!"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func presentReminderSetMessage(message: String){
        let alertController = UIAlertController.init(title: "Grab Umbrella Reminder", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    //    func setupNotificationReminder(){
    //
    //        var reminderText = "Don't forget your umbrella!"
    //
    //    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
