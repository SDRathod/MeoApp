//
//  ForgotPwdVerificationVC.swift
//  Meopin
//
//  Created by Tops on 9/4/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ForgotPwdVerificationVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblVerificationTitle: UILabel!
    @IBOutlet var lblMeopin: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var txtVerifyCode: UITextField!
    @IBOutlet var btnVerify: UIButton!
    @IBOutlet var btnResend: UIButton!
    
    @IBOutlet var lblMeopinYConst: NSLayoutConstraint!
    @IBOutlet var btnVerifyYConst: NSLayoutConstraint!
    
    var strSelUserId: String?
    var strSelPhoneNumber: String?
    
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
        
        if (Global.is_iPhone._5) {
            lblMeopinYConst.constant = 36
            btnVerifyYConst.constant = 18
        }
        else if (Global.is_iPhone._6 || Global.is_iPhone._6p) {
            lblMeopinYConst.constant = 50
            btnVerifyYConst.constant = 32
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
        
        lblVerificationTitle.text = Global().getLocalizeStr(key: "keyFPVerificationTitle")
        lblSubTitle.text = Global().getLocalizeStr(key: "keyFPVerifSubTitle")
        txtVerifyCode.placeholder = Global().getLocalizeStr(key: "keyFPVerifCode")
        btnResend.setTitle(Global().getLocalizeStr(key: "keyFPResendCode"), for: .normal)
        btnResend.setTitle(Global().getLocalizeStr(key: "keyFPResendCode"), for: .disabled)
        btnVerify.setTitle(Global().getLocalizeStr(key: "keyFPVerify"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblVerificationTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblMeopin.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(36))
        lblSubTitle.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
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
extension ForgotPwdVerificationVC {
    // MARK: -  API Call
    func sendForgotPwdVerifCodeCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(self.strSelPhoneNumber, forKey: "form[phoneNumber]")
        
        AFAPIMaster.sharedAPIMaster.forgotPwdSendVerifCodeCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
            }
            
            self.btnResend.isEnabled = false
            Global().delay(delay: 60) {
                self.btnResend.isEnabled = true
            }
        })
    }
    
    func forgotPwdVerifyCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(txtVerifyCode.text!, forKey: "form[verificationCode]")
        param.setValue(self.strSelPhoneNumber, forKey: "form[phoneNumber]")
        param.setValue(self.strSelUserId, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.forgotPwdCheckVerifCodeCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let forgotPwdChangeObj = ForgotPwdChangeVC(nibName: "ForgotPwdChangeVC", bundle: nil)
            forgotPwdChangeObj.strSelUserId = self.strSelUserId
            forgotPwdChangeObj.strSelPhoneNumber = self.strSelPhoneNumber
            forgotPwdChangeObj.strSelVerificationCode = self.txtVerifyCode.text
            self.navigationController?.pushViewController(forgotPwdChangeObj, animated: true)
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendClick(_ sender: Any) {
        self.sendForgotPwdVerifCodeCall()
    }
    
    @IBAction func btnVerifyClick(_ sender: Any) {
        self.view.endEditing(true)
        txtVerifyCode.text = txtVerifyCode.text!.trimmingCharacters(in: .whitespaces)
        guard (txtVerifyCode.text?.characters.count)! > 5 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPCodeMsg1"))
            return
        }
        self.forgotPwdVerifyCall()
    }
}

// MARK: -
extension ForgotPwdVerificationVC: UITextFieldDelegate {
    // MARK: -  UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
