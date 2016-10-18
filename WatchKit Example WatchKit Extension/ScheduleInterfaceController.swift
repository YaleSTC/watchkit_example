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
    var buses = BusInfo.allBuses()
    var session: WCSession!
    
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
    
    func sortBusList() {
        buses.sort() { $0.time < $1.time }
    }
    
    func updateUI() {
        // Configure interface objects here.
        sortBusList()

        busesTable.setNumberOfRows(buses.count, withRowType: "BusRow")
        for index in 0..<busesTable.numberOfRows {
            if let controllerRow = busesTable.rowController(at: index) as? BusRowController {
                controllerRow.bus = buses[index]
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
                self.updateUI()
            }
            LocationModule.sharedModule.startUpdatingLocation()
        }
        if let vehiclesData = applicationContext["vehicles"] as? Data {
            do {
                if let vehicles = try TransitAPIModule.sharedModule.extractData(vehiclesData) {
                    self.buses = vehicles
                    self.updateUI()
                }
            } catch {
                print("error parsing")
            }
        }
        if let routesData = applicationContext["routes"] as? Data {
            print("routes data is: ")
            print(NSString(data: routesData, encoding: 4)!)
        }
        
        print("BusInfo now has stop names \(BusInfo.stopNames)")
        print("application context has arrived")
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
