//
//  FutureW.swift
//  Weather
//
//  Created by Matthew Maher on 11/10/15.
//  Copyright © 2015 Matthew Maher. All rights reserved.
//

import Foundation
import Alamofire

class FutureW {
    private var _futureURL: String!
    
    private var _myLatitude: String!
    private var _myLongitude: String!
    private var _appID: String!
    
    private var _day: String!
    
    private var _futureTemp: String!
    private var _futureTempFar: Int!
    
    private var _theLow = [Int]()
    private var _theHigh = [Int]()
    private var _theWeather = [String]()
        
    var day: String {
        if _day == nil {
            _day = "What day is it?"
        }
        return _day
    }
    
    var futureTemp: String {
        if _futureTemp == nil {
            _futureTemp = ""
        }
        return _futureTemp
    }
    
    var weatherTempFar: Int {
        if _futureTemp == nil {
            _futureTempFar = 0
        } else {
            let theTemp = Double(_futureTempFar)
            toFaren(theTemp)
        }
        return _futureTempFar
    }
    
    var theLow: [Int] {
        return _theLow
    }
    
    var theHigh: [Int] {
        return _theHigh
    }
    
    var theWeather: [String] {
        return _theWeather
    }
    
    var futureURL: String {
        if _futureURL == nil {
            print("\(latitude) !!!!! \(longitude)")
            
            let lat = latitude
            let long = longitude
            
            _myLatitude = "lat=\(lat)"
            _myLongitude = "&lon=\(long)"
            _appID = "&appid=\(API_KEY)"
            
            _futureURL = "\(URL_BASE_FORCAST)\(_myLatitude)\(_myLongitude)\(DAY_COUNT)\(_appID)"
        }
        
        return _futureURL
    }
    
    init (day: String) {
        self._day = day
    }
    
    func downloadFutureWDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: futureURL)!
        
        print("Future: \(url)")
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let main = dict["city"] as AnyObject? {
                    
                    if let name = main["name"] as AnyObject? {
                        
                        print("Location: \(name)")
                    }
                }
                
                for var i = 0; i < 5; i++ {
                    if let list = dict["list"] as AnyObject? {
                        
                        if let temp = list[i]["temp"] as AnyObject? {
                            
                            if let min = temp["min"] as AnyObject? {

                                self._theLow.append(Int(self.toFaren(min)))
                            }
                            
                            if let max = temp["max"] as AnyObject? {

                                self._theHigh.append(Int(self.toFaren(max)))
                            }
                            
                        }
                    }
                }
                
                for var n = 0; n < 5; n++ {
                    if let list = dict["list"] as AnyObject? {
                        
                        if let weather = list[n]["weather"] as AnyObject? {
                            
                            if let weatherType = weather[0]["main"] as AnyObject? {

                                self.buildImgArray(String(weatherType))
                            }
                            
                        }
                    }
                    
                }
                print(self.theWeather)
                
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
    
    func buildImgArray(weather: String) {
        
        print(weather)
        
        let weatherType = "\(weather)"
        
        if (weatherType.lowercaseString.rangeOfString("thunder") != nil) {
            self._theWeather.append("thunderstorm-7")
        } else if (weatherType.lowercaseString.rangeOfString("rain") != nil) {
            self._theWeather.append("rain-7")
        } else if (weatherType.lowercaseString.rangeOfString("drizzle") != nil) {
            self._theWeather.append("rain-7")
        } else if (weatherType.lowercaseString.rangeOfString("snow") != nil) {
            self._theWeather.append("snow-flake-7")
        } else if (weatherType.lowercaseString.rangeOfString("sleet") != nil) {
            self._theWeather.append("snow-flake-7")
        } else if (weatherType.lowercaseString.rangeOfString("clear") != nil) {
            self._theWeather.append("sun-7")
        } else if (weatherType.lowercaseString.rangeOfString("sun") != nil) {
            self._theWeather.append("sun-7")
        } else if (weatherType.lowercaseString.rangeOfString("wind") != nil) {
            self._theWeather.append("windy-7")
        } else if (weatherType.lowercaseString.rangeOfString("gale") != nil) {
            self._theWeather.append("windy-7")
        } else {
            self._theWeather.append("cloudy-many-7")
        }
    }
}


