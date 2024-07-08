//
//  MyAppApp.swift
//  MyApp
//
//  Created by Jinwoo Kim on 7/1/24.
//

import SwiftUI

@main
struct MyAppApp: App {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Button("Open New Window") { 
                    openWindow(id: "FooID") // Pressing button will trigger infinite loop
                }
            }
        }
        
        WindowGroup("Secondary", id: "FooID") { 
            WindowVisibilityToggle(windowID: "FooID")
        }
    }
}
