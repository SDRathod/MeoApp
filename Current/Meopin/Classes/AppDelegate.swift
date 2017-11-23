
//
//  AppDelegate.swift
//  Meopin
// test
//  Created by Tops on 8/29/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var mySlideViewObj: MySlideViewController?

    var window: UIWindow?
    var navObj: UINavigationController?
    var strDeviceToken: String?
    
    var arrCountryList : NSMutableArray = []
    var arrCityList = NSMutableArray()
    var arrCityName : [String] = []
    var arrCountryName : [String] = []
    var arrCityFromCountry : [String] = []
    var isCountryCitySelect : Int = 1
    var isVarificationFail = Bool()
    var isVarifyCode = Bool()
    var arrSpeciality : [String] = []
    var arrSpecialityId : [String] = []
    var arrCategory   : [String] = []
    var arrCategoryId   : [String] = []
    var arrReasonName   : [String] = []
    var arrReasonList   : [NSDictionary] = []
    var arrReasonArr   = NSMutableArray()
    var isMapList = false
    var arrSpecialitySelected = NSMutableArray()
    var arrCategorySelected = NSMutableArray()
    var locationManager: CLLocationManager!
    var isLocationOn = false
    var floatCurrentLat: Float = 42.330887
    var floatCurrentLong: Float = -73.257377
    typealias Success = (_ returnData: Any) -> Void
    typealias Failure = (_ error:Error) -> Void
    
    var isSuccess : Bool = false
    // MARK: -  Did Finish Launching Method
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if (Global.LanguageData().SelLanguage == "" || Global.LanguageData().SelLanguage == nil) {
            Global.singleton.saveToUserDefaults(value: Global.LanguageData.English, forKey: Global.LanguageData.SelLanguageKey)
        }
        
        GMSPlacesClient.provideAPIKey(Global.kPlaceAPiKey)
        LocalizeHelper.sharedLocalSystem().setLanguage(Global.LanguageData().SelLanguage)
        IQKeyboardManager.sharedManager().enable = true
        
        //SDK Allocation
        Fabric.with([Crashlytics.self])
        
        let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
        if (remoteNotif != nil) {
            Global.appPushNotifHandler.getPushNotificationDataAndProcess(pushdata: remoteNotif as! NSDictionary)
        }
    
        window = UIWindow.init(frame: UIScreen.main.bounds)
        self.gotoDetailApp()
        window?.makeKeyAndVisible()
        
        Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.isFromFavorite)
        Global.singleton.saveToUserDefaults(value: "0" , forKey: "isClickSlidMenu")

        Global.singleton.allocLanguageSelView()
        Global.singleton.allocLanguageSelViewForSlideMenu()
        
        getCategoryAndSpecialityApi_Call()
        self.backGroundProcessQueueMethods()
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
        RegistrationForNotification()

        if !isAppAlreadyLaunchedOnce() {
            // first time launch code
            searchFilterDataClass().saveDefaultValueforSearchFilter()
        }
         
        let isFirstTime = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.IsFirstTimeLogIn)
        if isFirstTime ==  "1" {
            
        }

        locationAllocation()
        print("Access Token ====== \(Global.kLoggedInUserData().AccessToken ?? "")")
        
        getReasonListApi_call()
        
        if let notification = launchOptions?[.remoteNotification] as? NSDictionary {
            notificationReceived(notification: notification as [NSObject : AnyObject])
        }
        
        return true
    }
    
    func locationAllocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .restricted) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    // MARK: -  Go to detail app Method
    func gotoDetailApp() {
        mySlideViewObj = MySlideViewController(nibName: "SlideViewController", bundle: nil)
        mySlideViewObj?.delegate = self.mySlideViewObj
        navObj = UINavigationController.init(rootViewController: mySlideViewObj!)
        window?.rootViewController = navObj;
    }
    
    // MARK: -  Generic Function For KPDropDown Selection View
    func GenericDropDownMenuAllocation(genericDropDown:KPDropMenu) -> KPDropMenu {
        genericDropDown.itemTextColor = .white
        genericDropDown.itemBackground = Global.kAppColor.BlueDark
        return genericDropDown
    }
    
    // MARK: -  Generic Function For KPDropDown Selection View
    func GenericDropDownMenuMultiAllocation(genericDropDown:KPDropMenuMulti) -> KPDropMenuMulti {
        genericDropDown.itemTextColor = .white
        genericDropDown.itemBackground = Global.kAppColor.BlueDark
        return genericDropDown
    }
    
    
    // MARK: -  Generic Function For KPDropDown Selection View
    func GenericDropDownMenuMultiRepeatAllocation(genericDropDown:KPDropMenuMultiRepeat) -> KPDropMenuMultiRepeat {
        genericDropDown.itemTextColor = .white
        genericDropDown.itemBackground = Global.kAppColor.BlueDark
        return genericDropDown
    }
    
    func backGroundProcessQueueMethods() {
        DispatchQueue.global(qos: .background).async {
            self.parseCountryCodeJson()
            DispatchQueue.main.async {
                Global.countrySingleton.allocCountryListSelectView()
            }
        }
    
        DispatchQueue.global(qos: .background).async {
            self.parseCityCodeJson()
            DispatchQueue.main.async {
                Global.citySingleton.allocCityListSelectView()
            }
        }
        
        Global.categortySingleton.allocCategoryListSelectView()
        Global.spectialitySingleton.allocSpecialityListSelectView()
        Global.appointmentSingleton.allocAppointmentListSelectView()
        Global.genderSingleton.allocGenderListSelectView()
        Global.profilSingleton.allocProfileListSelectView()
        Global.ReasonListSingleton.allocReasonListSelectView()
    }
    
    
    //MARK:-  PUSH NOTIFICATION REGISTER
    func RegistrationForNotification() -> Void {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func notificationReceived(notification: [NSObject:AnyObject]) {
        NSLog("notificationReceived : - %@",notification)
        Global.appPushNotifHandler.getPushNotificationDataAndProcess(pushdata: notification as NSDictionary)

        //IPNotificationManager.shared.GetPushProcessData(dictNoti: notification as NSDictionary)
    }
    func requestForPushNotificationPermission(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]) {
                (granted, error) in
            }
            application.registerForRemoteNotifications()
        }
        else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            application.registerForRemoteNotifications()
        }
    }
    
    // MARK: -  Push Notifications Method
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        strDeviceToken = deviceTokenString
        if (Global.singleton.removeNull(str: deviceTokenString) == "") {
            strDeviceToken = ""
        } else {
            Global.appDelegate.strDeviceToken = strDeviceToken
        }
        
        print("Device Token: " + strDeviceToken!)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                if (settings.authorizationStatus != .authorized) {
                    self.strDeviceToken = ""
                }
            })
        }
        else {
            if (UIApplication.shared.currentUserNotificationSettings?.types.isEmpty)! {
                NSLog("ERROR GETING DEVICE TOKEN ")
                strDeviceToken = ""
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        strDeviceToken = ""
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.noData)
        Global.appPushNotifHandler.getPushNotificationDataAndProcess(pushdata: userInfo as NSDictionary)
    }
    
    //MARK:-  PUSH NOTIFICATION REGISTER
