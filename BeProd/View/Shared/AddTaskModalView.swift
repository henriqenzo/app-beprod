//
//  AddTaskModalView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 14/05/25.
//

import SwiftUI
import SwiftData

struct AddTaskModalView: View {
    
    @Query(sort: \UserTask.sortIndex) private var tasks: [UserTask]
    
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @EnvironmentObject var constancyViewModel: ConstancyViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var durationFormatted: String {
        let hours = tasksViewModel.newTaskDurationHours
        let minutes = tasksViewModel.newTaskDurationMinutes
        
        if hours != 0 && minutes == 0 {
            return "\(hours)h"
        } else if hours != 0 && minutes == 5 {
            return "\(hours)h0\(minutes)m"
        } else if hours == 0 && minutes != 0 {
            return "\(minutes)m"
        } else if hours == 0 && minutes == 0 {
            return "0h00m"
        }
        else {
            return "\(hours)h\(minutes)m"
        }
    }
    
    var body: some View {
        
        VStack(spacing: 44) {
            HStack {
                Button(action: {
                    tasksViewModel.showingAddTaskModal = false
                    tasksViewModel.resetEditingState()
                }) {
                    Text("Cancelar").foregroundStyle(Color("Primary"))
                }
                
                Spacer()
                
                Text(tasksViewModel.isEditing ? "Editar Tarefa" : "Adicionar Tarefa").font(.headline)
                
                Spacer()
                
                Button(action: {
                    tasksViewModel.addOrEditTask(for: tasksViewModel.selectedDate)
                    constancyViewModel.saveHistory(tasks: tasks)
                }) {
                    Text("Salvar").foregroundStyle(Color("Primary")).fontWeight(.semibold)
                }
            }
            
            VStack(spacing: 0) {
                
                HStack {
                    Text("Etiqueta").font(.body)
                    Spacer()
                    TextField("Tarefa", text: $tasksViewModel.newTaskTitle)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 229)
                }
                .frame(height: 44)
                .padding(.vertical, 6)
                .padding(.trailing)
                
                Divider().background(Color("Gray2"))
                
                HStack {
                    Text("Prioridade").font(.body)
                    Spacer()
                    Picker(selection: $tasksViewModel.newTaskPriority, label: EmptyView()) {
                        Text("Nenhuma").tag("Nenhuma")
                        Divider()
                        Text("Baixa").tag("Baixa")
                        Text("Média").tag("Média")
                        Text("Alta").tag("Alta")
                    }
                    .tint(tasksViewModel.newTaskPriority == "Nenhuma" ? Color("Placeholder") : Color.secondary)
                    .frame(height: 22)
                }
                .frame(height: 44)
                .padding(.vertical, 6)
                
                Divider().background(Color("Gray2"))
                
                HStack {
                    Toggle(isOn: $tasksViewModel.showingTimePicker) {
                        Text("Duração").font(.body)
                        
                        if tasksViewModel.showingTimePicker {
                            Text("\(durationFormatted)").font(.subheadline).foregroundStyle(Color("Primary"))
                        }
                    }
                }
                .frame(height: 44)
                .padding(.vertical, 6)
                .padding(.trailing)
                
                Divider().background(Color("Gray2"))
                
                if tasksViewModel.showingTimePicker {
                    TimePickerView()
                }
            }
            .padding(.leading)
            .background(Color("Gray3"))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .background(Color("Gray4"))
        .onDisappear {
            // Garante que o estado seja resetado se a modal for fechada pelo gesto
            if tasksViewModel.isEditing {
                tasksViewModel.resetEditingState()
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
            let viewModel = TasksViewModel(context: container.mainContext)

            return AddTaskModalView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }

    return PreviewWrapper()
}
