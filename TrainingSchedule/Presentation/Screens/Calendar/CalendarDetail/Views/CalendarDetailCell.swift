//
//  CalendarDetailCell.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 10/7/24.
//

import UIKit

protocol CalendarDetailCellDelegate: AnyObject {
    func handleEditEvent(runningHistory: RunningHistory?)
}

class CalendarDetailCell: UICollectionViewCell {

    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var eventContentLabel: UILabel!

    weak var delegate: CalendarDetailCellDelegate?

    var event: RunningHistory?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTapGesture()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.handleEditEvent(runningHistory: event)
    }
}
