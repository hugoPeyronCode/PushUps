//
//  HowManyPushupsView.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

struct HowManyPushupsView: View {
    
    @State private var selectedNumber : Int = 0
    
    var body: some View {
        
        VStack {
            Text("How many pushups can you do in a row? You can try now and tell how you did.")
                .tag(7)
            // here I want a slider going from 1 to 200
            Picker("Number of Pushups", selection: $selectedNumber) {
                  ForEach(1...200, id: \.self) {
                      Text("\($0)").tag($0)
                  }
              }
            .pickerStyle(.wheel)
            
            Text(commentedTextOnNumberOfPushups(numberOfPushups: selectedNumber))
        }
    }
    
    func commentedTextOnNumberOfPushups(numberOfPushups: Int) -> String {
        switch true {
        case numberOfPushups < 5:
            return "Just starting? Let's ramp it up!"
        case numberOfPushups == 10:
            return "Hit double digits! Keep going!"
        case numberOfPushups <= 20:
            return "Looking good! Aim higher?"
        case numberOfPushups <= 30:
            return "30! You're on fire!"
        case numberOfPushups <= 40:
            return "40! Muscle party is on."
        case numberOfPushups <= 50:
            return "Half-century! Warrior alert."
        case numberOfPushups <= 60:
            return "60! Strength soaring high."
        case numberOfPushups <= 70:
            return "70? You're crushing it!"
        case numberOfPushups <= 80:
            return "80! Ground's trembling, huh?"
        case numberOfPushups <= 90:
            return "90! Nearly invincible."
        case numberOfPushups <= 100:
            return "Hit 100! Monster mode."
        case numberOfPushups <= 150:
            return "150? Strength legend!"
        case numberOfPushups < 200:
            return "Closing in on 200. Epic!"
        case numberOfPushups == 200:
            return "200?! Defying gravity!"
        default:
            return "Beyond human? You're awe-inspiring!"
        }
    }
}

#Preview {
    HowManyPushupsView()
}
