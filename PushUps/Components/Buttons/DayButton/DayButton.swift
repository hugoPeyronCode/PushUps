//
//  DayButton.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

struct DayButton: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    let dayIndex : Int
    
    var body: some View {
            ZStack {
                ZStack{
                    Circle()
                        .foregroundStyle(homeViewModel.updateDayColor(dayID: dayIndex))
                        .overlay() {
                            VStack {
                                Text("Day \(dayIndex)")
                                    .font(.title3)
                                    .fontWeight(.black)
                                Text("\(homeViewModel.days[dayIndex].pushupsCount)/\(homeViewModel.userGoal)")
                                    .fontWeight(.bold)
                            }
                        }
                }
                .padding()
                
                CircularProgressBar(progress: calculateProgress(), color: homeViewModel.updateDayColor(dayID: dayIndex))
                    .foregroundStyle(.white)
            }
            .padding()
            .frame(maxHeight: 180)
    }
    
    func calculateProgress() -> Double {
        let day = homeViewModel.days[dayIndex]
        guard homeViewModel.userGoal > 0 else { return 0 }
        return Double(day.pushupsCount) / Double(homeViewModel.userGoal)
    }
    
}

#Preview {
    DayButton(homeViewModel: HomeViewModel(), dayIndex: 2)
}
