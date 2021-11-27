//
//  ACLExercisesViewModel.swift
//  ACL
//
//  Created by Gagandeep on 19/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation

class ACLExercisesViewModel {
    
    var exercise: ACLExercise?
    
    func getExcercises(type: ACLExercisesType, _ completion: @escaping cloudDataCompletionHandler) {
        
        let parameters = ["uid": DataManager.shared.userId!, "id": "\(type.rawValue)"]
        CloudDataManager.shared.getACLExercises(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            // get data
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create model
                self.exercise = ACLExercise(data)
            }
            // return completion
            completion(true, "")
        }
    }
    
    func addFavourite(id : String ,completion: @escaping cloudDataCompletionHandler){
        let param = ["uid": DataManager.shared.userId!, "type" : APIConstants.favType.Excercise, "item_id": id]

        CloudDataManager.shared.addFavorite(param) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }

            completion(true, validation.errorMessage)
        }
    }
    
    //item_id
    func markCheck(item_id: String, completion : @escaping cloudDataCompletionHandler){
        let param = ["uid": DataManager.shared.userId!, "item_id": item_id]
        CloudDataManager.shared.addCheck(param) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }

            completion(true, validation.errorMessage)
        }
        
    }
    
}
