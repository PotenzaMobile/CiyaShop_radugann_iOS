//
//  LocationHelper.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 17/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import CiyaShopSecurityFramework
import SwiftyJSON

class LocationHelper: NSObject
{
    var latitude : String?
    var longitude : String?
    
    var location : String?
    var locationManager : CLLocationManager?
    var geocoder : CLGeocoder?
    var placemark : CLPlacemark?
    var oldLocation : CLLocation?
    var locationStatus : NSString?
    var storeLocation = CLLocation(latitude: 21.2478925, longitude: 72.791003)
    class var sharedInstance: LocationHelper
    {
        struct Singleton {
            static let instance = LocationHelper()
        }
        return Singleton.instance
    }
    
}


//MARK:- CLLocationManager delegate methods

extension LocationHelper : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        var shouldIAllow = false

        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            self.locationManager!.requestWhenInUseAuthorization()
            self.locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager!.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let newLocation = locations.last
//        print("newLocation latitude - ",newLocation?.coordinate.latitude)
//        print("newLocation longitude - ",newLocation?.coordinate.longitude)
        
        geocoder?.reverseGeocodeLocation(newLocation!, completionHandler: { (placemarks, error) in
            
            if(error == nil && placemarks!.count > 0)
            {
                self.placemark = placemarks?.last
                let lati = "\(newLocation!.coordinate.latitude)"
                let longi = "\(newLocation!.coordinate.longitude)"

//                print("old Location - ",self.oldLocation)

                /*if(self.oldLocation == nil)
                {
                    self.latitude = lati
                    self.longitude = longi
                    self.oldLocation = newLocation
                    self.changeLocation()
                }else */if(Int((newLocation?.distance(from: self.storeLocation))!) < Int(DistanceForLocationUpdate))
                {
//                    print("distance - ",(newLocation?.distance(from: self.storeLocation))!)

                    self.oldLocation = newLocation
                    self.latitude=lati
                    self.longitude=longi
                    
                    //calling api here
                    self.changeLocation()
                    print("Location changed")
                }else{
//                    print("distance - ",(newLocation?.distance(from: self.storeLocation))!)

                }
                
            }else{
                print("Error:: ",error)
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Cannot find the location.")
        self.latitude = "0"
        self.longitude = "0"
    }
}

//MARK:- Methods
extension LocationHelper
{
    func updateLocation()
    {
        if CLLocationManager.locationServicesEnabled() {
            //Location Services Enabled
            if CLLocationManager.authorizationStatus() == .denied {
                // ALERTVIEW([MCLocalization stringForKey:@"Please go to Settings and turn on Location Service for this app."], appDelegate.window.rootViewController);
                print("Please go to Settings and turn on Location Service for this app.")
            }

            //enable location
            geocoder = CLGeocoder()
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager!.desiredAccuracy = kCLLocationAccuracyBest
                locationManager!.delegate = self
                locationManager!.requestWhenInUseAuthorization()
            }
            locationManager!.startUpdatingLocation()
        }else{
            print("Please enable Location Service for this app.")
        }
    }
    
    func stopUpdateLocation()
    {
        locationManager?.stopUpdatingLocation()
    }
    func TriggerLocalNotification()
    {
        let notificationContent = UNMutableNotificationContent()

        // Add the content to the notification content
        notificationContent.title = "Geofencing"
        notificationContent.body = "This is test push notification for geofencing you have entered in store regieon"
        notificationContent.badge = NSNumber(value: 1)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,repeats: false)

        let request = UNNotificationRequest(identifier: "testNotification",content: notificationContent, trigger: trigger)
        let userNotificationCenter = UNUserNotificationCenter.current()

//        userNotificationCenter.add(request) { (error) in
//            if let error = error {
//                print("Notification Error: ", error)
//            }
//        }
    }
}
//MARK:- API call
extension LocationHelper
{
    func changeLocation()
    {
        //showLoader()
            
        var params = [AnyHashable : Any]()
        params["lat"] = "\(latitude)"
        params["lng"] = "\(longitude)"
        params["device_token"] = strDeviceToken
        params["device_type"] = "1"

        print("params - ",params)
        
        
        CiyaShopAPISecurity.findGeoLocation(params) { (success, message, responseData) in
            
            let jsonReponse = JSON(responseData!)
            print("jsonReponse - ",jsonReponse)
            if success {
                self.TriggerLocalNotification()
            } else {
                
            }
            //hideLoader()
            
        }
    }
    
}
