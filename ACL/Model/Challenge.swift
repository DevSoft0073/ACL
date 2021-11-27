//
//  Challenge.swift
//  ACL
//
//  Created by RGND on 27/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class Challenge {
    
    var pastChalenges: [Challenge] = [Challenge]()
    var name: String?
    var id: String?
    var description: String?
    var week: String?
    var weekTitle: String?
    var userId: String?
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var learnDescp : String?
    
     init(_ data: [String: Any]) {
        self.id = data["id"] as? String
        self.userId = data["uid"] as? String
        self.name = data["name"] as? String
        self.description = data["description"] as? String
        self.week = data["week"] as? String
        self.weekTitle = data["week_title"] as? String
        self.learnDescp = data["learn_description"] as? String

        if let completed = data["completed"] as? String {
            self.isCompleted = completed == "1"
        }
        if let isFavorite = data["isFavorite"] as? String {
            
            self.isFavorite = isFavorite == "1"
        }
        
        pastChalenges.removeAll()
        
        if let challenges = data["completd_challenge"] as? [[String: Any]] {
            for challenge in challenges {
                pastChalenges.append(Challenge(challenge))
            }
        }
    }
}
