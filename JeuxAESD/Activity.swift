//
//  Activity.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-07.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation

class Activity: Equatable {
    public var description: String { return "Activity(text: \(text), startTime: \(startTime), endTime: \(endTime), parentLocation: \(String(describing: parentLocation)))" }
    
    private var _text: String
    private var _startTime: Date
    private var _endTime: Date
    private var _parentLocation: Location?
    private var _results: [Result]
    
    var text: String {
        get {
            return _text
        }
    }
    
    var startTime: Date {
        get {
            return _startTime
        }
    }
    
    var endTime: Date {
        get {
            return _endTime
        }
    }
    
    var parentLocation: Location? {
        get {
            return _parentLocation
        }
        set {
            _parentLocation = newValue
        }
    }
    
    var results: [Result] {
        get {
            return _results
        }
    }
    
    init(_ text: String, _ startTime: Date, _ endTime: Date, _ results: [Result], _ parentLocation: Location? = nil) {
        _text = text
        _startTime = startTime
        _endTime = endTime
        _parentLocation = parentLocation
        _results = results
    }
    
    convenience init?(from: NSDictionary?, parentLocation: Location? = nil) {
        guard let name = from?.value(forKey: "name") as? String else {
            Logger.error("Failed to parse activity name")
            return nil
        }
        
        guard let startTimeString = from?.value(forKey: "start_time") as? String else {
            Logger.error("Failed to parse activity start time")
            return nil
        }
        
        guard let endTimeString = from?.value(forKey: "end_time") as? String else {
            Logger.error("Failed to parse activity end time")
            return nil
        }
        
        guard let startTime = DateFormatter.iso8601.date(from: startTimeString) else {
            Logger.error("Failed to parse start time as ISO8601 date")
            return nil
        }
        
        guard let endTime = DateFormatter.iso8601.date(from: endTimeString) else {
            Logger.error("Failed to parse end time as ISO8601 date")
            return nil
        }
        
        guard let resultsArray = from?.value(forKey: "results") as? NSArray else {
            Logger.error("Failed to parse results as NSArray")
            return nil
        }
        
        var results = [Result]()
        
        for object in resultsArray {
            guard let result = Result(from: object as? NSDictionary) else {
                Logger.error("Failed to parse results array object as Result")
                return nil
            }
            
            results.append(result)
        }
        
        self.init(name, startTime, endTime, results, parentLocation)
    }
    
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.text == rhs.text && lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime
    }
}
