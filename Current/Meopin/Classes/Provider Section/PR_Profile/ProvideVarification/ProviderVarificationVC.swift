//
//  ForgotPwdVerificationVC.swift
//  Meopin
//
//  Created by Tops on 9/4/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

//protocol ProviderVarificationVCDelegate {
//   // func resendForgotPwdVarifCode()
//}

class ProviderVarificationVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var txtVerifyCode: UITextField!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var btnVerify: UIButton!
    var imgUserPic: UIImage?
    
    var dictUserData  = NSMutableDictionary()
    // var delegate: ForgotPwdVerificationDelegate?
    
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
        
        self.setLanguageTitles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.btnResend.isEnabled = false
        Global().delay(delay: 60) {
            self.btnResend.isEnabled = true
        }
        txtVerifyCode.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        lblSubTitle.text = Global().getLocalizeStr(key: "keyFPVerifSubTitle")
        btnResend.setTitle(Global().getLocalizeStr(key: "keyPaPResendCode"), for: .normal)
        btnResend.setTitle(Global().getLocalizeStr(key: "keyPaPResendCode"), for: .disabled)
        txtVerifyCode.placeholder = Global().getLocalizeStr(key: "keyFPVerifCode")
        btnResend.setTitle(Global().getLocalizeStr(key: "keyFPResendCode"), for: .normal)
        btnVerify.setTitle(Global().getLocalizeStr(key: "keyFPVerify"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblSubTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        txtVerifyCode.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        btnResend.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.2))
        btnVerify.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
    }
}

//MARK: -
extension ProviderVarificationVC {
    
    // MARK: -  API Call
    //Provider Profile Varification API call
    func callReSendVarificationCodeAPiCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        AFAPIMaster.sharedAPIMaster.postEditProviderProfileVarificationCall_Completion(params:param , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                self.btnResend.isEnabled = false
                Global().delay(delay: 60) {
                    self.btnResend.isEnabled = true
                }
            }
        }
    }
    
    //Provider Profile Edit data send API call
    func callForSendToVarificationCheck() {
        //form[profilePic]
        dictUserData.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtVerifyCode.text!), forKey: "form[verificationCode]")
        AFAPIMaster.sharedAPIMaster.postEditProviderProfileCall_Completion(params: dictUserData, userProfileImage: imgUserPic, showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            print(dictResponse)
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")

            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                Global.appDelegate.isVarifyCode = false
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        Global.appDelegate.isVarifyCode = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendClick(_ sender: Any) {
        btnResend.isUserInteractionEnabled = false
        btnResend.setTitleColor(UIColor.lightGray, for: .normal)
        callReSendVarificationCodeAPiCall()
    }
    
    @IBAction func btnVerifyClick(_ sender: Any) {
        self.view.endEditing(true)
        
        txtVerifyCode.text = txtVerifyCode.text!.trimmingCharacters(in: .whitespaces)
        guard (txtVerifyCode.text?.characters.count)! > 5 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPCodeMsg1"))
            return
        }
        callForSendToVarificationCheck()
    }
}

// MARK: -
extension ProviderVarificationVC: UITextFieldDelegate {
    
    // MARK: -  UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}
