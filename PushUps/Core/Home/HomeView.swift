//
//  HomeView.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    @State private var isNavigatingToPushUpsView = false
    @State private var scrollTarget: Int? = nil
    
    // Manage the position of the scrollingButton view
    @State private var position: Position = .center
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color(.gray)
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                
                VStack {
                    ScrollingButtons
                }
                
                VStack {
                    Header
                    Spacer()
                }
                
                VStack {
                    
                    Spacer()

                    HStack {
                        VStack {
                            focusButton
                            saveDay
                            resetToTodayButton
                            changeDateButton
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    GoToPushupViewButton
                    
                }
            }
            .fullScreenCover(isPresented: $isNavigatingToPushUpsView, onDismiss: {
                // Save the progression
                viewModel.saveDays()
            }) {
                PushupsView(homeViewModel: viewModel, dayIndex: viewModel.currentDay)
            }

            .sheet(isPresented: $showingDatePicker) {
                DatePicker("Select Start Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                    .onChange(of: selectedDate) { oldValue, newValue in
                        viewModel.setStartDate(date: newValue)
                    }
            }
            .onAppear {
                viewModel.saveDays()
            }
        }
    }
    
    var Header : some View {
        VStack {
            Text("99 Days")
                .fontDesign(.monospaced)
                .font(.title)
                .bold()
            
            ProgressView(value: viewModel.progress)
                .padding()
//            LinearProgressBar(viewModel.progress, color: .green, cornerRadius: 0)
        }
        .background(.thinMaterial)
        .foregroundStyle(.gray)
        .onTapGesture {
            // Tap to change the header info
        }
    }
    
    var GoToPushupViewButton: some View {
        Button {
            isNavigatingToPushUpsView.toggle()
            HapticManager.shared.generateFeedback(for: .successStrong)
        } label: {
            RoundedRectangle(cornerRadius: 55)
                .frame(maxHeight: 100)
                .foregroundStyle(.pink)
                .overlay {
                    HStack {
                        Text("Push".uppercased())
//                        Image(systemName: "figure.strengthtraining.traditional")
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.black)
                    .font(.title)
                    .fontDesign(.monospaced)
                }
                .padding()
        }
    }
    
    var focusButton: some View {
        Button {
            // Reset the target to ensure SwiftUI sees a change
            scrollTarget = nil
            // Now set the target which triggers the scroll
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scrollTarget = viewModel.currentDay
                print(viewModel.currentDay)
            }
        } label: {
            Image(systemName: "target")
                .font(.title)
                .padding(10)
                .foregroundStyle(.blue)
                .background(.ultraThinMaterial)
                .cornerRadius(150)
        }
    }
    
    var saveDay : some View {
        Button("Save") {
            viewModel.saveDays()
        }
        .padding()
        .foregroundStyle(.purple)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
    var changeDateButton : some View {
        Button("Date") {
            showingDatePicker.toggle()
        }
        .padding()
        .foregroundColor(.blue)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
    var resetToTodayButton : some View {
        Button("Reset") {
            viewModel.resetStartDate()
        }
        .padding()
        .foregroundColor(.red)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}

extension HomeViewModel {
    // Computed property to get the total number of pushups
    var totalPushUps: Int {
        days.reduce(0) { $0 + $1.pushupsCount }
    }
    
    // Calculate the number of days missed
    var daysMissed: Int {
        // Considering 'missed' as days past the 'currentDay' with pushups count less than the goal
        days.prefix(currentDay).filter { $0.pushupsCount < $0.goal }.count
    }

    // Calculate the maximum number of pushups done in one day
    var maxPushUpsInOneDay: Int {
        days.map { $0.pushupsCount }.max() ?? 0
    }
}

extension HomeView {
    var ScrollingButtons: some View {
        ScrollView {
            ScrollViewReader { value in
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.days) { day in
                        DayButtonSquareTest(homeViewModel: viewModel, dayIndex: day.id, strokeWidth: day.id == viewModel.currentDay ? 2 : 1)
                            .onTapGesture {
                                if day.id == viewModel.currentDay {
                                    isNavigatingToPushUpsView.toggle()
                                }
                            }
                        RoundedSpacer(color: .gray)
                    }
                }
                .offset(y: 10)
                .onAppear {
                    scrollTarget = viewModel.currentDay
                }
                .onChange(of: scrollTarget) { target, uselessArguement in
                    HapticManager.shared.generateFeedback(for: .successLight)
                    if let target = target {
                        withAnimation {
                            value.scrollTo(target, anchor: .center)
                        }
                    }
                }
                
            }
        }
    }
}


#Preview {
    HomeView()
}
