//
//  ViewController.swift
//  WeatherApp
//
//  Created by Александр on 16/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var hourIcon1: UIImageView!
    @IBOutlet weak var hourIcon2: UIImageView!
    @IBOutlet weak var hourIcon3: UIImageView!
    @IBOutlet weak var hourIcon4: UIImageView!
    @IBOutlet weak var hourIcon5: UIImageView!
    @IBOutlet weak var hourIcon6: UIImageView!
    @IBOutlet weak var hourIcon7: UIImageView!
    @IBOutlet weak var hourIcon8: UIImageView!
    @IBOutlet weak var hour1: UILabel!
    @IBOutlet weak var hour2: UILabel!
    @IBOutlet weak var hour3: UILabel!
    @IBOutlet weak var hour4: UILabel!
    @IBOutlet weak var hour5: UILabel!
    @IBOutlet weak var hour6: UILabel!
    @IBOutlet weak var hour7: UILabel!
    @IBOutlet weak var hour8: UILabel!
    
    @IBOutlet weak var wetherTable: UITableView!
// Массив иконок на серой View
    lazy var iconsOfHours:[UIImageView] = [hourIcon1, hourIcon2, hourIcon3, hourIcon4, hourIcon5, hourIcon6, hourIcon7, hourIcon8]
// Массив Label на серой View
    lazy var hours:[UILabel] = [hour1, hour2, hour3, hour4, hour5, hour6, hour7, hour8]
// Объект в котором я хотел хранить данные
    var weather: WeatherFormat = WeatherFormat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Замыкание через него я выставляю данные на элементы ViewController
        let showingData:(String, [Int], [String], [Float], [String])->Void = {cityName, unixDate, status, temp, desc in
            self.cityName.text = cityName
            self.temperature.text = String(round(10 * (temp[0] - 273.15))/10) + "˚"
            self.weatherDescription.text = desc[0]
            var i = 0
            for hour in self.hours {
                hour.text = String(Calendar.current.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(unixDate[i]))))
                i += 1
            }
            i = 0
            for icon in self.iconsOfHours {
                // Загрузка иконок погоды
                AF.request("http://openweathermap.org/img/w/\(status[i]).png", method: .get).responseData() { (response) -> Void in
                    switch response.result {
                    case let .success(imData):
                        icon.image = UIImage(data: imData)
                        print(UIImage(data: imData))
                    case let .failure(error):
                        print(error)
                    }
                }
                i += 1
            }
            // Сохранение данных в объект (не сохраняется)
            self.weather.name = cityName
            self.weather.temps = temp
            self.weather.dates = unixDate
            self.weather.icons = status
            self.weather.descs = desc
        }
        
        var weather:GetBelgorodWeather = GetBelgorodWeather()
        weather.getWeatherForecast(closure: showingData)
        
        print(self.weather.temps)
    }
    
    

    
}

