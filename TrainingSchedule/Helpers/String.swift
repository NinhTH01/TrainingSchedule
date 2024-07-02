//
//  String.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 28/6/24.
//

import UIKit

extension String {
    func capitalizedFirstLetterOfEachWord() -> String {
        return self.lowercased().split(separator: " ").map { $0.capitalized }.joined(separator: " ")
    }

    func iconMapper() -> UIImage {
        var iconImage = UIImage()

        switch self {
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
