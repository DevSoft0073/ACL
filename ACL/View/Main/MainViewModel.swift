//
//  MainViewModel.swift
//  ACL
//
//  Created by Gagandeep on 29/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation

class MainViewModel: NSObject {
    
    var quote: Quote?
    var event: Event?
    
func getData(completion: @escaping cloudDataCompletionHandler) {
        CloudDataManager.shared.getHomeDetials { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            // get data
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // get quotes
                if let quoteData = data["quotes"] as? [String: Any] {
                    self.quote = Quote(quoteData)
                }
                if let chapterData = data["event"] as? [String: Any] {
                    self.event = Event(chapterData)
                }
                
                if let totalChapters = data["total_chapter"] as? String{
                    Singleton.sharedInstance.totalChapters = totalChapters
                }
            }
            completion(true, validation.errorMessage)
        }
    }
    
    func addFavourite(completion: @escaping cloudDataCompletionHandler){
        let param = ["uid": DataManager.shared.userId!, "type" : APIConstants.favType.Quotes, "item_id": quote?.id]

        CloudDataManager.shared.addFavorite(param) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }

            completion(true, validation.errorMessage)
        }
    }
    
    
}
