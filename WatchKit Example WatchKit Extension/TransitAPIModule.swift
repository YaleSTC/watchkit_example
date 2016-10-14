//
//  TransitAPIModule.swift
//  WatchKit Example
//
//  Created by Lee on 10/14/16.
//  Copyright © 2016 Yale SDMP. All rights reserved.
//

import UIKit

class TransitAPIModule: NSObject {
    static let sharedModule = TransitAPIModule()
    var urlSession: URLSession?
    var dataTask: URLSessionDataTask?
    
    func extractData(_ responseData: Data?) throws -> ([BusInfo])? {
        if let jsonData = try self.extractJSON(responseData) {
            var busInfo = [BusInfo]()
            for busData in jsonData {
                busInfo.append(BusInfo(dictionary: busData as! NSDictionary))
            }
            return busInfo
        }
        return nil
    }
    
    func extractJSON(_ responseData: Data?) throws -> NSArray? {
        if let data = responseData {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let arrivalData = ((jsonData as? NSDictionary)?.value(forKey: "data") as? NSDictionary)?.allValues.first as? NSArray {
                return arrivalData
            }
        }
        return nil
    }
    
    /**
     * Initiates an HTTP GET request to the Yale Transit API.
     * On completion, |completionHandler| is called with the array of bus data.
     * On error, |errorHandler| is called.
     */
    func requestNearbyBuses(endpoint: String, completionHandler: @escaping (Data)->Void, errorHandler: @escaping (Error)->Void) {
        // construct the URL based on API documentation at https://developers.yale.edu/documentation/CampusLife/transloc
        // and https://market.mashape.com/transloc/openapi-1-2#stops
        func encodeQuery(parameter: String) -> String {
            return NSString(string: parameter).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        }
        
        // request based on location in latitude,longitude format
        let location = "41.3,-72.9"
        // request with radius around that location, in meters
        let radius = "100000"
        // using the Agencies endpoint and curl, I figured out that Yale's agency ID is 128.
        // that seems like useful information to put on the developers.yale.edu website
        let agencyId = "128"
        
        let urlString = "https://transloc-api-1-2.p.mashape.com/\(endpoint).json?agencies=\(agencyId)&geo_area=\(encodeQuery(parameter: location+"|"+radius))"
        
        // Set up the URL Session
        self.urlSession = URLSession.init(configuration: URLSessionConfiguration.default)
        
        // Creates the NSURLRequest
        if let url = URL(string: urlString) {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("61xCoucKwGmshWq6bg8wgspUm7N5p1wDMGojsnSLkpqkhuibfO", forHTTPHeaderField: "X-Mashape-Key")
            self.dataTask = self.urlSession!.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                print("Received callback")
                // callback here with data and response
                if let failure = error {
                    errorHandler(failure)
                } else {
                    completionHandler(data!)
                }
            })
            self.dataTask?.resume()
        } else {
            errorHandler(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
    }
}
