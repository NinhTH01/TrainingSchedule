//
//  RunningHistory+CoreDataProperties.swift
//  
//
//  Created by Trần Hải Ninh on 4/7/24.
//
//

import Foundation
import CoreData

extension RunningHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunningHistory> {
        return NSFetchRequest<RunningHistory>(entityName: "RunningHistory")
    }

    @NSManaged public var distance: Double
    @NSManaged public var createdAt: Date?

}
