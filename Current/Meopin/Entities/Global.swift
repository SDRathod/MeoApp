//
//  Global.swift
//  chilax
//
//  Created by Tops on 6/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//
//

import UIKit

class Global {
    // SDK keys & secrets etc.
    struct SDKKeys {
    }
    
    // Device Compatibility
    struct is_Device {
        static let _iPhone = (UIDevice.current.model as String).isEqual("iPhone") ? true : false
        static let _iPad = (UIDevice.current.model as String).isEqual("iPad") ? true : false
        static let _iPod = (UIDevice.current.model as String).isEqual("iPod touch") ? true : false
    }
    
    // Display Size Compatibility
    struct is_iPhone {
        static let _6p = (UIScreen.main.bounds.size.height >= 736.0 ) ? true : false
        static let _6 = (UIScreen.main.bounds.size.height <= 667.0 && UIScreen.main.bounds.size.height > 568.0) ? true : false
        static let _5 = (UIScreen.main.bounds.size.height <= 568.0 && UIScreen.main.bounds.size.height > 480.0) ? true : false
        static let _4 = (UIScreen.main.bounds.size.height <= 480.0) ? true : false
    }
    
    // IOS Version Compatibility
    struct is_iOS {
        static let _10 = ((Float(UIDevice.current.systemVersion as String))! >= Float(10.0)) ? true : false
        static let _9 = ((Float(UIDevice.current.systemVersion as String))! >= Float(9.0) && (Float(UIDevice.current.systemVersion as String))! < Float(10.0)) ? true : false
        static let _8 = ((Float(UIDevice.current.systemVersion as String))! >= Float(8.0) && (Float(UIDevice.current.systemVersion as String))! < Float(9.0)) ? true : false
    }
    
    // MARK: -  Shared classes
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let singleton = Singleton.sharedSingleton
    static let countrySingleton = CountryDropDown.sharedCountryDropDown
    static let citySingleton = CityDropDown.sharedCityDropDown
    static let categortySingleton = CategoryDropDown.sharedCategoryDropDown
    static let spectialitySingleton = SpecialityDropDown.sharedSpecialityhDropDown
    static let appointmentSingleton = AppointmentDropDown.sharedAppoinmentDropDown
    static let genderSingleton = GenderDropDown.sharedGenderDropDown
    static let profilSingleton = ProfileDropDown.sharedProfileDropDown
    static let ReasonListSingleton = ReasonListDropDown.sharedReasonListDropDown
    static let appPushNotifHandler = AppPushNotifHandler.shareAppPushNotifHandler
    
    // MARK: -  Screen size
    static let screenWidth : CGFloat = (Global.appDelegate.window!.bounds.size.width)
    static let screenHeight : CGFloat = (Global.appDelegate.window!.bounds.size.height)
    
