//
//  Date.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 01/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func Atual() -> String {
        let date = Date()
        let myLocale = Locale(identifier: "pt_BR")
    
        let formatter = DateFormatter()
        formatter.locale = myLocale
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
    }
    
    func dia() -> String {
        let date = Date()
        let myLocale = Locale(identifier: "pt_BR")
        
        let formatter = DateFormatter()
        formatter.locale = myLocale
        formatter.dateStyle = .medium

        return formatter.string(from: date)
    }
    
    func toString(data : Date) -> String {
        let myLocale = Locale(identifier: "pt_BR")
        let formatter = DateFormatter()
        formatter.dateFormat  = "dd-MM-yyyy"
        formatter.locale = myLocale
        return formatter.string(from: data)
    }
    
    func toString() -> String {
        let data = Date()
        let myLocale = Locale(identifier: "pt_BR")
        let formatter = DateFormatter()
        formatter.dateFormat  = "dd-MM-yyyy"
        formatter.locale = myLocale
        return formatter.string(from: data)
    }
    
    func toDate(data : String) -> Date {
        let myLocale = Locale(identifier: "pt_BR")
        let formatter = DateFormatter()
        formatter.dateFormat  = "dd-MM-yyyy"
        formatter.locale = myLocale
        return formatter.date(from: data)!
    }
    
    func dia(data : String) -> Date {
        let myLocale = Locale(identifier: "pt_BR")
        let formatter = DateFormatter()
        formatter.dateFormat  = "dd-MM-yyyy"
        formatter.locale = myLocale
        formatter.dateStyle = .medium
        return formatter.date(from: data)!
    }
    
    
    func hora() -> String {
        let date = Date()
        let myLocale = Locale(identifier: "pt_BR")
        
        let formatter = DateFormatter()
        formatter.locale = myLocale
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
    }
    
    func year(data : Date) -> Int{
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: data)
        return year
    }
    
    func month(data : Date) -> Int{
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: data)
        
        return month
    }
    
    func day(data : Date) -> Int{
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: data)
        
        return day
    }
  
}
