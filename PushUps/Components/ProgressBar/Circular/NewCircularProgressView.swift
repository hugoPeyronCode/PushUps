//
//  NewCircularProgressView.swift
//  PushUps
//
//  Created by Hugo Peyron on 30/04/2024.
//

import SwiftUI

struct NewCircularProgressView: View {
    var progress: Double
    let color1: Color
    let color2: Color
    let lineWidth: CGFloat
    var hasShadow : Bool
    
    init(progress: Double, color1: Color, color2: Color, lineWidth: CGFloat, hasShadow: Bool) {
        self.progress = progress
        self.color1 = color1
        self.color2 = color2
        self.lineWidth = lineWidth
        self.hasShadow = hasShadow
    }

    var body: some View {
        ZStack {
            let gradient = LinearGradient(colors: [color1, color2], startPoint: .leading, endPoint: .trailing)

            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(.thinMaterial)
                .shadow(color: .gray, radius: hasShadow ? 50 : 1)


            Circle()
                .trim(from: 0, to: progress)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

struct CircularProgressViewTest : View {
    var overallProgress : Double
    var lineWidth: CGFloat = 30
    var scaleEffect : CGFloat = 0.7
    
    init(overallProgress: Double) {
        self.overallProgress = overallProgress
        self.lineWidth = 30
        self.scaleEffect = 1
    }
    
    init(overallProgress: Double, lineWidth: CGFloat, scaleEffect: CGFloat) {
        self.overallProgress = overallProgress
        self.lineWidth = lineWidth
        self.scaleEffect = scaleEffect
    }
    
    var body: some View {
        
        let size = SizeConstants.screenWidth / 3
        
        ZStack {
            NewCircularProgressView(progress: calculateProgress(for: 3), color1: .pink, color2: .pink, lineWidth: lineWidth, hasShadow: true)
                .frame(width: size)

            NewCircularProgressView(progress: calculateProgress(for: 2), color1: .blue, color2: .blue, lineWidth: lineWidth, hasShadow: true)
                .frame(width: size + 60)

            NewCircularProgressView(progress: calculateProgress(for: 1), color1: .pink, color2: .pink, lineWidth: lineWidth, hasShadow: true)
                .frame(width: size + 120)

            NewCircularProgressView(progress: calculateProgress(for: 0), color1: .cyan, color2: .cyan, lineWidth:lineWidth, hasShadow: false)
                .frame(width: size + 180)
        }
        .scaleEffect(scaleEffect)
    }

    func calculateProgress(for circleIndex: Int) -> Double {
        let progressPerCircle = 1.0
        let baseProgress = overallProgress - Double(circleIndex) * progressPerCircle
        return min(max(baseProgress, 0), 1)
    }
}

#Preview{
    CircularProgressViewTest(overallProgress: 1.2)
}
