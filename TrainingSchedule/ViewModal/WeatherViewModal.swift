//
//  WeatherViewModal.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 27/6/24.
//

import CoreLocation

class WeatherViewModal: NSObject {
        // MARK: - Const
    private let weatherService = WeatherService()

    private let locationManager = CLLocationManager()
        // MARK: - Functions
    private func getWeatherStatus(lat: Double, long: Double) {
        weatherService.fetchWeatherAPI(lat: lat, long: long, completion: {data in
            print(data)
        })
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

}
        // MARK: - Extension
extension WeatherViewModal: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error: \(error)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.requestLocation()

        let coordinate = manager.location?.coordinate

        if coordinate?.latitude != nil && coordinate?.longitude != nil {
            getWeatherStatus(lat: coordinate!.latitude, long: coordinate!.longitude)
        }
    }
}
