//
//  CalendarDetailViewModel.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 10/7/24.
//

import Foundation
import UIKit

class CalendarDetailViewModel {
    private let calendar = Calendar.current

    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

    @Published var errorMessage: String?
}

extension CalendarDetailViewModel {
    func getEventOfDate(date: Date?) -> [RunningHistory]? {
        let startOfDay = Calendar.current.startOfDay(for: date!)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)

        let predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@",
                                    startOfDay as NSDate, endOfDay! as NSDate)
        let fetchRequest = RunningHistory.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            return results
        } catch {
            errorMessage = "Failed when get events from app's database."
            return nil
        }
    }

    func getFullDayToString(date: Date?) -> String {
        guard date != nil else {
            return "_"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM, yyyy"
        return dateFormatter.string(from: date!)
    }

    func getHourToString(date: Date?) -> String {
        guard date != nil else {
            return "_"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date!)
    }
}
