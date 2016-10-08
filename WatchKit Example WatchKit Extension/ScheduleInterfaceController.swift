//
//  ScheduleInterfaceController.swift
//  WatchKit Example
//
//  Created by Clark on 10/8/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import WatchKit
//import Foundation


class ScheduleInterfaceController: WKInterfaceController {

    @IBOutlet var busesTable: WKInterfaceTable!
    var buses = BusInfo.allBuses()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        busesTable.setNumberOfRows(buses.count, withRowType: "busRow")
        
        for index in 0..<busesTable.numberOfRows {
            if let controllerRow = busesTable.rowController(at: index) as? BusRowController {
                controllerRow.bus = buses[index]
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
