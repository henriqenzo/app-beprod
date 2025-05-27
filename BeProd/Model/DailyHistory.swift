//
//  DailyHistory.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 24/05/25.
//

import Foundation
import SwiftData

@Model
final class DailyHistory {
    var date: Date
    var completedTasks: Int
    var totalTasks: Int
    var percentual: Int
    
    init(date: Date = Date(), completedTasks: Int = 0, totalTasks: Int = 0, percentual: Int = 0) {
        self.date = date
        self.completedTasks = completedTasks
        self.totalTasks = totalTasks
        self.percentual = percentual
    }
}
 
