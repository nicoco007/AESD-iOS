//
//  MKPointLocationAnnotation.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-05-02.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Mapbox

class MKPointLocationAnnotation: MGLPointAnnotation {
    private let _location: Location?
    
    public var location: Location? {
        get {
            return _location
        }
    }
    
    init(location: Location) {
        _location = location
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        _location = nil
        super.init(coder: aDecoder)
    }
}
