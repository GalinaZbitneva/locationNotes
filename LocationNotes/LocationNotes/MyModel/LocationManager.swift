//
//  LocationManager.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 28.04.2021.
//

import UIKit
import CoreLocation

struct LocationCoordinate {
    var lat: Double
    var lon: Double
    
    static func create(location: CLLocation) -> LocationCoordinate {
        return LocationCoordinate (lat: location.coordinate.latitude, lon: location.coordinate.longitude)}
}

class LocationManager: NSObject , CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    var manager = CLLocationManager()
    
    var blockForSave: ((LocationCoordinate) -> Void)?
    
    
    func requestAutorization () {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lc = LocationCoordinate.create(location: locations.last!)
        blockForSave?(lc)
        manager.stopUpdatingLocation()
    }
    
    func getCurrentLocation (block: ((LocationCoordinate)->Void)?){
        blockForSave = block
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .other
        manager.startUpdatingLocation()
    }
    
}
