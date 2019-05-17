//
//  GetJSONFile.swift
//  WeatherApp
//
//  Created by Александр on 17/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetBelgorodWeather {
    var urlString:String = "http://api.openweathermap.org/data/2.5/forecast?q=Belgorod,ru&APPID=6aa532e84cdcf2cf38767d772b390c28"
    
    var weather:WeatherData?
    
    func getWeather() -> Void {
        AF.request(self.urlString).responseJSON { (response) -> Void in
            switch response.result {
            case let .success(value):
                let jsonVar = JSON(value)
                var dateInUnix:[Int] = []
                var weatherStatus:[String] = []
                var temp:[Float] = []
                for day in jsonVar["list"].arrayValue {
                    dateInUnix.append(day["dt"].intValue)
                    weatherStatus.append(day["weather"]["main"].stringValue)
                    temp.append(day["main"]["temp"].floatValue)
                }
                self.weather = WeatherData(date: dateInUnix, weather: weatherStatus, temperature: temp)
            case let .failure(error):
                print(error)
            }
        }
        if weather == nil {
            weather = WeatherData(date: [], weather: [], temperature: [])
        }
    }

}
