//
//  MyApp2App.swift
//  MyApp2
//
//  Created by Jinwoo Kim on 7/10/24.
//

import SwiftUI

@main
struct MyApp2App: App {
    @State private var isPopoverPresented = false
    
    var body: some Scene {
        WindowGroup {
            TabView { 
                Tab("Red", systemImage: "1.circle.fill") { 
                    Color.red
                }
                Tab("Blue", systemImage: "2.circle.fill") { 
                    Color.blue
                }
                Tab("Pink", systemImage: "3.circle.fill") { 
                    Color.pink
                }
                .popover(isPresented: $isPopoverPresented) { 
                    Color.cyan
                }
            }
            .overlay { 
                Button("Popover") { 
                    isPopoverPresented = true
                }
            }
        }
    }
}
