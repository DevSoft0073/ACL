//
//  WeeklyChallengeViewModel.swift
//  ACL
//
//  Created by RGND on 27/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class WeeklyChallengeViewModel {
    
    var challenge: Challenge?
    
    func getChallenge(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = getParameters()
        
        CloudDataManager.shared.getWeeklyChallenge(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create challenge model
                self.challenge = Challenge(data)
               
            }
            completion(true, "")
        }
    }
    
    func completeChallenge(_ completion: @escaping(cloudDataCompletionHandler)) {
        if let id = challenge?.id, let userid = DataManager.shared.userId {
            let parameters = ["challenge_id": id, "uid": userid, "completed": "1"]
            responseChallenge(parameters: parameters, completion)
        }
    }
    
    private func responseChallenge (parameters: [String: Any], _ completion: @escaping(cloudDataCompletionHandler)){
        CloudDataManager.shared.responseChallenge(parameters, completion: completion)
    }
    
    func getParameters() -> [String: Any] {
        let parameters = ["uid": DataManager.shared.userId!]
        return parameters
    }
    
    func addFavourite(_ completion: @escaping(cloudDataCompletionHandler)){
        let param = ["uid": DataManager.shared.userId!, "type" : APIConstants.favType.weekly_challenge, "item_id": challenge?.id]
        CloudDataManager.shared.addFavorite(param) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            completion(true, "")
        }
    }
        
}
