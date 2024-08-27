//
//  UserObject.swift
//  shoppingg
//
//  Created by Botan Amedi on 6/23/20.
//  Copyright © 2020 com.saucepanStory. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class UserObject{
    var Id = ""
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email = ""
    
    
    init(Id : String ,firstName : String , lastName : String , phoneNumber : String , email : String) {
        self.Id = Id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
    }
}



class UserAPI {
    

static func GetUserInfo(UserId : String , completion : @escaping (_ UserINFO : UserObject)->()){
        var userInfo : UserObject!
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "firebase_id": UserId,
            "loginUser": "Any"
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    let User = jsonData["user"]
                    for (_,val) in User{
                        
                        let user = UserObject(Id: val["firebase_id"].string ?? "",
                                              firstName: val["firstname"].string ?? "",
                                              lastName: val["lastname"].string ?? "",
                                              phoneNumber: val["telephone"].string ?? "",
                                              email: val["email"].string ?? "")
                        userInfo = user
                        print(userInfo.email)
                    }
                    if userInfo != nil{
                    completion(userInfo)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func UpdateNotification(OneSignalUUID : String){
         guard let UserId = UserDefaults.standard.string(forKey: "UserId") else {  return }
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "firebase_id": UserId,
            "onesignal_uuid": OneSignalUUID,
            "updateNotification": "Any"
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                   print("Notification Updated")
                }
            case .failure(let error):
                print("Notification not Updated")
                print(error)
            }
        }
    }
    
    
}
