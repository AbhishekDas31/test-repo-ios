//
//  WebServices.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 18/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Alamofire
import Amplify

class WebServices: NSObject {
    
    let accessToken = CustomUserDefaults.getAccessToken()
    
    //MARK:- Post Request with "status Code" check
    class func postRequest(urlString: String, paramDict:[String:Any],isWalletUser: Bool, isAuth: Bool,xAPIKey: String,
                           completionHandler:@escaping (NSDictionary?, String?, NSError?) -> ()) {
        
        var dicParam = [String: Any]()
        for (key, value) in paramDict {
            if value is String {
                dicParam [key] = (value as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                dicParam [key] = value
            }
        }
        
        let user = "swagger-client"
        let password = "swagger-secret"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        //        let headers = []
        var header:HTTPHeaders =  [:]
        if isAuth {
            if isWalletUser{
                header = ["Authorization": "bearer \(CustomUserDefaults.getWalletAccessToken())", "x-api-key": xAPIKey, "ClientHasId": "\(liveClientHashID)"]
            }else{
                header = ["Authorization": "bearer \(CustomUserDefaults.getAccessToken())", "x-api-key": xAPIKey, "x-request-id": "12345532675"]
            }
            
        } else {
            if isWalletUser{
                /*  x-api-key:tDwjoMFPiL1XDYTjb8H313BWbmFlh1ve21usj7Oj
                 ClientHasId:cebd2dfb-b010-48ef-b2f2-ac7e640e3a68 */
                header = ["x-api-key": xAPIKey, "ClientHasId": "\(liveClientHashID)", "Authorization": "Basic \(base64Credentials)"]
            }else{
                header = ["x-api-key": xAPIKey, "x-request-id": "12345532675"]
            }
            
        }
        
        AF.request(urlString, method: .post, parameters: dicParam, encoding: JSONEncoding.default, headers: header).responseString { (response:AFDataResponse<String>) in
            switch response.result {
            case let .success(value):
                if let dictionary = WebServices.convertStringToDictionary(text: value) {
                    completionHandler(dictionary as NSDictionary?, nil, nil)
                } else {
                    completionHandler(nil, value, nil)
                }
                //                if let JSON = value as? [String: Any] {
                //
                //                } else if let stringJson = value as? String {
                //
            //                }
            case .failure(_):
                Global.handleError(withMessage: "Something went wrong!", okBlock: {
                    WebServices.logOutUser()

                })
                // completionHandler(nil, nil, error as NSError?)
            }
        }
    }

    class func postRequestnexom(urlString: String, paramDict:[String:Any],isWalletUser: Bool, isAuth: Bool,xAPIKey: String,
                           completionHandler:@escaping (NSDictionary?, String?, NSError?) -> ()) {

        var dicParam = [String: Any]()
        for (key, value) in paramDict {
            if value is String {
                dicParam [key] = (value as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                dicParam [key] = value
            }
        }



        AF.request(urlString, method: .post, parameters: dicParam, encoding: JSONEncoding.default, headers: nil).responseString { (response:AFDataResponse<String>) in
            switch response.result {
            case let .success(value):
                if let dictionary = WebServices.convertStringToDictionary(text: value) {
                    completionHandler(dictionary as NSDictionary?, nil, nil)
                } else {
                    completionHandler(nil, value, nil)
                }
                //                if let JSON = value as? [String: Any] {
                //
                //                } else if let stringJson = value as? String {
                //
            //                }
            case .failure(_):
                Global.handleError(withMessage: "Something went wrong!", okBlock: {
                    WebServices.logOutUser()

                })
                // completionHandler(nil, nil, error as NSError?)
            }
        }
    }
    
    class func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    //MARK:- Post Request with "status Code" check
    class func postURLEncodedRequest(urlString: String, paramDict:[String:Any], isAuth: Bool,
                                     completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {

        var dicParam = [String: Any]()
        for (key, value) in paramDict {
            if value is String {
                dicParam [key] = (value as AnyObject).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                dicParam [key] = value
            }
        }
        let user = "swagger-client"
        let password = "swagger-secret"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var header:HTTPHeaders =  [:]
        if isAuth {
            header = ["Authorization": "Basic c3dhZ2dlci1jbGllbnQ6c3dhZ2dlci1zZWNyZXQ=", "x-api-key": "f33CQSi6x83mFrUv4Wi59fInMyhW7H89fst0d5k5"]
        } else {
            header = ["x-api-key": "f33CQSi6x83mFrUv4Wi59fInMyhW7H89fst0d5k5"]
        }

        AF.request(urlString, method: .post, parameters: dicParam, encoding: URLEncoding.httpBody, headers: header).validate(contentType: ["application/x-www-form-urlencoded; "]).responseJSON { (response:AFDataResponse<Any>) in
            switch response.result {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    completionHandler(JSON as NSDictionary?, nil)
                }
            case .failure(_):
                Global.handleError(withMessage: "Something went wrong!", okBlock: {
                    WebServices.logOutUser()

                })
                // completionHandler(nil, error as NSError?)
            }
        }
    }
    

    //MARK:- Get Request
    class func getRequest(urlString: String, paramDict:[String:Any]? = nil,isAuth: Bool,isWalletUser: Bool,xAPIKey: String, completionHandler:@escaping (NSDictionary?, [[String: Any]]?, NSError?) -> ()) {
        

        let user = "swagger-client"
        let password = "swagger-secret"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        //        let headers = []
        var header:HTTPHeaders =  [:]
        if isAuth {
            if isWalletUser{
                header = ["Authorization": "bearer \(CustomUserDefaults.getWalletAccessToken())", "x-api-key": xAPIKey, "ClientHasId": "\(liveClientHashID)"]
            }else{
                header = ["Authorization": "bearer \(CustomUserDefaults.getAccessToken())", "x-api-key": xAPIKey, "x-request-id": "12345532675"]
            }

        } else {
            if isWalletUser{
                header = ["x-api-key": xAPIKey, "ClientHasId": "\(liveClientHashID)", "Authorization": "Basic \(base64Credentials)"]
            }else{
                header = ["x-api-key": xAPIKey, "x-request-id": "12345532675"]
            }

        }
        AF.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response:AFDataResponse<Any>) in
            switch(response.result) {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    completionHandler(JSON as NSDictionary?, nil, nil)
                }
                if let arrayJSON = value as? [[String: Any]] {
                    completionHandler(nil,arrayJSON as [[String: Any]], nil)
                }
            case .failure(_):
                Global.handleError(withMessage: "Something went wrong!", okBlock: {
                    WebServices.logOutUser()

                })
                //completionHandler(nil, nil,error as NSError?)
                break
            }
        }
    }
    
    //MARK:- Delete Request
    class func deleteRequest(urlString: String, paramDict:Dictionary<String, Any>? = nil,
                             isAuth: Bool, completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        
        var dicParam = [String: Any]()
        for (key, value) in paramDict! {
            if value is String {
                dicParam [key] = value
            } else {
                dicParam [key] = value
            }
        }
        let user = "swagger-client"
        let password = "swagger-secret"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var header:HTTPHeaders =  [:]
        if isAuth {
            //            header = ["Authorization": "Bearer "+CustomUserDefault.getToken(), "device_platform": "ios", "app_version": "\(Constants.kAppVersion)"]
        } else {
            header = [:]
        }
        AF.request(urlString, method: .delete, parameters: dicParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response:AFDataResponse<Any>) in
            switch(response.result) {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    completionHandler(JSON as NSDictionary?, nil)
                }
            case .failure(_):
                Global.handleError(withMessage: "Something went wrong!", okBlock: {
                    WebServices.logOutUser()

                })
                // completionHandler(nil, error as NSError?)
                break
            }
        }
    }
    //MARK:- Put Request
    class func putRequest(urlString: String, paramDict:Dictionary<String, Any>? = nil,
                          isAuth: Bool, completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        
        var dicParam = [String: Any]()
        for (key, value) in paramDict! {
            if value is String {
                dicParam [key] = value
            } else {
                dicParam [key] = value
            }
        }
        let user = "swagger-client"
        let password = "swagger-secret"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var header:HTTPHeaders =  [:]
        if isAuth {
            //            header = ["Authorization": "Bearer "+CustomUserDefault.getToken(),"device_platform": "ios", "app_version": "\(Constants.kAppVersion)","language": "\(CustomUserDefault.getLanguageName())"]
        } else {
            header = [:]
        }
        AF.request(urlString, method: .put, parameters: dicParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response:AFDataResponse<Any>) in
            switch(response.result) {
            case let .success(value):
                if let JSON = value as? [String: Any] {
                    completionHandler(JSON as NSDictionary?, nil)
                }
            case .failure(_):
                Global.handleError(withMessage: "Something went wrong!", okBlock: {
                    WebServices.logOutUser()

                })
                // completionHandler(nil, error as NSError?)
                break
            }
        }
    }
    
    
    
    //MARK:- Post Request With Image
    class  func uploadImageWithParameterAndImageName(strImageKey :  String,urlString: String,xAPIKey: String,isAuth: Bool,isWalletUser:Bool, image : UIImage , paramDict:Dictionary<String, Any>? = nil,completionHandler:@escaping (NSDictionary?, NSError?) -> ()) {
        let user = "swagger-client"
        let password = "swagger-secret"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var header:HTTPHeaders =  [:]
        if isAuth {
            if isWalletUser{
                header = ["Authorization": "bearer \(CustomUserDefaults.getWalletAccessToken())", "x-api-key": xAPIKey, "ClientHasId": "\(liveClientHashID)"]
            }else{
                header = ["Authorization": "bearer \(CustomUserDefaults.getAccessToken())", "x-api-key": xAPIKey, "x-request-id": "12345532675"]
            }
            
        } else {
            if isWalletUser{
                header = ["x-api-key": xAPIKey, "ClientHasId": "\(liveClientHashID)", "Authorization": "Basic \(base64Credentials)"]
            }else{
                header = ["x-api-key": xAPIKey, "x-request-id": "12345532675"]
            }
            
        }
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in paramDict! {
                multiPart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data =  image.jpegData(compressionQuality: 1) {
                multiPart.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }

        }, to: urlString,headers: header)
            .responseJSON(completionHandler: { (response:AFDataResponse<Any>) in
                switch(response.result) {
                case let .success(value):
                    if let JSON = value as? [String: Any] {
                        completionHandler(JSON as NSDictionary?, nil)
                    }
                case .failure(_):
                    Global.handleError(withMessage: "Something went wrong!", okBlock: {
                        WebServices.logOutUser()

                    })
                    // completionHandler(nil, error as NSError?)
                    break
                }
            })
        
    }

    class func logOutUser()
    {
        _ = Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                removeCredentials()
                DispatchQueue.main.async {
                    Constants.kAppDelegate?.setControllers()
                }
            case .failure(let error):
                debugPrint("\(error.errorDescription)")
                //                DispatchQueue.main.async {
                //                    Global.showAlert(withMessage: "\(error.errorDescription)", sender: viewController)
                //                }
            }
        }
    }
    
}
