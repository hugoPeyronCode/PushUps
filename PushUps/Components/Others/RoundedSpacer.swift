//
//  RoundedSpacer.swift
//  PushUps
//
//  Created by Hugo Peyron on 15/03/2024.
//

import SwiftUI

struct RoundedSpacer: View {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(color: Color, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
        self.color = color
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    init(color: Color) {
        self.color = color
        self.width = 10
        self.height = 50
        self.cornerRadius = 25
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .frame(width: width, height: height)
            .foregroundStyle(color)
    }
}

#Preview {
    RoundedSpacer(color: .gray)
}
