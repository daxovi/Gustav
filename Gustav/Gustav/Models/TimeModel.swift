//
//  TimeModel.swift
//  Gustav
//
//  Created by Dalibor Janeček on 25.02.2022.
//

import Foundation

enum Phase: String {
    case workout = "Workout"
    case rest = "Rest"
}

struct TimeModel {
    let phase: Phase
    let totalTime: Int
}
