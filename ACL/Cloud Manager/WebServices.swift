//
//  WebServices.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import Alamofire

struct WebServicesConstants { //http://rapidsofts.com/acl/backend/web/api/
    static let baseURL = "http://3.130.228.30/acl/backend/web/api/"
    static let header = ["Content-Type": "application/json", "Client-Service": "frontend-client", "Auth-Key":"simplerestapi"]
}

typealias webServicesCompletionBlock = ([String: Any]?, _ error: Error?)->()

class WebServices {
    
    static func multipartRequest(_ parameter: Parameters, endPoint: String, completion: @escaping(([String: Any]?, _ error: Error?)->())) {
//        let boundary = "Boundary-\(UUID().uuidString)"
//        let header = ["Content-Type": "multipart/form-data; boundary=\(boundary)", "Client-Service": "frontend-client", "Auth-Key":"simplerestapi"]
        
        let url = URL(string: "\(WebServicesConstants.baseURL)\(endPoint)")!
        
        debugPrint("API Url ->\(url.absoluteString)")
        debugPrint("API Payload -> \(parameter)")
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            for param in parameter {
                MultipartFormData.append((param.value as! String).data(using: .utf8)!, withName: param.key)
            }
        }, to: url, method: .post, headers: WebServicesConstants.header) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    debugPrint("API Url ->\(url.absoluteString)")
                    
                    if let error = response.error {
                        debugPrint("API response ->\(error.localizedDescription)")
                        completion(nil, error)
                    }
                    
                    if let data = response.data, let responseJSON = try? JSONSerialization
                    .jsonObject(with: data, options: []) as? [String : Any]{
                       // debugPrint("API response ->\(String(describing: responseJSON))")
                        completion(responseJSON, nil)
                    }
                })
            case .failure(let encodingError):
                debugPrint("API response ->\(encodingError.localizedDescription)")
                completion(nil, encodingError)
            }
        }
    }
    
    
    
    static func multipartImageRequest(_ parameter: Parameters, imagesData:[String: Data] = [String: Data](), endPoint: String, completion: @escaping(([String: Any]?, _ error: Error?)->())) {
       
        let url = URL(string: "\(WebServicesConstants.baseURL)\(endPoint)")!
        
        debugPrint("API Url ->\(url.absoluteString)")
        debugPrint("API Payload -> \(parameter)")
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            // import image to request
            for imageData in imagesData {
                // set key name as array if array contains more than 1 pics
                let keyName = imagesData.count > 1 ? "\(imageData.key)[]" : "\(imageData.key)"
                // append data
                MultipartFormData.append(imageData.value, withName: keyName, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for param in parameter {
                MultipartFormData.append((param.value as! String).data(using: .utf8)!, withName: param.key)
            }
        }, to: url, method: .post, headers: WebServicesConstants.header) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    debugPrint("API Url ->\(url.absoluteString)")
                    
                    if let error = response.error {
                        debugPrint("API response ->\(error.localizedDescription)")
                        completion(nil, error)
                    }
                    
                    if let data = response.data, let responseJSON = try? JSONSerialization
                        .jsonObject(with: data, options: []) as? [String : Any]{
                        debugPrint("API response ->\(String(describing: responseJSON))")
                        completion(responseJSON, nil)
                    }
                })
            case .failure(let encodingError):
                debugPrint("API response ->\(encodingError.localizedDescription)")
                completion(nil, encodingError)
            }
        }
    }
    
    
    func getData() {
        Alamofire.request("/get").response { response in
            debugPrint(response)
        }
    }
    
    
    static func request(_ parameter: Parameters, endPoint: String) {
        
       // let header = ["Content-Type": "application/json", "Client-Service": "frontend-client", "Auth-Key":"simplerestapi"]
        
        let url = URL(string: "\(WebServicesConstants.baseURL)\(endPoint)")!
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            for param in parameter {
                MultipartFormData.append((param.value as! String).data(using: .utf8)!, withName: param.key)
            }
        }, to: url, method: .post, headers: WebServicesConstants.header, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    print("Validation Successful")
                    if let data = response.data , let res = response.response {
                        print(String(data: data, encoding: .utf8)!)
                        
                        if let responseJSON = try? JSONSerialization
                            .jsonObject(with: data,
                                        options: []) as? [String : Any] {
                            
                            print(responseJSON as Any)
                        }
                    }
                })
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    
    static func sessionRequest(_ parameter: Parameters, endPoint: String, completion: @escaping(([String: Any]?)->())) {
        let postData = getParameterData(parameter)
        var request = URLRequest(url: URL(string: "\(WebServicesConstants.baseURL)\(endPoint)")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("frontend-client", forHTTPHeaderField: "Client-Service")
        request.addValue("simplerestapi", forHTTPHeaderField: "Auth-Key")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(nil)
                return
            }
            if let responseJSON = try? JSONSerialization
                .jsonObject(with: data,
                            options: []) as? [String : Any] {
                print(responseJSON as Any)
                completion(responseJSON)
            } else {
                print(String(data: data, encoding: .utf8)!)
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    static func multipartAudioRequest(_ parameter: Parameters, audioData:[String: Data], endPoint: String, completion: @escaping(([String: Any]?, _ error: Error?)->())) {
        
        let url = URL(string: "\(WebServicesConstants.baseURL)\(endPoint)")!
        
        debugPrint("API Url ->\(url.absoluteString)")
        debugPrint("API Payload -> \(parameter)")
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            // import audio to request
            for audioData in audioData {
                MultipartFormData.append(audioData.value, withName: audioData.key, fileName: "\(Date().timeIntervalSince1970).m4a", mimeType: "audio/m4a")
            }
            
            for param in parameter {
                MultipartFormData.append((param.value as! String).data(using: .utf8)!, withName: param.key)
            }
        }, to: url, method: .post, headers: WebServicesConstants.header) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    debugPrint("API Url ->\(url.absoluteString)")
                    
                    if let error = response.error {
                        debugPrint("API response ->\(error.localizedDescription)")
                        completion(nil, error)
                    }
                    
                    if let data = response.data, let responseJSON = try? JSONSerialization
                        .jsonObject(with: data, options: []) as? [String : Any]{
                        debugPrint("API response ->\(String(describing: responseJSON))")
                        completion(responseJSON, nil)
                    }
                })
            case .failure(let encodingError):
                debugPrint("API response ->\(encodingError.localizedDescription)")
                completion(nil, encodingError)
            }
        }
    }
   
    
    static func getParameterData(_ parameter: Parameters?) -> Data? {
        // let parameters2 = "{ \"email\" : \"shyam23@admin.com\", \"password\" : \"Admin123$123\"}"
        guard let parameters = parameter else {
            return nil
        }
        
        var parameterString = "{ "
        var count = 0
        for param in parameters {
            count += 1
            parameterString.append("\"\(param.key)\" : \"\(param.value)\"")
            if count < parameters.count {
                parameterString.append(", ")
            }
        }
        parameterString.append("}")
        
        return parameterString.data(using: .utf8)
    }
    
    
    
    
    
}
