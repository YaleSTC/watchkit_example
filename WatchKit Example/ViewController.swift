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
        TransitAPIModule.sharedModule.requestNearbyBuses(endpoint: "vehicles", completionHandler: { (info: Data)->Void in
            self.watchData["vehicles"] = info
            self.sendToWatch()
            print("Info: \(info)")
            TransitAPIModule.sharedModule.requestNearbyBuses(endpoint: "stops", completionHandler: { (info: Data)->Void in
                self.watchData["stops"] = info
                self.sendToWatch()
                print("Stops: \(NSString(data: info, encoding: 4)!)")
                }, errorHandler: { (err: Error)->Void in
                    print("Error: \(err)")
            })
            }, errorHandler: { (err: Error)->Void in
                print("Error: \(err)")
        })
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