    // MARK: -  Get UIColor from RGB
    func RGB(r: Float, g: Float, b: Float, a: Float) -> UIColor {
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a))
    }
    
    // MARK: -  Dispatch Delay
    func delay(delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func getLocalizeStr(key: String) -> String {
        return LocalizeHelper.sharedLocalSystem().localizedString(forKey: key)
    }
    
    //MARK: TIME FORMAT
    func TimeFormatter_12H() -> DateFormatter {
        //06:35 PM
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }
    
    func TimeFormatter_24_H() -> DateFormatter {
        //19:29:50
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    //MARK: DATE FORMAT
    func dateFormatterFullWiteTimeZone() -> DateFormatter {
        //2016-10-24 19:29:50 +0000
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter
    }
    
    func dateFormatterFull_DMY_HMS() -> DateFormatter {
        //24-10-2016 19:29:50
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }
    
    func dateFormatter() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func dateFormatterForDisplay() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter
    }
    func dateFormatterMMDDYYY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }
    
    func dateFormatterForDisplay_DMMMY() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter
    }
    func dateFormatterForCall() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    func dateFormatterForYearOnly() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }
    func dateFormatterForMonthINNumberOnly() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter
    }
    func dateFormatterForDaysMonthsYears() -> DateFormatter {
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, d LLL yyyy"
        return dateFormatter
    }
    func dateFormatterForYMD_T_HMSsss() -> DateFormatter {
        //yyyy-MM-dd'T'HH:mm:ss.SSS
        //"Date": "2016-12-15T00:00:00",
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter
    }
    
    func dateFormatterForYMD_T_HMS() -> DateFormatter {
        //yyyy-MM-dd'T'HH:mm:ss
        //"Date": "2016-12-15T00:00:00",
        var dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    // MARK: -  Web service Base URL
    static let baseURLPath = "http://meopin.com/mobile/web/api/"
    static let BlogBaseURLPath = "https://info.meopin.com/wp-json/wp/v2/"
    
    // MARK: -  Application Colors
    struct kAppColor {
        static let BlueDark = Global().RGB(r: 42.0, g: 82.0, b: 134.0, a: 1.0)
        static let BlueLight = Global().RGB(r: 126.0, g: 162.0, b: 209.0, a: 1.0)
        static let GreenDark = Global().RGB(r: 90.0, g: 167.0, b: 60.0, a: 1.0)
        static let GreenLight = Global().RGB(r: 126.0, g: 209.0, b: 132.0, a: 1.0)
        static let GrayDark = Global().RGB(r: 85.0, g: 85.0, b: 85.0, a: 1.0)
        static let GrayLight = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 1.0)
        static let OffWhite = Global().RGB(r: 245.0, g: 245.0, b: 245.0, a: 1.0)
        static let LightGray = Global().RGB(r: 230.0, g: 230.0, b: 230.0, a: 1.0)
        static let Red = Global().RGB(r: 255.0, g: 58.0, b: 47.0, a: 1.0)
        static let Yellow = Global().RGB(r: 197.0, g: 176.0, b: 50.0, a: 1.0)
        
    }
    
    // MARK: -  Application Name
    static let kAppName = "Meopin"
    //static let kPlaceAPiKey = "AIzaSyAPFDN5JC5Cdp1o5k2CJLC9Zs-13_2Dnoc"
    static let kPlaceAPiKey = "AIzaSyB8vow9vHFb9UyxlxQ1GzDkjLlwEdnkHvE"
    
    // MARK: -  Application Fonts
    struct kFont {
        static let SourceRegular = "SourceSansPro-Regular"
        static let SourceSemiBold = "SourceSansPro-SemiBold"
        static let SourceBold = "SourceSansPro-Bold"
        static let MeopinTops = "Meopin_TOPS"
    }
    
    // MARK: - 
    struct LanguageData {
        static let English: String! = "en"
        static let Dutch: String! = "nl"
        static let French: String! = "fr"
        static let German: String! = "de"
        
        static let SelLanguageKey: String! = "meopinSelLanguage"
        var SelLanguage: String! = Global.singleton.retriveFromUserDefaults(key: Global.LanguageData.SelLanguageKey) ?? ""
    }
    
    // MARK: -  User Data
    struct kLoggedInUserKey {
        static let IsFirstTimeLogIn: String! = "meopinUserFirstTimeLogIn"
        static let IsLoggedIn: String! = "meopinUserIsLoggedIn"
        static let IsPassword: String! = "meopinUserIsPassword"
        static let AccessToken: String! = "meopinUserAccessToken"
        static let RefreshToken: String! = "meopinUserRefreshToken"
        static let ExpiresIn: String! = "meopinUserExpiresIn"
        static let Role: String! = "meopinUserRole"
        static let Id: String! = "meopinUserId"
        static let Salutation: String! = "meopinUserSalutation"
        static let Title: String! = "meopinUserTitle"
        static let FirstName: String! = "meopinUserFName"
        static let LastName: String! = "meopinUserLName"
        static let UserName: String! = "meopinUserName"
        static let Email: String! = "meopinUserEmail"
        static let PhoneNumber: String! = "meopinUserPhoneNumber"
        static let ProfilePic: String! = "meopinUserProfilePic"
        static let PracticeName: String! = "meopinUserPracticeName"
        static let Street: String! = "meopinUserStreet"
        static let Speciality: String! = "meopinUserSpeciality"

        static let StreetNo: String! = "meopinUserStreetNo"
        static let City: String! = "meopinUserCity"
        static let Country: String! = "meopinUserCountry"
        static let Website: String! = "meopinUserWebsite"
        static let Fax: String! = "meopinUserFax"
        static let Password: String! = "meopinUserPassword"
        static let LastLoginTimestamp: String! = "meopinUserLastLoginTimestamp"
    }
    
    struct kLoggedInUserData {
        var isPassword: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.IsPassword)
        var IsLoggedIn: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.IsLoggedIn)
        var AccessToken: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.AccessToken)
        var RefreshToken: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.RefreshToken)
        var ExpiresIn: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.ExpiresIn)
        var Role: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Role)
        var Id: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Id)
        var Salutation: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Salutation)
        var Title: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Title)
        var FirstName: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.FirstName)
        var LastName: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.LastName)
        var UserName: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.UserName)
        var Email: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Email)
        var Speciality: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Speciality)

        var PhoneNumber: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.PhoneNumber)
        var ProfilePic: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.ProfilePic)
        var PracticeName: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.PracticeName)
        var Street: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Street)
        var StreetNo: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.StreetNo)
        var City: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.City)
        var Country: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Country)
        var Website: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Website)
        var Fax: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Fax)
        var LastLoginTimestamp: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.LastLoginTimestamp)
    }
    
    // MARK: -  String Type for Validation
    enum kStringType : Int {
        case AlphaNumeric
        case AlphabetOnly
        case NumberOnly
        case Fullname
        case Username
        case Email
        case PhoneNumber
    }
    
    struct kWebPageURL {
        static let PrivacyPolicy = "https://info.meopin.com/privacy-policy/"
        static let TermsConditions = "https://info.meopin.com/terms-and-conditions/"
        static let Contact = "https://info.meopin.com/contact/"
        static let AboutUs = "https://info.meopin.com/about-us/"
        static let RegisterProvider = "https://test.meopin.com/en/registration/medical-provider"
        static let HelpDesk = "https://test.meopin.com/en/registration/medical-provider"
        static let DataProtection = "https://info.meopin.com/data-protection/"
    }
    
    struct kUserRole {
        static let Patient = "1"
        static let Provider = "2"
        static let Both = "3"
    }
    
    struct kReviewRatingColor {
        static let Rate0 = Global().RGB(r: 200.0, g: 200.0, b: 200.0, a: 1.0)
        static let Rate1 = Global().RGB(r: 229.0, g: 9.0, b: 0.0, a: 1.0)
        static let Rate2 = Global().RGB(r: 219.0, g: 122.0, b: 0.0, a: 1.0)
        static let Rate3 = Global().RGB(r: 194.0, g: 210.0, b: 0.0, a: 1.0)
        static let Rate4 = Global().RGB(r: 82.0, g: 200.0, b: 0.0, a: 1.0)
        static let Rate5 = Global().RGB(r: 0.0, g: 191.0, b: 19.0, a: 1.0)
    }
    
    static let kDeviceTypeWS = "1"
    
    struct kTextFieldProperties {
        static let BorderColor = Global().RGB(r: 225.0, g: 225.0, b: 225.0, a: 1.0).cgColor
    }
    struct kTextFieldBorderProperties {
        static let BorderColor = Global().RGB(r: 42.0, g: 82.0, b: 134.0, a: 1.0).cgColor
    }
    
    struct kSearchFilterParameterKey {
        
        static let PatientID: String! = "form[patientId]"
        static let Keyword: String! = "form[keyword]"
        static let Category: String! = "form[category]"
        static let Speciality: String! = "form[specialty]"
        static let CityAndCountry: String! = "form[cityAndCountry]"
        static let AppointmentDate: String! = "form[appointmentDate]"
        static let AppointmentTime: String! = "form[appointmentTime]"
        static let OnlineAppointmentFlag: String! = "form[onlineAppointmentFlag]"
        static let Radius: String! = "form[radius]"
        static let SpokenLanguages: String! = "form[spokenLanguages]"
        static let Rating: String! = "form[rating]"
        static let Gender: String! = "form[gender]"
        static let IsProfilePicture: String! = "from[hasProfilePicture]"
        static let ResultType: String! = "form[resultType]"
        static let Lat: String! = "form[lat]"
        static let Long: String! = "form[lng]"
        static let Page: String! = "form[page]"
        static let MapCenterLat: String! = "form[mapCenterLat]"
        static let MapCenterLong: String! = "form[mapCenterLong]"
        static let CurrLat1: String! = "form[mapCorner1Lat]"
        static let CurrLong1: String! = "form[mapCorner1Long]"
        static let CurrLat2: String! = "form[mapCorner2Lat]"
        static let CurrLong2: String! = "form[mapCorner2Long]"
        static let CurrLat3: String! = "form[mapCorner3Lat]"
        static let CurrLong3: String! = "form[mapCorner3Long]"
        static let CurrLat4: String! = "form[mapCorner4Lat]"
        static let CurrLong4: String! = "form[mapCorner4Long]"
    }
    
    struct kSearchFilterParamKey {
        static let PatientID: String! = "MPPatientId"
        static let Keyword: String! = "MPkeyword"
        static let Category: String! = "MPCategory"
        static let Speciality: String! = "MPSpecialty"
        static let CityAndCountry: String! = "MPCityAndCountry"
        static let AppointmentDate: String! = "MPAppointmentDate"
        static let AppointmentTime: String! = "MPAppointmentTime"
        static let isCancelTime: String! = "MPIsCancelTime"
        static let OnlineAppointment: String! = "MPOnlineAppointment"
        static let Radius: String! = "MPRadius"
        static let SpokenLanguages: String! = "MPSpokenLanguages"
        static let Rating: String! = "MPRating"
        static let Gender: String! = "MPGender"
        static let IsProfilePicture: String! = "MPIsProfilePicture"
        static let ResultType: String! = "MPResultType"
        static let Lat: String! = "MPLat"
        static let Long: String! = "MPLong"
        static let TempLat: String! = "MPTempLat"
        static let TempLong: String! = "MPTempLong"
        static let Page: String! = "MPPage"
        static let MapCenterLat: String! = "MPCenterLat1"
        static let MapCenterLong: String! = "MPCenterLong1"
        static let CurrLat1: String! = "MPCurrLat1"
        static let CurrLong1: String! = "MPCurrLong1"
        static let CurrLat2: String! = "MPCurrLat2"
        static let CurrLong2: String! = "MPCurrLong1"
        static let CurrLat3: String! = "MPCurrLat3"
        static let CurrLong3: String! = "MPCurrLong3"
        static let CurrLat4: String! = "MPCurrLat4"
        static let CurrLong4: String! = "MPCurrLong4"
        static let ResetState: String! = "MPResetState"
        static let isFromFavorite: String! = "MPIsFavorit"
    }
}

