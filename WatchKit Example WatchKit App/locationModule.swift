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
    lazy var locationManager: CLLocationManager = self.manager()
    var currentLocation: CLLocation?;
    var stops = [Int: CLLocationCoordinate2D] ()
    var callback: (([Int]) ->Void)

    
    
     func manager() -> CLLocationManager {
        let myManager = CLLocationManager()
        myManager.distanceFilter = kCLDistanceFilterNone
        myManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myManager.delegate = self
        return myManager
    }

    // TODO: 
    /* 1. write a function filter(stops) declaration: func filter ([String: CLL2D coordinates]) -> [Int]
        takes in a dictionary of the stopID and CLL2D coordinates, filters them and finds the nearest Stops and returning them in an integer array
        2. beginUpdaates function that utilizes a call back that takes the same dictionary that filter took in, and an completion handler - it stores the value of dictionary and the value of the callback
            declaration: func beginUpdates(dict: [int: CLL2D], completionHandler: ([int])->Void) {
            self.stops = dict
            self.callback = completionHandler
        3. finally in the didUpdate function - use callback(filter(stops))
    // takes in an NSDictionary that pairs Stop Ids with CLL2D coordinates
    // filters by the current location
    // returns the closest location
  /*  func findNearbyStops(allStops: [String: CLLocationCoordinate2D])-> [String] {
// filtering can't be done here
     // helper filter Stops method - 
     didUpdate
    } */ */
    
    // returns a String array of the nearest stops
    func calculateShortestDistance(currentLocation: CLLocationCoordinate2D, dict: [String: CLLocationCoordinate2D])->[String] {
        
        // check if have done this calculation before - returns nearest bus stops
        // given a current location
        // is it possible to do a memoizedValues - there isn't really a point unless the key is for your current location
        /*
        let memoizedValue = memoizedValues[currentLocation]
        if memoizedValue != nil {
            return memoizedValue
        } */
        
        var shortestDistance: CLLocationDistance? = nil
        if dict.count > 0 {

        }
        
        
    }
    
    func filter(dict: [String: CLLocationCoordinate2D])->[Int]
    {
        
    }
    
 
 
   func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func requestLocationAccess() {
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func coordinate()-> CLLocationCoordinate2D {
        return (self.currentLocation?.coordinate)!
    }
    
    func speed()-> Double {
       return self.currentLocation!.speed
    }
    
    func direction() -> Double {
        return self.currentLocation!.course
    }
    
    // location delegate stuff
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.currentLocation = locations.last!
        callback(filter(stops))
    }
    
}
