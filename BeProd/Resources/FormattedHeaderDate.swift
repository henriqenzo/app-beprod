//
//  FormattedHeaderDate.swift
//  BeProd
//
//  Created by Enzo Henrique Botelho Romão on 19/05/25.
//

import Foundation

// Data formatada
extension Date {
    func formattedHeaderDate() -> String {
        let dayMonthFormatter = DateFormatter()
        dayMonthFormatter.locale = Locale(identifier: "pt_BR")
        dayMonthFormatter.dateFormat = "dd MMM"
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "pt_BR")
        weekdayFormatter.dateFormat = "EEEE"
        
        let dayMonth = dayMonthFormatter.string(from: self)
        let weekday = weekdayFormatter.string(from: self).capitalized
        
        return "\(dayMonth) | \(weekday)"
    }
}
