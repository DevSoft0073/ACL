//
//  SigninViewModel.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class SigninViewModel {
    
    var email: String?
    var password: String?
    
    func signin(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParameters()
        DataManager.shared.password = password
        CloudDataManager.shared.login(parameters, completion: completion)
    }
    
    func validateEntries() -> (valid: Bool, message: String) {
        guard let emailAddress = email, emailAddress.count > 0 else {
            return (false, "Invalid email address")
        }
        guard let passwordText = password, passwordText.count > 0 else {
            return (false, "Please enter valid password")
        }
        
        return (true, "")
    }
    
    func getParameters() -> [String: Any] {
        
        let parameters = ["username": email ?? "",
                          "password": password ?? "","device_token": DataManager.shared.token ?? "","device_type": "ios"]
        
        return parameters
    }
}
