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
    var body: some Scene {
        WindowGroup {
           let container = try! ModelContainer(for: UserTask.self)
           let viewModel = TasksViewModel(context: container.mainContext)
           
           MainTabView()
               .modelContainer(container)
               .environmentObject(viewModel)
       }
    }
}
