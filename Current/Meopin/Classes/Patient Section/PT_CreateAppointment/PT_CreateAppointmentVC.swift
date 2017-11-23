//
//  CreateAppointmentVC.swift
//  Meopin
//
//  Created by Tops on 10/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class PT_CreateAppointmentVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnReason: UIButton!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var lblRatingScore: UILabel!
    
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnFavoraite: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var btnConfBooking: UIButton!
    @IBOutlet weak var txtPatientFName: UITextField!
    @IBOutlet weak var txtPatientLName: UITextField!
    @IBOutlet weak var txtPatientMobNo: UITextField!
    @IBOutlet weak var txtPatientEmail: UITextField!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtReasonView: UITextView!
    @IBOutlet var btnReasonHeightConst: NSLayoutConstraint!
    @IBOutlet var scrConstrint: NSLayoutConstraint!
    
    var dictSelProviderData = NSDictionary()
    var strSelDate: String = ""
    var strSelFromTime: String = ""
    var strSelToTime: String = ""
    var strSelProviderId: String = ""
    var strIndexReason = String()
    var isNavFavScreen : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.sharedManager().enable = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.setFontProperty()
        txtPatientFName.text =  Global.singleton.retriveFromUserDefaults(key:Global.kLoggedInUserKey.FirstName )
        txtPatientLName.text =  Global.singleton.retriveFromUserDefaults(key:Global.kLoggedInUserKey.LastName )
        txtPatientEmail.text =  Global.singleton.retriveFromUserDefaults(key:Global.kLoggedInUserKey.Email )
        txtPatientMobNo.text =  Global.singleton.retriveFromUserDefaults(key:Global.kLoggedInUserKey.PhoneNumber )
    }
    
    
    func setFontProperty() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnFavoraite.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(15))

        lblAddress.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        lblSelectedDate.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblDistance.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblProviderName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblSpeciality.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        btnReason.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnEdit.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        btnConfBooking.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        lblTitle.text = Global().getLocalizeStr(key: "keyAppointmentTitle")
        txtReasonView.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        txtPatientEmail.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        txtPatientFName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        txtPatientLName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        txtPatientMobNo.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        
        txtPatientFName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        txtPatientFName.leftViewMode = .always
        txtPatientFName.layer.masksToBounds = true
        txtPatientFName.layer.cornerRadius = 2.0
        txtPatientFName.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtPatientFName.layer.borderWidth = 0.4
        txtPatientFName.placeholder = Global().getLocalizeStr(key: "keyPaPFirstName")
        
        txtPatientLName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        txtPatientLName.leftViewMode = .always
        txtPatientLName.layer.masksToBounds = true
        txtPatientLName.layer.cornerRadius = 2.0
        txtPatientLName.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtPatientLName.layer.borderWidth = 0.4
        txtPatientLName.placeholder = Global().getLocalizeStr(key: "keyPaPLastName")
        
        txtPatientMobNo.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        txtPatientMobNo.leftViewMode = .always
        txtPatientMobNo.layer.masksToBounds = true
        txtPatientMobNo.layer.cornerRadius = 2.0
        txtPatientMobNo.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtPatientMobNo.layer.borderWidth = 0.4
        txtPatientMobNo.placeholder = Global().getLocalizeStr(key: "keyPaPPhone Number")
        
        txtPatientEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 15))
        txtPatientEmail.leftViewMode = .always
        txtPatientEmail.layer.masksToBounds = true
        txtPatientEmail.layer.cornerRadius = 2.0
        txtPatientEmail.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtPatientEmail.layer.borderWidth = 0.4
        txtPatientEmail.placeholder = Global().getLocalizeStr(key: "keyLIEmail")
        
        txtReasonView.layer.masksToBounds = true
        txtReasonView.layer.cornerRadius = 2.0
        txtReasonView.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtReasonView.layer.borderWidth = 0.4
        txtReasonView.text = Global().getLocalizeStr(key: "keyPersonalMessage")
        
        btnReason.setTitle(Global().getLocalizeStr(key: "keyReasonForAppointment"), for: .normal)
        btnConfBooking.setTitle(Global().getLocalizeStr(key: "keyConfirmBooking"), for: .normal)
        self.setProviderData()
    }
    
    func setProviderData()  {
        
        if Global.appDelegate.isLocationOn == true {
            let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            if isNavFavScreen == true {
                let myLocation:CLLocation = CLLocation(latitude: Double(dictSelProviderData.object(forKey: "lat") as? String ?? "0")!, longitude: Double(dictSelProviderData.object(forKey: "lon") as? String ?? "0")!)
                let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                if strDistance != "" || strDistance != "0.0" {
                    lblDistance.text = ("\(strDistance) km")
                } else {
                    lblDistance.text = ("")
                }
            } else  {
                let myLocation:CLLocation = CLLocation(latitude: Double(dictSelProviderData.object(forKey: "lat") as? String ?? "0")!, longitude: Double(dictSelProviderData.object(forKey: "lng") as? String ?? "0")!)
                let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                if strDistance != "" || strDistance != "0.0" {
                    lblDistance.text = ("\(strDistance) km")
                } else {
                    lblDistance.text = ("")
                }
            }
        } else {
            lblDistance.text = ("")
        }
        
        
        if isNavFavScreen == true {
            let arrSpeciality = dictSelProviderData.value(forKey: "specialties") as? NSArray ?? NSArray()
            if arrSpeciality.count > 0 {
                let strSpeciality = arrSpeciality .componentsJoined(by: "|")
                lblSpeciality.text = strSpeciality
            } else  {
                lblSpeciality.text = ""
            }
            
            let strRating = dictSelProviderData.object(forKey: "rating") as?
                String ?? "0.0"
            if strRating == "" || strRating == "0.0" || strRating == "0" || strRating.isEmpty {
                lblRatingScore.text = "0.0"
            } else {
                lblRatingScore.text = dictSelProviderData.object(forKey: "rating") as? String ?? "0.0"
            }
            
            if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                if ((dictSelProviderData.object(forKey: "isFavorited") as? String ?? "") == "1") {
                    btnFavoraite.setTitleColor(Global.kAppColor.Red, for: .normal)
                }
            }
            else {
                btnFavoraite.isHidden = true
            }
            
            let isFavStatus = dictSelProviderData.object(forKey: "isFavorited") as? String ?? ""
            if isFavStatus == "" || isFavStatus.isEmpty || isFavStatus == "0" {
                btnFavoraite.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            } else  {
                btnFavoraite.setTitleColor(Global.kAppColor.Red, for: .normal)
            }
        } else  {
            let arrSpeciality = dictSelProviderData.value(forKey: "specialty") as? NSArray ?? NSArray()
            if arrSpeciality.count > 0 {
                let strSpeciality = arrSpeciality .componentsJoined(by: "|")
                lblSpeciality.text = strSpeciality
            } else  {
                lblSpeciality.text = ""
            }
            
            
            let strRating = dictSelProviderData.object(forKey: "hospitalRating") as?
                String ?? "0.0"
            if strRating == "" || strRating == "0.0" || strRating == "0" || strRating.isEmpty {
                lblRatingScore.text = "0.0"
            } else {
                lblRatingScore.text = dictSelProviderData.object(forKey: "hospitalRating") as? String ?? "0.0"
            }
            if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                if ((dictSelProviderData.object(forKey: "isFavorite") as? String ?? "") == "1") {
                    btnFavoraite.setTitleColor(Global.kAppColor.Red, for: .normal)
                }
            }
            else {
                btnFavoraite.isHidden = true
            }
            let isFavStatus = dictSelProviderData.object(forKey: "isFavorite") as? String ?? ""
            if isFavStatus == "" || isFavStatus.isEmpty || isFavStatus == "0" {
                btnFavoraite.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            } else  {
                btnFavoraite.setTitleColor(Global.kAppColor.Red, for: .normal)
            }
        }
        if let strProfilePic =  dictSelProviderData.object(forKey: "profilePictureUrl") as? String {
            if (strProfilePic.isEmpty || strProfilePic == "") {
                profileImg.sd_setImage(with: URL.init(string: dictSelProviderData.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
            else {
                profileImg.sd_setImage(with: URL.init(string: strProfilePic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
        }
        else {
            profileImg.sd_setImage(with: URL.init(string: dictSelProviderData.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        
        let strCategoryName = dictSelProviderData.value(forKey: "category") as? String ?? ""
        if strCategoryName == "Hospital" {
            lblProviderName.text  = dictSelProviderData.value(forKey: "hospitalName") as? String ?? ""
        } else  {
            var strFullName: String = ""
            if ((dictSelProviderData.value(forKey: "salutation") as? String ?? "").characters.count > 0) {
                strFullName = "\(dictSelProviderData.value(forKey: "salutation") as? String ?? "") "
            }
            if ((dictSelProviderData.value(forKey: "") as? String ?? "firstName").characters.count > 0) {
                strFullName = "\(strFullName)\(dictSelProviderData.value(forKey: "firstName") as? String ?? "") "
            }
            strFullName = "\(strFullName)\(dictSelProviderData.value(forKey: "lastName") as? String ?? "")"
                lblProviderName.text  = strFullName
        }
        
        lblAddress.text = dictSelProviderData.object(forKey: "address") as? String ?? ""
        let tempToTime = Global.singleton.convertServerTimeToNewTime(strStartDate: strSelFromTime)
        lblSelectedDate.text = ("\(self.strSelDate) AT \(tempToTime)")
        if Global.appDelegate.isLocationOn == true {
            let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            
            let myLocation:CLLocation = CLLocation(latitude: Double(dictSelProviderData.object(forKey: "lat") as? String ?? "0")!, longitude: Double(dictSelProviderData.object(forKey: "lng") as? String ?? "0")!)
            
            let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
            if strDistance != "" || strDistance != "0.0" {
                lblDistance.text = ("\(strDistance) km")
            }
            else {
                lblDistance.text = ("")
            }
        } else {
            lblDistance.text = ("")
        }
    }
    
    func distanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> String {
        let  distanceInMeters = source.distance(from: destination)
        let distanceInMiles = distanceInMeters/1000
        return String(format:"%.2f",distanceInMiles)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Global.ReasonListSingleton.allocReasonListSelectView()
        Global.ReasonListSingleton.dropMenuReasonList.items = Global.appDelegate.arrReasonName
        Global.ReasonListSingleton.delegate  = self
    
        profileView.layer.masksToBounds = true
        profileView.layer.cornerRadius = 4
        profileView.layer.borderWidth = 1
        profileView.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        lblRatingScore.layer.masksToBounds = true
        lblRatingScore.layer.cornerRadius = lblRatingScore.frame.height / 2
        
        Global().delay(delay: 1.0) { 
            if(Global.is_iPhone._4) {
                Global.ReasonListSingleton.addReasonListDropDownList(inView: self.view, with: CGRect(x: 10, y: self.btnReason.frame.origin.y + self.btnReason.frame.size.height , width: Global.screenWidth - 20, height:  self.btnReason.frame.size.height))
            } else if (Global.is_iPhone._5) {
                Global.ReasonListSingleton.addReasonListDropDownList(inView: self.view, with: CGRect(x: 10, y: self.btnReason.frame.origin.y , width: Global.screenWidth - 20, height:  self.btnReason.frame.size.height))
            }else if (Global.is_iPhone._6 || Global.is_iPhone._6p) {
                Global.ReasonListSingleton.addReasonListDropDownList(inView: self.view, with: CGRect(x: 10, y: self.btnReason.frame.origin.y, width: Global.screenWidth - 20, height:  self.btnReason.frame.size.height))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            scrConstrint.constant = keyboardFrame.height + 44
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let _ = (infoKey as AnyObject).cgRectValue {
            scrConstrint.constant = 44
        }
    }
}

extension PT_CreateAppointmentVC : ReasonListDropMenuDelegate {
    func didSelectReasonList(strAppointmentName: String, intIndexPath: Int32) {
        self.btnReason.setTitle(strAppointmentName, for: UIControlState.normal)
        let diction = Global.appDelegate.arrReasonArr.object(at: Int(intIndexPath))
            as? NSDictionary ?? NSDictionary()
        strIndexReason = diction .value(forKey:"id") as? String ?? ""
    }
}

// MARK
extension PT_CreateAppointmentVC {
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnConfirmBookingClick(_ sender: Any) {
        
        if strIndexReason == "" || strIndexReason.isEmpty {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyReasonSelectAlert"))
        }else if txtReasonView.text == Global().getLocalizeStr(key: "keyPersonalMessage")  {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyReasonAlert"))
        }else if txtReasonView.text == "" || txtReasonView.text.isEmpty || txtReasonView.text.characters.count == 0 {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyReasonAlert"))
        }else {
            self.createBookingAppointmentApi_Call()
        }
    }
    
    func createBookingAppointmentApi_Call() {
        
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(strSelProviderId, forKey: "form[providerId]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtPatientFName.text!), forKey: "form[firstName]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtPatientLName.text!), forKey: "form[lastName]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtPatientMobNo.text!), forKey: "form[phoneNumber]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtReasonView.text!), forKey: "form[personalMessage]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtPatientEmail.text!), forKey: "form[email]")
        param.setValue(strSelDate, forKey: "form[appointmentDate]")
        param.setValue(strSelFromTime, forKey: "form[appointmentFromTime]")
        param.setValue(strSelToTime, forKey: "form[appointmentToTime]")
        param.setValue(strIndexReason, forKey: "form[reason]")
        print(param)
        
        AFAPIMaster.sharedAPIMaster.PatientCreateAppointmentApi_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                let PT_AppointmentResultVCObj = PT_AppointmentResultVC(nibName: "PT_AppointmentResultVC", bundle: nil)
                param.setValue(self.dictSelProviderData.value(forKey: "statusLable") as? String ?? "", forKey: "form[statusLable]")
                PT_AppointmentResultVCObj.dictPatietnDetail = param
                PT_AppointmentResultVCObj.dictSelProviderData = self.dictSelProviderData
                PT_AppointmentResultVCObj.strAppoimentID = dictData.value(forKey:"appointmentId") as? String ?? ""
                PT_AppointmentResultVCObj.strSelProviderId = self.strSelProviderId
                self.navigationController?.pushViewController(PT_AppointmentResultVCObj, animated: true)
            }
        })
    }
}


// MARK
extension PT_CreateAppointmentVC: UITextFieldDelegate {
    
    // MARK: -  Textfield Delegate call Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "") {
            return true
        }
        else if textField == txtPatientFName || textField == txtPatientLName {
            let maxLength = 25
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if (textField == txtPatientMobNo ) {
            if (txtPatientMobNo.text?.characters.count == 0) {
                if (string == "+") {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                if (string == "+") {
                    return false
                }
                else if ((textField.text?.characters.count)! > 15) {
                    return false
                }
                else {
                    return string.isValidString(string, Global.kStringType.PhoneNumber)
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPatientFName {
            textField .resignFirstResponder()
            txtPatientLName .becomeFirstResponder()
        } else  if textField == txtPatientLName {
            textField .resignFirstResponder()
            txtPatientEmail .becomeFirstResponder()
        } else  if textField == txtPatientEmail{
            textField .resignFirstResponder()
            txtPatientMobNo .becomeFirstResponder()
        }  else if textField == txtPatientMobNo {
            textField .resignFirstResponder()
        }
        return true
    }
}

// MARK: -
extension PT_CreateAppointmentVC: UITextViewDelegate {
    
    // MARK: -  UITextView Delegate
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == Global().getLocalizeStr(key: "keyPersonalMessage")) {
            textView.text = ""
            textView.textColor = Global.kAppColor.GrayDark
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        let strTemp: NSString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        if (strTemp.length > 0) {
        }
        else {
        }
        
        if (text == "") {
            return true
        }
        if ((textView.text?.characters.count)! > 200) {
            return false
        }
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = Global().getLocalizeStr(key: "keyPersonalMessage")
            textView.textColor = Global.kAppColor.GrayLight
        }
    }
}


