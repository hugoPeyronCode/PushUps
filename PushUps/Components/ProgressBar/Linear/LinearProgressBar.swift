//
//  LinearProgressBar.swift
//  PushUps
//
//  Created by Hugo Peyron on 04/05/2024.
//

import SwiftUI

struct LinearProgressBar: View {
    // The progress variable should be between 0 and 1
    var progress: Double
    var color: Color
    let cornerRadius: CGFloat
    
    init(progress: Double, color: Color) {
        self.progress = progress
        self.color = color
        self.cornerRadius = 25
    }
    
    init(_ progress: Double, color: Color, cornerRadius: CGFloat) {
        self.progress = progress
        self.color = color
        self.cornerRadius = cornerRadius
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.white.opacity(0.1))

                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: geometry.size.width * CGFloat(progress))
                    .foregroundColor(color) // Foreground indicating progress
                    .animation(.linear, value: progress)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 10)
    }
}

#Preview {
    LinearProgressBar(0.5, color: .white, cornerRadius: 0)
}
