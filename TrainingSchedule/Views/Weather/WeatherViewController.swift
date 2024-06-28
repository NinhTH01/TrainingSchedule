//
//  WeatherViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 26/6/24.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var tempLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var lowestTempLabel: UILabel!

    @IBOutlet weak var highestTempLabel: UILabel!

    let weatherViewModel = WeatherViewModel()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.setupLocationManager()
        setupBind()
    }

}

extension WeatherViewController {
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func setupBind() {
        weatherViewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)

//        weatherViewModel.$weatherForecastStatus
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] weatherForecastStatus in
//                dump(weatherForecastStatus)
//            }
//            .store(in: &cancellables)

        weatherViewModel.$weatherStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherStatus in
                dump(weatherStatus)
                self?.cityLabel.text = weatherStatus?.name
                self?.tempLabel.text = weatherStatus?.main.temp.kelvinToCelsiusString()
                self?.descriptionLabel.text = weatherStatus?.weather[0].description.capitalizedFirstLetterOfEachWord()
                self?.highestTempLabel.text = "H: \(weatherStatus?.main.tempMax.kelvinToCelsiusString() ?? "_")"
                self?.lowestTempLabel.text = "L: \(weatherStatus?.main.tempMin.kelvinToCelsiusString() ?? "_")"

                switch weatherStatus?.weather[0].main {
                case .cloud:
                    self?.backgroundImageView.image = UIImage(named: "CloudBackground")
                case .rain:
                    self?.backgroundImageView.image = UIImage(named: "RainBackground")
                case .clear:
                    self?.backgroundImageView.image = UIImage(named: "ClearBackground")
                case .drizzle:
                    self?.backgroundImageView.image = UIImage(named: "DrizzleBackground")
                case .thunderstorm:
                    self?.backgroundImageView.image = UIImage(named: "ThunderStormBackground")
                case .none:
                    self?.backgroundImageView.image = UIImage(named: "DefaultBackground")
                }
            }
            .store(in: &cancellables)
    }

}
