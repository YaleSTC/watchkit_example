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
    var stops = [String: CLLocationCoordinate2D] ()
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
    
  /*  func distance(from: CLLocation, to: CLLocationCoordinate2D) ->CLLocationDistance
    {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    } */
    
    // returns a String array of the nearest stops
    // passed an dictionary of bustopIDs with their 2d coordinate
    // QUESTION: should it be a string array or an integer array??
    func calculateShortestDistance(currentLocation: CLLocation?, dict: [String: CLLocationCoordinate2D])->[String] {
        
        var shortestDistance: CLLocationDistance? = nil
        var secondShortest: CLLocationDistance? = nil
        var thirdShortest: CLLocationDistance? = nil
        var closestStops = [String]()
        if dict.count > 0 {
            for (stop, coordinate) in dict
            {
                // calculate distance from current location
                let coordinateLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let distance = currentLocation?.distance(from: coordinateLocation)
                if (shortestDistance == nil || distance! < shortestDistance!)
                {
                    // update the closest stop values
                    thirdShortest = secondShortest
                    secondShortest = shortestDistance
                    shortestDistance = distance
                    closestStops.append(stop)
                }
                else if (secondShortest == nil || distance! < secondShortest!)
                {
                    // update values
                    thirdShortest = secondShortest
                    secondShortest = distance
                    closestStops.append(stop)
                }
                else if (thirdShortest == nil || distance! < thirdShortest!)
                {
                    // update values
                    thirdShortest = distance
                    closestStops.append(stop)
                }
            }
            
        return closestStops
        
            
        }
        
        
    
    // returns the list of shortest stops
    func filter(dict: [String: CLLocationCoordinate2D])->[Int]
    {
        let closestStops = calculateShortestDistance(currentLocation: self.currentLocation, dict: dict)
        var stopList = [Int] ()
        for stop in closestStops {
            stopList.append(Int(stop)!)
            
        }
        return stopList
        
    }
        
    func beginUpdates(dict: [String: CLLocationCoordinate2D], completionHandler: @escaping ([Int])->Void)-> Void {
            self.stops = dict
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
        callback(filter(dict: stops))
    }
    
}
