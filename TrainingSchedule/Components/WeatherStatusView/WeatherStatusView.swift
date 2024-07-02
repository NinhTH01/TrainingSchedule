//
//  WeatherStatusView.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 2/7/24.
//

import UIKit

class WeatherStatusView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var valueLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }

    private func commonSetup() {
        Bundle.main.loadNibNamed("WeatherStatusView", owner: self)
        self.addSubview(contentView)
        self.layer.cornerRadius = 12
    }

    func setup(title: String, value: String, weatherMain: WeatherMain?) {
        titleLabel.text = title
        valueLabel.text = value
        changeBackgroundColorByWeather(weather: weatherMain)
    }

}
