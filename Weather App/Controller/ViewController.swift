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
    

}



