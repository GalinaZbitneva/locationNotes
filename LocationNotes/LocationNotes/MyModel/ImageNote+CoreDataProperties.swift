//
//  ImageNote+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 14.04.2021.
//
//

import Foundation
import CoreData


extension ImageNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageNote> {
        return NSFetchRequest<ImageNote>(entityName: "ImageNote")
    }

    @NSManaged public var imageBig: Data?
    @NSManaged public var nate: Note?

}

extension ImageNote : Identifiable {

}
