//
//  File.swift
//  Weather App
//
//  Created by Przemek on 2/14/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import Foundation

struct Weather {
    
    var temperatureCelcius: Int
    var temperatureFahrenheit: Int
    var city: String
    var date: Date?
    
    init(city: String, temperature: Int) {
        self.city = city
        self.temperatureCelcius = temperature - 273
        self.temperatureFahrenheit = Weather.fahrenheitFromCelcius(inCelcius: temperature)
    }
    
    init(city: String, temperature: Int, date: Date?) {
        self.init(city: city, temperature: temperature)
        self.date = date
    }
    
    private static func fahrenheitFromCelcius(inCelcius: Int) -> Int {
        let fahrenheit = inCelcius * (9/5) + 32
        return fahrenheit
    }
}
