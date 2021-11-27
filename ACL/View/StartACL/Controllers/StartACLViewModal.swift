//
//  StartACLViewModal.swift
//  ACL
//
//  Created by Aman on 22/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation

class StartACLViewModal {
    
    var weekTraining : WeekTraining?
    
    
    func createChapter(meeting_info: String,cohot_no: String,lat:String,lng: String,address:String,chaptername: String,enroll_date: String  ,_ completion: @escaping(cloudDataCompletionHandler)){
        let leaderName = Singleton.sharedInstance.userLatLonginMY_ACL["leader"] as? String ?? ""
        let leaderAbout = Singleton.sharedInstance.userLatLonginMY_ACL["leaderAbout"] as? String ?? ""
        let coLeader = Singleton.sharedInstance.userLatLonginMY_ACL["coleader"] as? String ?? ""
        let joinLink = Singleton.sharedInstance.userLatLonginMY_ACL["join_link"] as? String ?? ""
        let contactEmail = DataManager.shared.userEmailAddress ?? ""
        let groupStart = Singleton.sharedInstance.userLatLonginMY_ACL["group_started"] as? String ?? ""
        
        let city = Singleton.sharedInstance.userLatLonginMY_ACL["city"] as? String ?? ""
        let country = Singleton.sharedInstance.userLatLonginMY_ACL["country"] as? String ?? ""
        let additionalCoLeader = Singleton.sharedInstance.userLatLonginMY_ACL["additionalColeaders"] as? String ?? ""
        let firstMeetMonth = Singleton.sharedInstance.userLatLonginMY_ACL["firstMeetingMonth"] as? String ?? ""
        let chapterType = Singleton.sharedInstance.userLatLonginMY_ACL["chapterType"] as? String ?? ""
        let firstMeetDate = Singleton.sharedInstance.userLatLonginMY_ACL["firstMeetingDate"] as? String ?? ""
        let about = Singleton.sharedInstance.userLatLonginMY_ACL["about"] as? String ?? ""
        let descp = Singleton.sharedInstance.userLatLonginMY_ACL["description"] as? String ?? ""
        let via_App = Singleton.sharedInstance.userLatLonginMY_ACL["via_app"] as? String ?? ""
        let  meeting_infoStr =  Singleton.sharedInstance.userLatLonginMY_ACL["meeting_info"] as? String ?? ""
        let param = ["uid": DataManager.shared.userId!,"meeting_info": meeting_infoStr,"cohot_no": cohot_no,"lat":lat,"lng":lng,"address": address,"name":chaptername,"enroll_date": enroll_date, "leader": leaderName,"leader_about_bio": leaderAbout,"co_leader": coLeader,"join_link": joinLink,"group_started": groupStart,"contact": contactEmail, "city" : city,"country": country,"additionalColeaders":additionalCoLeader,"firstMeetingMonth": firstMeetMonth,"chapterType": chapterType, "firstMeetingDate": firstMeetDate,"about": about,"status":"1","via_app":via_App,"description":descp]
        
        

          CloudDataManager.shared.createChapter(param) { response, error in
              // vaidate response
              let validation = CloudDataManager.shared.validateResponse(response, error: error)
              guard validation.isValid else {
                  completion(false, validation.errorMessage)
                  return
              }
              completion(true, "")
          }
      }
    
    
    func getWeekListApproval( _ completion: @escaping(cloudDataCompletionHandler)){
        
        CloudDataManager.shared.getWeektrainingList(["uid": DataManager.shared.userId ?? ""]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                self.weekTraining = WeekTraining(data)
                completion(true, "")
            }
        }
    }
    
    
}
