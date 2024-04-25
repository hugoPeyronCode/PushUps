//
//  xMark.swift
//  PushUps
//
//  Created by Hugo Peyron on 25/04/2024.
//

import SwiftUI

struct xMark: View {
    
    let action : DismissAction
    
    init(_ action: DismissAction) {
        self.action = action
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {action()}, label: {
                    Image(systemName: "xmark")
                        .bold()
                        .foregroundStyle(.white)
                })
                .padding()
                Spacer()
            }
        }
    }
}
