//
//  Quote.swift
//  ACL
//
//  Created by Gagandeep on 29/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class Quote: NSObject {
    var id: String?
    var quote: String?
    var author: String?
    var isFavorite: Bool = false
    
    init(_ data: [String: Any]) {
        self.id = data["id"] as? String
        self.quote = data["quotes"] as? String
        self.author = data["author"] as? String
        
        if let fav =  data["isFavorite"] as? String, fav == "1" {
             self.isFavorite = true
        }
    }
}


class Event: NSObject {
    var id: String?
    var title: String?
    var event_date: Double?
  

    
    init(_ data: [String: Any]) {
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        let date = data["event_date"] as? String
        self.event_date = Double(date ?? "")
//       self.cohot_no = data["cohot_no"] as? String
//        self.contact = data["contact"] as? String
//        let date = data["enroll_date"] as? String
//        self.enroll_date = Double(date ?? "")
//        self.group_started = data["group_started"] as? String
//        self.join_link = data["join_link"] as? String
//        self.name = data["name"] as? String
//        self.status = data["status"] as? String
    }
}
