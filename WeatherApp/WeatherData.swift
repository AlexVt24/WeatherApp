//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Александр on 17/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

struct WeatherData {
    var dateInUnix:[Int] = [0, 0, 0, 0, 0]
    var weatherStatus:[String] = ["", "", "", "", ""]
    var temp:[Float] = [0.0, 0.0, 0.0, 0.0, 0.0]
    
    init(date: [Int], weather: [String], temperature: [Float]) {
        self.dateInUnix = date
        self.weatherStatus = weather
        self.temp = temperature
    }
    
}
