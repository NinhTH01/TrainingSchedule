//
//  Int.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 1/7/24.
//

import Foundation

extension Int {
    func unixTimeToHourString() -> String {
        let date = Date(timeIntervalSince1970: Double(self))

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH"

        let hourString = dateFormatter.string(from: date)

        return hourString
    }

    func unixTimeToHourMinuteString() -> String {
        let date = Date(timeIntervalSince1970: Double(self))

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)
    }

    func seperatorFormat() -> String {
        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .decimal

        numberFormatter.maximumFractionDigits = 2

        if let formattedValue = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedValue
        } else {
            return String(self)
        }
    }
}
