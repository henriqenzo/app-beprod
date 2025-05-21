//
//  TaskViewModel.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 15/05/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class TasksViewModel: ObservableObject {
    
    private var modelContext: ModelContext
        
    init(context: ModelContext) {
        self.modelContext = context
    }
    
    @Published var segmentSelected = 0
    @Published var showingTimePicker = false
    
    @Published var showingAddTaskModal = false {
       didSet {
           if !showingAddTaskModal {
               // Sempre que a modal é fechada (de qualquer maneira), reseta o estado de edição
               resetEditingState()
           }
       }
    }
    
    // Propriedades do formulário
    @Published var newTaskTitle = ""
    @Published var newTaskDurationHours = 0
    @Published var newTaskDurationMinutes = 0
    @Published var newTaskPriority = "Nenhuma"
    @Published var completed: Bool = false
    
    // Propriedades de edição
    @Published var isEditing = false
    @Published var editingTask: UserTask?
    
    
        
    // Função para preparar nova tarefa
    func prepareForNewTask() {
        resetEditingState()
        showingTimePicker = false
        showingAddTaskModal = true
    }
    
    // Função prepara para editar tarefa
    func prepareForEdit(task: UserTask) {
        isEditing = true
        editingTask = task
        
        newTaskTitle = task.title
        newTaskDurationHours = task.durationHours
        newTaskDurationMinutes = task.durationMinutes
        newTaskPriority = task.priority
        
        showingTimePicker = task.hasDuration // Define o estado baseado na tarefa
        showingAddTaskModal = true // Abre Modal
    }
    
    // Função cria tarefa
    func addOrEditTask() {
        guard !newTaskTitle.isEmpty else { return }
        
        if isEditing, let taskToEdit = editingTask {
            taskToEdit.title = newTaskTitle
            taskToEdit.durationHours = showingTimePicker ? newTaskDurationHours : 0
            taskToEdit.durationMinutes = showingTimePicker ? newTaskDurationMinutes : 0
            taskToEdit.priority = newTaskPriority
            taskToEdit.completed = completed
            // Não precisa inserir novamente, já está no contexto
        } else {
            let newTask = UserTask(
                title: newTaskTitle,
                durationHours: showingTimePicker ? newTaskDurationHours : 0,
                durationMinutes: showingTimePicker ? newTaskDurationMinutes : 0,
                priority: newTaskPriority,
                completed: completed,
                isEventual: segmentSelected == 1
            )
            modelContext.insert(newTask)
        }

        // Tenta salvar
        try? modelContext.save()

        clearForm()
        showingAddTaskModal = false
    }

    // Função remover tarefa pelo id
    func deleteTask(_ task: UserTask) {
        withAnimation {
            modelContext.delete(task)
            try? modelContext.save()
        }
    }
    
    // Função limpa os campos do formulário
    func clearForm() {
        newTaskTitle = ""
        newTaskDurationHours = 0
        newTaskDurationMinutes = 0
        newTaskPriority = "Nenhuma"
        completed = false
    }
    
    // Função ordena as tasks na lista
    func moveTask(_ tasks: [UserTask], from source: IndexSet, to destination: Int) {
        var updatedTasks = tasks
        updatedTasks.move(fromOffsets: source, toOffset: destination)

        for (index, task) in updatedTasks.enumerated() {
            task.sortIndex = index
        }

        try? modelContext.save()
    }
    
    // Função reseta estado de edição
    func resetEditingState() {
        isEditing = false
        editingTask = nil
        clearForm()
    }
    
}
