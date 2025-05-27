//
//  ConstancyViewModel.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 24/05/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class ConstancyViewModel: ObservableObject {
    
    private var modelContext: ModelContext
        
    init(context: ModelContext) {
        self.modelContext = context
    }

    func saveHistory(tasks: [UserTask]) {
        
        let allRoutineTasks = tasks.filter { !$0.isEventual }
        let completedTasks = allRoutineTasks.filter { $0.completed }.count
        let totalTasks = allRoutineTasks.count
        let percentual = totalTasks > 0 ? Int(round(Double(completedTasks) / Double(totalTasks) * 100)) : 0
        
        let today = Calendar.current.startOfDay(for: Date())
        
        let predicate = #Predicate<DailyHistory> { $0.date == today }
        let descriptor = FetchDescriptor<DailyHistory>(predicate: predicate)
        
        if let todayHistory = (try? modelContext.fetch(descriptor))?.first {
            todayHistory.completedTasks = completedTasks
            todayHistory.totalTasks = totalTasks
            todayHistory.percentual = percentual
        } else {
            let newEntry = DailyHistory(
                date: today,
                completedTasks: completedTasks,
                totalTasks: totalTasks,
                percentual: percentual
            )
            modelContext.insert(newEntry)
        }
        
    }
    
    //        print("Last History Save: \(lastHistorySave)")
    //        print("Data do histórico: \(Calendar.current.startOfDay(for: lastHistorySave))")
    //        print("Completadas: \(completedTasks)")
    //        print("Tasks Totais: \(totalTasks)")
    //        print("Porcentagem de completadas: \(percentual)")

}

