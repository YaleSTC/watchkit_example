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
    }
    
    func updateUI() {
        // Configure interface objects here.
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
            do {
                if let stops = try JSONSerialization.jsonObject(with: stopsData, options: .allowFragments) as? NSDictionary {
                    if let stopsArray = stops["data"] as? NSArray {
                        for stop in stopsArray {
                            if let stopDict = stop as? NSDictionary {
                                let name = stopDict["name"] as! String
                                let stopId = stopDict["stop_id"] as! NSString
                                stopNames[stopId.integerValue] = name
                            }
                        }
                    }
                }
            } catch {
                print("error parsing")
            }
            BusInfo.stopNames = stopNames
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
