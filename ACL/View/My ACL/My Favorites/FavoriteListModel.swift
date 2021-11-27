//
//  FavoriteListModel.swift
//  ACL
//
//  Created by Aman on 30/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class FavoriteListModel: NSObject {

    var favList: [FavoriteList]! = []
       
       
    func getData(type: String,completion: @escaping cloudDataCompletionHandler){
        CloudDataManager.shared.getFavListing(["uid":DataManager.shared.userId ?? "", "type": type]) { response, error in
               // vaidate response
               let validation = CloudDataManager.shared.validateResponse(response, error: error)
               guard validation.isValid else {
                   completion(false, validation.errorMessage)
                   return
               }
            self.favList.removeAll()
               if let data = response?[APIConstants.Response.data] as? [[String: Any]] {
                for list in data{
                    self.favList.append(FavoriteList(list))
                }
               }
               completion(true, validation.errorMessage)
           }
       }
    
    func getRecordingData(completion: @escaping cloudDataCompletionHandler){
     CloudDataManager.shared.getRecordingListing(["uid":DataManager.shared.userId ?? ""]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
         self.favList.removeAll()
            if let data = response?[APIConstants.Response.data] as? [[String: Any]] {
             for list in data{
                 self.favList.append(FavoriteList(list))
             }
            }
            completion(true, validation.errorMessage)
        }
    }
    
    
}
