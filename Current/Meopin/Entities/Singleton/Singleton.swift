                                          //
//  Singleton.swift
//  chilax
//
//  Created by Tops on 6/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import ISMessages

@objc protocol SingletonDelegate {
    @objc optional func didSelectLanguage()
}
                                          
class Singleton: NSObject {
    static let sharedSingleton = Singleton()
    var delegate: SingletonDelegate?
    var scrollLanguageSelection: ScrollLanguage?
    var scrollLanguageSelectionForSlideMenu: ScrollLanguage?
    var intSelLanguageIndexFromScroll: Int = 0
    
    var intSlideMenuAppointmentCount: Int = 0
    var intSlideMenuInboxCount: Int = 0
    var intSlideMenuReviewCount: Int = 0
    
    // MARK: -  Skip Backup Attribute for File
    func addSkipBackupAttributeToItemAtURL(URL:NSURL) {
        assert(FileManager.default.fileExists(atPath: URL.path!))
        do {
            try URL.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
        }
        catch let error as NSError {
            print("Error excluding \(URL.lastPathComponent!) from backup \(error)");
        }
    }
    
    // MARK: -  Device Specific Method
    func getDeviceSpecificNibName(_ strNib: String) -> String {
        if Global.is_iPhone._4 {
            return strNib + ("_4")
        }
        else {
            return strNib
        }
    }
    
    func getDeviceSpecificFontSize(_ fontsize: CGFloat) -> CGFloat {
        return ((Global.screenWidth) * fontsize) / 320
    }
    
