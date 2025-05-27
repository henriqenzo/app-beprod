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
        
//        UserDefaults.standard.set(
//            Calendar.current.date(byAdding: .day, value: -1, to: Date()),
//            forKey: UserDefaults.lastResetDateKey
//        )
        
        checkAndResetTasksIfNeeded()
    }
    
    let calendar = Calendar.current
    @Published var currentDay = Calendar.current.startOfDay(for: Date())
    @Published var selectedDate = Calendar.current.startOfDay(for: Date())
    
    // Para fazer testes alterando o dia atual no app
//    @Published var today = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

    @Published var segmentSelected = 0
    @Published var showingTimePicker = false
    
    @Published var showingAddTaskModal = false {
       didSet {
           if !showingAddTaskModal {
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
    
    
    func checkAndResetTasksIfNeeded() {
        // Para testar: (descomente)
//        let fakeDate = calendar.date(byAdding: .day, value: 1, to: Date())!
//        let today = calendar.startOfDay(for: fakeDate)
        
        let lastReset = UserDefaults.standard.object(forKey: UserDefaults.lastResetDateKey) as? Date
        let lastResetDay = lastReset.map { calendar.startOfDay(for: $0) }
        
        guard lastResetDay != currentDay else {
            return // Já ressetou hoje
        }

        // Fetch tasks do banco
        let descriptor = FetchDescriptor<UserTask>()
        do {
            let allTasks = try modelContext.fetch(descriptor)

            for task in allTasks {
                if task.isEventual {
                    if task.createdDate != nil {
                        guard let createdDate = task.createdDate else { return }
                        let createdDateWithoutTime = calendar.startOfDay(for: createdDate)
                        if createdDateWithoutTime < currentDay {
                            modelContext.delete(task) // Remove do banco
                        }
                    }
                } else {
                    task.completed = false // Reseta a conclusão
                }
            }

            try modelContext.save()
            UserDefaults.standard.set(Date(), forKey: UserDefaults.lastResetDateKey)
        } catch {
            print("Erro ao resetar tarefas diárias: \(error.localizedDescription)")
        }
    }
    
    func prepareForNewTask() {
        resetEditingState()
        showingTimePicker = false
        showingAddTaskModal = true
    }
    
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
    
    func addOrEditTask(for selectedDate: Date) {
        guard !newTaskTitle.isEmpty else { return }
        
        if isEditing, let taskToEdit = editingTask {
            taskToEdit.title = newTaskTitle
            taskToEdit.durationHours = showingTimePicker ? newTaskDurationHours : 0
            taskToEdit.durationMinutes = showingTimePicker ? newTaskDurationMinutes : 0
            taskToEdit.priority = newTaskPriority
        } else {
            guard selectedDate >= Calendar.current.startOfDay(for: Date()) else {
                return
            }
            
            let newTask = UserTask(
                title: newTaskTitle,
                durationHours: showingTimePicker ? newTaskDurationHours : 0,
                durationMinutes: showingTimePicker ? newTaskDurationMinutes : 0,
                priority: newTaskPriority,
                completed: completed,
                isEventual: segmentSelected == 1,
                createdDate: segmentSelected == 1 ? selectedDate : nil
            )
            modelContext.insert(newTask)
        }

        try? modelContext.save()

        clearForm()
        showingAddTaskModal = false
    }

    func deleteTask(_ task: UserTask) {
        withAnimation {
            modelContext.delete(task)
            try? modelContext.save()
        }
    }
    
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
    
    func resetEditingState() {
        isEditing = false
        editingTask = nil
        clearForm()
    }
    
}

extension UserDefaults {
    static let lastResetDateKey = "lastResetDate"
}
