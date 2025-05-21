//
//  HeaderTasksView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 14/05/25.
//

import SwiftUI
import SwiftData

struct HeaderTasksView: View {
    
    // Usa o mesmo ViewModel
    @EnvironmentObject var viewModel: TasksViewModel
    
    init() {
        // Customização do segmented control
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("Primary"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            // Header
            VStack(spacing: 16) {
                
                VStack(spacing: 38) {
                    
                    Text("Tarefas").font(.headline)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Picker(selection: $viewModel.segmentSelected, label: Text("Picker")) {
                                Text("Cotidianas").font(.largeTitle).tag(0)
                                Text("Eventuais").tag(1)
                            }
                                .pickerStyle(.segmented)
                                .frame(width: 221)
                            
                                    
                            Spacer()
                            
                            Button(action: {
                                viewModel.prepareForNewTask()
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color("Primary"))
                            }
                            
                            
                        }
                        
                        if viewModel.segmentSelected == 0 {
                            Text(Date().formattedHeaderDate())
                                .font(.headline)
                                .foregroundStyle(Color("LightGray"))
                        }
                        
                        if viewModel.segmentSelected == 1 {
                            WeekDatePickerView()
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
                
                Divider()
                    .background(Color("Gray3"))
                
            }
            .padding(.top, 8)
            
        }
        
        .sheet(isPresented: $viewModel.showingAddTaskModal) {
            AddTaskModalView()
                .environmentObject(viewModel)
        }
        
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let viewModel = TasksViewModel(context: container.mainContext)

            return HeaderTasksView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }

    return PreviewWrapper()
}
