//
//  SearchResultViewModel.swift
//  ACL
//
//  Created by Aman on 04/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class SearchModel :NSObject{
    var quotes: [[String: Any]]?
    var weekly_challenges: [[String: Any]]?
    var weekly_meditation: [[String: Any]]?
    var video: [[String: Any]]?

    init(_ data: [String: Any]) {
        self.quotes = data["quotes"] as? [[String: Any]]
        self.weekly_challenges = data["weekly_challenges"] as? [[String: Any]]
        self.weekly_meditation = data["weekly_meditation"] as? [[String: Any]]
        self.video = data["video"] as? [[String: Any]]
    }
    
}



class SearchResultViewModel {
    var searchArray : [SearchModel] = [SearchModel]()
    
    
    func getSearchContent(searchText: String, _ completion: @escaping(cloudDataCompletionHandler)){
        CloudDataManager.shared.getSearchContent(str: searchText) { response, error in
            
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            // remove old data
            self.searchArray.removeAll()
            // get data
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create search model
                self.searchArray.append(SearchModel(data))
            }
            completion(true, "")
        }
        
    }
    func addFavouriteForVideo(videoId : String, completion: @escaping cloudDataCompletionHandler){
          let param = ["uid": DataManager.shared.userId!, "type" : APIConstants.favType.Video, "item_id": videoId]

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
