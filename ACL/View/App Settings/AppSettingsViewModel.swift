//
//  AppSettingsViewModel.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class AppSettingsViewModel {
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

    
    init() {
        
    }
    
    func update( _ settings: AppSettings) {
        self.musicEnabled = settings.musicEnabled
        self.soundEffectsEnabled = settings.soundEffectsEnabled
        self.emailNoticesEnabled = settings.emailNoticesEnabled
        self.pushNotificationEnabled = settings.pushNotificationEnabled
        self.contactInfoEnabled = settings.contactInfoEnabled
        self.cityCountryEnabled = settings.cityCountryEnabled
        self.premiumMemberEnabled = settings.premiumMemberEnabled
        self.remainSignInEnabled = settings.remainSignInEnabled
        Singleton.sharedInstance.remainSignIn = settings.remainSignInEnabled
        self.otherUserProfilePic = settings.otherUserProfilePic
        self.profileSeenDate = settings.profileSeenDate
        self.profileSeenLocation = settings.profileSeenLocation
        self.profileSeenUsername = settings.profileSeenUsername
        self.profileViewed = settings.profileViewed
        self.aclCommunityAccount = settings.aclCommunityAccount
        self.ownChapter = settings.ownChapter
    }
    
    
    func getSettings(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = ["uid": DataManager.shared.userId!]
        CloudDataManager.shared.updateSettings(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
             if let data = response?[APIConstants.Response.data] as? [String: Any] {
                let appSettings = AppSettings(data)
                self.update(appSettings)
            }
            
            completion(true, "")
        }
    }
    
    func updateSettings(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParameters()
        CloudDataManager.shared.updateSettings(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                let appSettings = AppSettings(data)
                self.update(appSettings)
            }
            
            completion(true, "")
        }
    }
    
    func getParameters() -> [String: Any] {
        let parameters = ["uid": DataManager.shared.userId!,
                          "music_general": String(Int(truncating: NSNumber(value: musicEnabled))),
                          "sound_effect": String(Int(truncating: NSNumber(value: soundEffectsEnabled))),
                          "email_notices": String(Int(truncating: NSNumber(value: emailNoticesEnabled))),
                          "push_notification": String(Int(truncating: NSNumber(value: pushNotificationEnabled))),
                          "show_contact_info": String(Int(truncating: NSNumber(value: contactInfoEnabled))),
                          "show_city_country": String(Int(truncating: NSNumber(value: cityCountryEnabled))),
                          "premium_member": String(Int(truncating: NSNumber(value: premiumMemberEnabled))),
                          "remain_signed_in": String(Int(truncating: NSNumber(value: remainSignInEnabled)))]
        return parameters
    }
    
}
