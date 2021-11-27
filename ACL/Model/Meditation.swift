//
//  Meditation.swift
//  ACL
//
//  Created by RGND on 28/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class Meditation {
    
    var categoryId: String?
    var categoryIcon: String?
    var categoryName: String?
    
    var authorName: String?
    var authorDescription: String?
    var readerName: String?
    var readerDescription: String?
    
    var backgroundImage: String?
    var backgroundSound: String?
    var isFavorite : String?
    
    init(_ data: [String: Any]) {
        self.categoryId = data["id"] as? String
        self.categoryIcon = data["image"] as? String
        self.categoryName = data["name"] as? String
        
        self.backgroundImage = data["background_image"] as? String
        self.backgroundSound = data["background_sound"] as? String
        
        self.authorName = data["author_name"] as? String
        self.authorDescription = data["author_description"] as? String
        self.readerName = data["reader_name"] as? String
        self.readerDescription = data["reader_description"] as? String
    }
}

class CustomSounds{
    var backgroundSound: String?
    var name : String?
    
    init(_ data: [String: Any]) {
        self.backgroundSound = data["file"] as? String
        self.name = data["name"] as? String

    }
    
}
