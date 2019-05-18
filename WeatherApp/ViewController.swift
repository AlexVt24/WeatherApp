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
        let test:GetBelgorodWeather = GetBelgorodWeather()
        test.getWeather()
    }
}

