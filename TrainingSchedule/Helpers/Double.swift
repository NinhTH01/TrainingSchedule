//
//  Double.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 28/6/24.
//

extension Double {
    func kelvinToCelsiusString() -> String {
        let celsius = self - 273.15
        return String(format: "%.f°", celsius)
    }

    func meterSectoKilometHourString() -> String {
        let speedInKilometInHour = self * 3.6
        return String(format: "%.f", speedInKilometInHour)
    }
}
