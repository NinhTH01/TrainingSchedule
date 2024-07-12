//
//  Repository.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 12/7/24.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeather(lat: Double, long: Double) async throws -> WeatherStatus
    func fetchForecaseWeather(lat: Double, long: Double) async throws -> WeatherForecastStatus
}

class WeatherRepository: WeatherRepositoryProtocol {
    let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchWeather(lat: Double, long: Double) async throws -> WeatherStatus {
        return try await networkService.fetchWeather(lat: lat, long: long)
    }

    func fetchForecaseWeather(lat: Double, long: Double) async throws -> WeatherForecastStatus {
        return try await networkService.fetchForecaseWeather(lat: lat, long: long)
    }
}
