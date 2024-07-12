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

    let locationManager = CLLocationManager()

    private var cancellables = Set<AnyCancellable>()

    @Published var weatherStatus: WeatherStatus?

    @Published var weatherForecastStatus: WeatherForecastStatus?

    @Published var errorMessage: String?

    // MARK: - Functions
    private func getWeatherStatus(lat: Double, long: Double) {
        let weatherRepository = WeatherRepository(networkService: NetworkWeatherService())
        Task { @MainActor in
            do {
                self.weatherStatus = try await weatherRepository.fetchWeather(lat: lat, long: long)
                self.weatherForecastStatus = try await weatherRepository.fetchForecaseWeather(lat: lat, long: long)
            } catch let error as StringError {
                errorMessage = error.message
            }
        }
    }
    // Check for ARC

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        if locationManager.authorizationStatus == .authorizedAlways
            || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
            getWeatherStatus(lat: locationManager.location!.coordinate.latitude,
                             long: locationManager.location!.coordinate.longitude)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

}
// MARK: - Extension
extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
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
