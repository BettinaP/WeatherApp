//
//  SavedLocation+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Bettina on 10/26/16.
//  Copyright © 2016 Bettina Prophete. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SavedLocation {

    @NSManaged var locationName: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?

}
