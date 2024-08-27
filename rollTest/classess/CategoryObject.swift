//
//  CategoryObject.swift
//  shoppingg
//
//  Created by Botan Amedi on 6/23/20.
//  Copyright © 2020 com.saucepanStory. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CategoryObject {
    var id : Int = 0
    var title = ""
    var image = ""
    var countProducts = ""
    var parentId = ""
    init(id:Int,title:String,image:String,countProducts:String,parentId:String) {
        self.id = id
        self.title = title
        self.image = image
        self.countProducts = countProducts
        self.parentId = parentId
    }
}


class CatagoryAPI {
    
    static func getData(completion : @escaping (_ Cat : [CategoryObject])->()){
        var category = [CategoryObject]()
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "getMainCategory":API.UserName,
            "language_id":lang
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let cat = CategoryObject(id: val["category_id"].int ?? 0, title: val["name"].string ?? "", image: val["image"].string ?? "", countProducts: val["counting"].string ?? "", parentId: val["parent_id"].string ?? "")
                        category.append(cat);
                    }
                    completion(category);
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func getCategoryInData(CategoryID : String ,completion : @escaping (_ Cat : [CategoryObject])->()){
        var category = [CategoryObject]()
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "thiscategoryid":CategoryID ,
            "language_id":lang
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let cat = CategoryObject(id: val["category_id"].int ?? 0, title: val["name"].string ?? "", image: val["image"].string ?? "", countProducts: val["counting"].string ?? "", parentId: val["parent_id"].string ?? "")
                        category.append(cat);
                        
                    }
                    completion(category);
                    
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetOneProducts(CategoryID : Int ,completion : @escaping (_ Cat : [ProductObject])->()){
        var product = [ProductObject]()
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "language_id":lang,
            "getOneProducts" :"Any",
            "category_id" : CategoryID
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let pro = ProductObject(product_id: val["product_id"].int ?? 0,
                                                                    ownerId: val["firebase_id"].string ?? "",
                                                                    name: val["name"].string ?? "",
                                                                    catagoryName: val["catname"].string ?? "",
                                                                    viewed: val["viewed"].int ?? 0,
                                                                    image: val["image"].string ?? "",
                                                                    price: val["price"].string ?? "",
                                                                    details: val["details"].string ?? "",
                                                                    rating: val["rating"].string ?? "0",
                                                                    countReviews: val["countReviews"].string ?? "",
                                                                    latitude:  val["Latitude"].double ?? 0,
                                                                    longitude: val["Longitude"].double ?? 0,
                                                                    phone: val["phone_number"].string ?? "",
                                                                    description: val["description"].string ?? "",
                                                                    zone: val["zone_id"].string ?? "",
                                                                    dateAdded: val["date_added"].string ?? "",
                                                                    catagoryId : val["category_id"].int ?? 0,
                                                                    DolarPrice: val["price_d"].int ?? 0,
                                                                    firebaseImage: val["firebase_image"].int ?? 0,
                                                                    location: val["location"].string ?? "")
                        product.append(pro)
                    }
                    completion(product)
                }
            case .failure(let error):
                print(error);
            }
        }
    }


    
    static func GetAllProductFilter(priceFrom : Double , priceTo : Double ,ZonId : Int ,CategoryID : Int ,completion : @escaping (_ Cat : [ProductObject])->()){
        var product = [ProductObject]()
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        let stringUrl = URL(string: API.URL);
        var param : [String : Any] = [
                "key":API.key,
                "username":API.UserName,
                "language_id":lang,
                "getOneProducts" :"Any"
            ]
        
        if ZonId != 0{
            param["zone_id"] = ZonId
        }
        if CategoryID != 0{
            param["category_id"] = CategoryID
        }
        
        if priceFrom != 0.0{
            param["price_from"] = priceFrom
        }
        if priceTo >= 0.0 {
            param["price_to"] = priceTo
        }
        print(ZonId)
        print(CategoryID)
        print(priceFrom)
        print(priceTo)
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
             {
             case .success(_):
                 let jsonData = JSON(response.data ?? "")
                 if(jsonData[0] != "error"){
                     for (_,val) in jsonData{
                         let pro = ProductObject(product_id: val["product_id"].int ?? 0,
                                                                     ownerId: val["firebase_id"].string ?? "",
                                                                     name: val["name"].string ?? "",
                                                                     catagoryName: val["catname"].string ?? "",
                                                                     viewed: val["viewed"].int ?? 0,
                                                                     image: val["image"].string ?? "",
                                                                     price: val["price"].string ?? "",
                                                                     details: val["details"].string ?? "",
                                                                     rating: val["rating"].string ?? "0",
                                                                     countReviews: val["countReviews"].string ?? "",
                                                                     latitude:  val["Latitude"].double ?? 0,
                                                                     longitude: val["Longitude"].double ?? 0,
                                                                     phone: val["phone_number"].string ?? "",
                                                                     description: val["description"].string ?? "",
                                                                     zone: val["zone_id"].string ?? "",
                                                                     dateAdded: val["date_added"].string ?? "",
                                                                     catagoryId : val["category_id"].int ?? 0,
                                                                     DolarPrice: val["price_d"].int ?? 0,
                                                                     firebaseImage: val["firebase_image"].int ?? 0,
                                                                     location: val["location"].string ?? "")
                         product.append(pro)
                     }
                     completion(product)
                 }
             case .failure(let error):
                 print(error);
             }
         }
     }
}

