//
//  CalendarDetailViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 10/7/24.
//

import UIKit

class CalendarDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var selectedDate: Date?

    var eventList: [RunningHistory]?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = CalendarDetailViewModel().getFullDayToString(date: selectedDate)

        eventList = CalendarDetailViewModel().getEventOfDate(date: selectedDate)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CalendarDetailViewController:
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDetailCell",
                                                       for: indexPath) as? CalendarDetailCell)!
        cell.eventContentLabel.text = "You have run \(getTwoDigitsSeperator(number: eventList![indexPath.item].distance))m"
        cell.endLabel.text = CalendarDetailViewModel().getHourToString(date: eventList![indexPath.item].createdAt)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = self.collectionView.frame.height / 8

        return CGSize(width: width, height: height)
    }
}

extension CalendarDetailViewController {
    private func getTwoDigitsSeperator(number: Double?) -> String {
        guard number != nil else {
            return "_"
        }

        let numberFormatter = NumberFormatter()

        numberFormatter.numberStyle = .decimal

        numberFormatter.maximumFractionDigits = 2

        if let formattedValue = numberFormatter.string(from: NSNumber(value: number!)) {
            return formattedValue
        } else {
            return String(number!)
        }
    }
}
