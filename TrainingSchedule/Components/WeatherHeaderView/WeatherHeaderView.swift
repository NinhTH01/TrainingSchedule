//
//  WeatherHeaderView.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 2/7/24.
//

import UIKit

class WeatherHeaderView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var tempLabel: UILabel!

    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var highestLabel: UILabel!

    @IBOutlet weak var lowestLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }

    private func commonSetup() {
        Bundle.main.loadNibNamed("WeatherHeaderView", owner: self)
        self.addSubview(contentView)
        self.layer.cornerRadius = 12
    }

    func setup(temp: String?, city: String?, description: String?, highestTemp: String?, lowestTemp: String?) {
        tempLabel.text = temp
        cityLabel.text = city
        descriptionLabel.text = description
        highestLabel.text = "H: \(highestTemp ?? "_")"
        lowestLabel.text = "L: \(lowestTemp ?? "_")"
    }

}
