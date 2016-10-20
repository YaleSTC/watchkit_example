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
            busNameLabel.setText(bus.lineName)
            busNameLabel.setTextColor(hexStringToUIColor(hex: bus.lineColor))
            busTimeLabel.setText(bus.stringForTimeOfArrivalAtStop(stop))
            busStationLabel.setText(bus.stringForStop(stop))
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
