//
//  WeekDatePickerView.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 19/05/25.
//

import SwiftUI

struct WeekDatePickerView: View {
    @State private var selectedDate = Date()

    @State private var currentWeekStart: Date = Date().startOfWeek()
    
    let calendar = Calendar.current
    private let daysOfWeek = ["D", "S", "T", "Q", "Q", "S", "S"]
    var today: Date { calendar.startOfDay(for: Date()) } // Data atual sem hora
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(selectedDate.formattedHeaderDate())
                    .font(.headline)
                    .foregroundStyle(Color("LightGray"))

                Spacer()
                
                HStack(spacing: 28) {
                    Button(action: {
                        if currentWeekStart == today.startOfWeek() {
                            return
                        }
                        currentWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart)!
                        
                        let previousWeekDate = calendar.date(byAdding: .day, value: -7, to: selectedDate)!
                                                    
                        if previousWeekDate >= today {
                            selectedDate = previousWeekDate
                        } else {
                            selectedDate = today
                        }
                        
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        generator.impactOccurred()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                            .opacity(currentWeekStart == today.startOfWeek() ? 0.3 : 1)
                    }
                    .disabled(currentWeekStart == today.startOfWeek())

                    Button(action: {
                        currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
                        
                        selectedDate = calendar.date(byAdding: .day, value: 7, to: selectedDate)!
                        
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        generator.impactOccurred()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("Primary"))
                    }
                }
            }
            
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    let day = calendar.date(byAdding: .day, value: index, to: currentWeekStart)!
                    let isPastDay = day < today // Verifica se o dia é anterior ao atual
                    
                    VStack {
                        Text(daysOfWeek[index])
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(Color("Gray"))
                        Text("\(calendar.component(.day, from: day))")
                            .font(.headline)
                            .frame(width: 36, height: 36)
                            .background(calendar.isDate(day, inSameDayAs: selectedDate) ? Color("Primary") : Color.clear)
                            .foregroundStyle(!calendar.isDate(day, inSameDayAs: Date()) || calendar.isDate(day, inSameDayAs: selectedDate) ? .white : Color("Primary"))
                            .clipShape(Circle())
                            .onTapGesture {
                                if !isPastDay && day != selectedDate { // Só permite seleção se não for um dia passado e se não estiver selecionado
                                    selectedDate = day
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.prepare()
                                    generator.impactOccurred()
                                }
                            }
                            .opacity(isPastDay ? 0.2 : 1.0) // Reduz opacidade se for um dia passado
                        
                    }
                    .frame(maxWidth: .infinity) // Ocupa espaço igual
                    .disabled(isPastDay) // Desabilita interação
                    .animation(.easeInOut(duration: 0.2), value: selectedDate)
                    
                }
            }
            
        }
    }
}

extension Date {
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var previewDate = Date()

        var body: some View {
            WeekDatePickerView()
        }
    }

    return PreviewWrapper()
}
