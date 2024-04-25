//
//  PushupsView.swift
//  PushUps
//
//  Created by Hugo Peyron on 22/03/2024.
//

import SwiftUI

struct PushupsView: View {
    
    var dayIndex: Int
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var cameraManager = CameraManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                PhoneFacingUpwardWarning
                
                //Here I would like to display the camera of the phone.
                CameraView
                
                ZStack {
                    
                    CircularProgressBar(progress: Double(cameraManager.pushupCount) / Double(homeViewModel.days[dayIndex].goal), color: .green)
                    
                    ProgressInformation

                }
                .frame(width: SizeConstants.screenWidth / 2 )
                
                Text(homeViewModel.days[dayIndex].isGoalComplete ? "Goal Completed!" : "Keep Going!")
                    .padding()
                
                Text(cameraManager.stateHistory.debugDescription)
                
                Button("+1") {
                    withAnimation(.snappy){
                        cameraManager.pushupCount += 1
                    }
                }
                
                DistanceInformation
                
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
    PushupsView(dayIndex: 2, homeViewModel: HomeViewModel())
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
    
    var PhoneFacingUpwardWarning: some View {
        Text(cameraManager.isFacingUpward ? "Let's gooo" : "Please place the phone correctly, facing upward.")
                .fontWeight(.semibold)
                .padding()
                .multilineTextAlignment(.center)
    }
    
    var ProgressInformation : some View {
        VStack {
            Text("\(cameraManager.pushupCount) / \(homeViewModel.days[dayIndex].goal)")
            // Display goal completion status
        }
        .fontWeight(.black)
        .font(.title)
    }
    
    var DistanceInformation : some View {
        // Display distance detected by the camera
        Text("\(cameraManager.distanceLabel)")
            .padding()
    }
}
