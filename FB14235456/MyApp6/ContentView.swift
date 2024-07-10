//
//  ContentView.swift
//  MyApp6
//
//  Created by Jinwoo Kim on 7/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresenting = false
    @State private var sheetSize: CGSize = .init(width: 300.0, height: 300.0)
    
    var body: some View {
        Button("Present View") {
            isPresenting = true
        }
        .sheet(isPresented: $isPresenting, onDismiss: {
            sheetSize = .init(width: 300.0, height: 300.0)
        }) {
            VStack {
                Button("Set 200") {
                    withAnimation {
                        sheetSize = .init(width: 200.0, height: 200.0)
                    }
                }
                
                Button("Set 400") {
                    withAnimation {
                        sheetSize = .init(width: 400.0, height: 400.0)
                    }
                }
            }
            .padding()
            .frame(idealWidth: sheetSize.width, idealHeight: sheetSize.height)
            .presentationSizing(.fitted.sticky(horizontal: false, vertical: true))
        }
    }
}

#Preview {
    ContentView()
}
