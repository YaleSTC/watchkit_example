//
//  ScheduleInterfaceController.swift
//  WatchKit Example
//
//  Created by Clark on 10/8/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleInterfaceController: WKInterfaceController {

    @IBOutlet var busesTable: WKInterfaceTable!
    var buses = BusInfo.allBuses()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        busesTable.setNumberOfRows(buses.count, withRowType: "BusRow")
        
        for index in 0..<busesTable.numberOfRows {
            if let controllerRow = busesTable.rowController(at: index) as? BusRowController {
                controllerRow.bus = buses[index]
            }
        }
        
        self.testAction()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // test code
    let session = URLSession(configuration: .default)
    
    func testAction() {
        var request = URLRequest(url: URL(string: "https://httpbin.org/post")!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        let body = "Hello Cruel World!".data(using: .utf8)
        let task = session.uploadTask(with: request, from: body) { (data, response, error) in
            if let error = error {
                print("error %@", error)
            } else {
                let response = response as! HTTPURLResponse
                let data = data!
                print("success %d", response.statusCode)
                if response.statusCode == 200 {
                    
                    print(">>%@<<", String(data: data, encoding: .utf8) ?? "")
                }  
            }  
        }  
        task.resume()  
    }
}
