//
//  CustomCalendarView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 23/05/25.
//

import SwiftUI
import SwiftData

struct CustomCalendarView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var history: [DailyHistory]
        
    @EnvironmentObject var viewModel: ConstancyViewModel
    
    private var completedDays: Int {
        viewModel.calculateCompletedDays(history: history)
   }
    
    private let daysOfWeek = ["D", "S", "T", "Q", "Q", "S", "S"]

    var body: some View {
        var year: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: viewModel.currentMonthDisplayed)
        }
        
        
        VStack(spacing: 0) {
            
            Text("\(year)")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color("Placeholder"))
                .animation(.easeInOut(duration: 0.3), value: year)
            
            VStack(spacing: 32) {
                // Header com troca de mês
                HStack(spacing: 44) {
                    
                    VStack(spacing: 4) {
                        Text("Mês")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("LightGray"))
                        
                        HStack {
                            Button(action: {
                                viewModel.changeMonth(by: -1)
                                
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                generator.impactOccurred()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 22))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("Primary"))
                            }
                            
                            Spacer()

                            Text(viewModel.monthTitle)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .animation(.bouncy(duration: 0.2), value: viewModel.currentMonthDisplayed)
                            
                            Spacer()

                            Button(action: {
                                viewModel.changeMonth(by: 1)
                                
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.prepare()
                                generator.impactOccurred()
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
                            .trim(from: 0, to: CGFloat(completedDays) / CGFloat(viewModel.numberOfDaysInMonth))
                            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                            .foregroundStyle(Color("Primary"))
                            .animation(.easeInOut(duration: 0.2), value: viewModel.currentMonthDisplayed)
                        Text("\(completedDays) Dias")
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
                        ForEach(viewModel.daysInMonth, id: \.self) { date in
                            if viewModel.calendar.isDate(date, equalTo: .distantPast, toGranularity: .day) {
                                Color.clear.frame(height: 35)
                            } else {
                                // Verifica se há um historyDay correspondente a esta data
                                if let historyDay = history.first(where: { $0.date == date }) {
                                    let dayPerformance = viewModel.getPerformanceOfDay(percentual: historyDay.percentual)
                                        
                                    ZStack {
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .square))
                                            .foregroundStyle(viewModel.calendar.isDateInToday(date) ? Color.white : Color.clear)
                                            .frame(width: 42, height: 42)
                                        Text("\(viewModel.calendar.component(.day, from: date))")
                                            .font(.system(size: 14))
                                            .frame(maxWidth: .infinity, minHeight: viewModel.calendar.isDateInToday(date) ? 35 : 40)
                                            .background(
                                                dayPerformance == "bad" ? Color("Primary").opacity(0.2) :
                                                dayPerformance == "medium" ? Color("Primary").opacity(0.6) :
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
                                            .foregroundStyle(viewModel.calendar.isDateInToday(date) ? Color.white : Color.clear)
                                            .frame(width: 44, height: 44)
                                        Text("\(viewModel.calendar.component(.day, from: date))")
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
    
    }

}

#Preview {
    struct PreviewWrapper: View {
        @State private var previewDate = Date()

        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let viewModel = ConstancyViewModel(context: container.mainContext)

            return CustomCalendarView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }

    return PreviewWrapper()
}

