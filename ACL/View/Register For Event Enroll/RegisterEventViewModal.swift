//
//  RegisterEventViewModal.swift
//  ACL
//
//  Created by Aman on 22/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation

class RegisterEventViewModal{
    
    var eventList : [EventList]! = []
    
    func getEventList(_ completion: @escaping(cloudDataCompletionHandler)){
        CloudDataManager.shared.eventListing(["uid": DataManager.shared.userId!]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            self.eventList.removeAll()
            if let data = response?[APIConstants.Response.data] as? [[String: Any]] {
                for dataList in data{
                    self.eventList.append(EventList(dataList))
                }
            }
            completion(true, "")
        }
        
    }
    
    func joinEvent(event_Id: String, _ completion: @escaping(cloudDataCompletionHandler)){
        
        CloudDataManager.shared.joinEvent(["event_id": event_Id,"uid": DataManager.shared.userId!]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            completion(true, "")
        }
    }
    
    
}
