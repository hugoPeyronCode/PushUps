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
    let fontSize: Font
    let lineWidth: CGFloat
    let withText: Bool
    
    init(progress: Double, color1: Color, color2: Color, fontSize: Font, lineWidth: CGFloat, withText: Bool) {
        self.progress = progress
        self.color1 = color1
        self.color2 = color2
        self.fontSize = fontSize
        self.lineWidth = lineWidth
        self.withText = withText
    }

    var body: some View {
        ZStack {
            let gradient = LinearGradient(colors: [color1, color2], startPoint: .leading, endPoint: .trailing)

            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(gradient.opacity(0.5))
                .shadow(color: .black, radius: 0.5)

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
        ZStack {
            NewCircularProgressView(progress: calculateProgress(for: 3), color1: .yellow, color2: .yellow, fontSize: .callout, lineWidth: lineWidth, withText: false)
                .frame(width: 120)

            NewCircularProgressView(progress: calculateProgress(for: 2), color1: .blue, color2: .blue, fontSize: .callout, lineWidth: lineWidth, withText: false)
                .frame(width: 180)

            NewCircularProgressView(progress: calculateProgress(for: 1), color1: .green, color2: .green, fontSize: .callout, lineWidth: lineWidth, withText: false)
                .frame(width: 240)

            NewCircularProgressView(progress: calculateProgress(for: 0), color1: .pink, color2: .pink, fontSize: .callout, lineWidth:lineWidth, withText: false)
                .frame(width: 300)
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
    CircularProgressViewTest(overallProgress: 0.2)
}
