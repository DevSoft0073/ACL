//
//  SingupViewModel.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class SignupViewModel {
    

    var email: String?
    var username: String?
    var password: String?
    var latitude: String?
    var longitude: String?
    var city: String?
    var country: String?
    var profileImageData: Data?
    var shouldSavePassword: Bool = false
    var firstName : String?
    var lastName : String?
    var phone : String?
    var isMailVerified : Bool?
    var OTP : String?
    
    func signup(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParameters()
        DataManager.shared.password = password
        CloudDataManager.shared.signup(parameters, completion: completion)
    }
    
    func guest_signup(_ completion: @escaping(cloudDataCompletionHandler)) {
           let parameters = getParametersForGuest()
           CloudDataManager.shared.signup_Guest(parameters, completion: completion)
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
                    
                    self.OTP = "\(otp)"
                }
            }
            let msg = response?[APIConstants.Response.message] as? String ?? ""
            completion(true, msg)

           
        }
        
    }
    
    
    func saveProfileImage(_ completion: @escaping(cloudDataCompletionHandler)) {
        
        let parameters = ["uid": DataManager.shared.userId!]
        var imageData = [String: Data]()
        if let data = profileImageData {
            imageData["profile_pic"] = data
        }
        
        CloudDataManager.shared.updateProfile(parameters, imagesData: imageData) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                let profile = UserProfile(data)
                // keep user logged in if selected
                DataManager.shared.keepLoggedIn = self.shouldSavePassword
            }
            completion(true, "")
        }
        
    }
    
    func validateEntries() -> (valid: Bool, message: String) {
        guard let emailAddress = email, emailAddress.isValidEmailAddress() else {
            return (false, "Invalid email address")
        }
        guard let passwordText = password, passwordText.count > 5 else {
            return (false, "Please enter minimum 6 characters in for password")
        }
        
        return (true, "")
    }
    
    func validateEntriesForGuest() -> (valid: Bool, message: String) {
          guard let emailAddress = email, emailAddress.isValidEmailAddress() else {
              return (false, "Invalid email address")
          }
          return (true, "")
      }
    
    
    
    func getParameters() -> [String: Any] {
        
        let parameters:[String : Any] = ["username": username ?? "","email": email ?? "","password": password ?? "","device_type": "ios","device_token": DataManager.shared.token ?? "","latitude": latitude ?? "","longitude": longitude ?? "","city": city ?? "", "country": country ?? "", "firstname": firstName ?? "","lastname": lastName ?? "", "phone": phone ?? ""]
        
        return parameters
    }
    func getParametersForGuest() -> [String: Any] {
        
        let parameters:[String : Any] = ["username": username ?? "","email": email ?? "","device_type": "ios", "device_toke": "123123123","latitude": latitude ?? "","longitude": longitude ?? "","city": city ?? "","country": country ?? "","firstname": firstName ?? "","lastname": lastName ?? "","phone": phone ?? ""]
        
        return parameters
    }

    
    
    
    func updateSettings(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParametersForSetting()
        CloudDataManager.shared.updateSettings(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
//                let appSettings = AppSettings(data)
//                self.update(appSettings)
            }
            
            completion(true, "")
        }
    }
    
    func getParametersForSetting() -> [String: Any] {
        let parameters = ["uid": DataManager.shared.userId!,
                          "remain_signed_in": "1"]
        return parameters
    }
    
}
