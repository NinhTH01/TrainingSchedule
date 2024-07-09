//
//  WeatherWindView.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 1/7/24.
//

import UIKit

class WeatherWindView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var gustLabel: UILabel!

    @IBOutlet weak var windDirectionLabel: UILabel!

    @IBOutlet weak var windSpeedLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }

    private func commonSetup() {
        Bundle.main.loadNibNamed("WeatherWindView", owner: self)
        self.addSubview(contentView)
        self.layer.cornerRadius = 12
    }

    func setup(gust: String, windDirection: String, windSpeed: String, weatherMain: WeatherMain?) {
        gustLabel.text = gust
        windDirectionLabel.text = windDirection
        windSpeedLabel.text = windSpeed
        changeBackgroundColorByWeather(weather: weatherMain)
    }
}
