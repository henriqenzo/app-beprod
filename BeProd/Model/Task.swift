//
//  Task.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 15/05/25.
//

import Foundation

struct UserTask: Identifiable, Codable {
    let id: UUID
    var title: String
    var durationHours: Int
    var durationMinutes: Int
    var priority: String
    var completed: Bool
    
    // Inicializador com valores padrão
    init(id: UUID = UUID(), title: String, durationHours: Int = 0, durationMinutes: Int = 0, priority: String = "Nenhuma", completed: Bool = false) {
        self.id = id
        self.title = title
        self.durationHours = durationHours
        self.durationMinutes = durationMinutes
        self.priority = priority
        self.completed = completed
    }
    
}
