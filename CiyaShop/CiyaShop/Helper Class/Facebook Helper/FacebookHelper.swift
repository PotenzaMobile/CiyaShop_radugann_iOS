//
//  FacebookHelper.swift
//  CiyaShop
//
//  Created by Apple on 28/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

typealias FaceBookLoginBlock = (Bool,[AnyHashable : Any]?) -> Void

class FacebookHelper  {
    
    var facebookLoginCompletion: FaceBookLoginBlock?
    var dictFbDetails: [AnyHashable : Any]?

    private static var shareInstance: FacebookHelper = {
         let instance = FacebookHelper()
         return instance
     }()

    
    class func shared() -> FacebookHelper {
        return shareInstance
    }
    
    private func loginFBUser() {
        let loginFB = LoginManager()
        loginFB.logIn(permissions: ["public_profile", "email"], from: keyWindow?.rootViewController) { (result, error) in
            
            var response = [AnyHashable : Any]()
            
            if error != nil {
                response["error"] = "1"
                self.facebookLoginCompletion!(false,response)
            } else if result!.isCancelled {
                response["error"] = "2"
                self.facebookLoginCompletion!(false,response)
            } else {
                self.getFBUserDetails()
            }
        }
    }
    
    
    private func getFBUserDetails() {
        GraphRequest(graphPath: "me", parameters: ["fields" : "picture.type(large), email, id,first_name, last_name"]).start { (connection, result, error) in
            if error != nil {
                var response = [AnyHashable : Any]()
                response["error"] = "3"
                self.facebookLoginCompletion!(false,response)
            } else {
                self.facebookLoginCompletion!(true,(result as! [AnyHashable : Any]))
            }
        }
    }
    
    func getFacebookDetails(vc : UIViewController,onComplition: @escaping FaceBookLoginBlock)
    {
        self.facebookLoginCompletion = onComplition
        
        if (AccessToken.current != nil) {
            getFBUserDetails()
        } else {
            loginFBUser()
        }
    }
    
    
    
    
    
    
    
    
    //MARK: - FAcebook Pixel event
    
    //Product Search Event

    class func logSearchedEvent(contentType:String,searchString: String, success: Bool) {
        
        let params = [
            AppEvents.ParameterName.contentType.rawValue : contentType,
            AppEvents.ParameterName.searchString.rawValue : searchString,
            AppEvents.ParameterName.success.rawValue : NSNumber(value: success ? 1 : 0)
            ] as [String : Any]
        
        AppEvents.logEvent(AppEvents.Name.searched, parameters: params)
        AppEvents.logEvent(AppEvents.Name(rawValue: "Search Event Log"))
    }
    
    //Product View content Event
    class func logViewedContentEvent(contentType:String,contentId: String,currency: String, price: Double) {
        
        let params = [
            AppEvents.ParameterName.contentType.rawValue : contentType,
            AppEvents.ParameterName.contentID.rawValue : contentId,
            AppEvents.ParameterName.currency.rawValue : currency
            ] as [String : Any]
        
        AppEvents.logEvent(AppEvents.Name.viewedContent, valueToSum: price, parameters: params)
        AppEvents.logEvent(AppEvents.Name(rawValue: "Product View Content"))
    }
    
    
    //Product Add to cart Event
    class func logAddedToCartEvent(contentId:String,contentType: String,currency: String, price: Double) {
        
        let params = [
            AppEvents.ParameterName.contentType.rawValue : contentType,
            AppEvents.ParameterName.contentID.rawValue : contentId,
            AppEvents.ParameterName.currency.rawValue : currency
            ] as [String : Any]
        
        AppEvents.logEvent(AppEvents.Name.addedToCart, valueToSum: price, parameters: params)
    }
    
    //Product Add to Wishlist Event
    class func logAddedToWishlistEvent(contentId:String,contentType: String,currency: String, price: Double) {
        
        let params = [
            AppEvents.ParameterName.contentType.rawValue : contentType,
            AppEvents.ParameterName.contentID.rawValue : contentId,
            AppEvents.ParameterName.currency.rawValue : currency
            ] as [String : Any]
        
