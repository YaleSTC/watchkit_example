//
//  locationModule.swift
//  WatchKit Example
//
//  Created by Shanelle Roman on 10/7/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import CoreLocation




class LocationModule: NSObject, CLLocationManagerDelegate
{
    static let sharedModule = LocationModule()
    
    lazy var locationManager: CLLocationManager = {
        let myManager = CLLocationManager()
        myManager.distanceFilter = kCLDistanceFilterNone
        myManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myManager.delegate = self
        return myManager
    }()
    
    var currentLocation: CLLocation?
    // block gets called whenever new filtered stops are available
    var callback: (([Int]) ->Void)?
    var stops: [Int: CLLocationCoordinate2D]?
    

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
    
  /*  func distance(from: CLLocation, to: CLLocationCoordinate2D) ->CLLocationDistance
    {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    } */
    
    let MAX_NUM_CLOSE_STOPS = 3
    
    // returns an array of the nearest stops
    // passed an dictionary of bustopIDs with their 2d coordinate
    func filter(stops: [Int: CLLocationCoordinate2D]) -> [Int] {
        // if there is no current location, don't filter
        if currentLocation == nil {
            return [Int](stops.keys)
        }
        var stopDistances = [(stopId: Int, distance: CLLocationDistance)]()
        
        for (stopId, coordinate) in stops {
            // calculate distance from current location
            let coordinateLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = currentLocation!.distance(from: coordinateLocation)
            stopDistances.append((stopId: stopId, distance: distance))
        }
        // sort so the closest ones are at the beginning
        stopDistances.sort { (stop1dist, stop2dist) -> Bool in
            return stop1dist.distance < stop2dist.distance
        }
        
        var closestStops = [Int]()
        for i in 0..<MAX_NUM_CLOSE_STOPS {
            if i >= stopDistances.count {
                break
            }
            closestStops.append(stopDistances[i].stopId)
        }
        
        return closestStops
    }
        
    func beginUpdates(stops: [Int: CLLocationCoordinate2D], completionHandler: @escaping ([Int])->Void)-> Void
    {
        self.stops = stops
        self.callback = completionHandler
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
    
    // location delegate stuff
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.currentLocation = locations.last!
        if let stopsToFilter = self.stops {
            self.callback?(filter(stops: stopsToFilter))
        }
    }
}
