

import SwiftUI
import SwiftData

struct ConstancyView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserTask.sortIndex) private var tasks: [UserTask]
    @Query private var history: [DailyHistory]
        
    @EnvironmentObject var viewModel: ConstancyViewModel
    
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea() //Adiciona bgColor para a tela (ignorando a safeArea)
            
            VStack {
                
                
                VStack(spacing: 24) {
                    
                    Text("Constância").font(.headline)
                    
                    VStack {
                        CustomCalendarView()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 25)
                    .background(Color("Gray3"))
                    .cornerRadius(10)
                }
                
//                Spacer()
                
                ScrollView {
                    if history.isEmpty {
                        Text("Histórico vazio")
                            .foregroundStyle(Color.red)
                    } else {
                        Text("Tem histórico")
                            .foregroundStyle(Color.green)
                        ForEach(history) { historyOfDay in
                            VStack {
                                Text("Data: \(historyOfDay.date)")
                                Text("Completadas: \(historyOfDay.completedTasks)")
                                Text("Total de tasks: \(historyOfDay.totalTasks)")
                                Text("\(historyOfDay.percentual)%")
                                    .foregroundStyle(Color("Primary"))
                            }
                        }
                    }
                }
//                .padding(.vertical, 20)
                
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
       
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var task = UserTask(title: "Apresentação trabalho da facul", durationHours: 1, durationMinutes: 50, priority: "Nenhuma", completed: false, isEventual: true
        )

        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let viewModel = ConstancyViewModel(context: container.mainContext)

            return ConstancyView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }
    
    return PreviewWrapper()
}
