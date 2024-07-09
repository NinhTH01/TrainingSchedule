//
//  RoundButton.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 3/7/24.
//

import UIKit

class RoundButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = layer.frame.height / 2
    }
}
