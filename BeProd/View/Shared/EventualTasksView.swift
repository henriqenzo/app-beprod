

import SwiftUI
import SwiftData

struct EventualTasksView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserTask.sortIndex) private var tasks: [UserTask]
    
    @EnvironmentObject var viewModel: TasksViewModel
    
    init() {
        // Muda a cor de fundo do item selecionado do segmentedControl
        UISegmentedControl.appearance().selectedSegmentTintColor = .primary
    }
    
    func handleOpenAddTaskModal() {
        print("Abriu modal.")
    }
    
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
                                if createdDateWithoutTime == viewModel.selectedDate {
                                    // Renderiza a tarefa
                                    TaskRowView(task: task)
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                viewModel.deleteTask(task)
                                            } label: {
                                                Image(systemName: "trash.fill")
                                            }
                                            .tint(.red)
                                            
                                            Button {
                                                viewModel.prepareForEdit(task: task)
                                            } label: {
                                                Image(systemName: "pencil").font(.system(size: 26))
                                            }
                                            .tint(.gray)
                                        }
                                }
                            } else {
                                // Renderiza a tarefa
                                TaskRowView(task: task)
                                    .opacity(0.4)
                            }
                            
                        }
                        .onMove { indices, newOffset in
                            viewModel.moveTask(tasks, from: indices, to: newOffset)
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
}

#Preview {
    EventualTasksView()
        .modelContainer(for: UserTask.self, inMemory: true)
}
