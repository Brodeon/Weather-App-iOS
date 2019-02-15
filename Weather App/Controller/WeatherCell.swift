//
//  WeatherCell.swift
//  Weather App
//
//  Created by Przemek on 2/14/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {

    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let calendar = Calendar.current
    
    var weather: Weather? {
        didSet {
            if let value = weather {
                temperatureLabel.text = "\(value.temperatureCelcius)°"
                dayLabel.text = weekDay(dayOfWeek: calendar.component(.weekday, from: value.date!))
                weatherImage.image = UIImage(named: weatherIcon(condition: value.weatherCondition!))
            }
        }
    }
    
    private func weekDay(dayOfWeek: Int) -> String {
        switch dayOfWeek {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
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
