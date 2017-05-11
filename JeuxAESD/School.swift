//
//  School.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-06.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation

class School {
    private var _id: Int
    private var _name: String
    
    public var id: Int {
        get {
            return _id
        }
    }
    
    public var name: String {
        get {
            return _name
        }
    }
    
    init(_ id: Int, _ name: String) {
        _id = id
        _name = name
    }
    
    convenience init?(from: NSDictionary?) {
        guard from != nil else {
            Logger.error("NSDictionary is empty!")
            return nil
        }
        
        guard let id = from?.value(forKey: "id") as? Int else {
            Logger.error("Failed to parse id as int")
            return nil
        }
        
        guard let name = from?.value(forKey: "name") as? String else {
            Logger.error("Failed to parse name as string")
            return nil
        }
        
        self.init(id, name)
    }
}
