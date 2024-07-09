//
//  WeatherService.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 27/6/24.
//
import Foundation

final class WeatherService {

    // MARK: Const

    private let apiKey = "2331c2360840269c7bd115ab58a88269"

    private let baseWeatherURL = "https://api.openweathermap.org/data/2.5"

    // MARK: Fetch API function

    func getCurrentWeather(lat: Double, long: Double, completion: @escaping(Result<WeatherStatus, Error>) -> Void) {
        print(lat, long)
        let url = URL(string: "\(baseWeatherURL)/weather?lat=\(lat)&lon=\(long)&appid=\(self.apiKey)")!

        URLSession.shared.fetchData(for: url) { (result: Result<WeatherStatus, Error>) in
            switch result {
            case .success(let weatherStatus):
                completion(.success(weatherStatus))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getFiveDaysForecast(lat: Double, long: Double,
                             completion: @escaping(Result<WeatherForecastStatus, Error>) -> Void) {
        let url = URL(string: "\(baseWeatherURL)/forecast?lat=\(lat)&lon=\(long)&appid=\(self.apiKey)")!

        URLSession.shared.fetchData(for: url) { (result: Result<WeatherForecastStatus, Error>) in
            switch result {
            case .success(let weatherForecaseStatus):
                completion(.success(weatherForecaseStatus))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

}
