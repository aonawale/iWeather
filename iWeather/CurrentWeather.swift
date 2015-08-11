//
//  CurrentWeather.swift
//  iWeather
//
//  Created by Ahmed Onawale on 7/20/15.
//  Copyright © 2015 Ahmed Onawale. All rights reserved.
//

import Foundation

final class CurrentWeather: Weather {
    
    var date: String?
    
    override init(weatherDictionary: NSDictionary) {
        let unixTime = weatherDictionary.valueForKey("time") as! Int
        self.date = NSDate.dateStringFromUnixTime(unixTime, dateStyle: .LongStyle, timeStyle: .ShortStyle)
        super.init(weatherDictionary: weatherDictionary)
    }
}