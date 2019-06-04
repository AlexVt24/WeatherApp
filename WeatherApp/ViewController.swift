//
//  ViewController.swift
//  WeatherApp
//
//  Created by Александр on 16/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    
    @IBOutlet weak var weatherTable: UITableView!
    
    @IBOutlet weak var mainView: UIView!
    
    var getWeather:GetBelgorodWeather = GetBelgorodWeather()
    
// Массив иконок на серой View
    lazy var iconsOfHours:[UIImageView] = [hourIcon1, hourIcon2, hourIcon3, hourIcon4, hourIcon5, hourIcon6, hourIcon7, hourIcon8]
// Массив Label на серой View
    lazy var hours:[UILabel] = [hour1, hour2, hour3, hour4, hour5, hour6, hour7, hour8]
// Объект в котором я хотел хранить данные
    var weather: WeatherFormat = WeatherFormat()
    
    var rowCount:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTable.delegate = self
        weatherTable.dataSource = self
        downloadDataAboutWeather()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weather.temps.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomCell = self.weatherTable.dequeueReusableCell(withIdentifier: "Day", for: indexPath) as! CustomCell
        if weather.dates.count > 0 {
            let dayInUnixTime:Int = 86400
            let date = Date(timeIntervalSince1970: TimeInterval(weather.dates[0] + dayInUnixTime * indexPath.row))
            let format = DateFormatter()
            format.dateFormat = "dd-MM-yyyy"
            let formattedDate = String(format.string(from: date))
            let day = String(format.weekdaySymbols[Calendar.current.component(.weekday, from: date)-1])
            cell.dayLabel.text = day
            cell.dateLabel.text = formattedDate
            cell.tempLabel.text = String(round(10 * (self.weather.averageTemp[indexPath.row] - 273.15))/10) + "˚"
            AF.request("http://openweathermap.org/img/w/\(self.weather.averageIcon[indexPath.row]).png", method: .get).responseData() { (response) -> Void in
                switch response.result {
                case let .success(imData):
                    cell.iconImage.image = UIImage(data: imData)
                case let .failure(error):
                    print(error)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            toChangeTheDataOnMainWeatherView(name:self.weather.name, temp:self.weather.tempNow, desc:self.weather.descNow, icon:self.weather.iconNow)
            toChangeTheDataOnForecastView(dates:self.weather.dates, icons:self.weather.icons)
        case 0..<weather.temps.count - 1:
            var index = 0
            for _ in self.weather.dates {
                if Calendar.current.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(self.weather.dates[index]))) == 0 {
                    break
                }
                index += 1
            }
            toChangeTheDataOnMainWeatherView(name: weather.name, temp: weather.averageTemp[indexPath.row], desc: weather.averageDesc[indexPath.row] , icon: weather.averageIcon[indexPath.row])
            toChangeTheDataOnForecastView(dates: [Int](weather.dates[index + (indexPath.row - 1) * hours.count..<hours.count + indexPath.row * hours.count]), icons: [String](weather.icons[index + (indexPath.row - 1) * hours.count..<hours.count + indexPath.row * hours.count]))
        case weather.temps.count - 1:
            toChangeTheDataOnMainWeatherView(name: weather.name, temp: weather.averageTemp[weather.temps.count - 1], desc: weather.averageDesc[weather.temps.count - 1] , icon: weather.averageIcon[weather.temps.count - 1])
            toChangeTheDataOnForecastView(dates: [Int](weather.dates.suffix(hours.count)), icons: [String](weather.icons.suffix(hours.count)))
            
        default: break
        }
    }

    func downloadDataAboutWeather() -> Void {
        
        let saveNowData:(String, Float, String, String)->Void = {cityName, tempNow, descNow, iconNow in
            self.weather.name = cityName
            self.weather.tempNow = tempNow
            self.weather.descNow = descNow
            self.weather.iconNow = iconNow
            self.toChangeTheDataOnMainWeatherView(name:self.weather.name, temp:self.weather.tempNow, desc:self.weather.descNow, icon:self.weather.iconNow)
        }
        
        let saveForecastData:([Int], [String], [Float], [String])->Void = {unixDate, status, temp, desc in
            self.weather.dates = unixDate
            self.weather.icons = status
            self.weather.descs = desc
            let dayInUnixTime:Int = 86400
            var i:Int = 0
            var j:Int = 0
            var dayEnd:Int = Int(Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date(timeIntervalSince1970: TimeInterval(unixDate[0])))!.timeIntervalSince1970)
            for t in temp {
                if unixDate[i] < dayEnd {
                    self.weather.temps[j].append(t)
                    i += 1
                } else {
                    self.weather.averageTemp.append(self.weather.temps[j].reduce(0, +) / Float(self.weather.temps[j].count))
                    self.weather.temps.append([])
                    dayEnd += dayInUnixTime
                    j += 1
                    self.weather.temps[j].append(t)
                    i += 1
                    
                }
            }
            self.weather.averageTemp.append(self.weather.temps[j].reduce(0, +) / Float(self.weather.temps[j].count))
            i = 0
            var a = 0
            var b = self.weather.temps[i].count - 1
            for _ in self.weather.temps {
                
                self.weather.averageIcon.append(self.weather.commonElementsInArray(stringArray: Array(status[a...b])))
                self.weather.averageDesc.append(self.weather.commonElementsInArray(stringArray: Array(desc[a...b])))
                a = b + 1
                i += 1
                if i < self.weather.temps.count {
                    b += self.weather.temps[i].count
                }
               
            }
            print(self.weather.icons)
            print(self.weather.averageIcon)
            self.toChangeTheDataOnForecastView(dates:self.weather.dates, icons:self.weather.icons)
            
            self.weatherTable.reloadData()
        }
        
        self.getWeather.getWeatherForecast(closureForNow:saveNowData, closureOfForecast: saveForecastData)
    }
    
    func toChangeTheDataOnMainWeatherView(name:String, temp:Float, desc:String, icon:String) -> Void {
        cityName.text = name
        temperature.text = String(round(10 * (temp - 273.15))/10) + "˚"
        weatherDescription.text = desc
        mainView.backgroundColor = UIColor(patternImage: UIImage(named: "\(icon).jpg")!)
    }
    
    func toChangeTheDataOnForecastView(dates:[Int], icons:[String]) -> Void {
        var i = 0
        for hour in hours {
            hour.text = String(Calendar.current.component(.hour, from: Date(timeIntervalSince1970: TimeInterval(dates[i]))))
            i += 1
        }
        i = 0
        for icon in iconsOfHours {
            // Загрузка иконок погоды
            AF.request("http://openweathermap.org/img/w/\(icons[i]).png", method: .get).responseData() { (response) -> Void in
                switch response.result {
                case let .success(imData):
                    icon.image = UIImage(data: imData)
                case let .failure(error):
                    print(error)
                }
            }
            i += 1
        }
    }
    
    @IBAction func updateWeather(_ sender: Any) {
        downloadDataAboutWeather()
    }
    
}
