//
//  Calendar.swift
//  ACL
//
//  Created by Aman on 30/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class CalendarMod: NSObject {
    var name: String?
       var descp: String?
//       var cohot_no: String?
//       var address: String?
       var enroll_date: String?
//       var status: String?

    
    
    

       init(_ data: [String: Any]) {
           self.name = data["title"] as? String
           self.descp = data["description"] as? String
           self.enroll_date = data["event_date"] as? String
//           self.status = data["status"] as? String
       }
    
//    "id": 27,
//              "name": "testttt--",
//              "meeting_info": "iohiuh",
//              "uid": 70,
//              "cohot_no": "knk",
//              "lat": "28.5383355",
//              "lng": "-81.3792365",
//              "address": "Orlando, FL, USA",
//              "enroll_date": "1606608000",
//              "status": 1,
//              "leader": "",
//              "leader_about_bio": "",
//              "co_leader": "",
//              "contact": "",
//              "join_link": "",
//              "image": "",
//              "description": "",
//              "group_started": "",
//              "created_at": 1603373963,
//              "updated_at": 1603373963
//
    
    
}



