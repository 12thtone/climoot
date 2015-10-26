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
    
    private var _currentTemp: String!
    private var _currentLow: String!
    private var _currentHigh: String!
    
    var location: Location!
    
    init () {
        _myLatitude = "lat=\(location.latitude)"
        _myLongitude = "&lon=\(location.longitude)"
        _appID = "&appid=\(API_KEY)"
        _currentURL = "\(URL_BASE_NOW)\(_myLatitude)\(_myLongitude)"
    }
    
    var currentURL: String {
        if _currentURL == nil {
            _currentURL = "http://12thtone.com"
        }
        return _currentURL
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = ""
        }
        return _currentTemp
    }
    
    var currentLow: String {
        if _currentLow == nil {
            _currentLow = ""
        }
        return _currentLow
    }
    
    var currentHigh: String {
        if _currentHigh == nil {
            _currentHigh = ""
        }
        return _currentHigh
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _currentURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                // In as Int, convert to string
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                // In as Int, convert to string
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                // The JSON dict's "types" is an array of dictionaries
                // Key = String and Value = String
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        // URL returned - need a new request
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let desResult = response.result
                            
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                // as? String due to AnyObject
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    
                                }
                                
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    // to is name of next evolution
                    if let to = evolutions[0]["to"] as? String {
                        
                        // Exclude anything with the word "mega"
                        // API supports mega, but we don't have images, etc.
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                // Returns URL with character number.
                                // Remove everything but the number.
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                
                                let num = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(level)"
                                }
                                
                            }
                            
                        }
                    }
                    
                }
                
            }
        }
    }
}


