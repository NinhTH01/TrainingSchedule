//
//  WeatherStatus.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 27/6/24.
//
import Foundation

struct WeatherStatus: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dateTime: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dateTime = "dt"
        case sys
        case timezone
        case id
        case name
        case cod
    }
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}
