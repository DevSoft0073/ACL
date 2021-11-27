//
//  AppSettings.swift
//  ACL
//
//  Created by RGND on 14/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class AppSettings: NSObject {

    var musicEnabled: Bool = false
    var soundEffectsEnabled: Bool = false
    var emailNoticesEnabled: Bool = false
    var pushNotificationEnabled: Bool = false
    var contactInfoEnabled: Bool = false
    var cityCountryEnabled: Bool = false
    var premiumMemberEnabled: Bool = false
    var remainSignInEnabled: Bool = false
    var otherUserProfilePic: String?
    var profileSeenDate: String?
    var profileSeenLocation: String?
    var profileSeenUsername: String?
    var profileViewed: Bool = false
    var aclCommunityAccount: Bool = false
    var ownChapter: String?

    var userId: String = DataManager.shared.userId!
    
    init(_ data: [String: Any]) {
        
        if let value = data["uid"] as? String {
            self.userId = value
        }
        if let value = data["acl_community_account"] as? NSString {
            self.aclCommunityAccount = value.boolValue
        }
        if let value = data["email_notices"] as? NSString {
            self.emailNoticesEnabled = value.boolValue
        }
        if let value = data["music_general"] as? NSString {
            self.musicEnabled = value.boolValue
        }
        if let value = data["premium_member"] as? NSString {
            self.premiumMemberEnabled = value.boolValue
        }
        if let value = data["profile_pic"] as? String {
            self.otherUserProfilePic = value
        }
        if let value = data["profile_seen_date"] as? String {
            self.profileSeenDate = value
        }
        if let value = data["profile_seen_location"] as? String {
            self.profileSeenLocation = value
        }
        if let value = data["profile_seen_username"] as? String {
            self.profileSeenUsername = value
        }
        if let value = data["profile_viewed"] as? NSString {
            self.profileViewed = value.boolValue
        }
        if let value = data["push_notification"] as? NSString {
            self.pushNotificationEnabled = value.boolValue
        }
        if let value = data["remain_signed_in"] as? NSString {
            self.remainSignInEnabled = value.boolValue
        }
        if let value = data["show_city_country"] as? NSString {
            self.cityCountryEnabled = value.boolValue
        }
        if let value = data["show_contact_info"] as? NSString {
            self.contactInfoEnabled = value.boolValue
        }
        if let value = data["sound_effect"] as? NSString {
            self.soundEffectsEnabled = value.boolValue
        }
        if let value = data["own_chapter"] as? String {
            self.ownChapter = value
        }
        
    }
}
