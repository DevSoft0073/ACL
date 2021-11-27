//
//  QuestionOfWeek.swift
//  ACL
//
//  Created by Gagandeep on 14/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class QuestionOfWeek {
    
    var title: String?
    var id: String?
    var isFavorite: String?
    var answerList: [AnswerOfQuestion] = [AnswerOfQuestion]()
    
    init(_ data: [String: Any]) {
        self.title = data["question"] as? String
        self.id = data["id"] as? String
        self.isFavorite = data["isFavorite"] as? String

        if let list = data["answer_listing"] as? [[String: Any]] {
            for answer in list {
                self.answerList.append(AnswerOfQuestion(answer))
            }
        }
    }
}

class FlowerListing {
    
    var id: String?
    var image: String?
    var isSelected = false
    
    init(_ data: [String: Any]) {
        self.id = "\(data["id"] as? Int ?? 0)"
        self.image = data["image"] as? String
    }
}




class AnswerOfQuestion {
    
    var answer: String?
    var uid: String?
    var username: String?
    var flower: String?
    var isanonymous : String?
    var post_Id : String?
    
    init(_ data: [String: Any]) {
        self.answer = data["answer"] as? String
        self.uid = "\((data["uid"] as? Int) ?? 0 )"
        self.flower = data["flower"] as? String
        self.username = data["username"] as? String
        self.isanonymous = data["anonymous"] as? String
        self.post_Id = data["id"] as? String
    }
}

