//
//  AppPushNotifHandler.swift
//  chilax
//
//  Created by Tops on 6/14/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import RNNotificationView

class AppPushNotifHandler: NSObject {
    static let shareAppPushNotifHandler = AppPushNotifHandler()
    
    var dictPushData: NSDictionary?
    var dictAPSData: NSDictionary?
    var dictData: NSDictionary?
    var intAppState: Int?
    
    // MARK: -  Get Notification Data Method
    func getPushNotificationDataAndProcess(pushdata: NSDictionary) {
        
        dictPushData = pushdata
        dictAPSData = (pushdata["aps"] as? NSDictionary)
        intAppState = UIApplication.shared.applicationState.rawValue
        
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
                Global.appDelegate.getSlideMenuPatientCountCall()
            }
            else {
                Global.appDelegate.getSlideMenuProviderCountCall()
            }
        }
        self.handlePushNotification()

        if (Global.kLoggedInUserData().Id != nil && (Global.kLoggedInUserData().Id != "")) {
            self.handlePushNotification()
        }
    }
    
    // MARK: -  Handle Notification Method
    func handlePushNotification() {
        if (Global.appDelegate.navObj == nil) {
            handlePushNotifBasedOnNotifType()
        }
        else {
            Global().delay(delay: 0.2, closure: {
                if #available(iOS 9.0, *) {
                    let strMessage = self.dictAPSData?.value(forKey: "alert") as? String ?? ""
                    self.showLocalMessageNotification(msg: strMessage)
                } else {
                    self.handlePushNotifBasedOnNotifType()
                }
            })
        }
    }
    
    // MARK: -  Handle HandlePushNotifBasedOnNotifType Method
    func handlePushNotifBasedOnNotifType() {
        let state: UIApplicationState = UIApplication.shared.applicationState
        if state == .active {
            Global.appDelegate.mySlideViewObj?.setGoToInboxNotificationController()
        }
        else  {
            Global.appDelegate.mySlideViewObj?.setGoToInboxNotificationController()
        }
    }
    
    func showLocalMessageNotification(msg:String) -> Void {
        RNNotificationView.show(withImage: #imageLiteral(resourceName: "NotificationImage"), title: "Meopin", message: msg, duration: 3, iconSize: CGSize(width: 22, height: 22)) {
            self.handlePushNotifBasedOnNotifType()
        }
    }
}
