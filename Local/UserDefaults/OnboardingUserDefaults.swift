//
//  OnboardingUserDefaults.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 9/7/24.
//

import Foundation

class OnboardingUserDefaults: UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }

    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
