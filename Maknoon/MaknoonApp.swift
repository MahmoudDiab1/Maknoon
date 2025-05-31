//
//  MaknoonApp.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 31/05/2025.
//

import SwiftUI

@main
struct MaknoonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
