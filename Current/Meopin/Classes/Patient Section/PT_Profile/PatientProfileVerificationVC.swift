//
//  PatientProfileVerificationVC.swift
//  Meopin
//
//  Created by Tops on 9/11/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PatientProfileVerificationVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblMeopin: UILabel!
    @IBOutlet var lblVerificationTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var txtVerifyCode: UITextField!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var btnVerify: UIButton!
    
    @IBOutlet var lblMeopinYConst: NSLayoutConstraint!
    
    var shareObjUserData: UserSObject = UserSObject()
    var imgUserPic: UIImage?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtVerifyCode.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtVerifyCode.leftViewMode = .always
        
        txtVerifyCode.layer.masksToBounds = true
        txtVerifyCode.layer.cornerRadius = 2.0
        txtVerifyCode.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtVerifyCode.layer.borderWidth = 0.4
        
        txtVerifyCode.text = ""
        
        if (Global.is_iPhone._6 || Global.is_iPhone._6p) {
            lblMeopinYConst.constant = 20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.setLanguageTitles()
        
        txtVerifyCode.becomeFirstResponder()
        
        self.btnResend.isEnabled = false
        Global().delay(delay: 60) {
            self.btnResend.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblVerificationTitle.text = Global().getLocalizeStr(key: "keyPaPVerificationTitle")
        lblSubTitle.text = Global().getLocalizeStr(key: "keyPaPVerifSubTitle")
        txtVerifyCode.placeholder = Global().getLocalizeStr(key: "keyPaPVerifCode")
        btnResend.setTitle(Global().getLocalizeStr(key: "keyPaPResendCode"), for: .normal)
        btnResend.setTitle(Global().getLocalizeStr(key: "keyPaPResendCode"), for: .disabled)
        btnVerify.setTitle(Global().getLocalizeStr(key: "keyPaPVerify"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblMeopin.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(36))
        lblVerificationTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblSubTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        txtVerifyCode.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        btnResend.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        btnVerify.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
    }
        
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PatientProfileVerificationVC {
    // MARK: -  API Call
    func sendEditProfileVerificationCodeCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.sendPatientProfileVerificationCodeCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            
            self.btnResend.isEnabled = false
            Global().delay(delay: 60) {
                self.btnResend.isEnabled = true
            }
        })
    }
    
    func editPatientProfileCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObjUserData.strSalutation, forKey: "form[salutation]")
        param.setValue(shareObjUserData.strTitle, forKey: "form[title]")
        param.setValue(shareObjUserData.strFName, forKey: "form[firstName]")
        param.setValue(shareObjUserData.strLName, forKey: "form[lastName]")
        param.setValue(shareObjUserData.strEmail, forKey: "form[email]")
        param.setValue(shareObjUserData.strUserName, forKey: "form[username]")
        param.setValue(shareObjUserData.strPhoneNumber, forKey: "form[phoneNumber]")
        param.setValue(txtVerifyCode.text!, forKey: "form[verificationCode]")
        
        AFAPIMaster.sharedAPIMaster.postEditPatientProfileCall_Completion(params: param, img: imgUserPic, imgName: "form[profilePic]", showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "userId") as? String ?? "", forKey: Global.kLoggedInUserKey.Id);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "salutation") as? String ?? "", forKey: Global.kLoggedInUserKey.Salutation);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "title") as? String ?? "", forKey: Global.kLoggedInUserKey.Title);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "firstName") as? String ?? "", forKey: Global.kLoggedInUserKey.FirstName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "lastName") as? String ?? "", forKey: Global.kLoggedInUserKey.LastName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "username") as? String ?? "", forKey: Global.kLoggedInUserKey.UserName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "email") as? String ?? "", forKey: Global.kLoggedInUserKey.Email);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "phoneNumber") as? String ?? "", forKey: Global.kLoggedInUserKey.PhoneNumber);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "profilePictureUrl") as? String ?? "", forKey: Global.kLoggedInUserKey.ProfilePic);
            }
            Global.appDelegate.isVarifyCode = false
            Global.appDelegate.mySlideViewObj?.addDynamicDataSource()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        Global.appDelegate.isVarifyCode = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendClick(_ sender: Any) {
        self.sendEditProfileVerificationCodeCall()
    }
    
    @IBAction func btnVerifyClick(_ sender: Any) {
        self.view.endEditing(true)
        
        txtVerifyCode.text = txtVerifyCode.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtVerifyCode.text?.characters.count)! > 5 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPCodeMsg1"))
            return
        }
        self.editPatientProfileCall()
    }
}

// MARK: -
extension PatientProfileVerificationVC: UITextFieldDelegate {
    // MARK: -  UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
