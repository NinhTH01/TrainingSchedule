//
//  CalendarCell.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 10/7/24.
//

import UIKit

protocol CalendarCellDelegate: AnyObject {
    func handleTappedOnDate(date: Date?)
}

class CalendarCell: UICollectionViewCell {

    @IBOutlet weak var hasEventView: UIView!

    @IBOutlet weak var dayLabel: UILabel!

    var date: Date?

    weak var delegate: CalendarCellDelegate?

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
        delegate?.handleTappedOnDate(date: date)
    }
}
