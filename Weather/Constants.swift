//
//  Constants.swift
//  Weather
//
//  Created by Matthew Maher on 10/26/15.
//  Copyright © 2015 Matthew Maher. All rights reserved.
//

// http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=bd82977b86bf27fb59a04b61b657fb6f


import Foundation

let URL_BASE_NOW = "http://api.openweathermap.org/data/2.5/weather?"
let URL_BASE_FORCAST = "http://api.openweathermap.org/data/2.5/forecast?"
let API_KEY = "07bdad6bd15a568d42eb14383c71ecf8"

typealias DownloadComplete = () -> ()
