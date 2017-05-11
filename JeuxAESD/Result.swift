//
//  Result.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-06.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation

class Result {
    private var _id: Int
    private var _type: ResultType
    private var _school: School
    
    public var id: Int {
        get {
            return _id
        }
    }
    
    public var type: ResultType {
        get {
            return _type
        }
    }
    
    public var school: School {
        get {
            return _school
        }
    }
    
    init(_ id: Int, _ type: ResultType, _ school: School) {
        _id = id
        _type = type
        _school = school
    }
    
    convenience init?(from: NSDictionary?) {
        guard let id = from?.value(forKey: "id") as? Int else {
            Logger.error("Failed to parse id as int")
            return nil
        }
        
        guard let type = ResultType(from: from?.value(forKey: "type") as? NSDictionary) else {
            Logger.error("Failed to parse type as ResultType")
            return nil
        }
        
        guard let school = School(from: from?.value(forKey: "school") as? NSDictionary) else {
            Logger.error("Failed to parse school as School")
            return nil
        }
        
        self.init(id, type, school)
    }
}