//    func RegistrationForNotification() -> Void {
//        if #available(iOS 10.0, *) {
//            let center  = UNUserNotificationCenter.current()
//            center.delegate = self
//            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
//                if error == nil{
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
//        }
//        else {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String : AnyObject] {
            print(userInfo)
            Global.appPushNotifHandler.getPushNotificationDataAndProcess(pushdata: userInfo as NSDictionary)

           // IPNotificationManager.shared.GetPushProcessDataWhenActive(dictNoti: userInfo as NSDictionary)
        }
        NSLog("Handle push from foreground" )
        completionHandler(.badge)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String : AnyObject] {
            print(userInfo)
            Global.appPushNotifHandler.getPushNotificationDataAndProcess(pushdata: userInfo as NSDictionary)

           // IPNotificationManager.shared.GetPushProcessData(dictNoti: userInfo as NSDictionary)
        }
        NSLog("Handle push from background or closed" )
        completionHandler()
    }

    
    // MARK: -  API Call Method
    func getAppCurrentVersionCall() {
        AFAPIMaster.sharedAPIMaster.getAppCurrentVersionData_Completion(params: nil, showLoader: true, enableInteraction: false, viewObj: (navObj?.topViewController?.view)!, onSuccess: { (returnData: Any) in
            
            let responseData: NSDictionary = returnData as! NSDictionary
            if (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String != responseData["response"] as! String) {
                let alert = UIAlertController(title: "", message: Global().getLocalizeStr(key: "keyAppUpgradeMsg"), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyAppUpgradeUpdate"), style: UIAlertActionStyle.default, handler: { action in
//                    UIApplication.shared.openURL(URL(string: "")!)
                }))
                self.navObj?.topViewController?.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func logoutUserCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.postLogoutUserCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: (navObj?.topViewController?.view)!, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            
            self.removeAllUserDefaultOnLogout()
            self.mySlideViewObj?.addDynamicDataSource()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "101"), object: nil)
        })
    }
    
    func getSlideMenuPatientCountCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.getPatientSlideMenuCounterDataCall_Completion(params: param, showLoader: false, enableInteraction: true, viewObj: (navObj?.topViewController?.view)!, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                Global.singleton.intSlideMenuAppointmentCount = Int(dictData.object(forKey: "appointments") as? String ?? "0")!
                Global.singleton.intSlideMenuInboxCount = Int(dictData.object(forKey: "inbox") as? String ?? "0")!
                Global.singleton.intSlideMenuReviewCount = Int(dictData.object(forKey: "reviews") as? String ?? "0")!
                
                self.mySlideViewObj?._tableView.reloadData()
            }
        })
    }
    
    func getSlideMenuProviderCountCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id, forKey: "form[providerId]")
        
        AFAPIMaster.sharedAPIMaster.getProviderSlideMenuCounterDataCall_Completion(params: param, showLoader: false, enableInteraction: true, viewObj: (navObj?.topViewController?.view)!, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                Global.singleton.intSlideMenuAppointmentCount = Int(dictData.object(forKey: "appointments") as? String ?? "0")!
                Global.singleton.intSlideMenuInboxCount = Int(dictData.object(forKey: "inbox") as? String ?? "0")!
                Global.singleton.intSlideMenuReviewCount = Int(dictData.object(forKey: "reviews") as? String ?? "0")!
                
                self.mySlideViewObj?._tableView.reloadData()
            }
        })
    }
    
    func getCategoryAndSpecialityApi_Call() {
        AFAPIMaster.sharedAPIMaster.getCategorySpecialityCall_Completion(params: nil, strUserId: "", showLoader: false, enableInteraction: true, viewObj:(self.navObj?.view)! , onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                let arrCategoryList = dictData.value(forKey: "categories") as? NSArray ?? NSArray()
                if arrCategoryList.count > 0 {
                    for element in arrCategoryList {
                        var diction = NSDictionary()
                        diction = element as! NSDictionary
                        self.arrCategory.append(diction .value(forKey:"name") as? String ?? "")
                        self.arrCategoryId.append(diction.value(forKey: "id") as? String ?? "")
                    }
                    Global.categortySingleton.allocCategoryListSelectView()
                    Global.categortySingleton.dropMenuCategory.items = self.arrCategory
                }
                
                let arrSpecialityList = dictData.value(forKey: "specialties") as? NSArray ?? NSArray()
                if arrSpecialityList.count > 0 {
                    for element in arrSpecialityList {
                        var diction = NSDictionary()
                        diction = element as! NSDictionary
                        self.arrSpeciality.append(diction .value(forKey:"name") as? String ?? "")
                        self.arrSpecialityId.append(diction.value(forKey: "id") as? String ?? "")
                    }
                    Global.spectialitySingleton.allocSpecialityListSelectView()
                    Global.spectialitySingleton.dropMenuSpeciality.items = self.arrSpeciality
                }
            }
        })
    }
    
    func getReasonListApi_call() {
        AFAPIMaster.sharedAPIMaster.getReasonListCall_Completion(params: nil, strUserId: "", showLoader: false, enableInteraction: true, viewObj:(self.navObj?.view)! , onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                let arrReasonList = dictData.value(forKey: "appointmentReason") as? NSArray ?? NSArray()
                if arrReasonList.count > 0 {
                    for element in arrReasonList {
                        var diction = NSDictionary()
                        diction = element as! NSDictionary
                        self.arrReasonName.append(diction .value(forKey:"name") as? String ?? "")
                        self.arrReasonList.append(diction)
                        self.arrReasonArr.add(diction)
                        Global.ReasonListSingleton.allocReasonListSelectView()
                        Global.ReasonListSingleton.dropMenuReasonList.items = self.arrReasonName
                    }
                }
                print(arrReasonList)
            }
        })
    }
    
    // MARK: -  Logic for Country to City Method
    func parseCityCodeJson() {
            arrCityName .removeAll()
            arrCityList = NSMutableArray(array: Global.singleton.getCityCodeJsonDataArray())
    }
    
    func parseCountryCodeJson() {
            arrCountryName.removeAll()
            arrCountryList .removeAllObjects()
        
            arrCountryList = NSMutableArray(array: Global.singleton.getCountryCodeJsonDataArray())
            for element in self.arrCountryList {
                var diction = NSDictionary()
                diction = element as! NSDictionary
                arrCountryName.append(diction .value(forKey:"country_name") as? String ?? "")
            }
    }
    
    func parseCountryToStateToCityList(getCountryId:Int) {
        
        arrCityFromCountry.removeAll()
        if arrCountryList.count > 0 {
            var diction = NSDictionary()
            diction = arrCountryList.object(at: getCountryId) as! NSDictionary
            
            let arrTempCity = self.arrCityList.filter { NSPredicate(format: "self.country_id == %@", String(diction .value(forKey: "country_id") as! String)).evaluate(with: $0) }
            
            for element in arrTempCity {
                var diction = NSDictionary()
                diction = element as! NSDictionary
                self.arrCityFromCountry.append(diction .value(forKey:"city_name") as? String ?? "")
            }
        }
    }
    
    
    // MARK: -  Logout Methods
    func removeAllUserDefaultOnLogout() {
        Global.singleton.saveToUserDefaults(value: "0", forKey: Global.kLoggedInUserKey.IsLoggedIn)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.AccessToken)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Role)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Id)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Salutation)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Title)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.FirstName)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.LastName)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.UserName)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Email)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.PhoneNumber)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.ProfilePic)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.PracticeName)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Street)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.StreetNo)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.City)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Country)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Website)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Fax)
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.LastLoginTimestamp)
    }
    
    // MARK: -  Application life cycle method
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        //self.getAppCurrentVersionCall()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}

