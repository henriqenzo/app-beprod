//
//  BeProdApp.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 13/05/25.
//

import SwiftUI
import SwiftData

@main
struct BeProdApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: UserTask.self, DailyHistory.self)
        } catch {
            fatalError("Falha ao configurar o ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(container)
                .environmentObject(TasksViewModel(context: container.mainContext))
                .environmentObject(ConstancyViewModel(context: container.mainContext))
        }
    }
}
