//
//  WeatherViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 26/6/24.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var headerView: WeatherHeaderView!

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var detailInformationView: UIView!

    @IBOutlet weak var windStatusView: WeatherWindView!

    @IBOutlet weak var weatherCollectionView: UICollectionView!

    @IBOutlet weak var humidityView: WeatherStatusView!

    @IBOutlet weak var pressureView: WeatherStatusView!

    @IBOutlet weak var feelsLikeView: WeatherStatusView!

    @IBOutlet weak var sunriseView: WeatherStatusView!

    @IBOutlet weak var sunsetView: WeatherStatusView!

    @IBOutlet weak var forecastStackView: RoundCornerStackView!

    @IBOutlet weak var visibilityView: WeatherStatusView!

    // MARK: - Variables and const

    private var previousContentOffSetY: Double = 0

    private var headerViewExpandHeight: Double = 0

    private var headerViewMinimizeHeight: Double = 80

    private var descriptionFadedOffSetHeight: Double = 0

    private var tempFadedOffSetHeight: Double = 0

    private var headerViewHeightConstraint: NSLayoutConstraint?

    private var defaultInformationTopConstraint: NSLayoutConstraint?

    private var currentWeatherStatus: WeatherStatus?

    private var currentWeatherForecastStatus: WeatherForecastStatus?

    private let weatherViewModel = WeatherViewModel()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBind()

        let nib = UINib(nibName: "WeatherCollectionViewCell", bundle: .main)
        weatherCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self

        scrollView.delegate = self

        weatherViewModel.setupLocationManager()

        // Setup Animation Attributes
        headerViewExpandHeight = view.frame.size.height * 0.30
        descriptionFadedOffSetHeight = view.frame.size.height * 0.10
        tempFadedOffSetHeight = view.frame.size.height * 0.20
        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewExpandHeight)
        defaultInformationTopConstraint =
        detailInformationView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
        NSLayoutConstraint.activate([
            headerViewHeightConstraint!,
            defaultInformationTopConstraint!
        ])
    }

    // MARK: - Binding
    private func setupBind() {
        weatherViewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)

        weatherViewModel.$weatherForecastStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherForecastStatus in
                self?.currentWeatherForecastStatus = weatherForecastStatus
                self?.weatherCollectionView.reloadData()
            }
            .store(in: &cancellables)

        weatherViewModel.$weatherStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherStatus in
                self?.updateData(weatherStatus: weatherStatus)
            }
            .store(in: &cancellables)
    }

}

