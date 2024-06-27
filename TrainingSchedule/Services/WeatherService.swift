//
//  WeatherService.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 27/6/24.
//
import Foundation

final class WeatherService {

    private let apiKey = "2331c2360840269c7bd115ab58a88269"

    public func fetchWeatherAPI(lat: Double, long: Double, completion: @escaping(WeatherStatus) -> Void) {
        DispatchQueue.global().async(execute: {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(self.apiKey)")

            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Error: HTTP Response Code Error")
                    return
                }

                if data == nil {
                    print("Error: No Response")
                    return
                }

                do {
                    let weatherData = try JSONDecoder().decode(WeatherStatus.self, from: data!)
                    completion((weatherData))
                } catch let decoderError {
                    print("Error: \(decoderError)")
                }
            }
            task.resume()
        })
    }
}
