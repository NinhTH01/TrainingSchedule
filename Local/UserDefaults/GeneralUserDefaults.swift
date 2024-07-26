//
//  OnboardingUserDefaults.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 9/7/24.
//

import Foundation

class GeneralUserDefaults: UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
        case hasAchived
    }

    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }

    var hasAchived: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasAchived.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasAchived.rawValue)
        }
    }
}
