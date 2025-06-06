//  20250605
// Entry Point

// @ModelContainer
// Creates the SQLite DB file

import SwiftUI
import SwiftData

@main
struct master_listApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: Item.self) // Creates the DB
    }
}
