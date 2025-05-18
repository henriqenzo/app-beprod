//
//  HeaderTasksView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 14/05/25.
//

import SwiftUI

struct HeaderTasksView: View {
    
    // Usa o mesmo ViewModel
    @EnvironmentObject var viewModel: TasksViewModel
    
    @Binding var selected: Int
    
    init(selected: Binding<Int>) {
        self._selected = selected
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
                            Picker(selection: $selected, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                                Text("Cotidianas").font(.largeTitle).tag(0)
                                Text("Eventuais").tag(1)
                            }
                                .pickerStyle(.segmented)
                                .frame(width: 221)
                            
                                    
                            Spacer()
                            
                            Button(action: {
                                viewModel.showingAddTaskModal = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color("Primary"))
                            }
                            
                            
                        }
                        Text("02 mai. | Sexta-feira")
                            .font(.headline)
                            .foregroundStyle(Color("LightGray"))
                        
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
        @State private var selected = 0
        let mockViewModel = TasksViewModel()
        
        var body: some View {
            HeaderTasksView(selected: $selected)
                .environmentObject(mockViewModel)
        }
    }
    
    return PreviewWrapper()
}
