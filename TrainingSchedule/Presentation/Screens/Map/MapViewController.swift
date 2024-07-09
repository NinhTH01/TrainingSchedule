//
//  MapViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 3/7/24.
//

import UIKit
import CoreLocation
import GoogleMaps
import Combine

class MapViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var mapView: UIView!

    @IBOutlet weak var startButton: RoundButton!
    // MARK: - Variables and consts
    private let viewModel = MapViewModel()

    private let mapPopupView = MapPopupViewController()

    private var googleMapView = GMSMapView()

    private var mapMarker = GMSMarker()

    private var mapPolyline: GMSPolyline!

    private var mapPath: GMSMutablePath!

    private var isRunning: Bool = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self

        mapPopupView.delegate = self

        setupBind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.setupLocationManager()
    }

    // MARK: - Bindings
    private func setupBind() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }

    // MARK: - IBAction
    @IBAction private func startRunning(_ sender: UIButton) {
        if isRunning {
            startButton.setTitle("Start", for: .normal)
            capturePolyline()
        } else {
            let cameraUpdate = GMSCameraUpdate.zoom(to: 18.0)
            googleMapView.animate(with: cameraUpdate)

            if let polyline = mapPolyline {
                polyline.map = nil
                mapPolyline = nil
            }

            mapPath = GMSMutablePath()

            startButton.setTitle("Stop", for: .normal)
        }
        isRunning.toggle()
    }
}

extension MapViewController: MapViewModelDelegate, MapPopViewControllerDelegate {
    // MARK: - Functions
    private func drawPolyline(location: CLLocation, locations: [CLLocation]) {
        guard let location = locations.last else { return }

        mapPath.add(location.coordinate)

        if mapPolyline == nil {
            mapPolyline = GMSPolyline(path: mapPath)
            mapPolyline.strokeColor = .blue
            mapPolyline.strokeWidth = 5.0
            mapPolyline?.map = googleMapView
        } else {
            mapPolyline?.path = mapPath
        }
    }

    private func capturePolyline() {
        let cameraBounds = GMSCoordinateBounds(path: mapPath)
        let cameraUpdate = GMSCameraUpdate.fit(cameraBounds, withPadding: 50.0)
        googleMapView.moveCamera(cameraUpdate)
        // Get delay to avoid capture before the camera update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            UIGraphicsBeginImageContextWithOptions(self.googleMapView.bounds.size, false, 0.0)
            self.googleMapView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let polylineImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.mapPopupView.popUpContent = PopUpContent(
                distance: self.viewModel.calculateDistance(path: self.mapPath),
                image: polylineImage)
            self.present(self.mapPopupView, animated: false) {
                self.mapPopupView.show()
            }
        }
    }

    // MARK: - Delegate Function
    func isHide() {
        if let polyline = mapPolyline {
            polyline.map = nil
            mapPolyline = nil
        }
        mapPath = nil
    }

    func setupMap(location: CLLocation) {
        let mapOptions = GMSMapViewOptions()
        mapOptions.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 18.0)

        mapOptions.frame = self.mapView.bounds

        googleMapView = GMSMapView(options: mapOptions)
        mapView.addSubview(googleMapView)

        mapMarker.position = location.coordinate
        mapMarker.map = googleMapView
    }

    func didUpdateLocations(location: CLLocation, locations: [CLLocation]) {
        CATransaction.begin()
        mapMarker.position = location.coordinate
        CATransaction.commit()

        let updatedCamera = GMSCameraUpdate.setTarget(location.coordinate)
        googleMapView.animate(with: updatedCamera)

        if isRunning {
            drawPolyline(location: location, locations: locations)
        }
    }
}
