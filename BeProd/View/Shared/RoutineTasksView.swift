
import SwiftUI
import SwiftData

struct RoutineTasksView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserTask.sortIndex) private var tasks: [UserTask]
    
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @EnvironmentObject var constancyViewModel: ConstancyViewModel
    
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea() //Adiciona bgColor para a tela (ignorando a safeArea)
            
            VStack {
                
                    if tasks.isEmpty {
                        Spacer()
                            .frame(height: 170)
                        Text("Você ainda não possui tarefas...").font(.body).foregroundStyle(Color("Gray"))
                    } else {
                    
                    List {
                        ForEach(tasks) { task in
            
                            if task.isEventual {
                                let createdDateWithoutTime = Calendar.current.startOfDay(for: task.createdDate!)
                                if createdDateWithoutTime == tasksViewModel.currentDay {
                                    // Renderiza a tarefa
                                    TaskRowView(task: task)
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                tasksViewModel.deleteTask(task)
                                            } label: {
                                                Image(systemName: "trash.fill")
                                            }
                                            .tint(.red)
                                            
                                            Button {
                                                tasksViewModel.prepareForEdit(task: task)
                                            } label: {
                                                Image(systemName: "pencil").font(.system(size: 26))
                                            }
                                            .tint(.gray)
                                        }
                                }
                            } else {
                                // Renderiza a tarefa
                                TaskRowView(task: task)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            tasksViewModel.deleteTask(task)
                                            constancyViewModel.saveHistory(tasks: tasks)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                        }
                                        .tint(.red)
                                        
                                        Button {
                                            tasksViewModel.prepareForEdit(task: task)
                                        } label: {
                                            Image(systemName: "pencil").font(.system(size: 26))
                                        }
                                        .tint(.gray)
                                    }
                            }
                            
                        }
                        .onMove { indices, newOffset in
                            tasksViewModel.moveTask(tasks, from: indices, to: newOffset)
                        }
                        .scrollContentBackground(.hidden)
                        .listRowBackground(Color.clear)
                        
                    }
                    .listStyle(.plain) // ou .inset

                }
                
                Spacer()

            }
            
        }
        
    }
    
    private func addTask() {
        withAnimation {
            let newTask = UserTask(title: "Nova Tarefa")
            modelContext.insert(newTask)
        }
    }
}

#Preview {
    RoutineTasksView()
        .modelContainer(for: UserTask.self, inMemory: true)
}
