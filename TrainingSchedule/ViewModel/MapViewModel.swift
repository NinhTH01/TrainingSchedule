//
//  MapViewModel.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 3/7/24.
//
import CoreLocation
import GoogleMaps
// MARK: - Protocol
protocol MapViewModelDelegate: AnyObject {
    func didUpdateLocations(location: CLLocation, locations: [CLLocation])
    func setupMap(location: CLLocation)
}

class MapViewModel: NSObject {
    // MARK: - Consts and variables
    let locationManager = CLLocationManager()

    let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

    weak var delegate: MapViewModelDelegate?

    @Published var errorMessage: String?

    // MARK: - Functions
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if locationManager.authorizationStatus == .authorizedAlways
            || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            delegate?.setupMap(location: locationManager.location!)
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

    func addDistanceToDatabase(distance: Double) {
        let runningHistory = RunningHistory(context: context)
        runningHistory.distance = distance
        runningHistory.createdAt = Date()
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
}

extension MapViewModel: CLLocationManagerDelegate {
    // MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard manager.location != nil else {return}

        delegate?.didUpdateLocations(location: manager.location!, locations: locations)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        delegate?.setupMap(location: locationManager.location!)
    }
}
