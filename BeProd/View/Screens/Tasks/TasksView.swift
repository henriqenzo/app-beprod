

import SwiftUI
import SwiftData

struct TasksView: View {
        
    // Instância do ViewModel (gerencia o estado)
    @EnvironmentObject var viewModel: TasksViewModel
    
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea() //Adiciona bgColor para a tela (ignorando a safeArea)
            
            VStack(spacing: 0) {
                
                HeaderTasksView()
                    .environmentObject(viewModel)
                
                if viewModel.segmentSelected == 0 {
                    RoutineTasksView()
                        .environmentObject(viewModel)
                }
                else {
                    EventualTasksView()
                        .environmentObject(viewModel)
                }
                
            }
            
        }

    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let viewModel = TasksViewModel(context: container.mainContext)

            return TasksView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }

    return PreviewWrapper()
}

