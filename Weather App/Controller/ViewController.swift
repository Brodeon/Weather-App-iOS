//
//  ViewController.swift
//  Weather App
//
//  Created by Przemek on 2/14/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, WeatherServiceDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperaturesCV: UICollectionView!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    var weatherItems = [Weather]() {
        didSet {
            temperaturesCV.reloadData()
        }
    }
    
    var weatherItem: Weather? {
        didSet {
            if let weather = weatherItem {
                cityLabel.text = weather.city
                temperatureLabel.text = "\(weather.temperatureCelcius)°"
                weatherConditionImage.image = UIImage(named: weatherIcon(condition: weather.weatherCondition!))
            }
        }
    }
    
    
    var locationManager = CLLocationManager()
    var weatherService = WeatherService()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperaturesCV.delegate = self
        temperaturesCV.dataSource = self
        locationManager.delegate = self
        weatherService.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
        
        temperaturesCV.layer.backgroundColor = UIColor.white.withAlphaComponent(CGFloat(0.0)).cgColor
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            weatherService.getPresentWeatherData(latitude: lat, longitude: lon)
            weatherService.getFutureWeatherData(latitude: lat, longitude: lon)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCollectionCell", for: indexPath) as! WeatherCell
        cell.weather = weatherItems[indexPath.item]
        
        cell.layer.borderColor = UIColor(red: CGFloat(0.16), green: CGFloat(0.16), blue: CGFloat(0.19), alpha: CGFloat(1.0)).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = cell.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cell.backgroundView = blurView
        
        return cell
    }
    
    func weatherResponse(weatherData: Weather?, error: WeatherError?) {
        if let weather = weatherData {
            self.weatherItem = weather
        }
    }
    
    func weatherResponse(weatherArray: [Weather]?, error: WeatherError?) {
        if let weatherDatas = weatherArray {
            self.weatherItems = weatherDatas.filter({ (weather) -> Bool in
                let hour = calendar.component(.hour, from: weather.date!)
                return -1...1 ~= (hour - 12)
            })
            
        }
    }
    
    private func weatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
    

}