    // MARK: -  UserDefaults Methods
    func saveToUserDefaults (value: String, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value , forKey: key as String)
        defaults.synchronize()
    }
    
    
    func retriveFromUserDefaults (key: String) -> String? {
        let defaults = UserDefaults.standard
        if let strVal = defaults.string(forKey: key as String) {
            return strVal
        }
        else{
            return "" as String?
        }
    }
    
    // MARK: -  String RemoveNull and Trim Method
    func removeNull (str:String) -> String {
        if (str == "<null>" || str == "(null)" || str == "N/A" || str == "n/a" || str.isEmpty) {
            return ""
        } else {
            return str
        }
    }
    
    func kTRIM(string: String) -> String {
        return string.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    // MARK: -  Attributed String
    func setButtonStringMeopinFontBaseLine(_ strText: String, floatIconFontSize:CGFloat, floatTextFontSize: CGFloat, floatBase: CGFloat, intIconPos: Int) -> NSMutableAttributedString { //first character Chilax font and other all GothamBook font
        let attributedString = NSMutableAttributedString(string: strText)
        if (intIconPos == 1) {//first character icon
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(floatIconFontSize))!, range: NSRange(location: 0, length: 1))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatTextFontSize))!, range: NSRange(location: 1, length: strText.characters.count-1))
            attributedString.addAttribute(NSBaselineOffsetAttributeName, value: Global.singleton.getDeviceSpecificFontSize(floatBase), range: NSRange(location: 1, length: strText.characters.count-1))
        }
        else if (intIconPos == 2) {//last character icon
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(floatTextFontSize))!, range: NSRange(location: 0, length: strText.characters.count-1))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatIconFontSize))!, range: NSRange(location: strText.characters.count-1, length: 1))
        }
        return attributedString;
    }
    
    // MARK: -  Get string size Method
    func getSizeFromString (str: String, stringWidth width: CGFloat, fontname font: UIFont, maxHeight mHeight: CGFloat) -> CGSize {
        let rect : CGRect = str.boundingRect(with: CGSize(width: width, height: mHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return rect.size
    }
    
    func getSizeFromAttributedString (str: NSAttributedString, stringWidth width: CGFloat, maxHeight mHeight: CGFloat) -> CGSize {
        let rect : CGRect = str.boundingRect(with: CGSize(width: width, height: mHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size
    }
     
    // MARK: -  Attributed String
    func setStringLineSpacing(_ strText: String, floatSpacing: CGFloat, intAlign: Int) -> NSMutableAttributedString {
        //o=center  1=left = 2=right
        let attributedString = NSMutableAttributedString(string: strText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = floatSpacing
        if intAlign == 0 {
            paragraphStyle.alignment = .center
        }
        else if intAlign == 1 {
            paragraphStyle.alignment = .left
        }
        else {
            paragraphStyle.alignment = .right
        }
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: (strText.characters.count )))
        return attributedString
    }
    
    // MARK: -  TextField Validation Method
    func validateEmail(strEmail: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: strEmail)
    }
    
    func validatePhoneNumber(strPhone: String) -> Bool {
        let phoneRegex: String = "[+]+([0-9]{11,15})"
        let test = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return test.evaluate(with: strPhone)
    }
    
    // MARK: -  Show Message on Success and Failure
    func showSuccessAlert(withMsg message: String) {
        ISMessages.showCardAlert(withTitle: "", message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.success, alertPosition: ISAlertPosition.top, didHide: nil)
    }
    
    func showWarningAlert(withMsg message: String) {
        ISMessages.showCardAlert(withTitle: "", message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.warning, alertPosition: ISAlertPosition.top, didHide: nil)
    }
    
    // MARK: -  Emoji encode decode string
    func emojisDecodedConvertedString(strText: String) -> String {
        let dataDecode: Data = strText.data(using: .utf8)!
        if (String.init(data: dataDecode, encoding: .nonLossyASCII) == nil){
            return strText
        }
        return String.init(data: dataDecode, encoding: .nonLossyASCII)!
    }
    
    func emojisEncodedConvertedString(strText: String) -> String {
        let dataEncode: Data = strText.data(using: .nonLossyASCII)!
        return String.init(data: dataEncode, encoding: .utf8)!
    }
    
    // MARK: -  get Directory Path
    func getDocumentDirPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return documentsPath
    }
    
    // MARK: -  Get current timestamp
    func getCurrentDateTimeStamp() -> String! {
        return String(NSDate().timeIntervalSince1970)
    }
    
    // MARK: -  get Country JSon array
    func getCountryCodeJsonDataArray() -> NSArray {
        do {
            let countrydata: Data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "country", ofType: "json")!))
            do {
                if let arrData: NSArray = try JSONSerialization.jsonObject(with: countrydata, options: []) as? NSArray {
                    return arrData
                }
            }
            catch {
            }
        }
        catch {
        }
        return NSArray()
    }
    
    // MARK: -  get City JSon array
    func getCityCodeJsonDataArray() -> NSArray {
        do {
            let countrydata: Data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "city_master", ofType: "json")!))
            do {
                if let arrData: NSArray = try JSONSerialization.jsonObject(with: countrydata, options: []) as? NSArray {
                    return arrData
                }
            }
            catch {
            }
        }
        catch {
        }
        return NSArray()
    }
}
        
// MARK: -
extension Singleton {
    // MARK: -  Date Convertion Methods
    
    
    
    func convertStringToDateWithDayName(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = "E d MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func convertDateToStringWithDayFullName(dateSel: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE  d MMMM yyyy"
        return dateFormatter.string(from: dateSel)
    }
    
    
    func convertDateToStringWithDayFullName1(dateSel: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE  d MMM yyyy"
        return dateFormatter.string(from: dateSel)
    }
    
    
    func convertDateToStringWithDayOrMonthFullName(dateSel: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date = dateFormatter.date(from: dateSel)!
        dateFormatter.dateFormat = "EEE  MM"
        return dateFormatter.string(from: date)
    }
    
    
    func convertDateToStringWithDaySmallName(dateSel: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE d MMM yyyy"
        return dateFormatter.string(from: dateSel)
    }
    
