//
//  HomeView.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    
    let days = (1...100).map { Day(id: $0, goal: 50) }
    
    @State private var selectedDayID: Int?
    
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { value in
                    LazyVStack(spacing: 30) {
                        ForEach(days) { day in
                            DayButton(count: day.id, color: viewModel.updateDayState(dayID: day.id))
                            RoundedSpacer(color: .gray)
                        }
                    }
                    .offset(y: 60)
                    .onAppear {
                        withAnimation {
                            value.scrollTo(viewModel.currentDay, anchor: .center) // Scroll to the current day
                        }
                    }
                }
            }
            
            VStack {
                Header
//                Text(viewModel.currentDay.description)

                Spacer()
                
                GoToPushupViewButton
                
//                Button("Change Start Date") {
//                    showingDatePicker.toggle()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePicker("Select Start Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { newDate in
                    viewModel.setStartDate(date: newDate)
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
            // Trigger push up view
        } label: {
            RoundedRectangle(cornerRadius: 25)
                .frame(maxHeight: 100)
                .foregroundStyle(.pink)
                .overlay {
                    Text("Do Some Pushups!".uppercased())
                        .foregroundStyle(.white)
                        .fontWeight(.black)
                        .font(.title)
                }
        }
        .padding()
    }
    
}

#Preview {
    HomeView()
}
