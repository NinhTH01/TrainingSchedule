//
//  String.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 28/6/24.
//

extension String {
    func capitalizedFirstLetterOfEachWord() -> String {
        return self.lowercased().split(separator: " ").map { $0.capitalized }.joined(separator: " ")
    }
}
