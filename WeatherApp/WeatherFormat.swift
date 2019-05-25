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
    var tempNow:Float = 0.0
    var descNow:String = ""
    var iconNow:String = ""
    var dates: [Int] = []
    var icons: [String] = []
    var temps: [[Float]] = [[]]
    var averageTemp: [Float] = []
    var averageIcon: [String] = []
    var averageDesc: [String] = []
    var descs: [String] = []
    
    func commonElementsInArray(stringArray: [String]) -> String {
        let dict = Dictionary(grouping: stringArray, by: {$0})
        let newDict = dict.mapValues({$0.count})
        return newDict.sorted(by: {$0.value > $1.value}).first?.key ?? ""
    }
}
