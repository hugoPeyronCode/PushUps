//
//  DayButtonSquareTest.swift
//  PushUps
//
//  Created by Hugo Peyron on 05/05/2024.
//

import SwiftUI

struct DayButtonSquareTest: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    let dayIndex : Int
    
    var body: some View {
        
        let color = homeViewModel.updateDayColor(dayID: dayIndex)
        let isToday = homeViewModel.currentDay == dayIndex
        
        // background
        RoundedRectangle(cornerRadius: 35)
            .foregroundStyle(.gray.opacity(0.1))
            .frame(width: SizeConstants.screenWidth * 0.45, height: SizeConstants.screenHeight * 0.15)
            .overlay {
                //Stroke
                    RoundedRectangle(cornerRadius: 35)
    //                    .stroke(lineWidth: 5)
                    .stroke(lineWidth: isToday ? 3 : 2)
                    .foregroundStyle(isToday ? .blue : color)

            }
            .overlay(alignment: .center) {
                VStack {
                    Text("Day \(dayIndex)")
                        .font(.subheadline)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.gray)
                    HStack {
                        Objectives
                        Spacer()
                        Symbol
                    }
                    .foregroundStyle(color)
                    .padding()
                    
                }
            }
            .foregroundStyle(color)

            .padding(.horizontal)
    }
}


extension DayButtonSquareTest {
    var Date : some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Day \(dayIndex)")
            Text("23 April 2024")
        }
        .fontDesign(.monospaced)
        .padding()
    }
    
    var Objectives : some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Goal")
                Text("\(homeViewModel.days[dayIndex].goal)")
                    .bold()
            }
            HStack {
                Text("Done")
                Text("\(homeViewModel.days[dayIndex].pushupsCount)")
                    .bold()
            }
        }
        .fontDesign(.monospaced)
    }
    
    var Symbol : some View {
        Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(homeViewModel.updateDayColor(dayID: dayIndex), homeViewModel.updateDayColor(dayID: dayIndex).opacity(0.1))
            .symbolRenderingMode(.palette)
            .font(.largeTitle)
            .rotationEffect(.degrees(-7))
    }
}

#Preview {
//    TestView()
    DayButtonSquareTest(homeViewModel: HomeViewModel(), dayIndex: 1)
//    DayButtonSquareTest(homeViewModel: HomeViewModel(), dayIndex: 0)
}

enum Position {
    case left, center, right
}

struct TestView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    // UI related
    @State private var position: Position = .center

    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(0.2)
                .ignoresSafeArea()

            ScrollView {
                HStack {
                    // Calculate offset based on the current position
                    Spacer(minLength: position == .right ? UIScreen.main.bounds.width / 2 : 0)

                    VStack {
                        ForEach(viewModel.days) { day in
                            VStack {
                                DayButtonSquareTest(homeViewModel: viewModel, dayIndex: day.id)
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.gray)
                                    .frame(width: 2, height: 50)
                            }
                        }
                    }

                    Spacer(minLength: position == .left ? UIScreen.main.bounds.width / 2 : 0)
                }
            }
            .scrollIndicators(.hidden)
        }
        .gesture(DragGesture()
            .onEnded { gesture in
                withAnimation(.spring()) {
                    handleSwipe(gesture: gesture)
                }
            }
        )
    }

    private func handleSwipe(gesture: DragGesture.Value) {
        let dragThreshold: CGFloat = 50.0 // Sensitivity of the swipe to trigger a move
        let direction = gesture.translation.width

        switch position {
        case .center:
            if direction > dragThreshold {
                position = .right
            } else if direction < -dragThreshold {
                position = .left
            }
        case .left:
            if direction > dragThreshold {
                position = .center
            }
        case .right:
            if direction < -dragThreshold {
                position = .center
            }
        }
    }
}
