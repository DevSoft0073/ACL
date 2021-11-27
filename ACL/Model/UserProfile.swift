//
//  UserProfile.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class UserProfile: NSObject {

    var firstname: String?
    var lastname: String?
    var phoneNumber: String?
    var mailingAddress:String?
    var isEmailVerified: Bool = false
    
    var userId: String?
    var username: String?
    var city: String?
    var country: String?;
    var device_token: String?
    var device_type: String = "iOS"
    var email: String?
    var latitude: String?
    var longitude: String?
    var profilePicUrl: String?
    var journal_pin: String?
    var status = 1;
    var isGuestUser: Bool = false
    
    init(_ data: [String: Any]) {
        if let Isguest = data["guest"] as? String {
                  // self.userId = userId
            if Isguest == "1"{
                self.isGuestUser = true
            }else{
                self.isGuestUser = false
            }
        }
        
        
        if let userId = data["id"] as? String {
            self.userId = userId
        }
        if let username = data["username"] as? String {
            self.username = username
        }
        if let city = data["city"] as? String {
            self.city = city
        }
        if let country = data["country"] as? String {
            self.country = country
        }
        if let device_token = data["device_token"] as? String {
            self.device_token = device_token
        }
        if let email = data["email"] as? String {
            self.email = email
        }
        if let latitude = data["latitude"] as? String {
            self.latitude = latitude
        }
        if let longitude = data["longitude"] as? String {
            self.longitude = longitude
        }
        if let profilePicUrl = data["profile_pic"] as? String {
            self.profilePicUrl = profilePicUrl
        }
        
        if let pin = data["journal_pin"] as? String {
            self.journal_pin = pin
        }
        
        if let isEmailVerified = data["email_varification"] as? String, isEmailVerified == "1" {
            self.isEmailVerified = true
        }
        
        if let aclAccount = data["aclAccount"] as? [String: Any] {
            if let firstname = aclAccount["firstname"] as? String {
                self.firstname = firstname
            }
            if let lastname = aclAccount["lastname"] as? String {
                self.lastname = lastname
            }
            if let mailingAddress = data["mailingAddress"] as? String {
                self.mailingAddress = mailingAddress
            }
            if let phoneNumber = aclAccount["phone"] as? String {
                self.phoneNumber = phoneNumber
            }
        }

        
        
    }
    
    
}
