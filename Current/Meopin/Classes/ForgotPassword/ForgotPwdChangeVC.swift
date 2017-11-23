//
//  ForgotPwdChangeVC.swift
//  Meopin
//
//  Created by Tops on 9/4/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ForgotPwdChangeVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblNewPwdTitle: UILabel!
    @IBOutlet var lblMeopin: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var txtNewPwd: UITextField!
    @IBOutlet var txtConfPwd: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var lblMeopinYConst: NSLayoutConstraint!
    @IBOutlet var btnSubmitYConst: NSLayoutConstraint!
    
    var strSelUserId: String?
    var strSelPhoneNumber: String?
    
    var strSelVerificationCode: String?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNewPwd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtNewPwd.leftViewMode = .always
        txtConfPwd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtConfPwd.leftViewMode = .always
        
        txtNewPwd.layer.masksToBounds = true
        txtNewPwd.layer.cornerRadius = 2.0
        txtNewPwd.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtNewPwd.layer.borderWidth = 0.4
        txtConfPwd.layer.masksToBounds = true
        txtConfPwd.layer.cornerRadius = 2.0
        txtConfPwd.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtConfPwd.layer.borderWidth = 0.4
        
        txtNewPwd.text = ""
        txtConfPwd.text = ""
        
        if (Global.is_iPhone._5) {
            lblMeopinYConst.constant = 36
            btnSubmitYConst.constant = 18
        }
        else if (Global.is_iPhone._6 || Global.is_iPhone._6p) {
            lblMeopinYConst.constant = 50
            btnSubmitYConst.constant = 32
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.setLanguageTitles()
        
        txtNewPwd.becomeFirstResponder()
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
        
        lblNewPwdTitle.text = Global().getLocalizeStr(key: "keyFPCreatePwdTitle")
        lblSubTitle.text = Global().getLocalizeStr(key: "keyFPCreatePwdSubTitle")
        txtNewPwd.placeholder = Global().getLocalizeStr(key: "keyFPNewPassword")
        txtConfPwd.placeholder = Global().getLocalizeStr(key: "keyFPConfirmaPassword")
        btnSubmit.setTitle(Global().getLocalizeStr(key: "keyFPSubmit"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblNewPwdTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblMeopin.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(36))
        lblSubTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        txtNewPwd.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtConfPwd.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        btnSubmit.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension ForgotPwdChangeVC {
    // MARK: -  API Call
    func changePwdFromForgotCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(self.strSelUserId, forKey: "form[userId]")
        param.setValue(self.strSelPhoneNumber, forKey: "form[phoneNumber]")
        param.setValue(txtNewPwd.text, forKey: "form[newPassword]")
        param.setValue(self.strSelVerificationCode, forKey: "form[verificationCode]")
        
        AFAPIMaster.sharedAPIMaster.forgotPwdChangePwdCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        let arrVC = self.navigationController?.viewControllers
        for vc in arrVC! {
            if vc is ForgotPwdVC{
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        self.view.endEditing(true)
        
        txtNewPwd.text = txtNewPwd.text!.trimmingCharacters(in: .whitespaces)
        txtConfPwd.text = txtConfPwd.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtNewPwd.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPNewPwdMsg1"))
            return
        }
        guard (txtNewPwd.text?.characters.count)! > 5 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPNewPwdMsg2"))
            return
        }
        guard (txtNewPwd.text?.validatePassword())! else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPNewPwdMsg2"))
            return
        }
        guard (txtConfPwd.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPConfPwdMsg1"))
            return
        }
        guard (txtNewPwd.text == txtConfPwd.text) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPConfPwdMsg2"))
            return
        }
        self.changePwdFromForgotCall()
    }
}

// MARK: -
extension ForgotPwdChangeVC: UITextFieldDelegate {
    // MARK: -  UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == txtNewPwd) {
            txtConfPwd.becomeFirstResponder()
        }
        return true
    }
}

// MARK: -
extension ForgotPwdChangeVC: SingletonDelegate {
    // MARK: -  Singleton Delegate Methods
    func didSelectLanguage() {
        self.setLanguageTitles()
    }
}
