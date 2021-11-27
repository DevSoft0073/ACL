//
//  CloudDataManager.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import Alamofire


typealias cloudDataCompletionHandler = (_ status: Bool, _ message: String)->()


class CloudDataManager {
    
    static var shared: CloudDataManager {
        return CloudDataManager()
    }
    
    func validateResponse(_ response: [String: Any]?, error: Error?) -> (isValid: Bool, errorMessage: String) {
        
        if let err = error {
            return (false, err.localizedDescription)
        }
        
        guard let response = response else {
            return (false, APIConstants.ResponseMessage.invalidResponse)
        }
        
        guard let status = response[APIConstants.Response.status] as? Int, status == APIConstants.StatusCode.success else {
            if let message = response[APIConstants.Response.message] as? String {
                return (false, message)
            }
            return (false, APIConstants.ResponseMessage.unknown)
        }
        return (true, response[APIConstants.Response.message] as? String ?? "")
    }
}

// MARK: - Authentication
extension CloudDataManager {
    func login(_ parameters: Parameters, completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.login) { response, error  in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                let profile = UserProfile(data)
                // save userid
                DataManager.shared.userId = profile.userId
                DataManager.shared.userName = profile.username
                // save email address
                DataManager.shared.userEmailAddress = profile.email
                // save Journal Pin
                DataManager.shared.myJournalPasscode = profile.journal_pin
                DataManager.shared.isGuestUser = false
                // save ACL flag based on firstname
                if let firstName = profile.firstname, !firstName.isEmpty {
                    DataManager.shared.isACLAccount = true
                }
            }
            
            completion(true, "")
        }
    }
    
    func signup(_ parameters: [String: Any], completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.singup) { response, error  in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                let profile = UserProfile(data)
                // save userid
                DataManager.shared.userId = profile.userId
                // save email address
                DataManager.shared.userEmailAddress = profile.email
                DataManager.shared.userName = profile.username
                DataManager.shared.isGuestUser = profile.isGuestUser
            }
            completion(true, "")
        }
        
    }
    
    func verifyOTP(_ parameters: [String: Any], completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.verifyOTP, completion: completion)
        
    }
    
    
    
    
    func signup_Guest(_ parameters: [String: Any], completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.guestLogin) { response, error  in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                let profile = UserProfile(data)
                // save userid
                DataManager.shared.userId = profile.userId
                // save email address
                DataManager.shared.userEmailAddress = profile.email
                DataManager.shared.isGuestUser = profile.isGuestUser
            }
            completion(true, "")
        }
        
    }
    
    
    func resetPassword(_ parameters: Parameters, completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.resetPassword) { response, error  in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            completion(true, "")
        }
    }
    
}

// MARK: - User Profile
extension CloudDataManager {
    /// Update Settings
    func updateSettings(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.updateSettings,completion: completion)
    }
    // Update profile data with image
    func updateProfile(_ parameters: Parameters, imagesData: [String: Data], completion: @escaping(webServicesCompletionBlock)) {
        
        WebServices.multipartImageRequest(parameters, imagesData: imagesData, endPoint: APIConstants.EndPoints.updateProfile) { response, error in
    
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                let profile = UserProfile(data)
                DataManager.shared.userEmailAddress = profile.email
                DataManager.shared.isGuestUser = profile.isGuestUser
                
                // save ACL flag based on firstname
                if let firstName = profile.firstname, !firstName.isEmpty {
                    DataManager.shared.isACLAccount = true
                }
            }
            completion(response, error)
        }
    }
    /// Update profile data
    func updateProfile(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartImageRequest(parameters, endPoint: APIConstants.EndPoints.updateProfile){ response, error in
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                let profile = UserProfile(data)
                DataManager.shared.userEmailAddress = profile.email
                DataManager.shared.isGuestUser = profile.isGuestUser
                // save ACL flag based on firstname
                if let firstName = profile.firstname, !firstName.isEmpty {
                    DataManager.shared.isACLAccount = true
                }
            }
            completion(response, error)
        }
    }
    
    func getProfile(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartImageRequest(parameters, endPoint: APIConstants.EndPoints.getProfile, completion: completion)
    }
    
    func checkEmailAvailability(_ parameters: Parameters, completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartImageRequest(parameters, endPoint: APIConstants.EndPoints.checkEmailAvailability) { response, error  in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            completion(true, "")
        }
    }
}

