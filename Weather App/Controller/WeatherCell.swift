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

    
    
}
