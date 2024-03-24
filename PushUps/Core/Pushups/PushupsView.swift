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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
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
            
            Group {
            Text("Push up count")
            Text("\(homeViewModel.days[dayIndex].pushupsCount) / \(homeViewModel.days[dayIndex].goal)")
            Text("\(homeViewModel.days[dayIndex].isGoalComplete.description)")
            }
            .fontWeight(.black)
            .font(.title)
            
            Spacer()
            
            VStack {
                Button {
                    homeViewModel.days[dayIndex].pushupsCount -= 1
                } label: {
                    Image(systemName: "minus.circle")
                        .foregroundStyle(.red)
                        .font(.system(size: 40))
                }
                .padding()
                
                Button {
                    homeViewModel.days[dayIndex].pushupsCount += 1
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(.purple)
                        .font(.system(size: 250))
                }
                .padding()
            }
            Spacer()
            Spacer()
        }
        .onDisappear{
            homeViewModel.saveDays()
        }
    }
}

#Preview {
    PushupsView(dayIndex: 2, homeViewModel: HomeViewModel())
}
