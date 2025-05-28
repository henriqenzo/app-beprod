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
    
    // Variáveis
    
    @Published var currentDay = Calendar.current.startOfDay(for: Date())
    @Published var currentMonthDisplayed = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Domingo
        return calendar
    }

    var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonthDisplayed),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }

        let daysCount = calendar.range(of: .day, in: .month, for: currentMonthDisplayed)!.count
        var days: [Date] = []

        // Preenche espaços vazios antes do primeiro dia
        for _ in 0..<(firstWeekday - calendar.firstWeekday) {
            days.append(Date.distantPast) // Dias em branco
        }

        // Preenche dias reais do mês
        for day in 1...daysCount {
            if let date = calendar.date(bySetting: .day, value: day, of: currentMonthDisplayed) {
                let dateWithoutTime = calendar.startOfDay(for: date)
                days.append(dateWithoutTime)
            }
        }

        return days
    }
    
    var numberOfDaysInMonth: Int {
        calendar.range(of: .day, in: .month, for: currentMonthDisplayed)?.count ?? 0
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "LLLL"
        return formatter.string(from: currentMonthDisplayed).capitalized
    }
    
    // Funções
    
    func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentMonthDisplayed) {
            currentMonthDisplayed = newDate
        }
    }
    
    func calculateCompletedDays(history: [DailyHistory]) -> Int {
        var routineDaysCompleted = 0
        for date in daysInMonth {
            if !calendar.isDate(date, equalTo: .distantPast, toGranularity: .day) {
                if let historyDay = history.first(where: { $0.date == date }) {
                    if historyDay.percentual >= 80 {
                        routineDaysCompleted += 1
                    }
                }
            }
        }
        return routineDaysCompleted
    }
    
    func getPerformanceOfDay(percentual: Int) -> String {
        switch percentual {
            case 20..<50: "bad"
            case 50..<80: "medium"
            case 80...100: "good"
            default: "nothing"
        }
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

}

