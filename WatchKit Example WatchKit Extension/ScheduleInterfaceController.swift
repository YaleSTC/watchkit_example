//
//  ScheduleInterfaceController.swift
//  WatchKit Example
//
//  Created by Clark on 10/8/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreLocation

class ScheduleInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var busesTable: WKInterfaceTable!
    // array of pairs (bus, stopId)
    var busArrivals = [(bus: BusInfo, stopId: Int, time: TimeInterval)]()
    var buses = [BusInfo]()
    var session: WCSession!
    
    func updateBusArrivals() {
        busArrivals = []
        // filter out the stops that are too far away, and create duplicates views of the bus as needed
        for bus in buses {
            for (arrivalStop, arrivalTime) in bus.timeOfArrival {
                if BusInfo.nearbyStops.contains(arrivalStop) {
                    bus.addLineNameColor(lineName: lineName, lineColor: lineColor)
                    busArrivals.append((bus: bus, stopId: arrivalStop, time: arrivalTime))
                }
            }
        }
        // sort by arrival time
        busArrivals.sort { (busArrival1, busArrival2) -> Bool in
            return busArrival1.time < busArrival2.time
        }
        self.updateUI()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        updateUI()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self;
            session.activate()
        }
        
        LocationModule.sharedModule.requestLocationAccess()
    }
    
    func updateUI() {
        // Configure interface objects here.
        busesTable.setNumberOfRows(busArrivals.count, withRowType: "BusRow")
        
        for index in 0..<busesTable.numberOfRows {
            if let controllerRow = busesTable.rowController(at: index) as? BusRowController {
                controllerRow.bus = busArrivals[index].bus
                controllerRow.stopId = busArrivals[index].stopId
                controllerRow.updateUI()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activation completed")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        // received data from the iOS app!
        if let stopsData = applicationContext["stops"] as? Data {
            var stopNames = [Int: String]()
            var stopLocations = [Int: CLLocationCoordinate2D]()
            do {
                if let stops = try JSONSerialization.jsonObject(with: stopsData, options: .allowFragments) as? NSDictionary {
                    if let stopsArray = stops["data"] as? NSArray {
                        for stop in stopsArray {
                            if let stopDict = stop as? NSDictionary {
                                let name = stopDict["name"] as! String
                                let stopId = stopDict["stop_id"] as! NSString
                                stopNames[stopId.integerValue] = name
                                if let location = stopDict["location"] as? NSDictionary {
                                    let longitude = location["lat"] as! NSNumber
                                    let latitude = location["lng"] as! NSNumber
                                    stopLocations[stopId.integerValue] = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error parsing")
            }
            BusInfo.stopNames = stopNames
            BusInfo.nearbyStops = Array(stopNames.keys)
            
            // here start filtering based on user's location
            LocationModule.sharedModule.beginUpdates(stops: stopLocations) { (stopIds: [Int])->Void in
                BusInfo.nearbyStops = stopIds
                self.updateBusArrivals()
            }
            LocationModule.sharedModule.startUpdatingLocation()
        }
        
        if let vehiclesData = applicationContext["vehicles"] as? Data {
            //get vehicles data
            do {
                if let vehicles = try TransitAPIModule.sharedModule.extractData(vehiclesData) {
                    self.buses = vehicles
                    self.updateBusArrivals()
                }
            } catch {
                print("error parsing")
            }
            print("vehicles data is: ")
            print(NSString(data: vehiclesData, encoding: 4)!)
            
            //get line numbers and colors
            let vehicleID: String
            var lineNum: String
            var lineName: String
            var lineColor: String
            
            if let vehiclesData = applicationContext["vehicles"] as? Data {
                do {
                    if let lines = try JSONSerialization.jsonObject(with: vehiclesData, options: .allowFragments) as? NSDictionary {
                        if let linesDict1 = lines["data"] as? NSDictionary {
                            if let linesDict = linesDict1["128"] as? NSDictionary {
                                for index in 0..<19 {
                                    if let line = linesDict[(index as NSNumber).stringValue] as? NSDictionary {
                                        if let lineSegments = line["segments"] as? NSArray {
                                            for lineSegment in lineSegments {
                                                if let lineSegDict = lineSegment as? NSDictionary {
                                                    if lineSegDict["0"] as? String == vehicleID {
                                                        let lineNum = line["route_id"]
                                                        let lineName = line["long_name"]
                                                        let lineColor = line["color"]
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("error parsing")
                }

            
            
        if let routesData = applicationContext["routes"] as? Data {
            print("routes data is: ")
            print(NSString(data: routesData, encoding: 4)!)
        }
        
        print("BusInfo now has stop names \(BusInfo.stopNames)")
        print("application context has arrived")
    }
    }
    }

    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
