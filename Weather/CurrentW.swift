//
//  CurrentW.swift
//  Weather
//
//  Created by Matthew Maher on 10/26/15.
//  Copyright © 2015 Matthew Maher. All rights reserved.
//

import Foundation
import Alamofire

class CurrentW {
    private var _currentURL: String!
    private var _myLatitude: String!
    private var _myLongitude: String!
    private var _appID: String!
    
    private var _day: String!
    
    private var _currentTemp: Int!
    private var _currentTempFar: Int!
    private var _currentHumidity: String!
    private var _currentWind: Int!
    private var _currentWindInMph: Int!
    private var _locationName: String!
    
    
    var day: String {
        if _day == nil {
            _day = "What day is it?"
        }
        return _day
    }
    
    var currentTemp: Int {
        if _currentTemp == nil {
            _currentTemp = 0
        }
        return _currentTemp
    }
    
    var currentTempFar: Int {
        if _currentTempFar == nil {
            _currentTempFar = 0
        }
        
        return _currentTempFar
    }
    
    var currentHumidity: String {
        if _currentHumidity == nil {
            _currentHumidity = "0"
        }
        return _currentHumidity
    }
    
    var currentWind: Int {
        if _currentWind == nil {
            _currentWind = 0
        }
        return _currentWind
    }
    
    var currentWindInMph: Int {
        if _currentWindInMph == nil {
            _currentWindInMph = 0
        }
        
        return _currentWindInMph
    }
    
    var locationName: String {
        if _locationName == nil {
            _locationName = "... uh ..."
        }
        return _locationName
    }
    
    var currentURL: String {
        if _currentURL == nil {
            print("\(latitude) !!!!! \(longitude)")
            
            let lat = latitude
            let long = longitude
            
            _myLatitude = "lat=\(lat)"
            _myLongitude = "&lon=\(long)"
            _appID = "&appid=\(API_KEY)"
            
            _currentURL = "\(URL_BASE_NOW)\(_myLatitude)\(_myLongitude)\(_appID)"
        }
        
        return _currentURL
    }
    
    init (day: String) {
        self._day = day
    }
    
    func downloadCurrentWDetails(completed: DownloadComplete) {
        
        print("UUURRRLLLL \(currentURL)")
        
        let url = NSURL(string: currentURL)!
        
        print(url)
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    print(name)
                    self._locationName = name
                }
                
                if let main = dict["main"] as AnyObject? {
                    
                    if let temp = main["temp"] as AnyObject? {
                        
                        print("Now: \(Int(self.toFaren(temp)))")
                        self._currentTempFar = Int(self.toFaren(temp))
                        print("Now: \(self._currentTempFar)")
                    }
                    
                    if let humidity = main["humidity"] as AnyObject? {
                        
                        print("Humidity: \(humidity)")
                        self._currentHumidity = String(humidity)
                    }
                }
                
                if let main = dict["wind"] as AnyObject? {
                    
                    if let windSpeed = main["speed"] as AnyObject? {
                        
                        print("Wind: \(Int(self.toMph(windSpeed)))")
                        self._currentWindInMph = Int(self.toMph(windSpeed))
                        print("Wind: \(self._currentWindInMph)")
                    }
                }
            
            } else {
                print("Didn't Parse")
            }
            completed()
        }
    }
    
    func toFaren(temp: AnyObject) -> Double {
        let farTemp = (Double(temp as! Double) * (9 / 5)) - 459.67
        
        return farTemp
    }
    
    func toMph(metPerSec: AnyObject) -> Double {
        let windMph = (Double(metPerSec as! Double)) * 2.23694
        
        return windMph
    }
}


