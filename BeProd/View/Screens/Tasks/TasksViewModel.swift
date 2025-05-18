//
//  TaskViewModel.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 15/05/25.
//

import Foundation
import SwiftUI

class TasksViewModel: ObservableObject {
    
    @Published var tasks: [UserTask] = []
    
    @Published var showingAddTaskModal = false
    @Published var showingTimePicker = false
    
    // Propriedades do formulário
    @Published var newTaskTitle = ""
    @Published var newTaskDurationHours = 0
    @Published var newTaskDurationMinutes = 0
    @Published var newTaskPriority = "Nenhuma"
    @Published var completed: Bool = false
    
    // Propriedades de edição
    @Published var isEditing = false
    @Published var editingTaskId: UUID?
        
    // Função criar tarefa
    func addTask() {
        
        // Validação: título não pode estar vazio
        guard !newTaskTitle.isEmpty else { return }
        
        if isEditing, let taskId = editingTaskId {
            if let index = tasks.firstIndex(where: { $0.id == taskId }) {
                tasks[index] = UserTask(
                    id: taskId, // Mantém o mesmo ID
                    title: newTaskTitle,
                    durationHours: showingTimePicker ? newTaskDurationHours : 0,
                    durationMinutes: showingTimePicker ? newTaskDurationMinutes : 0,
                    priority: newTaskPriority,
                    completed: tasks[index].completed // Mantém o status de completado
                )
            }
        } else {
            // Cria nova task com os dados do formulário
            let newTask = UserTask(
                title: newTaskTitle,
                durationHours: showingTimePicker ? newTaskDurationHours : 0,
                durationMinutes: showingTimePicker ? newTaskDurationMinutes : 0,
                priority: newTaskPriority,
                completed: completed
            )
            
            // Adiciona nova task no array
            tasks.append(newTask)
            print(tasks)
        }
        
        // Limpa formulário
        clearForm()
        
        // Fecha modal
        showingAddTaskModal = false
    }
    
    // Função remover tarefa pelo id
    func deleteTask(withId id: UUID) {
        withAnimation {
            tasks.removeAll { $0.id == id }
        }
        print(tasks)
    }
    
    // Função prepara para editar tarefa
    func prepareForEdit(task: UserTask) {
        isEditing = true
        
        editingTaskId = task.id
    
        newTaskTitle = task.title
        newTaskDurationHours = task.durationHours
        newTaskDurationMinutes = task.durationMinutes
        newTaskPriority = task.priority
        // Abre a modal
        showingAddTaskModal = true
    }
    
    // Função limpa os campos do formulário
    func clearForm() {
        newTaskTitle = ""
        newTaskDurationHours = 0
        newTaskDurationMinutes = 0
        newTaskPriority = "Nenhuma"
        editingTaskId = nil
        completed = false
    }
    
}
