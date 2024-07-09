//
//  UIView+Extension.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 2/7/24.
//

import UIKit

extension UIView {
    func changeBackgroundColorByWeather(weather: WeatherMain?) {
        switch weather {
        case .cloud:
            self.backgroundColor = UIColor(named: "CloudColor")
        case .rain:
            self.backgroundColor = UIColor(named: "RainColor")
        case .clear:
            self.backgroundColor = UIColor(named: "ClearSkyColor")
        case .drizzle:
            self.backgroundColor = UIColor(named: "DrizzleColor")
        case .thunderstorm:
            self.backgroundColor = UIColor(named: "ThunderColor")
        default:
            self.backgroundColor = UIColor(named: "ClearSkyColor")
        }
    }
}
