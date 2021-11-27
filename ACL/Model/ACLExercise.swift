//
//  ACLExercise.swift
//  ACL
//
//  Created by Gagandeep on 19/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation


class Exercise: NSObject {
    
    var id: String?
    var title: String?
    var summary: String?
    var isFavourite : String?
    var isChecked : Bool?
    
    init(_ data: [String: Any]) {
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        self.summary = data["description"] as? String
        self.isFavourite = data["isFavorite"] as? String
        let isCheck = data["isChecked"] as? String
        if isCheck == "1"{
            self.isChecked = true
        }else{
            self.isChecked = false
        }
    }
}

class ACLExercise: NSObject {
    
    var name: String?
    var image: String?
    var exercises: [Exercise] = [Exercise]()
    
    init(_ data: [String: Any]) {
        
        self.name = data["name"] as? String
        self.image = data["image"] as? String
        
        self.exercises.removeAll()
        if let exercisesData = data["exercises"] as? [[String : Any]] {
            for exercise in exercisesData {
                self.exercises.append(Exercise(exercise))
            }
        }
    }
}
