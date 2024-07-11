//
//  CalendarDetailViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 10/7/24.
//

import UIKit

class CalendarDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Variables and Consts
    var selectedDate: Date?

    private var eventList: [RunningHistory]?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = CalendarDetailViewModel().getFullDayToString(date: selectedDate)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                             target: self, action: #selector(addEventTapped))

        eventList = CalendarDetailViewModel().getEventOfDate(date: selectedDate)
        sortItemsByDate()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
    // MARK: - Extension Collection View Delegate
extension CalendarDetailViewController:
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDetailCell",
                                                       for: indexPath) as? CalendarDetailCell)!
        cell.eventContentLabel.text = eventList![indexPath.item].desc
        cell.endLabel.text = CalendarDetailViewModel().getHourToString(date: eventList![indexPath.item].date)
        cell.event = eventList![indexPath.item]
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = self.collectionView.frame.height / 9

        return CGSize(width: width, height: height)
    }
}
    // MARK: - Custom Delegate
extension CalendarDetailViewController: CalendarDetailCellDelegate {
    func handleEditEvent(runningHistory: RunningHistory?) {
        let controller = (storyboard?.instantiateViewController(identifier: "CalendarEditVC")
                          as? CalendarEditViewController)!
        controller.event = runningHistory
        controller.isEdit = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
    // MARK: - Extension
extension CalendarDetailViewController {
    @objc private func addEventTapped() {
        let controller = (storyboard?.instantiateViewController(identifier: "CalendarEditVC")
                          as? CalendarEditViewController)!
        controller.selectedDate = selectedDate
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func sortItemsByDate() {
        eventList?.sort { $0.date < $1.date }
        collectionView.reloadData()
    }
}
