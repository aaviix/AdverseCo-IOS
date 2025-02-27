//
//  AdverseCoApp.swift
//  AdverseCo
//
//  Created by Avanish Singh on 27.02.25.
//

import SwiftUI

@main
struct AdverseCoApp: App {
    @StateObject var adStore = AdStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(adStore)  // Provide AdStore to all child views
        }
    }
}