        AppEvents.logEvent(AppEvents.Name.addedToWishlist, valueToSum: price, parameters: params)
    }
    
    //Product Add to Purchase Event
    class func logPurchasedEvent(numItems:Int,contentId:String,contentType: String,currency: String, price: Double) {
        
        let params = [
            AppEvents.ParameterName.numItems.rawValue : NSNumber(value: numItems),
            AppEvents.ParameterName.contentType.rawValue : contentType,
            AppEvents.ParameterName.contentID.rawValue : contentId,
            AppEvents.ParameterName.currency.rawValue : currency
            ] as [String : Any]
        
        AppEvents.logPurchase(price, currency: currency,parameters: params)
    }
    
    
    //Product Initial Checkout Event
    class func logInitiatedCheckoutEvent(contentId:String,contentType: String,numItems:Int,paymentInfoAvailable:Bool,currency: String, totalPrice: Double) {
        
        let params = [
            AppEvents.ParameterName.numItems.rawValue : NSNumber(value: numItems),
            AppEvents.ParameterName.contentType.rawValue : contentType,
            AppEvents.ParameterName.contentID.rawValue : contentId,
            AppEvents.ParameterName.currency.rawValue : currency,
            AppEvents.ParameterName.paymentInfoAvailable.rawValue : NSNumber(value: paymentInfoAvailable ? 1 : 0)
            
            ] as [String : Any]
        
        AppEvents.logEvent(AppEvents.Name.initiatedCheckout, valueToSum: totalPrice, parameters: params)
    }
    
    //Abandoned_cart Event
    class func logAbandoned_CartEvent(contentId:String,contentType: String,numItems:Int,currency: String, price: Double) {
        
        let params = [
            "numItems" : NSNumber(value: numItems),
            "contentType" : contentType,
            "contentId" : contentId,
            "currency" : currency,
            "price" : price
            
            ] as [String : Any]
        
        AppEvents.logEvent(AppEvents.Name(rawValue: "Abandoned_Cart"), parameters: params)
    }
    
    class func checkForAbandonedCart() {
        if strCurrencySymbol == "" {
            return
        }
        
        if  let abandonedCartTime = getValueFromLocal(key: kFbAbandonedCartTime){
            if (abandonedCartTime as! String) != "" {
                
                let storeTime = convertStringToDate(strDate: abandonedCartTime as! String, formatter: "yyyy-MM-dd HH:mm:ss")!
                let currentTime = convertStringToDate(strDate: convertDateToString(date: Date(), formatter: "yyyy-MM-dd HH:mm:ss"), formatter: "yyyy-MM-dd HH:mm:ss")!
                
                let timeDifference: TimeInterval? = currentTime.timeIntervalSince(storeTime)
              
                let minutes = Double(timeDifference! / 60)
                let hours = minutes / 60
                let seconds = timeDifference ?? 0.0
                let days = minutes / 1440
                
                
                var time = false

                if days >= 1 || hours >= 0.5 {
                    time = true
                } else {
                    if minutes >= 30 {
                        time = true
                        print(String(format: " days = %.0f,hours = %.2f, minutes = %.0f,seconds = %.0f", days, hours, minutes, seconds))
                    }
                }
                
                if time {
                    if let arrFBCheckout = getJSONFromLocal(key: kFbAbandonedCartObject) {
                        let arrAbandonedCart = JSON(arrFBCheckout).arrayValue
                        for product in arrAbandonedCart {
                            self.logAbandoned_CartEvent(contentId: product["id"].stringValue, contentType: product["name"].stringValue, numItems: product["qty"].intValue, currency: strCurrencySymbol, price: product["price"].double ?? 0)
                        }
                    }
                }
            } else {
                setValueToLocal(key: kFbAbandonedCartTime, value: "")
                storeJSONToLocal(key: kFbAbandonedCartObject, value: Array<JSON>())
            }
        } else {
            setValueToLocal(key: kFbAbandonedCartTime, value: "")
            storeJSONToLocal(key: kFbAbandonedCartObject, value: Array<JSON>())
        }
        
    }
    
    
}



