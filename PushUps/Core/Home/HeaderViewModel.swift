//
//  HomeHeaderViewModel.swift
//  PushUps
//
//  Created by Hugo Peyron on 04/05/2024.
//

import Foundation
import Combine

class HomeHeaderViewModel: ObservableObject {
    @Published var currentIndex = 0
    var info: [String] = []  {
        willSet {
            objectWillChange.send()
        }
    }
    
    private var timer: Timer?

    init(totalPushUps: Int, daysMissed: Int, maxPushUps: Int, daysLeft: Int) {
        setupInfo(totalPushUps: totalPushUps, daysMissed: daysMissed, maxPushUps: maxPushUps, daysLeft: daysLeft)
        startTimer()
    }

    func setupInfo(totalPushUps: Int, daysMissed: Int, maxPushUps: Int, daysLeft: Int) {
        info.append("\(totalPushUps) Total Push Ups")
        info.append("\(daysMissed) Days Missed")
        info.append("\(maxPushUps) Max Daily Pushups")
        info.append("\(daysLeft) Days Left")
    }
    
    func updateData(totalPushUps: Int, daysMissed: Int, maxPushUps: Int, daysLeft: Int) {
        print("updated Data header view model")
        setupInfo(totalPushUps: totalPushUps, daysMissed: daysMissed, maxPushUps: maxPushUps, daysLeft: daysLeft)
    }
    
    // Start the timer
    func startTimer() {
        stopTimer() // Ensure there is no existing timer running
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.nextInfo()
        }
    }

    
    // Stop the timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func nextInfo() {
        HapticManager.shared.complexFeedback(sharpness: 1, intensity: 0.5, occurrences: 1)
        currentIndex = (currentIndex + 1) % info.count
    }

    func getInfo() -> String {
        // Safeguard for empty info array
        guard !info.isEmpty else { return "No Info" }
        return info[currentIndex]
    }

    func manualNext() {
        nextInfo()
        // Optionally restart the timer if you want the manual action to reset the timer interval
        startTimer()
    }

    deinit {
        print("De Init of HomeHeaderViewModel")
         stopTimer()
     }
}
