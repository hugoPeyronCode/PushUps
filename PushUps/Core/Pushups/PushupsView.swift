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
        VStack {
            if let image = cameraManager.depthImage {
                            Image(uiImage: image)
                                .resizable()
                                
                        }
            
            HStack{
                Button(action: {dismiss()}, label: {
                    Image(systemName: "xmark")
                        .bold()
                        .foregroundStyle(.white)
                })
                .padding()
                Spacer()
            }
            
            Spacer()
            
            /*Group {
                Text("Push up count")
                Text("\(homeViewModel.days[dayIndex].pushupsCount) / \(homeViewModel.days[dayIndex].goal)")
                Text("\(homeViewModel.days[dayIndex].isGoalComplete.description)")
            }
            .fontWeight(.black)
            .font(.title)
            */
            
            Spacer()
            
            VStack {
                
                
                
                
                
                Group {
                    Text("Push up count")
                    // Display the pushup count and make sure it's converted to String
                    Text("\(cameraManager.pushupCount) / \(homeViewModel.days[dayIndex].goal)")
                    // Display goal completion status
                    Text(homeViewModel.days[dayIndex].isGoalComplete ? "Goal Completed!" : "Keep Going!")
                }
                .fontWeight(.black)
                .font(.title)
                
                Spacer()
                
                // Display distance detected by the camera
                Text("Distance: \(cameraManager.distanceLabel)")
                    .padding()
                
                
            }
            Spacer()
            Spacer()
        }
        .onDisappear{
            homeViewModel.saveDays()
            homeViewModel.days[dayIndex].pushupsCount = cameraManager.pushupCount
        }
        .onAppear() {
            cameraManager.pushupCount = homeViewModel.days[dayIndex].pushupsCount
        }
    }
}

#Preview {
    PushupsView(dayIndex: 2, homeViewModel: HomeViewModel())
}
