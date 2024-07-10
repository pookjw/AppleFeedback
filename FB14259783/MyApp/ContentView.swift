//
//  ContentView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 7/10/24.
//

import SwiftUI

@_cdecl("makeSwiftUIContentView") func makeSwiftUIContentView() -> UIViewController {
    MainActor.assumeIsolated { 
        UIHostingController(rootView: ContentView())
    }
}

struct ContentView: View {
    var body: some View {
        TabView { 
            Color.red
                .ignoresSafeArea()
                .tabItem { 
                    Label("Red", systemImage: "1.circle.fill")
                }
            Color.orange
                .ignoresSafeArea()
                .tabItem { 
                    Label("Orange", systemImage: "2.circle.fill")
                }
            Color.yellow
                .ignoresSafeArea()
                .tabItem { 
                    Label("Yellow", systemImage: "3.circle.fill")
                }
                .ignoresSafeArea()
            Color.green
                .ignoresSafeArea()
                .tabItem { 
                    Label("Green", systemImage: "4.circle.fill")
                }
            Color.blue
                .ignoresSafeArea()
                .tabItem { 
                    Label("Blue", systemImage: "5.circle.fill")
                }
            Color.purple
                .ignoresSafeArea()
                .tabItem { 
                    Label("Purple", systemImage: "6.circle.fill")
                }
            Color.pink
                .ignoresSafeArea()
                .tabItem { 
                    Label("Pink", systemImage: "7.circle.fill")
                }
            Color.cyan
                .ignoresSafeArea()
                .tabItem { 
                    Label("Cyan", systemImage: "8.circle.fill")
                }
            Color.gray
                .ignoresSafeArea()
                .tabItem { 
                    Label("gray", systemImage: "9.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
