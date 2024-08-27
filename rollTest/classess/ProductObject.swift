//
//  ProductObject.swift
//  shoppingg
//
//  Created by Botan Amedi on 6/23/20.
//  Copyright © 2020 com.saucepanStory. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView
import MapKit


class ProductObject {
   
     var product_id : Int = 0
     var name = "";
     var ownerId = ""
     var catagoryName = ""
     var catagoryId = 0
     var viewed : Int = 0
     var image = "";
     var firebaseImage = 0
     var priceIQD = "";
     var IntPrice : Int = 0
     var details = ""
     var dateAdded = ""
     var description = "";
     var rating = "3.0"
     var countReviews = "0"
    var longitude = 0.0
    var latitude = 0.0
     var commentsId = ""
     var phone = "";
     var y_video_link = ""
     var relatedID = ""
     var zone = ""
     var formatDate = ""
     var DolarPrice = 0
     var location = ""
    
    
    init(product_id:Int ,ownerId : String,name:String,catagoryName : String,viewed:Int,image:String,price:String,details:String,rating:String,countReviews:String,latitude:Double,longitude:Double,phone:String,description:String , zone : String , dateAdded : String , catagoryId : Int ,DolarPrice : Int , firebaseImage : Int , location : String) {
         self.product_id = product_id;
         self.name = name
         self.ownerId = ownerId
         self.catagoryName = catagoryName
         self.viewed = viewed
         self.description = description
         self.image = image.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
         self.priceIQD = price
         self.IntPrice = (price as NSString).integerValue
         self.details = details
         self.rating = rating;
         self.countReviews = countReviews;
         self.phone = phone
         self.longitude = longitude
         self.latitude = latitude
         self.zone = zone
         self.dateAdded = dateAdded
         self.catagoryId = catagoryId
         self.DolarPrice = DolarPrice
         self.firebaseImage = firebaseImage
        self.location = location
     }

    
}

