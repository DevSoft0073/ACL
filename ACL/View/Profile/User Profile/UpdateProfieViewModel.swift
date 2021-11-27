//
//  UpdateProfieViewModel.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import UIKit

class UpdateProfieViewModel {
    
    var email: String?
    var username: String?
    var password: String?
    var latitude: String?
    var longitude: String?
    var city: String?
    var country: String?
    var profilePicData: Data?
    var profilePicUrl: String?
    var firstName : String?
    var lastName : String?
    var phone : String?
    var oldPassword: String?

    func update(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParameters()
        
        var imageData = [String: Data]()
        if let data = profilePicData {
            imageData["profile_pic"] = data
        }
        CloudDataManager.shared.updateProfile(parameters, imagesData: imageData) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            completion(true, "")
        }
    }
    
    func getProfile(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = ["userinfo": DataManager.shared.userId!]
        CloudDataManager.shared.getProfile(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                let profile = UserProfile(data)
                self.email = profile.email
                self.username = profile.username
                self.city = profile.city
                self.country = profile.country
                self.profilePicUrl = profile.profilePicUrl
                self.firstName = profile.firstname
                self.lastName = profile.lastname
                self.phone = profile.phoneNumber
            }
            completion(true, "")
        }
    }
    
    func validateEntries() -> (valid: Bool, message: String) {
//      guard let emailAddress = email, emailAddress.isValidEmailAddress() else {
//           return (false, "Invalid email address")
//      }
        guard let oldpswrd = oldPassword, oldpswrd.count > 0 else {
            return (false, "Please enter your current password")
        }
        
        if let passwordText = password, passwordText.count > 0, passwordText.count < 6 {
            return (false, "Please enter minimum 6 characters in for password")
        }
        guard let confirmPwd = oldPassword, confirmPwd == DataManager.shared.password else {
            return (false, "Please enter correct password")
        }
        guard let emailAddress = email, emailAddress.isValidEmailAddress() else {
            return (false, "Invalid email address")
        }
        guard let username = username, username.count > 0 else {
            return (false, "Please enter username")
        }
        
        return (true, "")
    }
    
    func getParameters() -> [String: Any] {
        
        var parameters = ["uid" : DataManager.shared.userId!, "device_type": "ios", "device_token": DataManager.shared.token ?? ""]
        
        if let value = password, value.count > 0 {
            parameters["password"] = value
        }
        if let value = latitude {
            parameters["latitude"] = value
        }
        if let value = longitude {
            parameters["longitude"] = value
        }
        if let value = city {
            parameters["city"] = value
        }
        if let value = country {
            parameters["country"] = value
        }
        if let value = username {
            parameters["username"] = value
        }
        if let value = email {
            parameters["email"] = value
        }
        if let value = phone {
            parameters["phone"] = value
        }
        
        return parameters
    }
    
}
