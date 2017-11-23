//
//  VarificationVC.swift
//  Meopin
//
//  Created by Tops on 9/5/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class VarificationVC: UIViewController {
    
    //Header Part
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblVarificationMsg: UILabel!
    @IBOutlet weak var lblVarificationConfMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var txtVarificationCode: UITextField!
    
    @IBOutlet weak var btnSubmitCode: UIButton!
    
    var timer = Timer()
    
    @IBOutlet weak var textFieldLayoutTopSet: NSLayoutConstraint!
    
    var strVarificationCode = String()
    var dictUserData  = NSMutableDictionary()
    var userProfileImage = UIImage()
    
    
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(VarificationVC.ErroFailValidationMethod), name:NSNotification.Name(rawValue: "ErroFailValidation"), object: nil)
        
        
        print(strVarificationCode)
        setLanguageTitles()
        btnResendCode.isUserInteractionEnabled = false
        btnResendCode.setTitleColor(UIColor.lightGray, for: .normal)
        txtVarificationCode.text = ""
        //self.designLayoutSetup()
        Timer1Min()
    }
    
    func ErroFailValidationMethod() {
        Global.appDelegate.isVarificationFail = false
        let VarificationObj = RegisterSuccessFailVC(nibName: "RegisterSuccessFailVC", bundle: nil)
        VarificationObj.statusSuccessFail = false
        self.navigationController?.pushViewController(VarificationObj, animated: true)
    }
    
    func Timer1Min() {
        timer = Timer.scheduledTimer(timeInterval: 60 , target: self, selector:  #selector(self.resendButtonDisablefor1Min), userInfo: nil, repeats: false)
    }
    
    func resendButtonDisablefor1Min() {
        btnResendCode.isUserInteractionEnabled = true
        btnResendCode.setTitleColor(Global().RGB(r: 42, g: 82, b: 134, a: 1), for: .normal)
    }
    
    /*func designLayoutSetup()  {
        if (Global.is_iPhone._4) {
            meophinTop.constant = 0
            scrollLayoutTop.constant = 2
            submitLayoutTop.constant = 15
            textFieldLayoutTopSet.constant = 0
        }else if (Global.is_iPhone._5) {
            meophinTop.constant = 17
            scrollLayoutTop.constant = 17
            submitLayoutTop.constant = 30
            textFieldLayoutTopSet.constant = 25
        }
        else if (Global.is_iPhone._6) {
            meophinTop.constant = 22
            scrollLayoutTop.constant = 30
            submitLayoutTop.constant = 30
            textFieldLayoutTopSet.constant = 32
        }
        else if (Global.is_iPhone._6p) {
            meophinTop.constant = 25
            scrollLayoutTop.constant = 35
            textFieldLayoutTopSet.constant = 30
            submitLayoutTop.constant = 35
        }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.text = Global().getLocalizeStr(key:  "keyResultVarification")

        lblVarificationMsg.text = Global().getLocalizeStr(key:  "KeyRegVVarificationMsg")
        lblVarificationConfMsg.text = Global().getLocalizeStr(key: "KeyRegVVarificationConfiMsg")
        txtVarificationCode.placeholder = Global().getLocalizeStr(key:  "KeyRegVVarificationCodeMsg")
        
        btnResendCode.setTitle(Global().getLocalizeStr(key:  "KeyRegVResendVarificationCode"), for: .normal)
        btnSubmitCode.setTitle(Global().getLocalizeStr(key:  "KeyRegVBtnSubmit"), for: .normal)
        
    }
    
    func setDeviceSpecificFonts() {
        
        lblTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblVarificationMsg.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblVarificationConfMsg.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        txtVarificationCode.layer.masksToBounds = true
        txtVarificationCode.layer.cornerRadius = 2.0
        txtVarificationCode.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtVarificationCode.layer.borderWidth = 0.4
        txtVarificationCode.paddingviewWithCustomValue(12.0, txtfield: txtVarificationCode)
        txtVarificationCode.leftViewMode = UITextFieldViewMode .always
        txtVarificationCode.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.5))
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnResendCode.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnSubmitCode.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
        
    }
}


extension VarificationVC  {
    // MARK: -   Varification API call
    func varificationCodeApiCall() {
        dictUserData.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtVarificationCode.text!), forKey: "form[verificationCode]")
        dictUserData.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        Global.appDelegate.isVarificationFail = true
        AFAPIMaster.sharedAPIMaster.postRegisterVarificationCodeCall_Completion(params:dictUserData , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            print(dictResponse)
            if ((dictResponse.object(forKey: "code") as? Int) == 200) {
                print(dictResponse)
                Global.singleton.showSuccessAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))

                let VarificationObj = RegisterSuccessFailVC(nibName: "RegisterSuccessFailVC", bundle: nil)
                VarificationObj.statusSuccessFail = true
                self.navigationController?.pushViewController(VarificationObj, animated: true)
            }
        }
    }
    
    
    // MARK: -  Resend Varification API call
    func resendVarificationCodeApiCall() {
        dictUserData.setValue(Global.singleton.emojisEncodedConvertedString(strText: ""), forKey: "form[verificationCode]")
        dictUserData.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.postRegistrationCall_Completion(params:dictUserData , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            print(dictResponse)
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                self.Timer1Min()
            }
        }
    }
    
    // MARK: -  All Button Click Method
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendCodeClick(_ sender: UIButton) {
        btnResendCode.isUserInteractionEnabled = false
        btnResendCode.setTitleColor(UIColor.lightGray, for: .normal)
        self.resendVarificationCodeApiCall()
    }
    
    @IBAction func btnSubmitCodeClick(_ sender: UIButton) {
        self.varificationCodeApiCall()
    }
    
    
    @IBAction func btnYouProviderClick(_ sender: Any) {
        let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
        loginObj.boolUserIsPatient = false
        self.navigationController?.pushViewController(loginObj, animated: true)
    }
    
    @IBAction func btnAboutUsClick(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Global.kWebPageURL.AboutUs)!)
    }
    
    @IBAction func btnContactClick(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Global.kWebPageURL.Contact)!)
    }
    
    
    func checkValidataionCode()  {
        guard (txtVarificationCode.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "KeyRegVVarificationCode"))
            return
        }
    }
}

extension VarificationVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if (string == "") {
//            return true
//        }
//        if (textField.text?.characters.count)! > 6 {
//            return false
//        }
//        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
//        let components = string.components(separatedBy: inverseSet)
//        let filtered = components.joined(separator: "")
//        return string == filtered
        return true
    }
}