class ProductAPI {
    static func GetAllProduct(pageNumber : Int ,completion : @escaping (_ Cat : [ProductObject])->()){
        var product = [ProductObject]()
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        let ZonId : Int = UserDefaults.standard.integer(forKey: "CityId")
        print(ZonId)
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "getAllProducts":API.UserName,
            "language_id":lang,
            "page_number": pageNumber,
            "zone_id" : ZonId
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let pro = ProductObject(product_id: val["product_id"].int ?? 0,
                                                ownerId : val["firebase_id"].string ?? "",
                                                name: val["name"].string ?? "",
                                                catagoryName: val["catname"].string ?? "",
                                                viewed: val["viewed"].int ?? 0,
                                                image: val["image"].string ?? "",
                                                price: val["price"].string ?? "",
                                                details: val["details"].string ?? "",
                                                rating: val["countReviews"].string ?? "0",
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
    
    
   static func GetImages(productId : Int ,completion : @escaping (_ img : [String])->()){
        var ImageArray = [String]()
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "getImages":productId
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        ImageArray.append(val["image"].string ?? "")
                    }
                    completion(ImageArray)
                }
            case .failure(let error):
                print(error);
            }
        }
        
    }
    

    
    static  func InsertProduct(PhoneNumber : String,FullName : String, Model : String , Latitude :Double ,Longitude :Double ,PriceDelar : Double , PriceIQD : Double  , Location : String,imageFirebase : String ,KurdishName : String, ArabicName : String ,KurdishDescription : String , ArabicDescription : String, CategoryId : Int , ZoneId : Int , ProductImage : JSON , ProductAttribute : String ){
             guard let UserId = UserDefaults.standard.string(forKey: "UserId") else {  return }
             let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "addproduct":99,
            "firebase_id" :UserId,
            "firebase_fullname" : FullName,
            "phone_number" : PhoneNumber,
            "model" :Model,
            "Latitude" :Latitude,
            "Longitude":Longitude,
            "price": PriceIQD ,
            "price_d" : PriceDelar,
            "location":Location,
            "image" : imageFirebase,
            "name_ku" :KurdishName,
            "description_ku" :KurdishDescription,
            "name_ar":ArabicName,
            "description_ar":ArabicDescription,
            "product_category":CategoryId,
            "zone_id" : ZoneId,
            "product_images" :ProductImage,
            "product_attribute" :ProductAttribute
        ]
        
         AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
             switch response.result
             {
             case .success:
                 let jsonData = JSON(response.data ?? "")
                 if(jsonData[0] != "error"){
                     if(jsonData["code"][0].int == 100){
                        
                         if (UserDefaults.standard.integer(forKey: "language") == 2){
                             let message = "تم الإضافة بنجاح, الرجاء كن في إنتظار موافقة نشر المنتج من الأدمن."
                             SCLAlertView().showSuccess(API.APP_TITLE, subTitle: message);
                         }else{
                             print(jsonData)
                             let message = "كاڵاكت بەسەركەوتوويانه زياد بو، تكايه چاوەروانى رەزامەندى ئەدمين بكه تا وەكو كاڵاكەت بڵاو ببێت."
                             SCLAlertView().showSuccess(API.APP_TITLE, subTitle: message);
                         }
                     }else{
                         if (UserDefaults.standard.integer(forKey: "language") == 2){
                             let message = "لم يتم إضافة المنتج."
                             SCLAlertView().showWarning(API.APP_TITLE, subTitle: message);
                         }else{
                             let message = "كاڵاكەت زياد نەبوو."
                             SCLAlertView().showWarning(API.APP_TITLE, subTitle: message);
                         }
                     }
                     
                 }
             case .failure(let error):
                 print(error);
             }
         }
     }
    
    
    
    
    static  func UpdateProduct(ProductId : Int , PhoneNumber : String,FullName : String, Model : String , Latitude :Double ,Longitude :Double ,PriceDelar : Double , PriceIQD : Double  , Location : String,imageFirebase : String ,KurdishName : String, ArabicName : String ,KurdishDescription : String , ArabicDescription : String, CategoryId : Int , ZoneId : Int , ProductImage : JSON , ProductAttribute : String ){
                guard let UserId = UserDefaults.standard.string(forKey: "UserId") else {  return }
                let stringUrl = URL(string: API.URL);
           let param: [String: Any] = [
               "key":API.key,
               "username":API.UserName,
               "updateproduct":99,
               "product_id" : ProductId,
               "firebase_id" :UserId,
               "firebase_fullname" : FullName,
               "phone_number" : PhoneNumber,
               "model" :Model,
               "Latitude" :Latitude,
               "Longitude":Longitude,
               "price": PriceIQD ,
               "price_d" : PriceDelar,
               "location":Location,
               "image" : imageFirebase,
               "name_ku" :KurdishName,
               "description_ku" :KurdishDescription,
               "name_ar":ArabicName,
               "description_ar":ArabicDescription,
               "product_category":CategoryId,
               "zone_id" : ZoneId,
               "product_images" :ProductImage,
               "product_attribute" :ProductAttribute
           ]
           
            AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
                switch response.result
                {
                case .success:
                    let jsonData = JSON(response.data ?? "")
                    if(jsonData[0] != "error"){
                        print("1")
                        if (UserDefaults.standard.integer(forKey: "language") == 2){
                            let message = "تم التحديث بنجاح, الرجاء كن في إنتظار موافقة نشر المنتج من الأدمن."
                            SCLAlertView().showSuccess(API.APP_TITLE, subTitle: message);
                        }else{
                            let message = "كاڵاكەت بەسەركەوتوويانه نوێ كرا، تكايه چاوەروانى رەزامەندى ئەدمين بكه تا وەكو كاڵاكەت بڵاو ببێت."
                            SCLAlertView().showSuccess(API.APP_TITLE, subTitle: message);
                        }
                    }else{
                        print("2")
                        if (UserDefaults.standard.integer(forKey: "language") == 2){
                            let message = "لم يتم التحديث."
                            SCLAlertView().showWarning(API.APP_TITLE, subTitle: message);
                        }else{
                            let message = "كاڵاكەت نوێ نەكرا."
                            SCLAlertView().showWarning(API.APP_TITLE, subTitle: message);
                        }
                    }
                case .failure(let error):
                    print(error);
                }
        }
        }
    
    
    
    
    static func SetToWishList(ProductID : Int, completion : @escaping (_ state : Bool)->()){
        guard let UserId = UserDefaults.standard.string(forKey: "UserId") else {  return }
                 let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "product_id": ProductID,
            "setProductWishList": UserId
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    if(jsonData["code"][0].int == 100){
                        print("تمت الإضافة إلى المفضلة")
                        completion(true)
                    }else{
                        print("لم يتم الإضافة إلى المفضلة")
                         completion(false)
                    }
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func RemovFromWishList(ProductID : Int, completion : @escaping (_ state : Bool)->()){
        guard let UserId = UserDefaults.standard.string(forKey: "UserId") else {  return }
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "product_id": ProductID,
            "removeProductWishList": UserId
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    if(jsonData["code"][0].int == 100){
                        print("تم الحذف")
                         completion(true)
                    }else if(jsonData["code"][0].int == 0){
                        print("لم يتم الحذف")
                         completion(false)
                    }
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetMyProducts(completion : @escaping (_ Cat : [ProductObject])->()){
        var product = [ProductObject]()
        guard let UserId = UserDefaults.standard.string(forKey: "UserId") else {  return }
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "getcustomerproduct": UserId,
            "language_id" : lang,
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                    let jsonData = JSON(response.data ?? "")
                    if(jsonData[0] != "error"){
                        for (_,val) in jsonData{
                            let pro = ProductObject(product_id: val["product_id"].int ?? 0,
                                                    ownerId : val["firebase_id"].string ?? "",
                                                    name: val["name"].string ?? "",
                                                    catagoryName: val["catname"].string ?? "",
                                                    viewed: val["viewed"].int ?? 0,
                                                    image: val["image"].string ?? "",
                                                    price: val["price"].string ?? "",
                                                    details: val["details"].string ?? "",
                                                    rating: val["countReviews"].string ?? "0",
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




class  ZoneObject {
    var zone_id : Int = 0
    var country_id : Int = 0
    var name = ""
    var code = ""
    
    
    init(id : Int , countyID : Int , name : String , code : String) {
        self.zone_id = id
        self.country_id = countyID
        self.name = name
        self.code = code
    }
}

class ZoneAPI {
    
    static func GetAllZone(completion : @escaping(_ Zons : [ZoneObject])->()){
        
        var Zones = [ZoneObject]()
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "getallZones":API.UserName,
               ]
               
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       if(jsonData[0] != "error"){
                           for (_,val) in jsonData{
                            let zone = ZoneObject(id: val["zone_id"].int ?? 0,
                                                                           countyID: val["country_id"].int ?? 0,
                                                                           name: val["name"].string ?? "",
                                                                           code: val["code"].string ?? "")
                               Zones.append(zone)
                           }
                           completion(Zones)
                       }
                   case .failure(let error):
                       print(error);
                   }
               }
        
    }
}

class  SlideShowObject {
    var banner_image_id : Int = 0
    var banner_id : Int = 0
    var title = ""
    var link = ""
    var image = ""
    
    init(id : Int , banner_id : Int , title : String , link : String , image : String) {
        self.banner_image_id = id
        self.banner_id = banner_id
        self.title = title
        self.link = link
        self.image = image
    }
}

class SlideShowAPI {
    
    static func GetSlideImage(completion : @escaping(_ SlideImage : [SlideShowObject])->()){
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        var Slide = [SlideShowObject]()
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "language_id" : lang,
                   "getSlideShow":API.UserName
               ]
               
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       if(jsonData[0] != "error"){
                           for (_,val) in jsonData{
                            let slide = SlideShowObject(id: val["banner_image_id"].int ?? 0,
                                                                           banner_id: val["banner_id"].int ?? 0,
                                                                           title: val["title"].string ?? "",
                                                                           link: val["link"].string ?? "",
                                                                           image: val["image"].string ?? "")
                               Slide.append(slide)
                           }
                           completion(Slide)
                       }
                   case .failure(let error):
                       print(error);
                   }
               }
    }
}


