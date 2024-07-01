//
//  MyAppApp.swift
//  MyApp
//
//  Created by Jinwoo Kim on 7/1/24.
//

import SwiftUI

@main
struct MyAppApp: App {
    var body: some Scene {
        WindowGroup {
            WindowVisibilityToggle(windowID: "FooID")
        }
        
        WindowGroup("Secondary", id: "FooID") {
            Color.orange
        }
    }
}
