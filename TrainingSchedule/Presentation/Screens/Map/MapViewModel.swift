//
//  MapViewModel.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 3/7/24.
//
import CoreLocation
import GoogleMaps

class MapViewModel: NSObject {
    // MARK: - Consts and variables
    let locationManager = CLLocationManager()

    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

    @Published var errorMessage: String?

    @Published var location: CLLocation?

    @Published var locationAuthorization: CLAuthorizationStatus?

    // MARK: - Functions
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if locationManager.authorizationStatus == .authorizedAlways
            || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationAuthorization = locationManager.authorizationStatus
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func calculateDistance(path: GMSPath) -> String {
        guard path.count() > 1 else {return "0.0"}
        var polylineDistance = 0.0
        for index in 0..<path.count() - 1 {
            let coordinate1 = path.coordinate(at: index)
            let coordinate2 = path.coordinate(at: index + 1)
            let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
            let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
            polylineDistance += location1.distance(from: location2)
        }
        addDistanceToDatabase(distance: polylineDistance)
        return String(format: "%.2f", polylineDistance)
    }

    private func addDistanceToDatabase(distance: Double) {
        let runningHistory = RunningHistory(context: context)
        runningHistory.distance = distance
        runningHistory.desc = "You have run \(getTwoDigitsSeperator(number: distance)) meters."
        runningHistory.date = Date()
        runningHistory.id = UUID().uuidString
        DispatchQueue.global().async {
            do {
                try self.context.save()
            } catch let error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func getTwoDigitsSeperator(number: Double?) -> String {
        guard number != nil else {
            return "_"
        }

        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .decimal

        numberFormatter.maximumFractionDigits = 2

        if let formattedValue = numberFormatter.string(from: NSNumber(value: number!)) {
            return formattedValue
        } else {
            return String(number!)
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    // MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard manager.location != nil else {return}
        location = manager.location
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.errorMessage = error.localizedDescription
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        locationAuthorization = manager.authorizationStatus
    }
}
