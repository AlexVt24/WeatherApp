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
    
    var weather:WeatherData = WeatherData(date: [], weather: [], temperature: [])
    
    
    func getWeather() -> Void {
        AF.request(self.urlString).responseJSON { (response) -> Void in
            switch response.result {
            case let .success(value):
                let jsonVar = JSON(value)
                for day in jsonVar["list"].arrayValue {
                    self.weather.dateInUnix.append(day["dt"].intValue)
                    self.weather.weatherStatus.append(day["weather"]["main"].stringValue)
                    self.weather.temp.append(day["main"]["temp"].floatValue)
                }
                print(self.weather.temp)
                break
            case let .failure(error):
                print(error)
            }
        }
        
    }
    

}
