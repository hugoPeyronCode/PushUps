//
//  DayButton.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

struct DayButton: View {
    
    let count : Int = 0
    
    var body: some View {
        
        ZStack {
            
            CircularProgressView(progress: progress, color: color(), fontSize: .body, lineWidth: 8, withText: false)
                .frame(height: 90)
            
            Circle()
                .foregroundStyle(.blue)
                .offset(y: 10)
            Circle()
                .foregroundColor(.cyan)
        }
        .padding()
    }
}

#Preview {
    DayButton()
}
