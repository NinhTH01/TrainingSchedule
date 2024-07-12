//
//  Service.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 12/7/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchWeather(lat: Double, long: Double) async throws -> WeatherStatus
    func fetchForecaseWeather(lat: Double, long: Double) async throws -> WeatherForecastStatus
}

class NetworkWeatherService: BaseNetworkService<WeatherRouter>, NetworkServiceProtocol {
    func fetchWeather(lat: Double, long: Double) async throws -> WeatherStatus {
        return try await requestGetErrorMessage(WeatherStatus.self, router: .fetchWeather(lat: lat, long: long))
    }
    func fetchForecaseWeather(lat: Double, long: Double) async throws -> WeatherForecastStatus {
        return try await requestGetErrorMessage(WeatherForecastStatus.self,
                                                router: .fetchForecastWeather(lat: lat, long: long))
    }
}
