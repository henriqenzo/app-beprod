//
//  TimePickerView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 14/05/25.
//

import SwiftUI
import SwiftData

struct TimePickerView: View {
    
    @EnvironmentObject var viewModel: TasksViewModel
    
    var minutesOptions: [Int] {
        Array(stride(from: 0, through: 55, by: 5))
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Text("Horas")
                .font(.headline)
                .foregroundColor(Color("LightGray"))
            
            Picker("Horas", selection: $viewModel.newTaskDurationHours) {
                ForEach(0..<25, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 80)

            Picker("Minutos", selection: $viewModel.newTaskDurationMinutes) {
                ForEach(minutesOptions, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 80)
            
            Text("Minutos")
                .font(.headline)
                .foregroundColor(Color("LightGray"))
            
        }
        .frame(width: 300, height: 150) // Altura do picker
        .padding(.vertical, 16)

    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: UserTask.self, configurations: config)
            let viewModel = TasksViewModel(context: container.mainContext)

            return TimePickerView()
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    }

    return PreviewWrapper()
}
