

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
                    
                    VStack(spacing: 20) {
                        CustomCalendarView()
                            .onAppear(perform: resetSelectedMonth)
                            .padding(.horizontal, 16)
                        
                        Divider()
                            .background(Color.secondary)
                        
                        VStack(spacing: 20) {
                            
                            Text("Tarefas concluídas (%)").font(.system(size: 16))
                            
                            HStack(spacing: 36) {
                                VStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color("Primary"))
                                    
                                    Text("80+")
                                        .font(.system(size: 14))
                                }
                                .frame(minWidth: 50)
                                
                                VStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color("Primary").opacity(0.6))
                                    
                                    Text("50-79")
                                        .font(.system(size: 14))
                                }
                                
                                VStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color("Primary").opacity(0.2))
                                    
                                    Text("20-49")
                                        .font(.system(size: 14))
                                }
                            }
                            
                        }
                        .padding(.horizontal, 16)
                        
                    }
                    .padding(.vertical, 16)
                    .background(Color("Gray3"))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                // Excluir depois dos testes
//                ScrollView {
//                    if history.isEmpty {
//                        Text("Histórico vazio")
//                            .foregroundStyle(Color.red)
//                    } else {
//                        Text("Tem histórico")
//                            .foregroundStyle(Color.green)
//                        ForEach(history) { historyOfDay in
//                            VStack {
//                                Text("Data: \(historyOfDay.date)")
//                                Text("Completadas: \(historyOfDay.completedTasks)")
//                                Text("Total de tasks: \(historyOfDay.totalTasks)")
//                                Text("\(historyOfDay.percentual)%")
//                                    .foregroundStyle(Color("Primary"))
//                            }
//                        }
//                    }
//                }
                
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
        }
       
    }
    
    func resetSelectedMonth() {
        viewModel.currentMonthDisplayed = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
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
