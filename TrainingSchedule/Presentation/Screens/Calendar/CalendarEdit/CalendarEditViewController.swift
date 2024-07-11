//
//  CalendarEditViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 11/7/24.
//

import UIKit
import Combine

class CalendarEditViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var deleteButton: UIButton!

    // MARK: - variables
    private var cancellables = Set<AnyCancellable>()

    var selectedDate: Date?

    var event: RunningHistory?

    var isEdit: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - IBAction
    @IBAction func deleteEvent(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Event",
                                                message: "Are you sure you want to proceed?",
                                                preferredStyle: .actionSheet)

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            self.deleteContextAndNavigateBack()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension CalendarEditViewController {

    // MARK: - Obj Function
    @objc private func textFieldDidChange() {
        enableTextField()
    }

    @objc private func saveEvent() {
        if isEdit {
            updateContextAndNavigateBack()
        } else {
            saveContextAndNavigateBack()
        }
    }

    private func setupView() {
        title = "Event"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain, target: self, action: #selector(saveEvent))

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        if let date = selectedDate {
            datePicker.date = date
        }

        if let currentEvent = event {
            textField.text = currentEvent.desc
            datePicker.date = currentEvent.date
        }

        if !isEdit {
            deleteButton.isEnabled = false
        }

        enableTextField()
    }

    // MARK: - Function
    private func enableTextField() {
        if let text = textField.text, !text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem!.isEnabled = false
        }
    }

    private func saveContextAndNavigateBack() {
        CalendarEditViewModel().saveEventToDatabase(description: textField.text ?? "", date: datePicker.date)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    let controller = (self.storyboard?.instantiateViewController(identifier: "CalendarVC")
                                      as? CalendarViewController)!
                    self.navigationController?.pushViewController(controller, animated: true)
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }, receiveValue: { })
            .store(in: &self.cancellables)
    }

    private func updateContextAndNavigateBack() {
        CalendarEditViewModel().updateEventToDatabase(description: textField.text ?? "",
                                                      date: datePicker.date, event: event)
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                let controller = (self.storyboard?.instantiateViewController(identifier: "CalendarVC")
                                  as? CalendarViewController)!
                self.navigationController?.pushViewController(controller, animated: true)
            case .failure(let error):
                self.showErrorAlert(message: error.localizedDescription)
            }
        }, receiveValue: { })
        .store(in: &self.cancellables)
    }

    private func deleteContextAndNavigateBack() {
        CalendarEditViewModel().deleteEventToDatebase(event: event)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    let controller = (self.storyboard?.instantiateViewController(identifier: "CalendarVC")
                                      as? CalendarViewController)!
                    self.navigationController?.pushViewController(controller, animated: true)
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }, receiveValue: { })
            .store(in: &self.cancellables)
    }
}
