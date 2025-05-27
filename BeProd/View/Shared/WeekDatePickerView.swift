//
//  WeekDatePickerView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 19/05/25.
//

import SwiftUI
import SwiftData

struct WeekDatePickerView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserTask.sortIndex) private var tasks: [UserTask]
    
    @EnvironmentObject var viewModel: TasksViewModel
    
    @State private var currentWeekStart: Date = Date().startOfWeek()
    
    let calendar = Calendar.current
    private let daysOfWeek = ["D", "S", "T", "Q", "Q", "S", "S"]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(viewModel.selectedDate.formattedHeaderDate())
                    .font(.headline)
                    .foregroundStyle(Color("LightGray"))

                Spacer()
                
                HStack(spacing: 28) {
                    Button(action: {
                        if currentWeekStart == viewModel.currentDay.startOfWeek() {
                            return
                        }
                        currentWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart)!
                        
                        let previousWeekDate = calendar.date(byAdding: .day, value: -7, to: viewModel.selectedDate)!
                                                    
                        if previousWeekDate >= viewModel.currentDay {
                            viewModel.selectedDate = previousWeekDate
                        } else {
                            viewModel.selectedDate = viewModel.currentDay
                        }
                        
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        generator.impactOccurred()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                            .opacity(currentWeekStart == viewModel.currentDay.startOfWeek() ? 0.3 : 1)
                    }
                    .disabled(currentWeekStart == viewModel.currentDay.startOfWeek())

                    Button(action: {
                        currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
                        
                        viewModel.selectedDate = calendar.date(byAdding: .day, value: 7, to: viewModel.selectedDate)!
                        
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        generator.impactOccurred()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                    }
                }
            }
            
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    let day = calendar.date(byAdding: .day, value: index, to: currentWeekStart)!
                    let dayWithoutTime = calendar.startOfDay(for: day)
                    let isPastDay = day < viewModel.currentDay // Verifica se o dia é anterior ao atual
                    let hasTask = checkIfHasTask(dayWithoutTime: dayWithoutTime)
                    
                    VStack {
                        Text(daysOfWeek[index])
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(Color("Gray"))
                        
                        VStack(spacing: 4) {
                            Text("\(calendar.component(.day, from: dayWithoutTime))")
                                .font(.headline)
                                .frame(width: 36, height: 36)
                                .background(calendar.isDate(day, inSameDayAs: viewModel.selectedDate) ? Color("Primary") : Color.clear)
                                .foregroundStyle(!calendar.isDate(day, inSameDayAs: Date()) || calendar.isDate(day, inSameDayAs: viewModel.selectedDate) ? .white : Color("Primary"))
                                .clipShape(Circle())
                                .onTapGesture {
                                    if !isPastDay && day != viewModel.selectedDate { // Só permite seleção se não for um dia que já passou e se não estiver selecionado
                                        viewModel.selectedDate = dayWithoutTime
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.prepare()
                                        generator.impactOccurred()
                                    }
                                }
                                .opacity(isPastDay ? 0.2 : 1.0) // Reduz opacidade se for um dia que já passou
                            
                            HStack {
                                if hasTask {
                                    Circle()
                                        .frame(width: 4, height: 4)
                                        .foregroundStyle(Color("Primary"))
                                }
                            }
                            .frame(height: 8)
                        }
                    }
                    .frame(maxWidth: .infinity) // Ocupa espaço igual
                    .disabled(isPastDay) // Desabilita interação
                    .animation(.easeInOut(duration: 0.2), value: viewModel.selectedDate)
                    
                }
            }
            
        }
    }
    
    func checkIfHasTask(dayWithoutTime: Date) -> Bool {
        // Verifica se existe pelo menos uma task que atende aos critérios
        return tasks.contains { task in
            // Verifica se é uma task eventual
            guard task.isEventual else { return false }
            
            // Variável com a data de criação sem o tempo
            let createdDateWithoutTime = Calendar.current.startOfDay(for: task.createdDate!)
            
            // Compara os dias e retorna true ou false
            return createdDateWithoutTime == dayWithoutTime
        }
    }
}

extension Date {
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var previewDate = Date()

        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let viewModel = TasksViewModel(context: container.mainContext)

            return WeekDatePickerView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }

    return PreviewWrapper()
}
