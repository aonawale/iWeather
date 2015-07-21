//
//  APIController.swift
//  iWeather
//
//  Created by Ahmed Onawale on 7/20/15.
//  Copyright (c) 2015 Ahmed Onawale. All rights reserved.
//

import Foundation

@objc protocol APIControllerDelegate: class {
    optional func didReceiveWeatherResult(weatherObject: NSDictionary)
    optional func didReceiveLocationResult(locationObject: NSDictionary)
}

class APIController {
    
    struct API {
        private static let ForcastKEY = "e9f75045f39337c8df914eb723c4832b"
        private static let ForecastURL = "https://api.forecast.io/forecast/"
        private static let GeocodeURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
        private static let GeocodeKey = "AIzaSyDo3xtVe5TuRDZ8PFrdLeuu14VCvM9ZILg"
    }
    
    weak var delegate: APIControllerDelegate?
    private let session = NSURLSession.sharedSession()
    
    func getWeatherData(coordinate: String) {        
        let baseURL = NSURL(string: "\(API.ForecastURL)\(API.ForcastKEY)/")
        let forecastURL = NSURL(string: coordinate, relativeToURL: baseURL)
        let task = session.dataTaskWithURL(forecastURL!) { data, response, error in
            if error != nil {
                println(error.localizedDescription)
            }
            if let HTTPresponse = response as? NSHTTPURLResponse {
                if HTTPresponse.statusCode == 200 {
                    var err: NSError?
                    if let weatherObject = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                        if err != nil {
                            println("JSON Error \(err!.localizedDescription)")
                        } else {
                            self.delegate?.didReceiveWeatherResult!(weatherObject as NSDictionary)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func suggestLocation(location: String) {
        let geocodeURL = NSURLComponents(string: API.GeocodeURL)
        geocodeURL?.query = "input=\(location)&key=\(API.GeocodeKey)"
        let task = session.dataTaskWithURL(geocodeURL!.URL!) { data, response, error in
            if error != nil {
                println(error.localizedDescription)
            }
            if let HTTPresponse = response as? NSHTTPURLResponse {
                if HTTPresponse.statusCode == 200 {
                    var err: NSError?
                    if let locationObject = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                        if err != nil {
                            println("JSON Error \(err!.localizedDescription)")
                        } else {
                            self.delegate?.didReceiveLocationResult!(locationObject as NSDictionary)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
}