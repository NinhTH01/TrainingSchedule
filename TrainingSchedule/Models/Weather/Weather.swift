//
//  Weather.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 28/6/24.
//

import Foundation

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: WeatherMain
    let description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

enum Description: String, Codable {
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
}

enum Icon: String, Codable {
    case the04D = "04d"
    case the04N = "04n"
    case the10D = "10d"
    case the10N = "10n"
}

enum MainEnum: String, Codable {
    case clouds = "Clouds"
    case rain = "Rain"
}

enum WeatherMain: String, Codable {
    case cloud = "Clouds"
    case rain = "Rain"
    case clear = "Clear"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
}
