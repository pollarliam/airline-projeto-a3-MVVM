//
//  wheretoApp.swift
//  whereto
//
//  Created by Ramael Cerqueira on 2025/9/17.
//

import SwiftUI
import SwiftData
import AppKit

@main
struct wheretoApp: App {
    @State private var isShowingHealthAlert: Bool = false
    @State private var healthMessage: String = ""

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
            MainView()
                .alert("Backend Health", isPresented: $isShowingHealthAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(healthMessage)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .modelContainer(sharedModelContainer)
        .commands {
            CommandMenu("Debug") {
                Button("Check Backend Health") {
                    Task { @MainActor in
                        let service = FlightsService()
                        do {
                            let result = try await service.health()
                            healthMessage = result.description
                        } catch {
                            healthMessage = error.localizedDescription
                        }
                        isShowingHealthAlert = true
                    }
                }
                .keyboardShortcut("h", modifiers: [.command, .shift])
            }
        }
    }
}
