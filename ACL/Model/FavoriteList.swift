//
//  FavoriteList.swift
//  ACL
//
//  Created by Aman on 30/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class FavoriteList: NSObject {

            var name: String?
            var created_at: String?
            var id: String?
            var videoLink : String?
            var isfavourite : String?
            var isCompleted : String?
            var wholeData : [String: Any]?
            var recordingUrl : String?
            var authorName : String?
        
          init(_ data: [String: Any]) {
            self.wholeData = data
              self.name = data["name"] as? String
              self.created_at = data["created_at"] as? String
              self.id = data["id"] as? String
             self.videoLink = data["video_link"] as? String
            self.isfavourite = data["isFavorite"] as? String
            self.isCompleted = data["completed"] as? String
            self.recordingUrl = data["recording"] as? String
            self.authorName = data["author"] as? String

            
            if self.name == nil{
                self.name = data["quotes"] as? String
            }
            
            if self.name == nil{
                self.name = data["title"] as? String
            }
            if self.name == nil{
                self.name = data["author_name"] as? String
            }
            if self.name == nil{
                self.name = data["question"] as? String
            }
           //question
          }
    
    
}
