//
//  CircularProgressBar.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

struct CircularProgressBar: View {
    let progress: Double
    let color1 : Color
    let color2 : Color
    let fontSize: Font
    let lineWidth : CGFloat
    let withText : Bool
    
    init(progress: Double, color1: Color, color2: Color, lineWidth: CGFloat) {
        self.progress = progress
        self.color1 = color1
        self.color2 = color1
        self.fontSize = .largeTitle
        self.lineWidth = lineWidth
        self.withText = false
    }
    
    init(progress: Double, color: Color, lineWidth: CGFloat) {
        self.progress = progress
        self.color1 = color
        self.color2 = color
        self.fontSize = .largeTitle
        self.lineWidth = lineWidth
        self.withText = false
    }
    
    init(progress: Double, color1: Color, color2: Color ) {
        self.progress = progress
        self.color1 = color1
        self.color2 = color2
        self.fontSize = .largeTitle
        self.lineWidth = 10
        self.withText = false
    }
    
    init(progress: Double, color1: Color, color2: Color, fontSize : Font, lineWidth:  CGFloat, withText: Bool) {
        self.progress = progress
        self.color1 = color1
        self.color2 = color2
        self.fontSize = fontSize
        self.lineWidth = lineWidth
        self.withText = withText
    }
    
    var body: some View {
        
        let gradient = LinearGradient(colors: [color1, color2], startPoint: .topLeading, endPoint: .bottomTrailing)
        
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(gradient.opacity(0.5))
                .shadow(color: .white.opacity(0.1), radius: 10, x: 10, y: 10)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    gradient,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
            
            if withText {
                Text("\(progress * 100, specifier: "%.0f")%")
                    .font(fontSize)
                    .fontWeight(.black)
                    .fontDesign(.rounded)
            }
        }
        .frame(width: SizeConstants.screenWidth / 2)
    }
}

//struct CircularProgressBarTestView: View {
//    // 1
//    @State var progress: Double = 0
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            ZStack {
//                // 2
//                CircularProgressBar(progress: progress, color1: .mint, color2: .yellow )
//                // 3
//            }.frame(width: 150, height: 150)
//            Spacer()
//            HStack {
//                // 4
//                Slider(value: $progress, in: 0...1)
//                // 5
//                Button("Reset") {
//                    resetProgress()
//                }.buttonStyle(.borderedProminent)
//            }
//        }
//    }
//    
//    func resetProgress() {
//        progress = 0
//    }
//}

#Preview {
    CircularProgressBar(progress: 0.4, color1: .orange, color2: .red, lineWidth: 50)
        .padding(50)
}
