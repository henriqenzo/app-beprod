

import SwiftUI

struct TasksView: View {
        
    // Instância do ViewModel (gerencia o estado)
    @StateObject var viewModel = TasksViewModel()
    
    @State var selected = 0
    
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea() //Adiciona bgColor para a tela (ignorando a safeArea)
            
            VStack(spacing: 0) {
                
                HeaderTasksView(selected: $selected)
                    .environmentObject(viewModel)
                
                if selected == 0 {
                    RoutineTasksView()
                        .environmentObject(viewModel)
                } else {
                    EventualTasksView()
                        .environmentObject(viewModel)
                }
                
            }
            
        }

    }
}

#Preview {
    TasksView()
}
