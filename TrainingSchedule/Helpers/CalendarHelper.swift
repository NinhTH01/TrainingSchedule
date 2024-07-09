//
//  CalendarHelper.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 9/7/24.
//

import Foundation

class CalendarHelper {
    let calendar = Calendar.current
}

extension CalendarHelper {
    // MARK: - Get specific date
    func getFirstDayOfMonth() -> Date? {
        let components = calendar.dateComponents([.year, .month], from: Date())

        var firstDayComponents = DateComponents()
        firstDayComponents.year = components.year
        firstDayComponents.month = components.month
        firstDayComponents.day = 1

        return calendar.date(from: firstDayComponents)
    }

    // MARK: - Convert date to string
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }

    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }

    func getMonthToString(date: Date) -> String {
        return "\(monthString(date: date)) \(yearString(date: date))"
    }
}
