//
//  Models.swift
//  PushUps
//
//  Created by Hugo Peyron on 15/03/2024.
//

import Foundation

struct Day: Identifiable {
    let id: Int
    var isGoalCompleted : Bool
    var pushupsCount: Int = 0
}
