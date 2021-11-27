//
//  NewsViewModel.swift
//  ACL
//
//  Created by Gagandeep on 27/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import Foundation

class News: NSObject {
    
    var id: String?
    var author: String?
    var banner: String?
    var image: String?
    var title: String?
    var newsDescription: NSAttributedString?
    
    init(_ data: [String: Any]) {
        
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        self.author = data["author"] as? String
        
        if let text = data["description"] as? String {
            self.newsDescription = text.htmlToAttributedString
        }
        
        self.image = data["image"] as? String
        self.banner = data["banner"] as? String
    }
    
}

class NewsViewModel {
    
    
    var newsArray: [News] = [News]()
    
    var listingBanner: String?
    var currentPage: String = "1"
    var totalPage: String = "1"
    
    
    func getNews( completion: @escaping cloudDataCompletionHandler) {
        let parameter = ["page": "1"]
        CloudDataManager.shared.getNews(parameter) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
            
                self.listingBanner = data["listing_banner"] as? String
                self.currentPage = data["currentPage"] as? String ?? "1"
                self.totalPage = data["totalPages"] as? String ?? "1"
                
                self.newsArray.removeAll()
                
                if let newsArray = data["news"] as? [[String: Any]] {
                    for newsData in newsArray {
                        self.newsArray.append(News(newsData))
                    }
                }
            }
            completion(true, validation.errorMessage)
        }
    }
}
