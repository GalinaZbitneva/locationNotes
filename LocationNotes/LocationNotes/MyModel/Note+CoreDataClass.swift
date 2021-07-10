//
//  Note+CoreDataClass.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 14.04.2021.
//
//

import Foundation
import CoreData
import UIKit

@objc(Note)
public class Note: NSManagedObject {
    class func newNote(name: String, inFolder:Folder?) -> Note{
        let newNote = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        newNote.name = name
        newNote.dateUpdate = NSDate() as Date
        
       // if let inFolder = inFolder {
            newNote.folder = inFolder
        //}
        //можно оставить просто newNote.folder = inFolder тк если inFolder = nil то папкм просто не будет
        return newNote
    }
    
    func addImage(image: UIImage) {
        let imageNote = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)// здесь мы указваем что переменная является объектом типа сущности ImageNote
        imageNote.imageBig = image.jpegData(compressionQuality: 1.0) // здесь объект из формата jpeg переводим в формат Data. без сжатия 1 - это 100%
        self.image = imageNote // говорим что входной параметр функции и есть imageNote
        
    }
    func addLocation(latitude:Double, lontitude:Double){
        let location = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
        location.latitude = latitude
        location.longitude = lontitude
        
        self.location = location
    }
    
    var dateUpdateString: String {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        return df.string(from: self.dateUpdate as! Date)
    }
    
    var imageActual: UIImage? {
        set{
            if newValue == nil{
                if self.image != nil {
                    CoreDataManager.sharedInstance.managedObjectContext.delete(self.image!) // удаляем картинку потому что новое значение говорит что картинки больше нет
                }
                self.imageSmall = nil
            } else {
                if self.image == nil { // те если у нас не было картинки, а теперь будет то создаем объект
                    self.image = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
                    
                }
                self.image?.imageBig = newValue?.jpegData(compressionQuality: 1)
                self.imageSmall = newValue?.jpegData(compressionQuality: 0.05)
            }
            dateUpdate = NSDate() as Date
            
        }
        get {
            if self.image != nil{
                if image?.imageBig != nil {
                    return UIImage(data: self.image!.imageBig! as Data)
                }
            }
            return nil
        }
        
        
    }
    
    var locationActual: LocationCoordinate? {
        get {
            if self.location == nil { //если у самой (этой) заметки нет локации
                return nil
            } else {
                return LocationCoordinate(lat: self.location!.latitude, lon: self.location!.longitude)
            }
    }
        set {
            if newValue == nil && self.location != nil { // те раньше локация была а сейчас не будет, значит удаляем локацию
                CoreDataManager.sharedInstance.managedObjectContext.delete(self.location!)
                
            }
            if newValue != nil && self.location != nil { // обновляем локацию
                self.location?.latitude = newValue!.lat
                self.location?.longitude = newValue!.lon
        }
            if newValue != nil && self.location == nil { //создаем локацию
                let newLocation = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
                newLocation.latitude = newValue!.lat
                newLocation.longitude = newValue!.lon
                
                self.location = newLocation
            }

        }
    }
    
    func addCurentLocation() {
        LocationManager.sharedInstance.getCurrentLocation{(location) in self.locationActual = location
            
        }
    }
}
