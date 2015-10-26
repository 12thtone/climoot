//
//  Location.swift
//  Weather
//
//  Created by Matthew Maher on 10/26/15.
//  Copyright © 2015 Matthew Maher. All rights reserved.
//

import Foundation

class Location {
    
    private var _latitude: String!
    private var _longitude: String!
    
    var latitude: String {
        if _latitude == nil {
            _latitude = "33"
        }
        return _latitude
    }
    
    var longitude: String {
        if _longitude == nil {
            _longitude = "83"
        }
        return _longitude
    }
    
}