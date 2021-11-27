//
//  DailyMeditationViewModel.swift
//  ACL
//
//  Created by RGND on 28/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class DailyMeditationViewModel {
    
    var meditation: Meditation?
    var customeMeditations: [Meditation] = [Meditation]()
    var customSound : [CustomSounds] = [CustomSounds]()
    
    func getMedications(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = ["uid": DataManager.shared.userId!]
        
        CloudDataManager.shared.getWeeklyMeditation(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            // get data
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                self.meditation = Meditation(data)
                // get custome meditations
                self.customeMeditations.removeAll()
                if let categories = data["category"] as? [[String: Any]] {
                    for category in categories {
                        self.customeMeditations.append(Meditation(category))
                    }
                    self.meditation?.isFavorite = data["isFavorite"] as? String
                }
            }
            completion(true, "")
        }
    }
    
    func getCustomMeditationSounds(_ completion: @escaping(cloudDataCompletionHandler)) {
//        let parameters = ["uid": DataManager.shared.userId!]
        
        CloudDataManager.shared.getCustomSounds([:]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            // get data
            if let data = response?[APIConstants.Response.data] as? [[String: Any]] {
                self.customSound.removeAll()
                for dict in data{
                    self.customSound.append(CustomSounds(dict))
                }
            }
            completion(true, "")
        }
    }
    
    func addFavourite(_ completion: @escaping(cloudDataCompletionHandler)){
        let param = ["uid": DataManager.shared.userId!, "type" : APIConstants.favType.Meditation, "item_id": meditation?.categoryId]
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