// MARK: -
extension AppDelegate: CLLocationManagerDelegate {
    // MARK: -  CLLocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation: CLLocation = locations.last!
        let locationOld: CLLocation = CLLocation(latitude: CLLocationDegrees(floatCurrentLat), longitude: CLLocationDegrees(floatCurrentLong))
        let distance: CLLocationDistance = locationOld.distance(from: newLocation)
        
        if (distance > 100) {
            floatCurrentLat = Float(newLocation.coordinate.latitude)
            floatCurrentLong = Float(newLocation.coordinate.longitude)
            
            Global.singleton.saveToUserDefaults(value: String(floatCurrentLat), forKey: Global.kSearchFilterParamKey.TempLat)
            Global.singleton.saveToUserDefaults(value: String(floatCurrentLong), forKey: Global.kSearchFilterParamKey.TempLong)

            Global.singleton.saveToUserDefaults(value: String(floatCurrentLat), forKey: Global.kSearchFilterParamKey.Lat)
            Global.singleton.saveToUserDefaults(value: String(floatCurrentLong), forKey: Global.kSearchFilterParamKey.Long)
            isLocationOn = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        var code: Int { return (error as NSError).code }
        var domain: String { return (error as NSError).domain }
        
        if domain == kCLErrorDomain {
            if (code == CLError.denied.rawValue) {
                
                floatCurrentLat = 42.330887;
                floatCurrentLong = -73.25737
                
                Global.singleton.saveToUserDefaults(value: String(floatCurrentLat), forKey: Global.kSearchFilterParamKey.TempLat)
                Global.singleton.saveToUserDefaults(value: String(floatCurrentLong), forKey: Global.kSearchFilterParamKey.TempLong)

                Global.singleton.saveToUserDefaults(value:"", forKey: Global.kSearchFilterParamKey.Lat)
                Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Long)
                isLocationOn = false
            }
        }
    }
}
