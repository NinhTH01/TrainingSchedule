//
//  RoundCornerStackView.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 1/7/24.
//

import UIKit

class RoundCornerStackView: UIStackView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
    }
}
