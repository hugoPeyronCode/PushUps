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
    @ObservedObject var cameraManager = PushUpsViewModel()
    
    // Tools
    @Environment(\.dismiss) private var dismiss
    
    // View Variables
    var dayIndex: Int
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Spacer()
                
                Text(encouragingText())
                    .frame(maxHeight: 20)
                    .bold()
                    .padding()
                
                Spacer()
                
                ZStack {
                    let progress = Double(cameraManager.pushupCount) / Double(homeViewModel.days[dayIndex].goal)
                    
                                        
                    CircularProgressViewTest(overallProgress: progress)
                        .frame(width: SizeConstants.screenWidth / 1.4 )
                    
                    //                    CircularProgressBar(progress: Double(cameraManager.pushupCount) / Double(homeViewModel.days[dayIndex].goal), color1: colors.0, color2: colors.1, fontSize: .caption2, lineWidth: 30, withText: false)
                    
                    //CircularProgressBar(progress: Double(cameraManager.pushupCount) / Double(homeViewModel.days[dayIndex].goal), color: .green)
                    
                    DistanceIndicator
                    
                    ProgressInformation
                    
//                    Button {
//                        withAnimation {
//                            cameraManager.pushupCount += 1
//
//                        }
//                    } label: {
//                        Text("+10")
//                    }
                }
                .frame(width: SizeConstants.screenWidth / 1.4 )
                
                
                if cameraManager.isFacingUpward {
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
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    xMark(dismiss)
                }
            })
            .onDisappear{
                homeViewModel.saveDays()
                homeViewModel.days[dayIndex].pushupsCount = cameraManager.pushupCount
            }
            .onAppear() {
                cameraManager.pushupCount = homeViewModel.days[dayIndex].pushupsCount
            }
        }
    }
}


#Preview {
    PushupsView(homeViewModel: HomeViewModel(), dayIndex: 2)
}


extension PushupsView {
    func changeCircularProgressBarColors() -> (Color, Color) {
        if cameraManager.pushupCount > homeViewModel.userGoal {
            return (.yellow, .pink)
        } else if cameraManager.pushupCount == homeViewModel.userGoal {
            return (.green, .mint)
        } else {
            return (.blue, .white)
        }
    }
}

extension PushupsView {
    
    var CameraView : some View {
        // Camera
        VStack{
            if let image = cameraManager.depthImage {
                Image(uiImage: image)
                    .resizable()
            }
        }
    }
    
    var DistanceIndicator: some View {
        let maxScale: CGFloat = 30.0  // Maximum scale factor
        let dynamicScale = 1 + cameraManager.blackPixelCount * 30
        let scale = min(dynamicScale, maxScale)  // Ensure scale does not exceed maxScale
        
        return Circle()
            .fill(.white.opacity(0.5))
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
            Text("\(cameraManager.pushupCount) / \(homeViewModel.days[dayIndex].goal)")
            // Display goal completion status
        }
        .fontWeight(.black)
        .font(.title)
    }
}

extension PushupsView {
    func encouragingText() -> String {
        let count = cameraManager.pushupCount
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
