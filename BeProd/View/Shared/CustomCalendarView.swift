//
//  CustomCalendarView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 23/05/25.
//

import SwiftUI
import SwiftData

struct CustomCalendarView: View {
    
    @State private var currentDay = Calendar.current.startOfDay(for: Date())
    
    @Environment(\.modelContext) private var modelContext
    @Query private var history: [DailyHistory]
        
    @EnvironmentObject var viewModel: ConstancyViewModel

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Domingo
        return calendar
    }

    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDay),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }

        let daysCount = calendar.range(of: .day, in: .month, for: currentDay)!.count
        var days: [Date] = []

        // Preenche espaços vazios antes do primeiro dia
        for _ in 0..<(firstWeekday - calendar.firstWeekday) {
            days.append(Date.distantPast) // Dias em branco
        }

        // Preenche dias reais do mês
        for day in 1...daysCount {
            if let date = calendar.date(bySetting: .day, value: day, of: currentDay) {
                let dateWithoutTime = calendar.startOfDay(for: date)
                days.append(dateWithoutTime)
            }
        }

        return days
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "LLLL"
        return formatter.string(from: currentDay).capitalized
    }
    
    private let daysOfWeek = ["D", "S", "T", "Q", "Q", "S", "S"]

    var body: some View {
        VStack(spacing: 32) {
            // Header com troca de mês
            HStack(spacing: 44) {
                
                VStack(spacing: 4) {
                    Text("Mês")
                        .font(.system(size: 14))
                        .foregroundStyle(Color("LightGray"))
                        .animation(.easeInOut(duration: 0.2), value: currentDay)
                    
                    HStack {
                        Button(action: {
                            changeMonth(by: -1)
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22))
                                .fontWeight(.medium)
                                .foregroundStyle(Color("Primary"))
                        }
                        
                        Spacer()

                        Text(monthTitle)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        Spacer()

                        Button(action: {
                            changeMonth(by: 1)
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 22))
                                .fontWeight(.medium)
                                .foregroundStyle(Color("Primary"))
                        }
                    }
                    .frame(width: 150)
                }
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .foregroundStyle(Color("Gray2"))
                    Circle()
                        .trim(from: 0, to: 0.19)
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .square))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .foregroundStyle(Color("Primary"))
                    Text("6 Dias")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                }
                
            }
            
            VStack {
                // Dias da semana
                HStack {
                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                }

                // Dias do mês
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(daysInMonth, id: \.self) { date in
                        if calendar.isDate(date, equalTo: .distantPast, toGranularity: .day) {
                            Color.clear.frame(height: 35)
                        } else {
                            // Verifica se há um historyDay correspondente a esta data
                            if let historyDay = history.first(where: { $0.date == date }) {
                                let dayPerformance = getPerformanceOfDay(percentual: historyDay.percentual)
                                    
                                ZStack {
                                    Circle()
                                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .square))
                                        .foregroundStyle(calendar.isDateInToday(date) ? Color.white : Color.clear)
                                        .frame(width: 44, height: 44)
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .background(
                                            dayPerformance == "bad" ? Color("Primary").opacity(0.3) :
                                            dayPerformance == "medium" ? Color("Primary").opacity(0.55) :
                                            dayPerformance == "good" ? Color("Primary") :
                                            Color.clear
                                        )
                                        .clipShape(Circle())
                                }
                                
                            } else {
                                // Dia sem histórico (Zero tarefas concluídas)
                                ZStack {
                                    Circle()
                                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .square))
                                        .foregroundStyle(calendar.isDateInToday(date) ? Color.white : Color.clear)
                                        .frame(width: 44, height: 44)
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .background(Color.clear)
                                        .clipShape(Circle())
                                }
                            }
                            
                        }
                    }
                }
            }

        }
    }

    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDay) {
            currentDay = newDate
        }
    }
    
    private func getPerformanceOfDay(percentual: Int) -> String {
        switch percentual {
            case 20..<50: "bad"
            case 50..<80: "medium"
            case 80...100: "good"
            default: "nothing"
        }
    }

}

#Preview {
    CustomCalendarView()
}
