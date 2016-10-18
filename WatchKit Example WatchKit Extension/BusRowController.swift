//
//  BusRowController.swift
//  WatchKit Example
//
//  Created by Clark on 10/8/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import WatchKit

class BusRowController: NSObject {
    
    @IBOutlet var busNameLabel: WKInterfaceLabel!
    @IBOutlet var busTimeLabel: WKInterfaceLabel!
    @IBOutlet var busStationLabel: WKInterfaceLabel!
    
    var bus: BusInfo?
    var stopId: Int?
    
    func updateUI() {
        if let bus = bus, let stop = stopId {
            busNameLabel.setText(bus.name)
            busTimeLabel.setText(bus.stringForTimeOfArrivalAtStop(stop))
            busStationLabel.setText(bus.stringForStop(stop))
        }
    }
}
