//
//  IsDayCurrentViewModel.swift
//  PushUps
//
//  Created by Hugo Peyron on 15/03/2024.
//

import Foundation
import SwiftUI

enum DayStatus {
    case passed
    case current
    case toCome
}

class HomeViewModel: ObservableObject {
    @Published var currentDay = 0
    
    init() {
        // Load the start date when the view model initializes
        loadStartDate()
    }
    
    var progress: Double {
        // Ensure division by zero is handled by returning 0 progress if totalDays is 0
        let totalDays = 100
        // Calculate progress as currentDay / totalDays
        // Note: Convert to Double for accurate division and to match ProgressView's expected type
        return Double(currentDay) / Double(totalDays)
    }
    
    func setStartDate(date: Date) {
        let defaults = UserDefaults.standard
        defaults.set(date, forKey: "StartDate")
        
        // Update currentID based on the new start date
        updateCurrentID(startDate: date)
    }
    
    private func loadStartDate() {
        let defaults = UserDefaults.standard
        
        if let startDate = defaults.object(forKey: "StartDate") as? Date {
            print("update currentID")
            updateCurrentID(startDate: startDate)
        } else {
            // Handle case where start date is not set, e.g., by setting a default start date or prompting the user
            print("set start date to \(Date())")
            setStartDate(date: Date())
        }
    }
    
    private func updateCurrentID(startDate: Date) {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: Date())
        guard let daysSinceStart = dateComponents.day else {
            return
        }
        
        currentDay = daysSinceStart + 1
    }
    
    func updateDayState(dayID: Int) -> Color {
        if dayID < currentDay {
            return .green
        } else if dayID == currentDay {
            return .blue
        } else {
            return .gray
        }
    }
    
}
