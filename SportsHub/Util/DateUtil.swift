//
//  GetCurrentDate.swift
//  SportsHub
//
//  Created by Anas Salah on 16/05/2024.
//

import UIKit

struct DateUtil {
    
    private init() {}
    
    static func getCurrentDateString() -> String {
        let currentDate = Date()
        return formatDate(date: currentDate)
    }

    static func getDateOneWeekBefore() -> String {
        let currentDate = Date()
        if let dateOneWeekBefore = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate) {
            return formatDate(date: dateOneWeekBefore)
        }
        return getCurrentDateString()
    }

    static func getDateOneWeekAfter() -> String {
        let currentDate = Date()
        if let dateOneWeekAfter = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) {
            return formatDate(date: dateOneWeekAfter)
        }
        return getCurrentDateString()
    }

    private static func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    
}
