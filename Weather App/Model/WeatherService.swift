//
//  WeatherService.swift
//  Weather App
//
//  Created by Przemek on 2/14/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum WeatherError: Error {
    case downloadError
}

protocol WeatherServiceDelegate {
    func weatherResponse(weatherData: Weather?, error: WeatherError?)
    func weatherResponse(weatherArray: [Weather]?, error: WeatherError?)
}

struct WeatherService {
    
    let API_KEY = "***"
    let singleDataURL = "http://api.openweathermap.org/data/2.5/weather"
    let multipleDataURL = "http://api.openweathermap.org/data/2.5/forecast"
    var delegate: WeatherServiceDelegate?
    
    func getPresentWeatherData(latitude: String, longitude: String) {
        let params = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
        Alamofire.request(singleDataURL, method: .get, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                let temperature = Int(result["main"]["temp"].doubleValue)
                let city = result["name"].stringValue
                let weather = Weather(city: city, temperature: temperature)
                
                self.delegate?.weatherResponse(weatherData: weather, error: nil)
            } else {
                self.delegate?.weatherResponse(weatherArray: nil, error: WeatherError.downloadError)
            }
        }
    }
    
    func getFutureWeatherData(latitude: String, longitude: String) {
        let params = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
        Alamofire.request(multipleDataURL, method: .get, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                let jsonArray = result["list"].arrayValue
                
                var resultArray = [Weather]()
                for value in jsonArray {
                    let temperature = Int(value["main"]["temp"].doubleValue)
                    let date = self.stringToDate(stringDate: value["dt_txt"].stringValue)
                    
                    let weather = Weather(city: "", temperature: temperature, date: date)
                    resultArray.append(weather)
                }
                
                self.delegate?.weatherResponse(weatherArray: resultArray, error: nil)
            }
        }
    }
    
    func stringToDate(stringDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: stringDate)
    }
    
    
}
