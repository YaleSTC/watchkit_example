//
//  BusType.swift
//  WatchKit Example
//
//  Created by Clark on 10/7/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import Foundation
import CoreLocation

class BusInfo {
    static var stopNames = [Int : String]()
    // this array of stop IDs is updated periodically to represent the nearest stops to the user
    static var nearbyStops = [Int]()
    var name: String
    var route: Int
    // represents time of arrival as dictionary mapping stop ID -> seconds until arrival
    var timeOfArrival = [Int : TimeInterval]()
    
    // for converting from API date to NSDate
    let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    // for converting from TimeInterval to displayed date
    func displayTimeInterval(_ interval: TimeInterval) -> String? {
        if interval < 0 {
            return nil
        }
        if interval < 60 {
            return "\(Int(interval))s"
        }
        if interval < 3600 {
            return "\(Int(interval/60))m"
        }
        return "\(Int(interval/3600))h"
    }
    
    func stringForTimeOfArrivalAtStop(_ stop: Int) -> String {
        return displayTimeInterval(self.timeOfArrival[stop] ?? 0.0) ?? "0s"
    }
    
    func stringForStop(_ stop: Int) -> String {
        return BusInfo.stopNames[stop] ?? "Unknown"
    }
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        self.name = dictionary["vehicle_id"] as! String
        self.route = (dictionary["route_id"] as! NSString).integerValue
        let arrivalEstimates = dictionary["arrival_estimates"] as! NSArray
        // look only at the next arrival
        for possibleEstimate in arrivalEstimates {
            if let arrivalEstimate = possibleEstimate as? NSDictionary {
                let arrivalTime = arrivalEstimate["arrival_at"] as! String
                // arrival time is in format 2016-10-14T05:51:01-04:00
                let ETA = dateFormatter.date(from: arrivalTime)!
                let durationUntilArrival = ETA.timeIntervalSinceNow // if in the past, this is negative
                
                let stopId = (arrivalEstimate["stop_id"] as! NSString).integerValue
                self.timeOfArrival[stopId] = durationUntilArrival
            }
        }
    }
}