// MARK: - Weekly Challenge
extension CloudDataManager {
    
    func getWeeklyChallenge(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock))  {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.weeklyChallenge, completion: completion)
    }
    
    func responseChallenge(_ parameters: Parameters, completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.challengeComplete) { (response, error) in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            completion(true, "")
        }
    }
}

// MARK: - Meditation
extension CloudDataManager {
    func getWeeklyMeditation(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.weeklyMeditation, completion: completion)
        
    }
    
    func getCustomSounds(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)){
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.getCustomSound, completion: completion)

    }
}

// MARK: - Find ACL
extension CloudDataManager {
    func findNearByACL(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.nearbyACL, completion: completion)
    }
    
    func getACLInfo(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.aclinfo, completion: completion)
    }
}

// MARK: - My Journal
extension CloudDataManager {
    
    func updateJournalPin(_ parameters: Parameters, completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.updateProfile) { (response, error) in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            completion(true, "")
        }
    }
    
    func uploadRecordingFile(_ parameters: Parameters, audioData: [String: Data], completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartAudioRequest(parameters, audioData: audioData, endPoint: APIConstants.EndPoints.uploadRecordingFile) { (response, error) in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            completion(true, validation.errorMessage)
        }
    }
}
// MARK: - Thought Garden
extension CloudDataManager {
    func getWeeklyQuestion(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.weeklyQuestion, completion: completion)
    }
    func reportPOst(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.report_Post, completion: completion)
    }
    
    func postAnswerForWeeklyQuestion(_ parameters: Parameters, completion: @escaping(cloudDataCompletionHandler)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.answerPost) { (response, error) in
            // vaidate response
            let validation = self.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            completion(true, validation.errorMessage)
        }
    }
    
    func getFlowerListing(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.flowerListing, completion: completion)
    }
    
    
}

// MARK: - ALC Exercises
extension CloudDataManager {
    func getACLExercises(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.aclExercises, completion: completion)
    }
}

// MARK: - ALC Exercises
extension CloudDataManager {
    
    func getNews(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.news, completion: completion)
    }
    
}

// MARK: - Main page/ Home Page
extension CloudDataManager {
    
    func getHomeDetials(completion: @escaping(webServicesCompletionBlock)) {
        let parameters = ["uid": DataManager.shared.userId ?? ""]
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.home, completion: completion)
    }
    
}
// MARK: - search page
extension CloudDataManager {
    
    func getSearchContent(str: String, completion: @escaping(webServicesCompletionBlock)) {
        let parameters = ["search": str,"uid": DataManager.shared.userId ?? "0"]
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.search, completion: completion)
    }
    
}
// MARK: - add favorite in whole app
extension CloudDataManager {
    
    func addFavorite(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.addFavorite, completion: completion)
    }
    func addCheck(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
           WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.markCheck, completion: completion)
       }
    
}

// MARK: - My ACL create chapter
extension CloudDataManager {
    
    func createChapter(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.create_Chapter, completion: completion)
    }
    func getWeektrainingList(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
           WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.weektrainingList, completion: completion)
       }
}

// MARK: - chapter listing
extension CloudDataManager {
    
    func eventListing(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.event_Listing, completion: completion)
    }
 
    func joinEvent(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
           WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.join_Event, completion: completion)
       }
    
    func enrolledEventsListing(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.enrolledEvents, completion: completion)
    }
    func reportPagesAPI(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.reportPages, completion: completion)
    }
    
}
//-fav list

extension CloudDataManager {
    func getFavListing(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
          WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.favoritelist, completion: completion)
      }
    func getRecordingListing(_ parameters: Parameters, completion: @escaping(webServicesCompletionBlock)) {
        WebServices.multipartRequest(parameters, endPoint: APIConstants.EndPoints.recordings, completion: completion)
    }
    
}
