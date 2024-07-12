//
//  Router.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 12/7/24.
//

import Foundation

struct APIConfig {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let apiKey = "&appid=2331c2360840269c7bd115ab58a88269"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case invalidResponse
    case dataConversionFailure
}

enum WeatherRouter: URLRequestConvertible {
    case fetchWeather(lat: Double, long: Double)
    case fetchForecastWeather(lat: Double, long: Double)

    var endpoint: String {
        switch self {
        case .fetchWeather(let lat, let long):
            return "/weather?lat=\(lat)&lon=\(long)"
        case .fetchForecastWeather(let lat, let long):
            return "/forecast?lat=\(lat)&lon=\(long)"
        }
    }

    var method: String {
        switch self {
        case .fetchWeather:
            return "GET"
        case .fetchForecastWeather:
            return "GET"
        }
    }

    func makeURLRequest() throws -> URLRequest {
        guard let url = URL(string: APIConfig.baseURL + endpoint + APIConfig.apiKey) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        return request
    }

}
