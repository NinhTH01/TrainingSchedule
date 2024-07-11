//
//  CalendarEditViewModel.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 11/7/24.
//

import UIKit
import Combine
import CoreData

class CalendarEditViewModel {
    private let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
}

extension CalendarEditViewModel {
    func saveEventToDatabase(description: String, date: Date) -> Future<Void, Error> {
        let newEvent = RunningHistory(context: context)
        newEvent.date = date
        newEvent.desc = description
        newEvent.id = UUID().uuidString
        return Future { promise in
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func updateEventToDatabase(description: String, date: Date, event: RunningHistory?) -> Future<Void, Error> {
        guard event != nil else {
            return Future { promise in
                promise(.failure(NSError(domain: "EventNotFound", code: 404, userInfo: nil)))
            }
        }
        return Future { promise in
            let fetchRequest: NSFetchRequest<RunningHistory> = RunningHistory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", event!.id)

            do {
                let results = try self.context.fetch(fetchRequest)
                if let recordToUpdate = results.first {

                    recordToUpdate.date = date
                    recordToUpdate.desc = description

                    try self.context.save()
                    promise(.success(()))
                } else {
                    promise(.failure(NSError(domain: "RecordNotFound", code: 404, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }

    func deleteEventToDatebase(event: RunningHistory?) -> Future<Void, Error> {
        guard event != nil else {
            return Future { promise in
                promise(.failure(NSError(domain: "EventNotFound", code: 404, userInfo: nil)))
            }
        }
        return Future { promise in
            let fetchRequest: NSFetchRequest<RunningHistory> = RunningHistory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", event!.id)

            do {
                let results = try self.context.fetch(fetchRequest)
                if let recordToDelete = results.first {
                    self.context.delete(recordToDelete)
                    try self.context.save()
                    promise(.success(()))
                } else {
                    promise(.failure(NSError(domain: "RecordNotFound", code: 404, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }
}
