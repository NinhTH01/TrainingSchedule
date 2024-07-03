//
//  WeatherViewModal.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 27/6/24.
//

import CoreLocation
import Combine

class WeatherViewModel: NSObject {
    // MARK: - Const and variables
    let weatherService = WeatherService()
    // Dependency Injection

    let locationManager = CLLocationManager()

    private var cancellables = Set<AnyCancellable>()

    @Published var weatherStatus: WeatherStatus?

    @Published var weatherForecastStatus: WeatherForecastStatus?

    @Published var errorMessage: String?

    // MARK: - Functions
    private func getWeatherStatus(lat: Double, long: Double) {
        let weatherPublisher = Future<WeatherStatus, Error> { promise in
            self.weatherService.getCurrentWeather(lat: lat, long: long) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()

        let forecastPublisher = Future<WeatherForecastStatus, Error> { promise in
            self.weatherService.getFiveDaysForecast(lat: lat, long: long) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()

        Publishers.Zip(weatherPublisher, forecastPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] weatherStatus, weatherForecastStatus in
                self?.weatherStatus = weatherStatus
                self?.weatherForecastStatus = weatherForecastStatus
            })
            .store(in: &self.cancellables)
    }
    // Check for ARC

    func setupLocationManager() {
        locationManager.delegate = self

        if locationManager.authorizationStatus == .authorizedAlways {
            getWeatherStatus(lat: locationManager.location!.coordinate.latitude,
                             long: locationManager.location!.coordinate.longitude)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

}
// MARK: - Extension
extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error: \(error)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation()

        let coordinate = manager.location?.coordinate

        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            if coordinate?.latitude != nil && coordinate?.longitude != nil {
                getWeatherStatus(lat: coordinate!.latitude, long: coordinate!.longitude)
            }
        }
    }
}
