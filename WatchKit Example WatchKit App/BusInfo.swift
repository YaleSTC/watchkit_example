//
//  BusType.swift
//  WatchKit Example
//
//  Created by Clark on 10/7/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import Foundation

class BusInfo {
    static var stopNames = [Int : String]()
    var name: String
    var time: String
    var station: String
    
    class func allBuses() -> [BusInfo] {
        var buses = [BusInfo]()
        if let path = Bundle.main.path(forResource: "busInfoJSON", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                if let busJSON = try TransitAPIModule.sharedModule.extractData(data) {
                    for bus in busJSON {
                        buses.append(bus)
                    }
                }
            } catch {
                print(error)
            }
        }
        return buses
    }
    
    // for converting from API date to NSDate
    let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    // for converting from NSDate to displayed date
    let prettyDateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.short
        return formatter
    }()
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        self.name = dictionary["vehicle_id"] as! String
        let arrivalEstimates = dictionary["arrival_estimates"] as! NSArray
        // look only at the next arrival
        self.station = "Bus Stop"
        self.time = "Eventually"
        if arrivalEstimates.count > 0 {
            if let arrivalEstimate = arrivalEstimates.firstObject as? NSDictionary {
                let arrivalTime = arrivalEstimate["arrival_at"] as! String
                // arrival time is in format 2016-10-14T05:51:01-04:00
                let ETA = dateFormatter.date(from: arrivalTime)!
                self.time = prettyDateFormatter.string(from: ETA)
                let stopId = arrivalEstimate["stop_id"] as! NSString
                self.station = BusInfo.stopNames[stopId.integerValue] ?? "Unknown Stop"
            }
        }
    }
}


