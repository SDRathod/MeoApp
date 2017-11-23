//
//  ForgotPwdVC.swift
//  Meopin
//
//  Created by Tops on 9/1/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ForgotPwdVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblForgotTitle: UILabel!
    @IBOutlet var lblMeopin: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet var lblMeopinYConst: NSLayoutConstraint!
    @IBOutlet var btnNextYConst: NSLayoutConstraint!
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPhone.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtPhone.leftViewMode = .always
        
        txtPhone.layer.masksToBounds = true
        txtPhone.layer.cornerRadius = 2.0
        txtPhone.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtPhone.layer.borderWidth = 0.4
        
        txtPhone.text = ""
        
        if (Global.is_iPhone._5) {
            lblMeopinYConst.constant = 36
            btnNextYConst.constant = 18
        }
        else if (Global.is_iPhone._6 || Global.is_iPhone._6p) {
            lblMeopinYConst.constant = 50
            btnNextYConst.constant = 32
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.setLanguageTitles()
        
        txtPhone.becomeFirstResponder()
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
        
        lblForgotTitle.text = Global().getLocalizeStr(key: "keyFPForgotTitle")
        lblSubTitle.text = Global().getLocalizeStr(key: "keyFPSubTitle")
        txtPhone.placeholder = Global().getLocalizeStr(key: "keyFPMobile")
        btnNext.setTitle(Global().getLocalizeStr(key: "keyFPNext"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblForgotTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblMeopin.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(36))
        lblSubTitle.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        txtPhone.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        btnNext.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
    }
        
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension ForgotPwdVC {
    // MARK: -  API Call
    func sendForgotPwdVerifCodeCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(txtPhone.text!, forKey: "form[phoneNumber]")
        
        AFAPIMaster.sharedAPIMaster.forgotPwdSendVerifCodeCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                let forgotPwdVerificationObj = ForgotPwdVerificationVC(nibName: "ForgotPwdVerificationVC", bundle: nil)
                forgotPwdVerificationObj.strSelUserId = dictData.object(forKey: "userId") as? String ?? ""
                forgotPwdVerificationObj.strSelPhoneNumber = self.txtPhone.text
                self.navigationController?.pushViewController(forgotPwdVerificationObj, animated: true)
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        self.view.endEditing(true)

        txtPhone.text = txtPhone.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtPhone.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPMobileMsg1"))
            return
        }
        guard Global.singleton.validatePhoneNumber(strPhone: txtPhone.text!) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPMobileMsg2"))
            return
        }
        self.sendForgotPwdVerifCodeCall()
    }
}

// MARK: -
extension ForgotPwdVC: UITextFieldDelegate {
    // MARK: -  UITextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false
        }
        if (string == "") {
            return true
        }
        else if (textField == txtPhone) {
            if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
                return false
            }
            if (txtPhone.text?.characters.count == 0) {
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
        textField.resignFirstResponder()
        return true
    }
}
