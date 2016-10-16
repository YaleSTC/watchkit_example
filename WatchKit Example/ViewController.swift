//
//  ViewController.swift
//  WatchKit Example
//
//  Created by Lee on 10/7/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    var session: WCSession!
    var watchData = [String: Data]()
    var reloadTimer: Timer!
    let RELOAD_FREQUENCY = TimeInterval(60.0)
    
    func sendToWatch() {
        do {
            try WCSession.default().updateApplicationContext(watchData)
        } catch {
            print("Failed send to watch")
        }
    }

    override func viewDidLoad() {
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self;
            session.activate()
        }
        self.reloadTimer = Timer(timeInterval: RELOAD_FREQUENCY, target: self, selector: #selector(makeAllAPIRequests), userInfo: nil, repeats: true)
        self.reloadTimer.fire()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /**
     * Makes sequential API calls to the transit API.
     * Stores results in watchData
     * After the last API call has completed successfully, calls sendToWatch()
     */
    func makeAPIRequests(for endpoints: [String]) {
        if endpoints.count < 1 {
            self.sendToWatch()
        } else {
            let endpoint = endpoints[0]
            let remainingEndpoints = [String](endpoints.suffix(from: 1))
            TransitAPIModule.sharedModule.requestNearbyBuses(endpoint: endpoint, completionHandler: { (data) in
                self.watchData[endpoint] = data
                self.makeAPIRequests(for: remainingEndpoints)
                }, errorHandler: { (error) in
                    print("Error: \(error)")
            })
        }
    }
    
    func makeAllAPIRequests() {
        self.makeAPIRequests(for: ["vehicles", "stops", "routes"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activation completed with state \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session deactivated")
    }
}

