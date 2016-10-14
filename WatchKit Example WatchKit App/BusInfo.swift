//
//  BusType.swift
//  WatchKit Example
//
//  Created by Clark on 10/7/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import Foundation

class BusInfo {
    var name: String
    var latitude: String
    var longitude: String
    var arrivalEstimates: NSArray
    
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
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        self.name = dictionary["vehicle_id"] as! String
        //let time = dictionary["time"] as! String
        self.latitude = ((dictionary["location"] as! NSDictionary)["lat"] as! NSNumber).stringValue
        self.longitude = ((dictionary["location"] as! NSDictionary)["lng"] as! NSNumber).stringValue
        self.arrivalEstimates = dictionary["arrival_estimates"] as! NSArray
    }
}


