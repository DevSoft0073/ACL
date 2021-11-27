//
//  FinalACLViewModel.swift
//  ACL
//
//  Created by RGND on 28/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation

class ACL: NSObject {
    var id: String?
    var latitude: String?
    var longitude: String?
    var name:String?
    var uid: String?
    var status: String?
    var co_leader: String?
    var contact: String?
    var aclDescription: String?
    var group_started: String?
    var image: String?
    var join_link: String?
    var leader: String?
    var meet: String?
    var place: String?    
    var welcomeText: String?
    var isFavourite : String?
    var chapterType : chapterTypes?
    
    enum chapterTypes : Int {
            case publicChapter = 0
            case privateChapter = 1
            case ghostChapter = 2
        }
    
    
    init(_ data: [String: Any]) {
        self.id = data["id"] as? String
        self.latitude = data["latitude"] as? String
        self.longitude = data["longitude"] as? String
        self.name = data["name"] as? String
        self.status = data["status"] as? String
        self.uid = data["uid"] as? String
        self.co_leader = data["co_leader"] as? String
        self.contact = data["contact"] as? String
        self.aclDescription = data["description"] as? String
        self.group_started = data["group_started"] as? String
        self.image = data["image"] as? String
        self.join_link = data["join_link"] as? String
        self.leader = data["leader"] as? String
        self.meet = data["meeting_info"] as? String
        self.place = data["address"] as? String
        self.welcomeText = data["welcome"] as? String
        self.isFavourite = data["isFavorite"] as? String
        
        if let value = data["chapterType"] as? String{
            print("herre is chapter types",value)
            if value.contains("Private"){
                self.chapterType = .privateChapter
            }else if value.contains("Public"){
                self.chapterType = .publicChapter
            }else{
                self.chapterType = .ghostChapter
            }
        }

    }
}

class FinalACLViewModel {
        
    var aclArray: [ACL] = [ACL]()
    var selectedACLId: String?
    var selectedACL: ACL?
    
    var searchCityName = ""
    var searchCountryName = ""
    var searchLat: String = "40.299200"
    var searchLong: String = "-3.797380"
    var searchZipcode: String = ""
    var hasLocalChapters = false
    
    
    func findACL(_ completion: @escaping(cloudDataCompletionHandler)) {
        
        CloudDataManager.shared.findNearByACL(getParameters()) { response, error in
            
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            // remove old data
            self.aclArray.removeAll()
            // get data
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                
                if let localData = data["local"] as? [[String: Any]]{
                    if localData.count == 0{
                        self.hasLocalChapters = false
                    }else{
                        self.hasLocalChapters = true
                    }
                    for aclData in localData {
                        self.aclArray.append(ACL(aclData))
                    }
                }
                if let worldWideData = data["wordwide"] as? [[String: Any]]{
                    for aclData in worldWideData {
                        self.aclArray.append(ACL(aclData))
                    }
                }
                
                // create ACL model
//                for aclData in data {
//                    self.aclArray.append(ACL(aclData))
//                }
            }
            completion(true, "")
        }
        
    }
    
    func getACLInfo(_ completion: @escaping(cloudDataCompletionHandler)) {
        guard let selectedId =  selectedACLId else {
            completion(false, "")
            return
        }
        
        CloudDataManager.shared.getACLInfo(["id": selectedId,"uid":DataManager.shared.userId ?? ""]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create ACL model
                self.selectedACL = ACL(data)
            }
            
            completion(true, "")
        }
    }
    
    func getParameters() -> [String: Any] {
        let parameters = ["latitude": searchLat ,
                          "longitude": searchLong ,
                          "range": "100"]
        
        return parameters
    }
    
    func addFavourite(id : String,completion: @escaping cloudDataCompletionHandler){
        let param = ["uid": DataManager.shared.userId!, "type" : APIConstants.favType.Acl_groups, "item_id": id]

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
    
    
}
