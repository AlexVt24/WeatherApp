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
    var urlString:String = "http://api.openweathermap.org/data/2.5/forecast?q=Belgorod,RU&APPID=6aa532e84cdcf2cf38767d772b390c28"
    
    //MARK - Фукнция для получения данных от API OpenWeatherMap
    func getWeatherForecast(closure:@escaping (String, [Int], [String], [Float], [String]) -> Void) -> Void {
        AF.request(self.urlString).responseJSON { (response) -> Void in
            switch response.result {
            case let .success(value):
                let jsonVar = JSON(value)
                var cityName:String = jsonVar["city"]["name"].stringValue
                var date:[Int] = []
                var status:[String] = [] //Иконки
                var temp:[Float] = []
                var descriptions:[String] = []
                for day in jsonVar["list"].arrayValue {
                    date.append(day["dt"].intValue)
                    status.append(day["weather"].arrayValue[0]["icon"].stringValue)
                    temp.append(day["main"]["temp"].floatValue)
                    descriptions.append(day["weather"].arrayValue[0]["description"].stringValue)
                }
                closure(cityName, date, status, temp, descriptions)
            case let .failure(error):
                print(error)
            }
        }
        
    }
    

}
