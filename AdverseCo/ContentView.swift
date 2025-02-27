//
//  ContentView.swift
//  AdverseCo
//
//  Created by Avanish Singh on 27.02.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var adStore = AdStore()
    
    var body: some View {
        TabView {
            NavigationView { WebsiteView() }
                .tabItem {
                    Label("Website", systemImage: "globe")
                }
            
            NavigationView {
                AdCreationView()  // uses @EnvironmentObject var adStore
            }
            .tabItem {
                Label("Ads", systemImage: "megaphone")
            }
            
            NavigationView { FounderView() }
                .tabItem {
                    Label("Founder", systemImage: "person.circle")
                }
        }
        .environmentObject(adStore) // Provide it here
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AdStore()) // Provide for preview
    }
}

