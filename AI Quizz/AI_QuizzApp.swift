//
//  AI_QuizzApp.swift
//  AI Quizz
//
//  Created by Richard Lam on 2/5/2024.
//

import SwiftUI
import SwiftData

@main
struct AI_QuizzApp: App {
    @AppStorage("host") var host = DefaultValues.host
    @AppStorage("port") var port = DefaultValues.port
    @AppStorage("timeoutRequest") var timeoutRequest = DefaultValues.timeoutRequest
    @AppStorage("timeoutResource") var timeoutResource = DefaultValues.timeoutResource
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
        .modelContainer(sharedModelContainer)
    }

}
