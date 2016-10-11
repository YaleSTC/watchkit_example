//
//  locationModule.swift
//  WatchKit Example
//
//  Created by Shanelle Roman on 10/7/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import CoreLocation

class LocationModule: NSObject, CLLocationManagerDelegate {
    
    // utilizes lazy variables
    lazy var locatManager: CLLocationManager = self.manager();
    lazy var currentLocation: CLLocation = self.currentLocation;
    
    
     func manager() -> CLLocationManager {
        let myManager = CLLocationManager();
        myManager.distanceFilter = kCLDistanceFilterNone
        myManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
         myManager.delegate = self
        return myManager
    }

    
 
   func startUpdatingLocation() {
        self.locatManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locatManager.stopUpdatingLocation()
    }
    
    func requestLocationAccess() {
        self.locatManager.requestAlwaysAuthorization()
    }
    
    func coordinate()-> CLLocationCoordinate2D {
        return self.currentLocation.coordinate
    }
    
    func speed()-> Double {
       return self.currentLocation.speed
    }
    
    func direction() -> Double {
        return self.currentLocation.course
    }
    
    // location delegate stuff
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
    }
    
}