extension WeatherViewController {
    // MARK: - Functions
    private func unixTimeToHourMinuteString(unixTime: Int?) -> String {
        guard unixTime != nil else {
            return "_"
        }

        let date = Date(timeIntervalSince1970: Double(unixTime!))

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)
    }

    private func getTwoDigitsSeperator(number: Int?) -> String {
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

    private func meterSectoKilometHourString(meterSec: Double?) -> String {
        guard meterSec != nil else {
            return "_"
        }
        let speedInKilometInHour = meterSec! * 3.6
        return String(format: "%.f", speedInKilometInHour)
    }

    private func changeBackgroundByWeather(weather: WeatherMain?) {
        switch weather {
        case .cloud:
            backgroundImageView.image = UIImage(named: "CloudBackground")
        case .rain:
            backgroundImageView.image  = UIImage(named: "RainBackground")
        case .clear:
            backgroundImageView.image  = UIImage(named: "DefaultBackground")
        case .drizzle:
            backgroundImageView.image  = UIImage(named: "DrizzleBackground")
        case .thunderstorm:
            backgroundImageView.image = UIImage(named: "ThunderStormBackground")
        default:
            backgroundImageView.image = UIImage(named: "DefaultBackground")
        }
    }

    private func updateData(weatherStatus: WeatherStatus?) {
        currentWeatherStatus = weatherStatus

        forecastStackView.changeBackgroundColorByWeather(weather: weatherStatus?.weather?[0].main)

        windStatusView.setup(
            gust: meterSectoKilometHourString(meterSec: weatherStatus?.wind?.gust),
            windDirection: String(weatherStatus?.wind?.deg ?? 0),
            windSpeed: meterSectoKilometHourString(meterSec: weatherStatus?.wind?.speed),
            weatherMain: weatherStatus?.weather?[0].main)

        humidityView.setup(title: "HUMIDITY", value: "\(weatherStatus?.main?.humidity ?? 0)%",
                           weatherMain: weatherStatus?.weather?[0].main)

        feelsLikeView.setup(title: "FEELS LIKE",
                            value: weatherStatus?.main?.feelsLike?.kelvinToCelsiusString() ?? "_",
                            weatherMain: weatherStatus?.weather?[0].main)

        sunsetView.setup(title: "SUNSET",
                         value: unixTimeToHourMinuteString(unixTime: weatherStatus?.sys?.sunset),
                         weatherMain: weatherStatus?.weather?[0].main)

        sunriseView.setup(title: "SUNRISE",
                          value: unixTimeToHourMinuteString(unixTime: weatherStatus?.sys?.sunrise),
                          weatherMain: weatherStatus?.weather?[0].main)

        pressureView.setup(title: "PRESSURE", value: "\(getTwoDigitsSeperator(number: weatherStatus?.main?.pressure))\nhPa",
                           weatherMain: weatherStatus?.weather?[0].main)

        visibilityView.setup(title: "VISIBILITY", value: "\((weatherStatus?.visibility ?? 0) / 1000)km",
                             weatherMain: weatherStatus?.weather?[0].main)

        headerView.setup(
            temp: weatherStatus?.main?.temp?.kelvinToCelsiusString(),
            city: weatherStatus?.name,
            description: weatherStatus?.weather?[0].description?.capitalizedFirstLetterOfEachWord(),
            highestTemp: weatherStatus?.main?.tempMax?.kelvinToCelsiusString(),
            lowestTemp: weatherStatus?.main?.tempMin?.kelvinToCelsiusString())

        changeBackgroundByWeather(weather: weatherStatus?.weather?[0].main)
    }
}
// MARK: - CollectionView Delegate
extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return currentWeatherForecastStatus?.list?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = (collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as? WeatherCollectionViewCell)!

        cell.setup(currentWeatherForecastStatus?.list?[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: weatherCollectionView.frame.width / 7, height: weatherCollectionView.frame.height)
    }
}

// MARK: - ScrollView Delegate
extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffSetY = scrollView.contentOffset.y

        if currentOffSetY <= headerViewExpandHeight - headerViewMinimizeHeight {
            headerViewHeightConstraint?.constant = headerViewExpandHeight - currentOffSetY
            defaultInformationTopConstraint?.constant = currentOffSetY
        } else if currentOffSetY < 0 {
            headerViewHeightConstraint?.constant = headerViewExpandHeight
        } else if currentOffSetY > headerViewExpandHeight {
            headerViewHeightConstraint?.constant = headerViewMinimizeHeight
        }

//         Handle low/high + desc label faded logic when offSetY value = 10% of screen height
        if currentOffSetY <= descriptionFadedOffSetHeight {
            let fadedAlpha = (descriptionFadedOffSetHeight - currentOffSetY) / descriptionFadedOffSetHeight
            headerView.lowestLabel.alpha = fadedAlpha
            headerView.highestLabel.alpha = fadedAlpha
            headerView.descriptionLabel.alpha = fadedAlpha
        } else {
            let fadedAlpha = 0.0
            headerView.lowestLabel.alpha = fadedAlpha
            headerView.highestLabel.alpha = fadedAlpha
            headerView.descriptionLabel.alpha = fadedAlpha
        }

        // Handle temp label faded and new label appear when offSetY value = 20% of screen height
        if currentOffSetY > tempFadedOffSetHeight {
            let fadedAlpha = ( currentOffSetY - tempFadedOffSetHeight) / descriptionFadedOffSetHeight
            headerView.tempLabel.text = "\(currentWeatherStatus?.weather?[0].description?.capitalizedFirstLetterOfEachWord() ?? "") | \(currentWeatherStatus?.main?.temp?.kelvinToCelsiusString() ?? "")"
            headerView.tempLabel.font = headerView.tempLabel.font.withSize(25)
            headerView.tempLabel.alpha = fadedAlpha
        } else {
            let fadedAlpha = (tempFadedOffSetHeight - currentOffSetY) / descriptionFadedOffSetHeight
            headerView.tempLabel.text = currentWeatherStatus?.main?.temp?.kelvinToCelsiusString()
            headerView.tempLabel.alpha = fadedAlpha
            headerView.tempLabel.font = headerView.tempLabel.font.withSize(77)
        }
    }
}
