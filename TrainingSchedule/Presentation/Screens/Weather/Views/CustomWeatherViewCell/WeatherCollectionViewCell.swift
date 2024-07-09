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

        tempLabel.text = cell?.main?.temp?.kelvinToCelsiusString() ?? "0"

        timeLabel.text = unixTimeToHourString(unixTime: cell?.dateTime)

        weatherIconImageView.image = iconMapper(iconCode: cell?.weather?[0].icon)
    }

    private func unixTimeToHourString(unixTime: Int?) -> String {
        guard unixTime != nil else {
            return ""
        }

        let date = Date(timeIntervalSince1970: Double(unixTime!))

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH"

        let hourString = dateFormatter.string(from: date)

        return hourString
    }

    private func iconMapper(iconCode: String?) -> UIImage {
        var iconImage = UIImage()

        switch iconCode {
        case "01d", "01n":
            iconImage = UIImage(systemName: "sun.max.fill")!
        case "02d", "02n":
            iconImage = UIImage(systemName: "cloud.sun.fill")!
        case "03d", "03n", "04d", "04n":
            iconImage = UIImage(systemName: "cloud.fill")!
        case "09d", "09n":
            iconImage = UIImage(systemName: "cloud.drizzle.fill")!
        case "10d", "10n":
            iconImage = UIImage(systemName: "cloud.rain.fill")!
        case "11d", "11n":
            iconImage = UIImage(systemName: "cloud.bolt.fill")!
        case "13d", "13n":
            iconImage = UIImage(systemName: "cloud.snow.fill")!
        case "50d", "50n":
            iconImage = UIImage(systemName: "cloud.dust.fill")!
        default:
            iconImage = UIImage(systemName: "cloud.fill")!
        }
        return iconImage
    }
}
