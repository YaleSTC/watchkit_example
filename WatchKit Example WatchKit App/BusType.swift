//
//  BusType.swift
//  WatchKit Example
//
//  Created by Clark on 10/7/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import Foundation
import WatchKit

class BusInfo {
    var name: String
    var time: String
    var location: String
    var station: String
    
    init(name: String, time: String, location: String, station: String) {
        self.name = name
        self.location = location
        self.time = time
        self.station = station
        
    }
    
    class func allBuses() -> [BusInfo] {
        var buses = [BusInfo]()
        if let path = Bundle.main.path(forResource: "busInfoJSON", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [Dictionary<String, String>]
                for dict in json {
                    let bus = BusInfo(dictionary: dict)
                    buses.append(bus)
                }
            } catch {
                print(error)
            }
        }
        return buses
    }
    
    convenience init(dictionary: [String: String]) {
        let name = dictionary["name"]!
        let time = dictionary["time"]!
        let location = dictionary["location"]!
        let station = dictionary["station"]!
        self.init(name: name, time: time, location: location, station: station)
    }
}


