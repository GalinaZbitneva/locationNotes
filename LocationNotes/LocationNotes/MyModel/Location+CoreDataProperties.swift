//
//  Location+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 14.04.2021.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var note: Note?

}

extension Location : Identifiable {

}
