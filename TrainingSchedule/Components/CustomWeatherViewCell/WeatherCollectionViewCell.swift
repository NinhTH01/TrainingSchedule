//
//  WeatherCollectionViewCell.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 1/7/24.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var weatherIconImageView: UIImageView!

    @IBOutlet weak var tempLabel: UILabel!

    func setup(_ cell: List?) {

        tempLabel.text = cell?.main.temp.kelvinToCelsiusString() ?? "0"

        timeLabel.text = cell?.dateTime.unixTimeToHourString()

        weatherIconImageView.image = cell?.weather[0].icon.iconMapper()
    }
}
