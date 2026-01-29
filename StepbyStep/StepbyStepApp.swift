//
//  StepbyStepApp.swift
//  StepbyStep
//
//  Created by Melis Boyacı on 26.01.2026.
//

import SwiftUI

@main
struct StepbyStepApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
