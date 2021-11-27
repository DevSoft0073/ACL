//
//  Date+Extension.swift
//  ACL
//
//  Created by Gagandeep on 12/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

extension Date {
    
    func getString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: self)
    }
    
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    
    func onlyMonthString() -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMMM"
           return formatter.string(from: self)
       }
    
    func onlyYearString() -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy"
           return formatter.string(from: self)
       }
    
    
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd MMM YYYY hh:mm a"

       // dateFormatter.dateStyle = .medium

        return dateFormatter.string(from: date)
        
        
        
    }
    
    
    func getOnlyDateStringFromUTC() -> String {
         let date = Date(timeIntervalSince1970: self)

         let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale(identifier: "en_US")
         dateFormatter.dateFormat = "dd MMM YYYY"

        // dateFormatter.dateStyle = .medium

         return dateFormatter.string(from: date)
     }
    
    
    
}
extension Double{
       var cleanValue: String{
           //return String(format: 1 == floor(self) ? "%.0f" : "%.2f", self)
           return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)//
       }
   }
