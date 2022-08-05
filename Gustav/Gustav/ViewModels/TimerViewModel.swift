//
//  TimerViewModel.swift
//  Gustav
//
//  Created by Dalibor Janeček on 25.02.2022.
//

import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    
    @Published var time: Int {
        didSet {
            updatePercentage()
        }
    }
    @Published var isRunning = false {
        didSet {
            count()
        }
    }
    @Published var percentageWorkout: Double
    @Published var percentageRest: Double
    
    var phase: Phase
    var workout: TimeModel
    var rest: TimeModel
    
    init(workout: Int, rest: Int) {
        self.workout = TimeModel(phase: .workout, totalTime: workout)
        self.rest = TimeModel(phase: .rest, totalTime: rest)
        
        self.time = self.workout.totalTime
        self.phase = self.workout.phase
        self.percentageWorkout = 0.0
        self.percentageRest = 0.0
    }
    
    func count() {
        if !isRunning { return }
        if time == 0 {
            if phase == .workout {
                phase = rest.phase
                time = rest.totalTime + 1
                SoundManager.instance.playSound()
            } else {
                phase = workout.phase
                time = workout.totalTime + 1
                SoundManager.instance.playSound()
            }
        }
        time -= 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.count()
        }
    }
    
    func startStop() {
        self.isRunning.toggle()
    }
    
    func reset() {
        self.isRunning = false
        self.time = workout.totalTime
        self.phase = workout.phase
        self.percentageWorkout = 0.0
        self.percentageRest = 0.0
    }
    
    func skip() {
        time = 0
    }
    
    func updatePercentage() {
        if self.phase == .workout {
            percentageRest = 0.0
            withAnimation(.linear(duration: 1.1)) {
                if time == 0 {
                    percentageWorkout = 1.0
                } else {
                    percentageWorkout = max(1 - Double(time) / Double(workout.totalTime), 0.0)
                }
                print("\(percentageWorkout)")
            }
        } else {
            percentageWorkout = 1.0
            if time == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut) {
                        self.percentageWorkout = 0.0
                    }
                }
            }
            withAnimation(.linear(duration: 1.1)) {
                percentageRest = max(1 - Double(time) / Double(rest.totalTime), 0.0)
            }
            print("\(percentageRest)")
        }
    }
    
    func setWorkout(time: Int) {
        self.workout = TimeModel(phase: .workout, totalTime: time)
        reset()
    }
    
    func setRest(time: Int) {
        self.rest = TimeModel(phase: .rest, totalTime: time)
        reset()
    }
}
