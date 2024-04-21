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
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.days) { day in
                                DayButton(homeViewModel: viewModel, dayIndex: day.id)
                                    .onTapGesture {
                                        if day.id == viewModel.currentDay {
                                            isNavigatingToPushUpsView.toggle()
                                        }
                                    }
                                RoundedSpacer(color: .gray)
                            }
                        }
                        .offset(y: 60)
                        .onAppear {
                            scrollTarget = viewModel.currentDay
                        }
                        .onChange(of: scrollTarget) { target, uselessArguement in
                            if let target = target {
                                withAnimation {
                                    value.scrollTo(target, anchor: .center)
                                }
                            }
                        }
                        
                    }
                }

                
                VStack {
                    Header
                    Text(viewModel.currentDay.description)

                    Spacer()
                    
                    HStack(spacing: 20){
                        focusButton
                        saveDay
                        resetToTodayButton
                        changeDateButton
                    }
                    
                    GoToPushupViewButton
                    
                }
            }
            .fullScreenCover(isPresented: $isNavigatingToPushUpsView) {
                PushupsView(dayIndex: viewModel.currentDay, homeViewModel: viewModel)
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
            Text("\(100 - viewModel.currentDay) Days Left")
                .font(.title)
                .bold()
            ProgressView("", value: viewModel.progress)
                .tint(.green)
                .progressViewStyle(.linear)
                .padding(.horizontal,2)
        }
        .background(.thinMaterial)
    }
    
    var GoToPushupViewButton: some View {
        Button {
            isNavigatingToPushUpsView.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 25)
                .frame(maxHeight: 100)
                .foregroundStyle(.pink)
                .overlay {
                    HStack {
                        Text("Do Some Pushups!".uppercased())
                        Image(systemName: "figure.strengthtraining.traditional")
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.black)
                    .font(.title)
                }
                .padding()
        }
    }
    
    var focusButton: some View {
        Button("Focus") {
            // Reset the target to ensure SwiftUI sees a change
            scrollTarget = nil
            // Now set the target which triggers the scroll
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scrollTarget = viewModel.currentDay
                print(viewModel.currentDay)
            }
        }
        .padding()
        .foregroundStyle(.blue)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
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

#Preview {
    HomeView()
}
