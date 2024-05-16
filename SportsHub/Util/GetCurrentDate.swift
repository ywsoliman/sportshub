//
//  GetCurrentDate.swift
//  SportsHub
//
//  Created by Anas Salah on 16/05/2024.
//

import UIKit

func getDateAfter(_ days: Int) -> Date {
    var dateComponent = DateComponents()
    dateComponent.day = days
    
    let calendar = Calendar.current
    return calendar.date(byAdding: dateComponent, to: Date()) ?? Date()
}

func getDateBefore(_ days: Int) -> Date {
    var dateComponent = DateComponents()
    dateComponent.day = -days
    
    let calendar = Calendar.current
    return calendar.date(byAdding: dateComponent, to: Date()) ?? Date()
}

let currentDate = Date()
let afterCurrentDate = getDateAfter(5)
let beforeCurrentDate = getDateBefore(5)



