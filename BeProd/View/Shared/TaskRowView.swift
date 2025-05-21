//
//  TaskRowView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 16/05/25.
//

import SwiftUI

struct TaskRowView: View {
    var task: UserTask
   @Binding var isInEventualView: Bool
   
   @Environment(\.modelContext) private var modelContext
    
    var durationFormatted: String {
        if task.durationHours != 0 && task.durationMinutes == 0 {
            return "\(task.durationHours)h"
        } else if task.durationHours != 0 && task.durationMinutes == 5 {
            return "\(task.durationHours)h0\(task.durationMinutes)m"
        } else if task.durationHours == 0 && task.durationMinutes != 0 {
            return "\(task.durationMinutes)m"
        } else if task.durationHours == 0 && task.durationMinutes == 0 {
            return "-"
        }
        else {
            return "\(task.durationHours)h\(task.durationMinutes)m"
        }
    }
    
    var priorityExclamations: String {
        task.priority == "Alta" ? "!!!" : task.priority == "Média" ? "!!" : task.priority == "Baixa" ? "!" : ""
    }
    
    var body: some View {

            HStack {
                HStack(spacing: 12) {
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: task.completed ? .soft : .medium)
                        generator.prepare()
                        generator.impactOccurred()
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                            task.completed.toggle()
                        }
                        
                        try? modelContext.save() // salva a alteração no contexto
                    }) {
                        Image(systemName: task.completed ? "checkmark.square.fill" : "square")
                            .font(.system(size: 26))
                            .foregroundStyle(task.isEventual ? Color("Primary") : Color("Gray"))
                            .rotationEffect(.degrees(task.completed ? 0 : -180))
                            .scaleEffect(task.completed ? 1.0 : 1.1)
                    }
                    .disabled(isInEventualView)
                    .buttonStyle(PlainButtonStyle()) // <- evita efeitos extras do botão
                    
                    HStack(spacing: 0) {
                        Text(priorityExclamations).foregroundStyle(Color("Primary"))
                        Text(task.title)
                    }
                    
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 22))
                        .foregroundStyle(durationFormatted == "-" ? Color("Gray3") : Color("Gray"))
                    Text("\(durationFormatted)")
                        .foregroundStyle(durationFormatted == "-" ? Color("Gray3") : Color(.label))
                        .frame(width: 58)
                }
                
            }
            .padding(.vertical, 16)
            .opacity(task.completed ? 0.4 : 1)

    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var task = UserTask(title: "Estudar Swift", durationHours: 1, durationMinutes: 0, priority: "Nenhuma", completed: false, isEventual: true
        )
        @State private var isInEventualView = false

        var body: some View {
            TaskRowView(task: task, isInEventualView: $isInEventualView)
        }
    }
    
    return PreviewWrapper()
}
