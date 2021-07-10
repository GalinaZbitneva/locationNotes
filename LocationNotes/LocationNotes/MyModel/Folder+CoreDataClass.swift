//
//  Folder+CoreDataClass.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 14.04.2021.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    class func newFolder(name:String) -> Folder{
        let folder = Folder(context: CoreDataManager.sharedInstance.managedObjectContext)
        folder.name = name
        folder.dataUpdate = NSDate() as Date
        
        return folder
    }
    
    //здесь заметка привязывается к уже созданной внутри класса папке folder
    func addNoteToFolder() -> Note{
        let newNote = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        newNote.folder = self
        newNote.dateUpdate = NSDate() as Date
        return newNote
        
    }
    
    var notesSorted: [Note] {
        
        let sortDescriptor = NSSortDescriptor(key: "dateUpdate", ascending: false)
        return self.notes?.sortedArray(using: [sortDescriptor]) as! [Note]
    }
    
    

}