    func convertStringToDate(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: strDate)!
    }
    
    func convertStringToDateTime(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:m:s"
        return dateFormatter.date(from: strDate)!
    }
    
    func convertDateToString(dateSel: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: dateSel)
    }
    
    func removeTimeFromDate(dateSel: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateFormatter.string(from: dateSel))!
    }
    
    func removeDateFromTime(dateSel: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:m"
        return dateFormatter.date(from: dateFormatter.string(from: dateSel))!
    }
    
    func getDayDifferenceFromTwoStringDates(strStartDate: String, strEndDate: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStart: Date = dateFormatter.date(from: strStartDate)!
        let dateEnd: Date = dateFormatter.date(from: strEndDate)!
        
        return NSCalendar.current.dateComponents([.day], from: dateStart, to: dateEnd).day!
    }
    
    func convertStringTimeToDateTime(strTime: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:m"
        return dateFormatter.date(from: strTime)!
    }
    
    func convertDateTimeToStringTime(dateSel: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:m"
        return dateFormatter.string(from: dateSel)
    }
    
    func convertServerTimeToNewTime(strStartDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateStart: Date = dateFormatter.date(from: strStartDate)!
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateStart)
    }
  
    
    func convertInboxDateTostringFormate(dateSel: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date = dateFormatter.date(from: dateSel)!
        dateFormatter.dateFormat = "MMM dd hh:mm a"
        return dateFormatter.string(from: date)
    }
}
                                          
      
// MARK: -
extension Singleton {
    // MARK: -  Open Language Selection View
    func allocLanguageSelView() {
        scrollLanguageSelection = ScrollLanguage(frame: CGRect(x: 0, y: 0, width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(30)))
        scrollLanguageSelection?.addScrollForLanguage()
        scrollLanguageSelection?.delegate = self
    }
    
    // MARK: -  get Langugate Selection Scroll
    func addLanguageScrollView(inView: UIView, with frame: CGRect, textColor: UIColor, selTextColor: UIColor) {
        scrollLanguageSelection?.langTextColor = textColor
        scrollLanguageSelection?.langSelTextColor = selTextColor
        scrollLanguageSelection?.viewFrameChanged(newFrame: frame)
        inView.addSubview(scrollLanguageSelection!)
    }
    
    func removeLanguageScrollView() {
        scrollLanguageSelection?.removeFromSuperview()
    }
    
    // MARK: -  Open Language Selection View
    func allocLanguageSelViewForSlideMenu() {
        scrollLanguageSelectionForSlideMenu = ScrollLanguage(frame: CGRect(x: 0, y: 0, width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(30)))
        scrollLanguageSelectionForSlideMenu?.boolIsForSlideMenu = true
        scrollLanguageSelectionForSlideMenu?.addScrollForLanguage()
        scrollLanguageSelectionForSlideMenu?.delegate = self
    }
    
    // MARK: -  get Langugate Selection Scroll
    func addLanguageScrollViewForSlideMenu(inView: UIView, with frame: CGRect, textColor: UIColor, selTextColor: UIColor) {
        scrollLanguageSelectionForSlideMenu?.langTextColor = textColor
        scrollLanguageSelectionForSlideMenu?.langSelTextColor = selTextColor
        scrollLanguageSelectionForSlideMenu?.viewFrameChanged(newFrame: frame)
        inView.addSubview(scrollLanguageSelectionForSlideMenu!)
    }
    
    func removeLanguageScrollViewForSlideMenu() {
        scrollLanguageSelectionForSlideMenu?.removeFromSuperview()
    }
}
                                          
// MARK: -
extension Singleton: ScrollLanguageDelegate {
    // MARK: -  ScrollLanguage Delegate Methods
    func  didSelectLanguage(scrollObj: ScrollLanguage) {
        if (scrollObj == scrollLanguageSelection) {
            scrollLanguageSelectionForSlideMenu?.languageSelectionChanged(boolNeedDelegate: false)
        }
        else {
            scrollLanguageSelection?.languageSelectionChanged(boolNeedDelegate: false)
        }
        self.delegate?.didSelectLanguage!()
    }
}
                                          
                                          
                                          
