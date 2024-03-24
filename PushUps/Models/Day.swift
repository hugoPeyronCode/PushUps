//
//  Models.swift
//  PushUps
//
//  Created by Hugo Peyron on 15/03/2024.
//

import Foundation

struct Day: Identifiable, Codable {
    let id: Int
    var goal: Int
    var pushupsCount: Int = 0
    var isGoalComplete: Bool { pushupsCount >= goal }
    
    mutating func incrementPushUpCount() {
        pushupsCount += 1
    }
    
    mutating func decrementPushupsCount() {
        pushupsCount = max(0, pushupsCount - 1)
    }
}
