//
//  AddTaskModalView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 14/05/25.
//

import SwiftUI

struct AddTaskModalView: View {
    
    // Usa o mesmo ViewModel
    @EnvironmentObject var viewModel: TasksViewModel
    
    var durationFormatted: String {
        let hours = viewModel.newTaskDurationHours
        let minutes = viewModel.newTaskDurationMinutes
        
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
                    viewModel.showingAddTaskModal = false
                }) {
                    Text("Cancelar").foregroundStyle(Color("Primary"))
                }
                
                Spacer()
                
                Text(viewModel.isEditing ? "Editar Tarefa" : "Adicionar Tarefa").font(.headline)
                
                Spacer()
                
                Button(action: {
                    viewModel.addTask()
                    
                }) {
                    Text("Salvar").foregroundStyle(Color("Primary")).fontWeight(.semibold)
                }
            }
            
            VStack(spacing: 0) {
                
                HStack {
                    Text("Etiqueta").font(.body)
                    Spacer()
                    TextField("Tarefa", text: $viewModel.newTaskTitle)
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
                    Picker(selection: $viewModel.newTaskPriority, label: EmptyView()) {
                        Text("Nenhuma").tag("Nenhuma")
                        Divider()
                        Text("Baixa").tag("Baixa")
                        Text("Média").tag("Média")
                        Text("Alta").tag("Alta")
                    }
                    .tint(viewModel.newTaskPriority == "Nenhuma" ? Color("Placeholder") : Color.secondary)
                    .frame(height: 22)
                }
                .frame(height: 44)
                .padding(.vertical, 6)
                
                Divider().background(Color("Gray2"))
                
                HStack {
                    Toggle(isOn: $viewModel.showingTimePicker) {
                        Text("Duração").font(.body)
                        
                        if viewModel.showingTimePicker {
                            Text("\(durationFormatted)").font(.subheadline).foregroundStyle(Color("Primary"))
                        }
                    }
                }
                .frame(height: 44)
                .padding(.vertical, 6)
                .padding(.trailing)
                
                Divider().background(Color("Gray2"))
                
                if viewModel.showingTimePicker {
                    TimePickerView()
                        .environmentObject(viewModel)
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
        
    }
}

#Preview {
    // Cria uma instância mock do ViewModel para o preview
        let mockViewModel = TasksViewModel()
        
        // Injeta o ViewModel na hierarquia do preview
        return AddTaskModalView()
            .environmentObject(mockViewModel)
}
