//
//  SettingsView.swift
//  MyMacApp
//
//  Created by Richard Lam on 28/5/2024.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, models
    }
    
    var body: some View {
        TabView {
            GeneralSettingsView() 
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
    }
}

#Preview {
    SettingsView()
}
