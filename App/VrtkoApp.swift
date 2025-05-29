//
//  VrtkoApp.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 27.05.2025..
//

import SwiftUI
import FirebaseCore

@main
struct VrtkoApp: App {
    
    // Initialize Firebase when app starts
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
