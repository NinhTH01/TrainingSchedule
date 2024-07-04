//
//  Data.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 4/7/24.
//

import Foundation

extension Data {
    func prettyPrint() {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("json data malformed")
        }
    }
}
