//
//  ChangePasswordVC.swift
//  Meopin
//
//  Created by Tops on 9/4/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    //Header Part
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var InnerView: UIView!
    @IBOutlet weak var lblYourSettings: UILabel!
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnEditPress: UIButton!
    @IBOutlet weak var btnSavePassword: UIButton!
    
    @IBOutlet var lblTTFConfPassword: UILabel!
    @IBOutlet var lblTTFShowPassword: UILabel!
    @IBOutlet var btnConfPassword: UIButton!
    @IBOutlet var btnShowPassword: UIButton!
    
    var dictUserData  = NSDictionary()
    var isNavigateFormEdit = Bool()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfieldLayoutEditSet()
        self.setLanguageTitles()

        self.btnEditPress.isUserInteractionEnabled = true
        self.btnEditPress.alpha = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        textfieldLayoutSet()
        
        txtOldPassword.placeholder = Global().getLocalizeStr(key: "keyCPOldPassword")
        txtNewPassword.placeholder = Global().getLocalizeStr(key: "keyCPNewPassword")
        txtConfirmPassword.placeholder = Global().getLocalizeStr(key: "keyCPConfPassword")
        btnSavePassword.setTitle(Global().getLocalizeStr(key: "keyCPSavePassword"), for: .normal)
        btnEditPress.setTitle(Global().getLocalizeStr(key: "keyPaPEditDetails"), for: .normal)
        btnChangePassword.setTitle(Global().getLocalizeStr(key: "keyPaPChangePassword"), for: .normal)
        lblYourSettings.text = Global().getLocalizeStr(key: "keyPaPChangePassword")
       
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTTFShowPassword.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(8))
        btnEditPress.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnChangePassword.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnClose.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(20))
        lblYourSettings.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17.2))
        lblTTFShowPassword.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(8))
        btnSavePassword.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))

        if (txtConfirmPassword.text?.isEmpty)! {
            
        }
        else {
            if txtConfirmPassword.text == txtNewPassword.text {
                setTextTTFConfimPassword()
            }
            else  {
                txtConfirmPassword.text =  ""
            }
        }
    }
    
    // MARK: -  All textfield layouts Methods
    func textfieldLayoutEditSet() {
        for case let textField as UITextField in self.InnerView.subviews {
            textField.paddingviewWithCustomValue(12.0, txtfield: textField)
            textField.leftViewMode = UITextFieldViewMode .always
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 2.0
            textField.layer.borderColor = Global.kTextFieldProperties.BorderColor
            textField.layer.borderWidth = 0.4
            textField.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(14.2))
            textField.alpha = 1
            textField.isUserInteractionEnabled = true
            
        }
  }
}

extension ChangePasswordVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtOldPassword {
            textField .resignFirstResponder()
            txtNewPassword .becomeFirstResponder()
        }
        else  if textField == txtNewPassword {
            textField .resignFirstResponder()
            txtConfirmPassword .becomeFirstResponder()
        }
        else {
            textField .resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtOldPassword {
            hideConfirmPasswordIcon()
        }
        else if textField == txtConfirmPassword {
            hideConfirmPasswordIcon()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtConfirmPassword {
            if txtConfirmPassword.text == txtNewPassword.text {
                setTextTTFConfimPassword()
            }
            else {
                hideConfirmPasswordIcon()
            }
        }
    }
 
    func setTextTTFConfimPassword()  {
        lblTTFConfPassword.layer.borderColor = Global().RGB(r: 90, g: 167, b: 60, a: 1).cgColor
        lblTTFConfPassword.layer.cornerRadius = lblTTFConfPassword.frame.height / 2
        lblTTFConfPassword.layer.borderWidth = 1
        lblTTFConfPassword.textAlignment = .center
        lblTTFConfPassword.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(6))
        lblTTFConfPassword.text = ""
    }
    
    func hideConfirmPasswordIcon() {
        lblTTFConfPassword.layer.borderColor = UIColor.clear.cgColor
        lblTTFConfPassword.layer.cornerRadius = 0
        lblTTFConfPassword.backgroundColor = UIColor.clear
        lblTTFConfPassword.text =  ""
    }
    
    func textfieldLayoutSet() {
        for case let textField as UITextField in self.InnerView.subviews {
            textField.layer.masksToBounds = true
            if textField == txtConfirmPassword || textField != txtNewPassword {
                textField.paddingRightLeftviewWithCustomValue(12.0, txtfield: textField)
                textField.rightViewMode = UITextFieldViewMode .always
            }
            else {
                textField.paddingviewWithCustomValue(12.0, txtfield: textField)
            }
            textField.leftViewMode = UITextFieldViewMode .always
            textField.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        }
    }
}

