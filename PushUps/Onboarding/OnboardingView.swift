//
//  OnboardingView.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var selectedTab = 0
    @State private var selectedNumber: Int = 1
    
    var body: some View {
        
        ZStack {
            TabView(selection: $selectedTab) {
            
                VStack {
                    Text("Welcome to the 100 Days Pushups Challenge")
                        .tag(0)
                }
                
                Text("You'll have to connect your Instagram Account")
                    .tag(1)
                
                Text("Every Day we'll post your progress for you.")
                    .tag(2)
                
                Text("If you fail one day, your friends will know.")
                    .tag(3)
                
                Text("It's been proven that telling your friends increase your chance of success.")
                    .tag(4)
                
                Text("Once you've started there is no coming back. \nAre you sure you want to do this?")
                    .tag(5)
                
                Text("Awesome! Now I'll ask you some questions to know more about you and help you set up the right objectives for this challenge.")
                    .tag(6)
                
                HowManyPushupsView()
                    .tag(7)
                
                Text("Are you a sportperson?")
                    .tag(8)
                    // Very, Yes, A little bit, Not a all I defintely need training.
                
                Text("Do you have a healthy lifestyle?")
                    .tag(9)
                    // Yes I eat very well, no etc...
                
                Text("Ok so your daily goal is..... 10 push per day!")
                    .tag(10)
                
                Text("That will be 1000 pushups in 100 days. Take photo daily to keep track of you progress.")
                    .tag(11)
                
                Text("If you feel progress during the challenge you still can increase your daily goal.")
                    .tag(12)
                
                Text("If you succeed we'll share a story on your insta.")
                    .tag(13)
                
                Text("If you do not show up or if you fail, we'll also post one.")
                    .tag(14)
                
                Text("One last thing...")
                    .tag(15)
                
                Text("Make sure to put your phone right below your nose during the workout.")
                    .tag(16)
                
                Text("If our tech misses one, it's not a bug it's a feature of our super complex machine learning algorythm to get you ripped ok? So just do one more pushup.")
                    .tag(17)
                
                Button {
                    // go to home view
                } label: {
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundStyle(.orange)
                        .overlay {
                            Text("Let's do some pushups!")
                        }
                }
                .tag(18)

                
            }
            .font(.largeTitle)
            .fontWeight(.black)
            .tabViewStyle(.page)
            
            VStack {
                
                Text("\(selectedTab.description)")
                
                Spacer()
                HStack {
                    Button("Back") {
                        if selectedTab > 0 {
                            selectedTab -= 1
                        }
                    }
                    Button("Continue") { selectedTab += 1 }
                }
            }

        }
        
    }
}

#Preview {
    OnboardingView()
}
