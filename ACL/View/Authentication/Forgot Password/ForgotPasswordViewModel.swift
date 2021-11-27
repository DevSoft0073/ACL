//
//  ForgotPasswordViewModel.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class ForgotPasswordViewModel {
    
    var email: String?
    
    func resetPassword(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParameters()
        CloudDataManager.shared.resetPassword(parameters, completion: completion)
    }
    
    func validateEntries() -> (valid: Bool, message: String) {
        guard let emailAddress = email, emailAddress.isValidEmailAddress() else {
            return (false, "Invalid email address")
        }
        return (true, "")
    }
    
    func getParameters() -> [String: Any] {
        let parameters = ["email": email ?? ""]
        return parameters
    }
}