class Review{
    var review_Id = "";
    var name = "";
    var date = "";
    var image = "";
    var comment = "";
    var ratting : Int = 0
    
    init(review_Id:String,name:String,date:String,image:String,comment:String,ratting:Int) {
        self.review_Id = review_Id;
        self.name = name
        self.date = date
        self.image = image
        self.comment = comment
        self.ratting = ratting
    }
}

class GetReviewAPI {
    
    
    static  func setReviews(ProductID : Int, commentText : String , rating : Int,completion : @escaping (_ state : Bool)->()){
            guard let UserId = UserDefaults.standard.string(forKey: "UserId") else {  return }
            let stringUrl = URL(string: API.URL);
            let param: [String: Any] = [
                "key":API.key,
                "username":API.UserName,
                "firebase_id":UserId,
                "text" : commentText,
                "product_id" :ProductID,
                "rating" :rating
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    if(jsonData["code"][0].int == 100){
                        if (UserDefaults.standard.integer(forKey: "language") == 2){
                            let message = "تم إضافة تعليقك."
                            SCLAlertView().showSuccess(API.APP_TITLE, subTitle: message);
                            completion(true)
                        }else{
                            let message = "كومێمتەكەت به سەركەوتوويانه زياد بو."
                            SCLAlertView().showSuccess(API.APP_TITLE, subTitle: message);
                            completion(true)
                        }
                    }else{
                        if (UserDefaults.standard.integer(forKey: "language") == 2){
                            let message = "لم يتم إضافة التعليق."
                            SCLAlertView().showWarning(API.APP_TITLE, subTitle: message);
                            completion(false)
                        }else{
                            let message = "كومێمتەكەت نە گەييشت."
                            SCLAlertView().showWarning(API.APP_TITLE, subTitle: message);
                            completion(false)
                        }
                    }
                    
                }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static  func getReviews(ProductID : Int,completion : @escaping (_ imageArray : [Review])->()){
            var reviewS = [Review]()
            let stringUrl = URL(string: API.URL);
            let param: [String: Any] = [
                "key":API.key,
                "username":API.UserName,
                "getPrdocutReviews":ProductID
            ]
            
            AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
                switch response.result
                {
                case .success:
                    let jsonData = JSON(response.data ?? "")
                    if(jsonData[0] != "error"){
                        for (_,val) in jsonData{
                            let rev = Review(review_Id: val["review_id"].string ?? "", name: val["authername"].string ?? "", date: val["date_added"].string ?? "", image: val["image"].string ?? "", comment: val["text"].string ?? "" , ratting: val["rating"].int ?? 0)
                            
                            reviewS.append(rev);
                        }
                        completion(reviewS)
                    }
                case .failure(let error):
                    print(error);
                }
            }
    }

    
    
    
    
    
    
    
    
    
}


