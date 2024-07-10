//
//  CalendarViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 9/7/24.
//

import UIKit
import Combine

class CalendarViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet weak var calCollectionView: UICollectionView!
    // MARK: - Variables and const
    private let numsOfDayInCalendar = 35

    private let numsOfRowInCalendar: CGFloat = 8

    private let collectionViewSpacingAttribute: CGFloat = 2

    private var refDate: Date? = CalendarViewModel().getFirstDayOfMonth()

    private var dateList: [Date]?

    private var calendarDateList: [CalendarDate]?

    private let calendarModelView = CalendarViewModel()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendar()
        updateCalendar()

        calCollectionView.delegate = self
        calCollectionView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calCollectionView.reloadData()
    }

    // MARK: - Binding
    private func setupBind() {
        calendarModelView.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
}

    // MARK: - Collection View Delegate
extension CalendarViewController:
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numsOfDayInCalendar
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell",
                                                       for: indexPath) as? CalendarCell)!
        calendarDateList = calendarModelView.convertDatesAndHistoryToCalendarList(dates: dateList!)

        let cellDate = calendarDateList![indexPath.item]

        cell.dayLabel.text = CalendarViewModel().getDateToString(date: cellDate.date!)
        cell.date = cellDate.date
        cell.delegate = self

        if CalendarViewModel().isDateInThisMonth(cellDate.date!, inSameMonthAs: refDate!) {
            if CalendarViewModel().isToday(date: cellDate.date!) {
                cell.dayLabel.textColor = UIColor.white
                cell.dayLabel.layer.cornerRadius = cell.dayLabel.frame.width / 2
                cell.dayLabel.layer.backgroundColor = UIColor.red.cgColor
            } else {
                cell.dayLabel.layer.cornerRadius = 0
                cell.dayLabel.layer.backgroundColor = UIColor.clear.cgColor
                cell.dayLabel.textColor = UIColor.black
            }
        } else {
            cell.dayLabel.layer.backgroundColor = UIColor.clear.cgColor
            cell.dayLabel.textColor = UIColor.gray
        }

        if cellDate.isEvent {
            cell.hasEventView.backgroundColor = .gray
        } else {
            cell.hasEventView.backgroundColor = .clear
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (calCollectionView.frame.width - collectionViewSpacingAttribute) / numsOfRowInCalendar
        let height = (calCollectionView.frame.height - collectionViewSpacingAttribute) / 6

        return CGSize(width: width, height: height)
    }
}
    // MARK: - Cell Delegate
extension CalendarViewController: CalendarCellDelegate {
    func handleTappedOnDate(date: Date?) {
        if CalendarViewModel().isDateInThisMonth(date!, inSameMonthAs: refDate!) {
            let controller = (storyboard?.instantiateViewController(identifier: "CalendarDetailVC")
                              as? CalendarDetailViewController)!
            controller.selectedDate = date
            self.navigationController?.pushViewController(controller, animated: true)
        } else if CalendarViewModel().isDateNextMonth(date: date!, comparedTo: refDate!) {
            updateRefDateToNextMonth()
        } else {
            updateRefDateToLastMonth()
        }
    }
}

    // MARK: - Functions
extension CalendarViewController {
    private func setupCalendar() {
        let leftButton = UIBarButtonItem(title: CalendarViewModel().getLastMonthToString(date: refDate),
                                         style: .plain, target: self, action: #selector(changeToLastMonth))
        navigationItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(title: CalendarViewModel().getNextMonthToString(date: refDate),
                                          style: .plain, target: self, action: #selector(changeToNextMonth))
        navigationItem.rightBarButtonItem = rightButton
    }

    private func updateCalendar() {
        calCollectionView.reloadData()

        navigationItem.title = CalendarViewModel().getMonthYearToString(date: refDate)

        navigationItem.leftBarButtonItem?.title = CalendarViewModel().getLastMonthToString(date: refDate)

        navigationItem.rightBarButtonItem?.title = CalendarViewModel().getNextMonthToString(date: refDate)

        dateList = CalendarViewModel().getDatesInCurrentMonth(date: refDate!,
                                                                numOfDaysInCalendar: numsOfDayInCalendar)
    }

    private func updateRefDateToNextMonth() {
        refDate = CalendarViewModel().getRefDayOfNextMonth(date: refDate!)
        updateCalendar()
    }

    private func updateRefDateToLastMonth() {
        refDate = CalendarViewModel().getRefDayOfLastMonth(date: refDate!)
        updateCalendar()
    }

    @objc private func changeToNextMonth() {
        updateRefDateToNextMonth()
    }

    @objc private func changeToLastMonth() {
        updateRefDateToLastMonth()
    }
}
