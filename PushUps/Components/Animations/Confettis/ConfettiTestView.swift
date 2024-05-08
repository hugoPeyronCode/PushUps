//
//  ConfettiTestView.swift
//  PushUps
//
//  Created by Hugo Peyron on 07/05/2024.
//

import SwiftUI

struct ConfettiTestView: View {
    
    @State private var counter : Int = 1
    
    var body: some View {
        
        Text("Confetti")
            .confettiCannon(counter: $counter, colors: [.green, .mint])
        
        Button("\(counter)") {
            counter += 100
        }
        
    }
}

#Preview {
    ConfettiTestView()
}