class AttributeObject{
    var name = ""
    var text = ""
    var ID = 0
    
    
    init(ID : Int , name : String , text : String) {
        self.name = name
        self.text = text
        self.ID = ID
    }
}

class AttributeAPI{
    static func GetAttribute(productId : Int ,completion : @escaping (_ products : [AttributeObject])->()){
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        let stringUrl = URL(string: API.URL);
        var att = [AttributeObject]()
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "getattr": productId,
            "language_id": lang
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let attr = AttributeObject(ID: val["attribute_id"].int ?? 0, name: val["name"].string ?? "" , text : val["text"].string ?? "")
                        att.append(attr)
                    }
                    completion(att)
                }
            case .failure(let error):
                print(error);
            }
        }
    }
}
class CategoryAttributeObject{
    var name = ""
    var text = ""
    var ID = 0
    
    
    init(ID : Int , name : String , text : String) {
        self.name = name
        self.ID = ID
        self.text = text
    }
}

class AttributeCategoryAPI{
    static func GetCategoryAttribute(CategoryID : Int ,completion : @escaping (_ products : [CategoryAttributeObject])->()){
        let lang : Int = UserDefaults.standard.integer(forKey: "language")
        let stringUrl = URL(string: API.URL);
        var att = [CategoryAttributeObject]()
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "getCategoryAttr": CategoryID,
            "language_id": lang
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let attr = CategoryAttributeObject(ID: val["attribute_id"].int ?? 0, name: val["attr_name"].string ?? "", text: val[""].string ?? "" )
                        att.append(attr)
                    }
                    completion(att)
                }
            case .failure(let error):
                print(error);
            }
        }
    }
}
