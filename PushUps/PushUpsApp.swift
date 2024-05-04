//
//  PushUpsApp.swift
//  PushUps
//
//  Created by Hugo Peyron on 03/03/2024.
//

import SwiftUI

@main
struct PushUpsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear{
                    HapticManager.shared.prepareHaptic()
                }
        }
    }
}