extension ChangePasswordVC  {
    
    // MARK: -  All Button Click Methods
    @IBAction func btnEditClick(_ sender: UIButton) {
        self.btnEditPress.alpha = 1

        var isVCFound = false

        if isNavigateFormEdit == true {
            for viewcontrol in (self.navigationController?.viewControllers)! {
                
                if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
                    if viewcontrol is PatientViewProfileVC {
                        isVCFound = true
                        self.navigationController?.popToViewController(viewcontrol, animated: false)
                    } else {
                        let patientEditProfileObj = PatientEditProfileVC(nibName: "PatientEditProfileVC", bundle: nil)
                        patientEditProfileObj.dictUserData = NSMutableDictionary(dictionary: self.dictUserData)
                        self.navigationController?.pushViewController(patientEditProfileObj, animated: true)                }
                } else {
                    
                    if viewcontrol is ProviderViewProfileVC {
                        if isNavigateFormEdit == true {
                            
                        } else {
                            isVCFound = true
                            self.navigationController?.popToViewController(viewcontrol, animated: false)
                        }
                        
                    } else {
                        isVCFound = true
                        let providerEditProfileObj = ProviderProfile(nibName: "ProviderProfile", bundle: nil)
                        providerEditProfileObj.dictUserData = NSMutableDictionary(dictionary: self.dictUserData)
                        self.navigationController?.pushViewController(providerEditProfileObj, animated: true)
                    }
                }
            }
            
            if isVCFound == false {
                self.navigationController?.popViewController(animated: true)
            }

        } else {
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    
    @IBAction func closeClick(_ sender: UIButton) {
       // self.btnClose.alpha = 1
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowPasswordClick(_ sender: UIButton) {
        if self.txtNewPassword.isSecureTextEntry {
            self.txtNewPassword.isSecureTextEntry = false
            self.txtConfirmPassword.isSecureTextEntry = false
            self.lblTTFShowPassword.text = "Hide"
            self.lblTTFShowPassword.font = UIFont(name: Global.kFont.MeopinTops, size: 8)
        }
        else {
            self.txtNewPassword.isSecureTextEntry = true
            self.txtConfirmPassword.isSecureTextEntry = true
            self.lblTTFShowPassword.text = ""
            self.lblTTFShowPassword.font = UIFont(name: Global.kFont.MeopinTops, size: 10)
        }
    }
    
    @IBAction func btnSavePasswordClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard (txtOldPassword.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyCPVOldPassword"))
            return
        }
        guard (txtOldPassword.text?.characters.count)! > 5 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyCPPasswordMsg2"))
            return
        }
        guard (txtOldPassword.text?.validatePassword())! else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyCPPasswordMsg2"))
            return
        }
        guard (txtNewPassword.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyCPVNewPassword"))
            return
        }
        
        guard (txtNewPassword.text?.characters.count)! > 5 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyCPPasswordMsg2"))
            return
        }
        guard (txtNewPassword.text?.validatePassword())! else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyCPPasswordMsg2"))
            return
        }
        guard (txtConfirmPassword.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyCPVConfPassword"))
            return
        }
        
        if txtNewPassword.text != txtConfirmPassword.text {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVConfPassword1"))
        }
        else {
            changePasswordApiCallMethod()
        }
    }
    
    // MARK: -  Change Password API call Methods
    func changePasswordApiCallMethod() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(txtOldPassword
            .text, forKey: "form[oldPassword]")
        param.setValue(txtNewPassword.text, forKey: "form[newPassword]")
        param.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        
    AFAPIMaster.sharedAPIMaster.postChangePasswordCall_Completion(params:param , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            print(dictResponse)
            if ((dictResponse.object(forKey: "code") as? Int) == 200) {
                print(dictResponse)
                Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
