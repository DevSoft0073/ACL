//
//  UserProfileManager.swift
//  ACL
//
//  Created by RGND on 14/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class UserProfileManager {

    static var shared: UserProfileManager {
        return UserProfileManager()
    }
    
    var userProfile: UserProfile?
    
    
}
