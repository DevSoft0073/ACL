//
//  CalenderViewModel.swift
//  ACL
//
//  Created by Aman on 30/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class CalenderViewModel: NSObject {

    var calender: [CalendarMod]! = []
    
    
    func getData(completion: @escaping cloudDataCompletionHandler){
        CloudDataManager.shared.enrolledEventsListing(["uid":DataManager.shared.userId ?? ""]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            if let data = response?[APIConstants.Response.data] as? [[String: Any]] {
                for dataDict in data{
                    self.calender.append(CalendarMod(dataDict))
                }
            }
            completion(true, validation.errorMessage)
        }
    }
    
    
}
