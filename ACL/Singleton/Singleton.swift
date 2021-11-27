//
//  Singleton.swift
//  ACL
//
//  Created by Aman on 22/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation

class Singleton  {
   static let sharedInstance = Singleton()
    var userLatLonginMY_ACL = [String: Any]()
    var isEnterfromMyACL = false
    var isNeedSignupFromEventScreen  = false
    var currentTitle = ""
    var currentAuthor = ""
    var isNeedPlayback = false
    var isSoundSelected = false
    var selectedSoundURL = ""
    var selectedSoundName = ""
    var totalChapters = ""
    var backgroundSettingisOn = true
    var remainSignIn = false
    
    var reportBtnIndex = 0
    var isGuestCheckedNotice = false
}
