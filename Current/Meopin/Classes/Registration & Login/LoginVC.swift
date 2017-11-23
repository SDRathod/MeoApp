//
//  LoginVC.swift
//  Meopin
//
//  Created by Tops on 8/31/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import HMSegmentedControl
import IQKeyboardManagerSwift

class LoginVC: UIViewController {
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblMeopin: UILabel!
    @IBOutlet var btnYouProvider: UIButton!
    @IBOutlet var btnAboutUs: UIButton!
    @IBOutlet var btnContact: UIButton!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnForgotPwd: UIButton!
    @IBOutlet var btnNewUser: UIButton!
    
    @IBOutlet var btnProvider: UIButton!
    @IBOutlet var btnPatient: UIButton!
    
    @IBOutlet var segmentView: UIView!
    @IBOutlet var lblMeopinYConst: NSLayoutConstraint!
    @IBOutlet var btnForgotPwdYConst: NSLayoutConstraint!
    @IBOutlet var btnNewUserBottomConst: NSLayoutConstraint!
    
    var boolUserIsPatient: Bool = true
    var boolFromProvider: Bool = false
    
    // MARK: -  View Life Cycle Start Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentView.layer.borderWidth = 1
        segmentView.layer.borderColor = Global.kAppColor.BlueDark.cgColor
        
        txtEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtEmail.leftViewMode = .always
        txtPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtPassword.leftViewMode = .always
        
        txtEmail.layer.masksToBounds = true
        txtEmail.layer.cornerRadius = 2.0
        txtEmail.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtEmail.layer.borderWidth = 0.4
        
        txtPassword.layer.masksToBounds = true
        txtPassword.layer.cornerRadius = 2.0
        txtPassword.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtPassword.layer.borderWidth = 0.4
        
        btnYouProvider.titleLabel?.adjustsFontSizeToFitWidth = true
        btnAboutUs.titleLabel?.adjustsFontSizeToFitWidth = true
        btnContact.titleLabel?.adjustsFontSizeToFitWidth = true
        btnYouProvider.titleLabel?.minimumScaleFactor = 0.8
        btnAboutUs.titleLabel?.minimumScaleFactor = 0.8
        btnContact.titleLabel?.minimumScaleFactor = 0.8
        
        btnProvider.titleLabel?.adjustsFontSizeToFitWidth = true
        btnPatient.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    
        IQKeyboardManager.sharedManager().enable = true
        
        self.setLanguageTitles()
        
        txtEmail.text = ""
        txtPassword.text = ""
        
        if (Global.is_iPhone._5) {
            lblMeopinYConst.constant = 44
            btnForgotPwdYConst.constant = 15
            btnNewUserBottomConst.constant = 30
        }
        else if (Global.is_iPhone._6) {
            lblMeopinYConst.constant = 48
            btnForgotPwdYConst.constant = 22
            btnNewUserBottomConst.constant = 35
        }
        else if (Global.is_iPhone._6p) {
            lblMeopinYConst.constant = 50
            btnForgotPwdYConst.constant = 38
            btnNewUserBottomConst.constant = 24
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Global.singleton.delegate = self
        Global.singleton.addLanguageScrollView(inView: self.view, with: CGRect(x: 0, y: Global.screenHeight - Global.singleton.getDeviceSpecificFontSize(45), width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(30)), textColor: Global.kAppColor.GrayLight, selTextColor: Global.kAppColor.BlueDark)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()

        lblTitle.text = Global().getLocalizeStr(key: "keyLILoginTitle")
        btnPatient.setTitle(Global().getLocalizeStr(key: "keyLoginPatient"), for: .normal)
        btnProvider.setTitle(Global().getLocalizeStr(key: "keyLoginProvider"), for: .normal)
        
        if (self.boolUserIsPatient) {
            btnYouProvider.setTitle(Global().getLocalizeStr(key: "keyHomeYouPatient"), for: .normal)
            self.btnProvider.backgroundColor = UIColor.white
            self.btnProvider.setTitleColor(Global.kAppColor.BlueDark, for: .normal)
            
            self.btnPatient.backgroundColor = Global.kAppColor.BlueDark
            self.btnPatient.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            
            btnYouProvider.setTitle(Global().getLocalizeStr(key: "keyHomeYouProvider"), for: .normal)
            self.btnPatient.backgroundColor = UIColor.white
            self.btnPatient.setTitleColor(Global.kAppColor.BlueDark, for: .normal)
            
            self.btnProvider.backgroundColor = Global.kAppColor.BlueDark
            self.btnProvider.setTitleColor(UIColor.white, for: .normal)
        }
        
        btnAboutUs.setTitle(Global().getLocalizeStr(key: "keyHomeAboutUs"), for: .normal)
        btnContact.setTitle(Global().getLocalizeStr(key: "keyHomeContact"), for: .normal)
        txtEmail.placeholder = Global().getLocalizeStr(key: "keyLIEmail")
        txtPassword.placeholder = Global().getLocalizeStr(key: "keyLIPassword")
        btnForgotPwd.setTitle(Global().getLocalizeStr(key: "keyLIForPwd"), for: .normal)
        btnLogin.setTitle(Global().getLocalizeStr(key: "keyLILogin"), for: .normal)
        btnNewUser.setTitle(Global().getLocalizeStr(key: "keyLINewUser"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnClose.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17.5))
        
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblMeopin.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(36))
        
