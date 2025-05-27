//
//  Task.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 15/05/25.
//

import Foundation
import SwiftData

@Model
final class UserTask {
    var id: UUID
    var title: String
    var durationHours: Int
    var durationMinutes: Int
    var priority: String
    var completed: Bool
    var isEventual: Bool
    var hasDuration: Bool {
        durationHours > 0 || durationMinutes > 0
    }
    var createdDate: Date? // ← ADICIONE ISTO
    var sortIndex: Int // <- NOVO
    
    // Inicializador com valores padrão
    init(id: UUID = UUID(), title: String, durationHours: Int = 0, durationMinutes: Int = 0, priority: String = "Nenhuma", completed: Bool = false, isEventual: Bool = false, createdDate: Date? = nil, sortIndex: Int = 0) {
        self.id = id
        self.title = title
        self.durationHours = durationHours
        self.durationMinutes = durationMinutes
        self.priority = priority
        self.completed = completed
        self.isEventual = isEventual
        self.createdDate = createdDate
        self.sortIndex = sortIndex
    }
    
}
