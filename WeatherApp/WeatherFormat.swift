//
//  WeatherFormat.swift
//  WeatherApp
//
//  Created by Александр on 21/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

// Класс который я хотел исользовать для храннения данных которые рипшли от API OpenWetherMap

class WeatherFormat {
    var name: String = ""
    var dates: [Int] = []
    var icons: [String] = []
    var temps: [Float] = []
    var descs: [String] = []
    
}
