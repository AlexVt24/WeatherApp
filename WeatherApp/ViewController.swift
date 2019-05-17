//
//  ViewController.swift
//  WeatherApp
//
//  Created by Александр on 16/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var test:GetBelgorodWeather = GetBelgorodWeather()
        test.getWeather()
        var weatherNow:WeatherData = test.weather!
        print(weatherNow.temp)
    }


}

