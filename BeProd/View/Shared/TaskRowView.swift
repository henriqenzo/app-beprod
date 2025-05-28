//
//  TaskRowView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 16/05/25.
//

import SwiftUI
import SwiftData

struct TaskRowView: View {
    
    var task: UserTask
   
    @Query(sort: \UserTask.sortIndex) private var tasks: [UserTask]
    
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @EnvironmentObject var constancyViewModel: ConstancyViewModel
    
    var durationFormatted: String {
        if task.durationHours != 0 && task.durationMinutes == 0 {
            return "\(task.durationHours)h"
        } else if task.durationHours != 0 && task.durationMinutes == 5 {
            return "\(task.durationHours)h0\(task.durationMinutes)m"
        } else if task.durationHours == 0 && task.durationMinutes != 0 {
            return "\(task.durationMinutes)m"
        } else if task.durationHours == 0 && task.durationMinutes == 0 {
            return "-"
        }
        else {
            return "\(task.durationHours)h\(task.durationMinutes)m"
        }
    }
    
    var priorityExclamations: String {
        task.priority == "Alta" ? "!!!" : task.priority == "Média" ? "!!" : task.priority == "Baixa" ? "!" : ""
    }
    
    var body: some View {

            HStack {
                HStack(spacing: 12) {
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: task.completed ? .soft : .medium)
                        generator.prepare()
                        generator.impactOccurred()
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                            task.completed.toggle()
                            if !task.isEventual {
                                constancyViewModel.saveHistory(tasks: tasks)
                            }
                        }
                    }) {
                        Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                            .font(.system(size: 26))
                            .foregroundStyle(task.isEventual ? Color("Primary") : Color("Gray"))
                            .rotationEffect(.degrees(task.completed ? 0 : -90))
                            .scaleEffect(task.completed ? 1.0 : 1.1)
                    }
                    .disabled(tasksViewModel.segmentSelected == 1)
                    .buttonStyle(PlainButtonStyle()) // <- evita efeitos extras do botão
                    
                    HStack(spacing: 0) {
                        Text(priorityExclamations).foregroundStyle(Color("Primary"))
                        Text(task.title)
                    }
                    
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 20))
                        .foregroundStyle(durationFormatted == "-" ? Color("Gray3") : Color("Gray"))
                    Text("\(durationFormatted)")
                        .foregroundStyle(durationFormatted == "-" ? Color("Gray3") : Color(.label))
                        .font(.system(size: 14))
                        .frame(width: 45)
                }
                
            }
            .frame(height: 60)
            .opacity(task.completed ? 0.4 : 1)

    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var task = UserTask(title: "Apresentação trabalho da facul", durationHours: 1, durationMinutes: 50, priority: "Nenhuma", completed: false, isEventual: true
        )

        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let tasksViewModel = TasksViewModel(context: container.mainContext)
            let constancyViewModel = ConstancyViewModel(context: container.mainContext)

            return TaskRowView(task: task)
                .modelContainer(container)
                .environmentObject(tasksViewModel)
                .environmentObject(constancyViewModel)
        }
    }
    
    return PreviewWrapper()
}
