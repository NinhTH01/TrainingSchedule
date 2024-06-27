//
//  WeatherViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 26/6/24.
//

import UIKit

class WeatherViewController: UIViewController {

    let weatherViewModal = WeatherViewModal()

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherViewModal.setupLocationManager()
    }
}
