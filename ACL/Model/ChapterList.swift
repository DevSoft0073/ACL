//
//  ChapterList.swift
//  ACL
//
//  Created by Aman on 22/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation
import EventKit

class EventList {
    
    var title: String?
    var id: Int?
    var description : String?
    var event_date: String?
    var isEnrolled : Bool?
    var zoomLink : String?
    var originalTimeStamp : Double?
    
    //    var chapter_lat: String?
    //    var chapter_lng: String?
    //    var chapter_id: Int?
    //    var uid : Int?
    
    
    
    
    
    init(_ data: [String: Any]) {
        self.id = data["id"] as? Int
        self.title = data["title"] as? String
        self.description = data["description"] as? String
        let dateTimestamp = Double(data["event_date"] as? String ?? "") ?? 0
        
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: dateTimestamp)
        formatter.timeZone = TimeZone.init(abbreviation: "PST")
        print("herr is zoom links",dateTimestamp)
        formatter.dateFormat = "MM/dd/YYYY h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        self.event_date = formatter.string(from: date)
        self.originalTimeStamp = dateTimestamp
//        let pstTimeStamp = formatter.date(from: self.event_date ?? "")
//        self.originalTimeStamp = pstTimeStamp?.timeIntervalSince1970
        
        let isEnroll = data["isEnrolled"] as? String
        if isEnroll == "1"{
            self.isEnrolled = true
        }else{
            self.isEnrolled = false
        }
        self.zoomLink = data["zoom_link"] as? String
    }
    
    

}


class WeekTraining {
    var weekDictionary : [String:Any]?
    
    init(_ data: [String: Any]) {
        self.weekDictionary = data
    }
    
    
}