class searchFilterDataClass: NSObject {
    func saveDefaultValueforSearchFilterForMap() {
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPSpecialty")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPCategory")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPSpecialtyID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPCategoryID")
        UserDefaults.standard.synchronize()
        
        
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Keyword)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CityAndCountry)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.AppointmentDate)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.AppointmentTime)
        Global.singleton.saveToUserDefaults(value:"0", forKey:Global.kSearchFilterParamKey.OnlineAppointment)
        Global.singleton.saveToUserDefaults(value:"10", forKey:Global.kSearchFilterParamKey.Radius)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.SpokenLanguages)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Rating)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Gender)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.IsProfilePicture)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.ResultType)
        let checkReset = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.ResetState)
        if checkReset == "1" {
            Global.singleton.saveToUserDefaults(value:Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.TempLat)!, forKey:Global.kSearchFilterParamKey.Lat)
            Global.singleton.saveToUserDefaults(value:Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.TempLong)!, forKey:Global.kSearchFilterParamKey.Long)
        }
        
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Page)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.MapCenterLat)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.MapCenterLong)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat1)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong1)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat2)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong2)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat3)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong3)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat4)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong4)
        //        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong4)
    }
    
    func saveDefaultValueforSearchFilter() {
        
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPSpecialty")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPCategory")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPSpecialtyID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(NSMutableArray(), forKey: "MPCategoryID")
        UserDefaults.standard.synchronize()
        
        
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Keyword)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CityAndCountry)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.AppointmentDate)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.AppointmentTime)
        Global.singleton.saveToUserDefaults(value:"0", forKey:Global.kSearchFilterParamKey.OnlineAppointment)
        Global.singleton.saveToUserDefaults(value:"10", forKey:Global.kSearchFilterParamKey.Radius)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.SpokenLanguages)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Rating)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Gender)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.IsProfilePicture)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.ResultType)
        let checkReset = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.ResetState)
        if checkReset == "1" {
            Global.singleton.saveToUserDefaults(value:Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.TempLat)!, forKey:Global.kSearchFilterParamKey.Lat)
            Global.singleton.saveToUserDefaults(value:Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.TempLong)!, forKey:Global.kSearchFilterParamKey.Long)
        }
        
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Page)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.MapCenterLat)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.MapCenterLong)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat4)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong4)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong4)
    }
    
    func getSearchFilterDictKeyAndValue() -> NSMutableDictionary  {
        let param: NSMutableDictionary = NSMutableDictionary()
        
        let Role: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Role)
        if Role == "1" {
            let strPatientId = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Id)
            param.setValue(strPatientId, forKey: Global.kSearchFilterParameterKey.PatientID)
        } else {
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.PatientID)
        }
        
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Keyword), forKey: Global.kSearchFilterParameterKey.Keyword)
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Category), forKey: Global.kSearchFilterParameterKey.Category)
        let arrCategoryList = UserDefaults.standard.array(forKey: "MPCategoryID")
        let arrSpecialityList = UserDefaults.standard.array(forKey: "MPSpecialtyID")
        
        param.setValue(arrSpecialityList, forKey: Global.kSearchFilterParameterKey.Speciality)
        param.setValue(arrCategoryList, forKey: Global.kSearchFilterParameterKey.Category)
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CityAndCountry), forKey: Global.kSearchFilterParameterKey.CityAndCountry)
        
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.AppointmentDate), forKey: Global.kSearchFilterParameterKey.AppointmentDate)
        
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.AppointmentTime), forKey: Global.kSearchFilterParameterKey.AppointmentTime)
        
        let strIsProfileSelect = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.IsProfilePicture)
        
        if strIsProfileSelect == "0" {
            param.setValue("", forKey: Global.kSearchFilterParameterKey.IsProfilePicture)
        } else if strIsProfileSelect == "1" {
            param.setValue("0", forKey: Global.kSearchFilterParameterKey.IsProfilePicture)
        } else if strIsProfileSelect == "2" {
            param.setValue("1", forKey: Global.kSearchFilterParameterKey.IsProfilePicture)
        } else {
            param.setValue("", forKey: Global.kSearchFilterParameterKey.IsProfilePicture)
        }
        
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.OnlineAppointment), forKey: Global.kSearchFilterParameterKey.OnlineAppointmentFlag)
        
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Radius), forKey: Global.kSearchFilterParameterKey.Radius)
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.SpokenLanguages), forKey: Global.kSearchFilterParameterKey.SpokenLanguages)
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Rating), forKey: Global.kSearchFilterParameterKey.Rating)
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Gender), forKey: Global.kSearchFilterParameterKey.Gender)
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.ResultType), forKey: Global.kSearchFilterParameterKey.ResultType)
        param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Page), forKey: Global.kSearchFilterParameterKey.Page)
        
        let checkReset = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.ResetState)
        if checkReset == "1" {
            let strLat = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.TempLat)
            let strLong = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.TempLong)
            param.setValue(strLat, forKey: Global.kSearchFilterParameterKey.Lat)
            param.setValue(strLong, forKey: Global.kSearchFilterParameterKey.Long)
            param.setValue(strLat, forKey: Global.kSearchFilterParameterKey.MapCenterLat)
            param.setValue(strLong, forKey: Global.kSearchFilterParameterKey.MapCenterLong)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLat1)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLong1)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLat2)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLong2)
            
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLat3)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLong3)
            
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLat4)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: ""), forKey: Global.kSearchFilterParameterKey.CurrLong4)
        } else {
            let strLat = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Lat)
            let strLong = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Long)
            
            param.setValue(strLat, forKey: Global.kSearchFilterParameterKey.Lat)
            param.setValue(strLong, forKey: Global.kSearchFilterParameterKey.Long)
            param.setValue(strLat, forKey: Global.kSearchFilterParameterKey.MapCenterLat)
            param.setValue(strLong, forKey: Global.kSearchFilterParameterKey.MapCenterLong)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLat1), forKey: Global.kSearchFilterParameterKey.CurrLat1)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLong1), forKey: Global.kSearchFilterParameterKey.CurrLong1)
            
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLat2), forKey: Global.kSearchFilterParameterKey.CurrLat2)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLong2), forKey: Global.kSearchFilterParameterKey.CurrLong2)
            
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLat3), forKey: Global.kSearchFilterParameterKey.CurrLat3)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLong3), forKey: Global.kSearchFilterParameterKey.CurrLong3)
            
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLat4), forKey: Global.kSearchFilterParameterKey.CurrLat4)
            param.setValue(Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CurrLong4), forKey: Global.kSearchFilterParameterKey.CurrLong4)
        }
        
        
       
        return param
    }
}
