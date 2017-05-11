//
//  Event.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-02.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation

class Event<T> {
    typealias EventHandler = (T) -> ()
    
    private var eventHandlers: [EventHandler] = [EventHandler]()
    
    func addHandler(_ handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    func raise(_ data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}