        btnYouProvider.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnAboutUs.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnContact.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        txtEmail.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtPassword.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        btnLogin.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        
        btnForgotPwd.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        btnNewUser.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(16))
        
    }
        
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        Global.singleton.delegate = nil
        Global.singleton.removeLanguageScrollView()
        
        IQKeyboardManager.sharedManager().enable = false
        
        super.viewWillDisappear(animated)
    }
}

// MARK: -
extension LoginVC {
    // MARK: -  API Call
    func loginCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtEmail.text!), forKey: "form[email]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtPassword.text!), forKey: "form[plainPassword]")
        param.setValue(self.boolUserIsPatient ? Global.kUserRole.Patient : Global.kUserRole.Provider, forKey: "form[userRole]")
        param.setValue(Global.kDeviceTypeWS, forKey: "form[deviceType]")
        param.setValue(Global.appDelegate.strDeviceToken, forKey: "form[deviceToken]")
        
        AFAPIMaster.sharedAPIMaster.postLoginCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                //store login data in NSUserDefaults
                Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kLoggedInUserKey.IsLoggedIn)
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "accessToken") as? String ?? "", forKey: Global.kLoggedInUserKey.AccessToken);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "refreshToken") as? String ?? "", forKey: Global.kLoggedInUserKey.RefreshToken);
                Global.singleton.saveToUserDefaults(value: String(describing: (dictData.object(forKey: "expiresIn") as! NSNumber)) , forKey: Global.kLoggedInUserKey.ExpiresIn);
                Global.singleton.saveToUserDefaults(value: self.boolUserIsPatient ? Global.kUserRole.Patient : Global.kUserRole.Provider, forKey: Global.kLoggedInUserKey.Role);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "userId") as? String ?? "", forKey: Global.kLoggedInUserKey.Id);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "salutation") as? String ?? "", forKey: Global.kLoggedInUserKey.Salutation);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "title") as? String ?? "", forKey: Global.kLoggedInUserKey.Title);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "firstName") as? String ?? "", forKey: Global.kLoggedInUserKey.FirstName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "lastName") as? String ?? "", forKey: Global.kLoggedInUserKey.LastName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "username") as? String ?? "", forKey: Global.kLoggedInUserKey.UserName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "email") as? String ?? "", forKey: Global.kLoggedInUserKey.Email);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "phoneNumber") as? String ?? "", forKey: Global.kLoggedInUserKey.PhoneNumber);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "profilePictureUrl") as? String ?? "", forKey: Global.kLoggedInUserKey.ProfilePic);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "practiceName") as? String ?? "", forKey: Global.kLoggedInUserKey.PracticeName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "address") as? String ?? "", forKey: Global.kLoggedInUserKey.Street);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "") as? String ?? "", forKey: Global.kLoggedInUserKey.StreetNo);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "city") as? String ?? "", forKey: Global.kLoggedInUserKey.City);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "country") as? String ?? "", forKey: Global.kLoggedInUserKey.Country);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "website") as? String ?? "", forKey: Global.kLoggedInUserKey.Website);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "fax") as? String ?? "", forKey: Global.kLoggedInUserKey.Fax);
                
                //store current time stamp
                Global.singleton.saveToUserDefaults(value: Global.singleton.getCurrentDateTimeStamp(), forKey: Global.kLoggedInUserKey.LastLoginTimestamp)
                
                Global.appDelegate.mySlideViewObj?.addDynamicDataSource()
                if (Global.kLoggedInUserData().Role == Global.kUserRole.Provider) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "101"), object: nil)
                }
                else {
                    if (self.boolFromProvider) {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnCloseClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPatientClick(_ sender: Any) {
        self.boolUserIsPatient = true
        btnYouProvider.setTitle(Global().getLocalizeStr(key: "keyHomeYouPatient"), for: .normal)
        
        self.btnProvider.backgroundColor = UIColor.white
        self.btnProvider.setTitleColor(Global.kAppColor.BlueDark, for: .normal)
        
        self.btnPatient.backgroundColor = Global.kAppColor.BlueDark
        self.btnPatient.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func btnProviderClick(_ sender: Any) {
        self.boolUserIsPatient = false
        btnYouProvider.setTitle(Global().getLocalizeStr(key: "keyHomeYouProvider"), for: .normal)
        self.btnPatient.backgroundColor = UIColor.white
        self.btnPatient.setTitleColor(Global.kAppColor.BlueDark, for: .normal)
        
        self.btnProvider.backgroundColor = Global.kAppColor.BlueDark
        self.btnProvider.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    @IBAction func btnForgotPwdClick(_ sender: Any) {
        let forgotPwdObj = ForgotPwdVC(nibName: "ForgotPwdVC", bundle: nil)
        self.navigationController?.pushViewController(forgotPwdObj, animated: true)
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        txtEmail.text = txtEmail.text!.trimmingCharacters(in: .whitespaces)
        txtPassword.text = txtPassword.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtEmail.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyLIEmailMsg1"))
            return
        }
        guard Global.singleton.validateEmail(strEmail: txtEmail.text!) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyLIEmailMsg2"))
            return
        }
        guard (txtPassword.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyLIPasswordMsg1"))
            return
        }
        self.loginCall()
    }
    
    @IBAction func btnNewUserClick(_ sender: Any) {
        if (self.boolUserIsPatient) {
            let registerObj = RegisterVC(nibName: "RegisterVC", bundle: nil)
            self.navigationController?.pushViewController(registerObj, animated: true)
        }
        else {
            UIApplication.shared.openURL(URL(string: Global.kWebPageURL.RegisterProvider)!)
        }
    }
    
    @IBAction func btnYouProviderClick(_ sender: Any) {
        if (self.boolUserIsPatient) {
            self.boolUserIsPatient = false
        }
        else {
            self.boolUserIsPatient = true
        }
        txtEmail.text = ""
        txtPassword.text = ""
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    @IBAction func btnAboutUsClick(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Global.kWebPageURL.AboutUs)!)
    }
    
    @IBAction func btnContactClick(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Global.kWebPageURL.Contact)!)
    }
}

// MARK: -
extension LoginVC: UITextFieldDelegate {
    // MARK: -  UITextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false
        }
        if (string == "") {
            return true
        }
        else if (textField == txtEmail) {
            if ((txtEmail.text?.characters.count)! > 50) {
                return false
            }
        }
        else if (textField == txtPassword) {
            if ((txtPassword.text?.characters.count)! > 30) {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == txtEmail) {
            txtPassword.becomeFirstResponder()
        }
        return true
    }
}

// MARK: -
extension LoginVC: SingletonDelegate {
    // MARK: -  Singleton Delegate Methods
    func didSelectLanguage() {
        self.setLanguageTitles()
    }
}
