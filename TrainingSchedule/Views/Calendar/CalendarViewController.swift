//
//  CalendarViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 9/7/24.
//

import UIKit

class CalendarViewController: UIViewController {
    // MARK: - Variables and const
    private var refDate: Date? = CalendarHelper().getFirstDayOfMonth()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendar()
    }
}

extension CalendarViewController {
    func setupCalendar() {
//        title = CalendarHelper().getMonthToString(date: refDate)
    }
}
