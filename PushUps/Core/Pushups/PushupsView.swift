//
//  PushupsView.swift
//  PushUps
//
//  Created by Hugo Peyron on 22/03/2024.
//

import SwiftUI

struct PushupsView: View {
    // View Model
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var pushUpsViewModel = PushUpsViewModel()
    
    // Tools
    @Environment(\.dismiss) private var dismiss
    
    // View Variables
    var dayIndex: Int
    
    // Confettis
    @State private var counter : Int = 1
    @State private var confettiColors: [Color] = [.purple, .primary]
    
    var body: some View {
        let count = pushUpsViewModel.pushupCount
        let goal = homeViewModel.days[dayIndex].goal

        NavigationStack {
            
            ZStack {
                
                Colors.grayBackground
                
                VStack {
                    
                    Spacer()
                    
                    Text(encouragingText())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxHeight: 70)
                        .bold()
                        .padding()
                        .confettiCannon(counter: $counter, colors: confettiColors)
                    
                    Spacer()
                    
                    // Push Ups Counter Circle
                    ZStack {
                        let progress = Double(count) / Double(goal)
                                            
                        CircularProgressViewTest(overallProgress: progress)
                        
                        DistanceIndicator
                        
                        ProgressInformation
                        
                    }
                    
                    if pushUpsViewModel.isFacingUpward {
                        Spacer()
                        VStack{}
                            .frame(maxHeight: SizeConstants.screenHeight / 6)
                        Spacer()
                    } else {
                        Spacer()
                        PhoneFacingUpWarning
                            .frame(maxHeight: SizeConstants.screenHeight / 6)
                        Spacer()
                    }
                    
                }
                .frame(width: SizeConstants.screenWidth * 0.9)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        xMark(dismiss)
                    }
                })
                .onDisappear{
                    homeViewModel.days[dayIndex].pushupsCount = pushUpsViewModel.pushupCount
                    homeViewModel.saveDays()
                }
                .onAppear() {
                    pushUpsViewModel.pushupCount = homeViewModel.days[dayIndex].pushupsCount
            }
                .onChange(of: pushUpsViewModel.pushupCount) { _, _ in
                    triggerConffeti()
                }
                Text(pushUpsViewModel.distanceLabel)
            }
        }
        .fontDesign(.monospaced)
    }
}


#Preview {
    PushupsView(homeViewModel: HomeViewModel(), dayIndex: 2)
}

extension PushupsView {
    // Conffetis functions
    func triggerConffeti() {
        if pushUpsViewModel.pushupCount == homeViewModel.userGoal || pushUpsViewModel.pushupCount % 10 == 0 {
            print("Should trigger confetti")
            counter += 1
            HapticManager.shared.generateFeedback(for: .successStrong)
        } else {
            counter += 0
        }
    }
}

extension PushupsView {
    
    var CameraView : some View {
        // Camera
        VStack{
            if let image = pushUpsViewModel.depthImage {
                Image(uiImage: image)
                    .resizable()
            }
        }
    }
    
    var DistanceIndicator: some View {
        let maxScale: CGFloat = 30.0  // Maximum scale factor
        let dynamicScale = 1 + pushUpsViewModel.blackPixelCount * 30
        let scale = min(dynamicScale, maxScale)  // Ensure scale does not exceed maxScale
        
        return Circle()
            .stroke(lineWidth: 0.1)
            .fill(.black)
            .frame(width: 10, height: 10)  // Fixed size for demonstration
            .scaleEffect(scale)  // Apply the capped scale effect
    }
    
    var PhoneFacingUpWarning: some View {
        VStack {
            HStack(spacing: 1) {
                Image(systemName:"exclamationmark.triangle.fill" )
                
                Text("Place the phone on the floor facing you")
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Image(systemName: "exclamationmark.triangle.fill" )
                
            }
            .padding()
            .background( .orange.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    var ProgressInformation : some View {
        VStack {
            Text("\(pushUpsViewModel.pushupCount)")
            // Display goal completion status
        }
        .fontWeight(.black)
        .font(.largeTitle)
    }
}

extension PushupsView {
    func encouragingText() -> String {
        let count = pushUpsViewModel.pushupCount
        let goal = homeViewModel.userGoal
        
        let ratio = Double(count) / Double(goal)

        switch ratio {
        case 0:
            return "Ready to start? Let’s do this! 🚀"
        case 0..<0.25:
            return "Great start, keep pushing! 🌟"
        case 0.25..<0.5:
            return "You’re doing well, stay strong! 💪"
        case 0.5..<0.75:
            return "More than halfway there! 🎯"
        case 0.75..<1:
            return "Almost there, don’t stop now! 🏁"
        case 1:
            return "Goal achieved! Fantastic effort! 💪"
        case 1..<1.5:
            return "Awesome, you've hit your goal! 🔥"
        case 1.5..<2:
            return "Incredible! You're at 150% of your goal! 🌟"
        case 2..<3:
            return "Unstoppable! You've doubled your goal! 🎉"
        default:
            return "Phenomenal! \(Int(ratio)) times your goal!"
        }
    }
}
