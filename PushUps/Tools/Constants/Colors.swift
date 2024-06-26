//
//  Colors.swift
//  PushUps
//
//  Created by Hugo Peyron on 04/05/2024.
//

import Foundation
import SwiftUI

struct Colors {
    
    static var grayBackground : some View {
        Color(.gray)
            .opacity(0.3)
            .ignoresSafeArea()
    }
    
    static let premiumGradient = Gradient(colors: [.green, .blue, .purple, .pink])
    static let premiumLinearGradient =  LinearGradient(gradient: premiumGradient, startPoint: .leading, endPoint: .trailing)
    static let white = LinearGradient(gradient: Gradient(colors: [.white, .white]) , startPoint: .leading, endPoint: .trailing)
    
    static let radialGradient1 = RadialGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]),
        center: .center,
        startRadius: 0,
        endRadius: SizeConstants.screenWidth * 0.45
    )
    
    static let radialGradient2 = RadialGradient(
        gradient: Gradient(colors: [Color.yellow.opacity(0.5), Color.green]),
        center: .center,
        startRadius: 0,
        endRadius: SizeConstants.screenWidth * 0.45
    )
    
    static let radialGradient3 = RadialGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.5), Color.yellow]),
        center: .center,
        startRadius: 0,
        endRadius: SizeConstants.screenWidth * 0.45
    )
}
