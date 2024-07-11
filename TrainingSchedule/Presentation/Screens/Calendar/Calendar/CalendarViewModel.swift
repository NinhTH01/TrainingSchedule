//
//  CalendarHelper.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 9/7/24.
//

import Foundation
import CoreData
import UIKit
import Combine

class CalendarViewModel {
    private let calendar = Calendar.current

    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

    var items: [RunningHistory] = []

    @Published var errorMessage: String?
}

extension CalendarViewModel {
    func convertDatesAndHistoryToCalendarList(dates: [Date]) -> [CalendarDate] {
        do {
            items = try context.fetch(RunningHistory.fetchRequest())
        } catch {
            errorMessage = "Failed when get events from app's database."
        }

        var calendarList: [CalendarDate] = []

        for date in dates {
            var isEvent = false
            for item in items where isSameDay(date1: date, date2: item.date) {
                    isEvent = true
                    break
            }
            calendarList.append(CalendarDate(date: date, isEvent: isEvent))
        }

        return calendarList
    }
}

extension CalendarViewModel {
    // MARK: - Calculate for calendar
    func weekDays(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }

    func numsOfDayInMonth(date: Date) -> Int {
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }

    // MARK: - Get specific date
    func getFirstDayOfMonth() -> Date? {
        let components = calendar.dateComponents([.year, .month], from: Date())

        var firstDayComponents = DateComponents()
        firstDayComponents.year = components.year
        firstDayComponents.month = components.month
        firstDayComponents.day = 1

        return calendar.date(from: firstDayComponents)
    }

    func getRefDayOfNextMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }

    func getRefDayOfLastMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }

    // MARK: - Get list of dates
    func getLastDaysOfLastMonth(numsOfDay: Int, date: Date) -> [Date]? {
        guard let lastDayOfLastMonth = calendar.date(byAdding: .day, value: -numsOfDay, to: date) else {
            return nil
        }

        var dates = [Date]()
        var dateIterator = lastDayOfLastMonth

        for _ in 1...numsOfDay {
            dates.append(dateIterator)
            dateIterator = calendar.date(byAdding: .day, value: 1, to: dateIterator)!
        }

        return dates
    }

    func getFirstDaysOfnextMonth(numOfDays: Int, date: Date) -> [Date]? {
        guard let firstDayOfNextMonth = calendar.date(byAdding: .month, value: 1, to: date) else {
            return nil
        }

        var dates = [Date]()
        var dateIterator = firstDayOfNextMonth

        for _ in 1...numOfDays {
            dates.append(dateIterator)
            dateIterator = calendar.date(byAdding: .day, value: 1, to: dateIterator)!
        }

        return dates
    }

    func getDatesInMonth(date: Date) -> [Date]? {
        var dates = [Date]()

        guard let monthRange = calendar.range(of: .day, in: .month, for: date) else {
            return nil
        }

        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: date) {
                dates.append(date)
            }
        }

        return dates
    }

    func getDatesInCurrentMonth(date: Date, numOfDaysInCalendar: Int) -> [Date]? {
        let remainingDaysOfLastMonth = weekDays(date: date)
        let remainnigDaysOfNextMonth = numOfDaysInCalendar - numsOfDayInMonth(date: date) - remainingDaysOfLastMonth

        var dates: [Date] = []

        if remainingDaysOfLastMonth > 0 {
            let lastMonthDates = getLastDaysOfLastMonth(numsOfDay: remainingDaysOfLastMonth, date: date)
            dates.append(contentsOf: lastMonthDates ?? [])
        }

        let currentMonthDates = getDatesInMonth(date: date)
        dates.append(contentsOf: currentMonthDates ?? [])

        if remainnigDaysOfNextMonth > 0 {
            let nextMonthDates = getFirstDaysOfnextMonth(numOfDays: remainnigDaysOfNextMonth, date: date)
            dates.append(contentsOf: nextMonthDates ?? [])
        }

        return dates
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

    func getMonthYearToString(date: Date?) -> String {
        guard date != nil else {
            return "_"
        }
        return "\(monthString(date: date!)) \(yearString(date: date!))"
    }

    func getNextMonthToString(date: Date?) -> String {
        guard date != nil else {
            return "_"
        }
        guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: date!) else {
            return "_"
        }
        return monthString(date: nextMonthDate)
    }

    func getLastMonthToString(date: Date?) -> String {
        guard date != nil else {
            return "_"
        }
        guard let nextMonthDate = calendar.date(byAdding: .month, value: -1, to: date!) else {
            return "_"
        }
        return monthString(date: nextMonthDate)
    }

    func getDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone(identifier: "GMT+7")!
        dateFormatter.dateFormat = "d"

        return dateFormatter.string(from: date)
    }

    // MARK: - Check date
    func isToday(date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }

    func isSameDay(date1: Date, date2: Date) -> Bool {
        return calendar.component(.year, from: date1) == calendar.component(.year, from: date2) &&
        calendar.component(.month, from: date1) == calendar.component(.month, from: date2) &&
        calendar.component(.day, from: date1) == calendar.component(.day, from: date2)
    }

    func isDateInThisMonth(_ date1: Date, inSameMonthAs date2: Date) -> Bool {
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)

        return components1.year == components2.year && components1.month == components2.month
    }

    func isDateNextMonth(date: Date, comparedTo referenceDate: Date) -> Bool {
        let referenceComponents = calendar.dateComponents([.year, .month], from: referenceDate)

        let dateComponents = calendar.dateComponents([.year, .month], from: date)

        if let referenceYear = referenceComponents.year,
           let referenceMonth = referenceComponents.month,
           let dateYear = dateComponents.year,
           let dateMonth = dateComponents.month {

            if dateYear == referenceYear && dateMonth == referenceMonth + 1 {
                return true
            } else if dateYear == referenceYear + 1 && referenceMonth == 12 && dateMonth == 1 {
                return true
            }
        }
        return false
    }
}
