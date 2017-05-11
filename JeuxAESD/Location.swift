//
//  Location.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-07.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation

class Location: Equatable, CustomStringConvertible {
    public var description: String { return "Location(latitude: \(latitude), longitude: \(longitude), type: \(type), name: \(name), activities: \(activities))" }
    
    private var _latitude: Double
    private var _longitude: Double
    private var _type: Int
    private var _name: String
    private var _activities: [Activity]
    
    var latitude: Double {
        get {
            return _latitude
        }
    }
    
    var longitude: Double {
        get {
            return _longitude
        }
    }
    
    var type: Int {
        get {
            return _type
        }
    }
    
    var name: String {
        get {
            return _name
        }
    }
    
    var activities: [Activity] {
        get {
            return _activities
        }
    }
    
    init(_ name: String, _ latitude: Double, _ longitude: Double, _ type: Int, _ activities: [Activity] = []) {
        self._latitude = latitude
        self._longitude = longitude
        self._type = type
        self._name = name
        self._activities = activities
        
        for activity in activities {
            activity.parentLocation = self
        }
    }
    
    convenience init?(from: NSDictionary?) {
        guard let name: String = from?.value(forKey: "name") as? String else {
            Logger.error("Failed to parse name")
            return nil
        }
        
        guard let latitude = from?.value(forKey: "latitude") as? Double else {
            Logger.error("Failed to parse latitude")
            return nil
        }
        
        guard let longitude = from?.value(forKey: "longitude") as? Double else {
            Logger.error("Failed to parse longitude")
            return nil
        }
        
        guard let type = from?.value(forKey: "type") as? Int else {
            Logger.error("Failed to parse type")
            return nil
        }
        
        guard let activitiesArray = from?.value(forKey: "activities") as? NSArray else {
            Logger.error("Failed to cast activities key as NSDictionary")
            return nil
        }
        
        var activities = [Activity]()
        
        for item in activitiesArray {
            guard let activity = Activity(from: item as? NSDictionary) else {
                Logger.error("Failed to create instance of Activity from activity object")
                continue
            }
            
            activities.append(activity)
        }
        
        activities.sort(by: { (a, b) -> Bool in a.text.lowercased() < b.text.lowercased() })
        
        self.init(name, latitude, longitude, type, activities)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
