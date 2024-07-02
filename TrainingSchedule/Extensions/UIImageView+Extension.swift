//
//  UIImageView+Extension.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 1/7/24.
//

import UIKit
import AVFoundation

extension UIImageView {
    func changeBackgroundByWeather(weather: WeatherMain?) {
        switch weather {
        case .cloud:
            self.image = UIImage(named: "CloudBackground")
        case .rain:
            self.image  = UIImage(named: "RainBackground")
        case .clear:
            self.image  = UIImage(named: "DefaultBackground")
        case .drizzle:
            self.image  = UIImage(named: "DrizzleBackground")
        case .thunderstorm:
            self.image = UIImage(named: "ThunderStormBackground")
        default:
            self.image = UIImage(named: "DefaultBackground")
        }
    }
}
