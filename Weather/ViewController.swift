//
//  ViewController.swift
//  Weather
//
//  Created by Matthew Maher on 10/25/15.
//  Copyright © 2015 Matthew Maher. All rights reserved.
//

import UIKit
import CoreLocation

var latitude = ""
var longitude = ""


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var weatherC = [CurrentW]()
    var weatherF = [FutureW]()
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHumLabel: UILabel!
    @IBOutlet weak var currentWindLabel: UILabel!
    @IBOutlet weak var todayLowLabel: UILabel!
    @IBOutlet weak var todayHighLabel: UILabel!
    @IBOutlet weak var tomLowLabel: UILabel!
    @IBOutlet weak var tomHighLabel: UILabel!
    @IBOutlet weak var twoDaysLowLabel: UILabel!
    @IBOutlet weak var twoDaysHighLabel: UILabel!
    @IBOutlet weak var coinLowLabel: UILabel!
    @IBOutlet weak var coinHighLabel: UILabel!
    @IBOutlet weak var serLowLabel: UILabel!
    @IBOutlet weak var serHighLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var tomImage: UIImageView!
    @IBOutlet weak var twoImage: UIImageView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var serImage: UIImageView!
    
    
    var today = CurrentW(day: "Today")
    var future = FutureW(day: "Future")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization();
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        else {
            print("Location service disabled");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        
        weatherC = [CurrentW]()
        weatherF = [FutureW]()
        
        print("\(latitude) ---- \(longitude)")
        
        today.downloadCurrentWDetails { () -> () in

            self.updateCurrUI()
            
        }
        
        future.downloadFutureWDetails { () -> () in

            self.updateFutUI()
        }
        

        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        latitude = "\(lat)"
        longitude = "\(long)"
        
        print("\(latitude) +++ \(longitude)")
        
        updateUI()
    }

    func updateCurrUI () {
        
        print("VC!!! \(today.currentTempFar); \(today.currentHumidity); \(today.currentWindInMph)")
        
        currentTempLabel.text = "\(today.currentTempFar)"
        currentHumLabel.text = "\(today.currentHumidity)"
        currentWindLabel.text = "\(today.currentWindInMph)"
        locationLabel.text = "Welp, You're in \(today.locationName)."
    }
    
    func updateFutUI () {
        
        todayLowLabel.text = "\(future.theLow[0])"
        todayHighLabel.text = "\(future.theHigh[0])"
        tomLowLabel.text = "\(future.theLow[1])"
        tomHighLabel.text = "\(future.theHigh[1])"
        twoDaysLowLabel.text = "\(future.theLow[2])"
        twoDaysHighLabel.text = "\(future.theHigh[2])"
        coinLowLabel.text = "\(future.theLow[3])"
        coinHighLabel.text = "\(future.theHigh[3])"
        serLowLabel.text = "\(future.theLow[4])"
        serHighLabel.text = "\(future.theHigh[4])"
        
        mainImage.image = UIImage(named:"\(future.theWeather[0])")
        todayImage.image = UIImage(named:"\(future.theWeather[0])")
        tomImage.image = UIImage(named:"\(future.theWeather[1])")
        twoImage.image = UIImage(named:"\(future.theWeather[2])")
        coinImage.image = UIImage(named:"\(future.theWeather[3])")
        serImage.image = UIImage(named:"\(future.theWeather[4])")
        
    }

}

