//
//  UpdateProfileCommunityViewModel.swift
//  ACL
//
//  Created by RGND on 14/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class UpdateProfileCommunityViewModel {

    var firstname: String?
    var lastname: String?
    var email: String?
    var mailingAddress: String?
    var isEmailVerified: Bool = false
    var phoneNumber: String?
    var validateMailingAddress: Bool = false
    var mailingAddressError: String?
    var city: String?
    var country: String?
    var password: String?
    var username: String?
    var isSelectTerm : Bool?
    var otp : String?
    var isMailVerified : Bool = false
    
    func update(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParameters()
        CloudDataManager.shared.updateProfile(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            completion(true, "")
        }
    }
    
    
    func getOTPfromBackend(email: String, _ completion: @escaping(cloudDataCompletionHandler)){
        let param = ["email":email]
        CloudDataManager.shared.verifyOTP(param) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                if let otp = data["otp"] as? Int{
                    
                    self.otp = "\(otp)"
                }
            }
            let msg = response?[APIConstants.Response.message] as? String ?? ""
            completion(true, msg)

           
        }
        
    }
    
    
    func updateForGuest(_ completion: @escaping(cloudDataCompletionHandler)) {
           let parameters = getParametersForGuest()
           CloudDataManager.shared.updateProfile(parameters) { response, error in
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
                self.firstname = profile.firstname
                self.lastname = profile.lastname
                self.email = profile.email
                self.isEmailVerified = profile.isEmailVerified
                if let address = profile.mailingAddress, address.count > 0 {
                    self.mailingAddress = address
                } else {
                    self.mailingAddress = profile.email
                }
                self.phoneNumber = profile.phoneNumber
                self.city = profile.city
                self.country = profile.country
                self.username = profile.username
            }
            completion(true, "")
        }
    }
    
    func validateMailingAddress(_ completion: @escaping(cloudDataCompletionHandler)) {
        guard let emailAddress = mailingAddress, emailAddress.isValidEmailAddress() else {
            self.mailingAddressError = "Invalid email address"
            self.validateMailingAddress = false
            completion(false, "Invalid email address")
            return
        }
        
        let parameters:[String: Any] = ["uid": DataManager.shared.userId!, "email": mailingAddress ?? ""]
        CloudDataManager.shared.checkEmailAvailability(parameters) { status, message in
            self.validateMailingAddress = status
            if status {
                self.mailingAddressError = nil
            } else {
                self.mailingAddressError = message
            }
            completion(status, message)
        }
    }
    
    func validateEntries() -> (valid: Bool, message: String) {
        if let error = mailingAddressError, error.count > 0 {
            return (false, error)
        }
        
        guard let emailAddress = mailingAddress, emailAddress.isValidEmailAddress() else {
                return (false, "Invalid email address")
        }
        guard let firstname = firstname, firstname.count > 0 else {
            return (false, "Please enter valid first name")
        }
        guard let lastname = lastname, lastname.count > 0 else {
            return (false, "Please enter valid last name")
        }
//        guard isEmailVerified else{
//            return (false, "Please verify your email")
//        }
        
        return (true, "")
    }
        func validateEntriesForGuest() -> (valid: Bool, message: String) {
            if let error = mailingAddressError, error.count > 0 {
                return (false, error)
            }
            
            guard let emailAddress = mailingAddress, emailAddress.isValidEmailAddress() else {
                    return (false, "Invalid email address")
            }
            guard let firstname = firstname, firstname.count > 0 else {
                return (false, "Please enter valid first name")
            }
            guard let lastname = lastname, lastname.count > 0 else {
                return (false, "Please enter valid last name")
            }
            guard let cityname = city, cityname.count > 0 else {
                return (false, "Please enter city name")
            }
            guard let countryName = country, countryName.count > 0 else {
                return (false, "Please enter country name")
            }
            guard let pwd = password, pwd.count > 0 else {
                           return (false, "Please enter password")
                       }
            guard let selectTerm = isSelectTerm, selectTerm == true else{
                return (false, "Please check terms and conditions.")
            }
    //        guard isEmailVerified else{
    //            return (false, "Please verify your email")
    //        }
            
            return (true, "")
        }
    
    
    func getParameters() -> [String: Any] {
        
        var parameters = ["uid" : DataManager.shared.userId!]
        
        if let value = firstname {
            parameters["firstname"] = value
        }
        if let value = lastname {
            parameters["lastname"] = value
        }
        if let value = mailingAddress, value != email {
            parameters["mailing_Address"] = value
            parameters["email_verification"] = "0"
        }
        if let value = phoneNumber {
            parameters["phone"] = value
        }
        
        return parameters
    }
    
    func getParametersForGuest() -> [String: Any] {
        
        var parameters = ["uid" : DataManager.shared.userId!]
        
        if let value = firstname {
            parameters["firstname"] = value
        }
        if let value = lastname {
            parameters["lastname"] = value
        }
        if let value = mailingAddress, value != email {
            parameters["mailing_Address"] = value
            parameters["email_verification"] = "0"
        }
        if let value = phoneNumber {
            parameters["phone"] = value
        }
        if let value = city {
            parameters["city"] = value
        }
        if let value = country {
            parameters["country"] = value
        }
        
        return parameters
    }
    
}
