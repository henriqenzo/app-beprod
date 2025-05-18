

import SwiftUI

struct EventualTasksView: View {
    
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
                
                if viewModel.tasks.isEmpty {
                    Spacer()
                        .frame(height: 170)
                    Text("Você ainda não possui tarefas...").font(.body).foregroundStyle(Color("Gray"))
                } else {
                    
                    List {
                        ForEach($viewModel.tasks) { $task in
                            // Renderiza cada tarefa
                            TaskRowView(task: $task)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteTask(withId: task.id)
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
    // Cria uma instância mock do ViewModel para o preview
        let mockViewModel = TasksViewModel()
        
        // Injeta o ViewModel na hierarquia do preview
        return EventualTasksView()
            .environmentObject(mockViewModel)
}
