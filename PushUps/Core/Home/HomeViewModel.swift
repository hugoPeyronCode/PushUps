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
    @Published var days: [Day] = []
    @Published var currentDay = 0
    @Published var userGoal: Int = 10 {
         didSet {
             updateGoals()
         }
     }

    init() {
        if let savedDays = UserDefaults.standard.object(forKey: "SavedDays") as? Data {
            let decoder = JSONDecoder()
            if let loadedDays = try? decoder.decode([Day].self, from: savedDays) {
                self.days = loadedDays
            }
        } else {
            // Initialize days with the default goal if not saved data found
            self.days = (1...100).map { Day(id: $0, goal: self.userGoal) }
        }
        loadStartDate()
        saveDays()
    }

     func updateGoals() {
         for i in days.indices {
             days[i].goal = userGoal
         }
     }
    
    // Handle the progress bar in the header
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
    
    func updateDay(_ updatedDay: Day) {
        if let index = days.firstIndex(where: { $0.id == updatedDay.id }) {
            days[index] = updatedDay
        }
    }
    
    private func loadStartDate() {
        let defaults = UserDefaults.standard
                
        if let startDate = defaults.object(forKey: "StartDate") as? Date {
            print("update currentID to \(startDate.description)")
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
        
    func updateDayColor(dayID: Int) -> Color {
        guard dayID >= 0 && dayID < days.count else {
            return .gray // Return a default color if the index is out of bounds
        }

        let day = days[dayID]
        if day.pushupsCount > day.goal {
            return .green
        } else if dayID == currentDay && day.pushupsCount == day.goal {
            return .green
        } else if dayID == currentDay {
            return .blue
        } else if dayID < currentDay && day.pushupsCount == day.goal {
            return .green
        } else if dayID < currentDay && day.pushupsCount < day.goal {
            return .red
        } else {
            return .gray
        }
    }
    
    func resetStartDate() {
        // Reset the current day to 1
        currentDay = 1

        // Set the new start date to today
        let today = Date()
        let defaults = UserDefaults.standard
        defaults.set(today, forKey: "StartDate")

        self.days = (1...100).map { Day(id: $0, goal: self.userGoal, pushupsCount: 0) }

        // Save the newly initialized days to UserDefaults
        saveDays()
    }

    
    func saveDays() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(days) {
            UserDefaults.standard.set(encoded, forKey: "SavedDays")
            print("Days saved")
        }
    }
}
