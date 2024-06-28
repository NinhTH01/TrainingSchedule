//
//  WeatherForecastStatus.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 28/6/24.
//

import Foundation

// MARK: - WeatherForecastStatus
struct WeatherForecastStatus: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - List
struct List: Codable {
    let dateTime: Int
    let main: MainClass
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dateTime = "dt"
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}
