//
//  RegisterVC.swift
//  Meopin
//
//  Created by Tops on 9/1/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    //Header Part
   // @IBOutlet weak var btnLanguageSelect: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var scrView: UIScrollView!

  //  @IBOutlet weak var : UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lblHeaderTitile: UILabel!
    let popTip = PopTip()
   
    
    @IBOutlet weak var btnTPUsername: UIButton!
    @IBOutlet weak var btnTPPassword: UIButton!
    
    @IBOutlet weak var btnShowConfPassword: UIButton!
    
    //innerView  Part
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var txtSalutation: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfPass: UITextField!
    @IBOutlet weak var btnPolicy: UIButton!
    @IBOutlet weak var btnTearmsCon: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var lblPolicy: UILabel!
    @IBOutlet weak var lblTermsCondition: UILabel!
    
    @IBOutlet var lblTTFUserName: UILabel!
    @IBOutlet var lblTTFShowPassword: UILabel!
    @IBOutlet var lblTTFConfPassword: UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPolicy.backgroundColor = UIColor.lightGray
        btnTearmsCon.backgroundColor = UIColor.lightGray
        btnTearmsCon.isSelected = true
        btnTearmsCon.backgroundColor = Global().RGB(r: 42, g: 82, b: 134, a:1)
        btnPolicy.isSelected = true
        btnPolicy.backgroundColor = Global().RGB(r: 42, g: 82, b: 134, a:1)
        self.textfieldLayoutSet()
        self.setLanguageTitles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Global.singleton.delegate = self
        Global.singleton.addLanguageScrollView(inView: self.footerView, with: CGRect(x: 0, y: Global.singleton.getDeviceSpecificFontSize(5), width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(30)), textColor: Global.kAppColor.GrayLight, selTextColor: Global.kAppColor.BlueDark)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        Global.singleton.delegate = nil
        Global.singleton.removeLanguageScrollView()
        super.viewWillDisappear(animated)
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        setDeviceSpecificFonts()
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        txtSalutation.placeholder = Global().getLocalizeStr(key: "KeySalutation")
        txtTitle.placeholder = Global().getLocalizeStr(key: "KeyTitle")
        txtFirstname.placeholder = Global().getLocalizeStr(key: "KeyFirstName")
        txtLastName.placeholder = Global().getLocalizeStr(key: "KeyLastName")
        txtPassword.placeholder = Global().getLocalizeStr(key: "KeyPassword")
        txtUserName.placeholder = Global().getLocalizeStr(key: "KeyUserName")
        txtEmail.placeholder = Global().getLocalizeStr(key: "KeyEmailAddress")
        txtMobileNo.placeholder = Global().getLocalizeStr(key: "KeyMobileNo")
        txtPassword.placeholder = Global().getLocalizeStr(key: "KeyPassword")
        txtConfPass.placeholder = Global().getLocalizeStr(key: "KeyPasswordCon")
        
        let textPolicy = Global().getLocalizeStr(key: "KeyPolicy")
        let rangePolicy = (textPolicy as NSString).range(of: "Meopin's Privacy Policy")
        let attributedStringPolicy = NSMutableAttributedString(string:textPolicy)
        attributedStringPolicy.addAttribute(NSForegroundColorAttributeName, value:  Global().RGB(r: 42, g: 82, b: 134, a: 1) , range: rangePolicy)
        lblPolicy.attributedText = attributedStringPolicy;
        
        let textTC = Global().getLocalizeStr(key: "KeylblTerms")
        let rangeTC = (textTC as NSString).range(of: "Meopin's General Terms and Conditions")
        let attributedStringTC = NSMutableAttributedString(string:textTC)
        attributedStringTC.addAttribute(NSForegroundColorAttributeName, value: Global().RGB(r: 42, g: 82, b: 134, a: 1) , range: rangeTC)
        
        lblTermsCondition.attributedText = attributedStringTC;
        
        let textLogINContent = Global().getLocalizeStr(key: "KeyLogIN")
        let rangeLogIN = (textLogINContent as NSString).range(of: "LogIN")
        let attributedStringRangeLogIN = NSMutableAttributedString(string:textLogINContent)
        attributedStringRangeLogIN.addAttribute(NSForegroundColorAttributeName, value:  Global().RGB(r: 42, g: 82, b: 134, a: 1) , range: rangeLogIN)
        btnLogin.setAttributedTitle(attributedStringRangeLogIN, for: .normal)
        lblHeaderTitile.text = Global().getLocalizeStr(key: "keyRegisterTitile")
        btnRegister.setTitle(Global().getLocalizeStr(key: "keyFPVerify"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        lblHeaderTitile.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnRegister.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        lblPolicy.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblTermsCondition.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnTearmsCon.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(8))
        btnPolicy.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblTTFShowPassword.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(10))
        btnLogin.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        if (txtConfPass.text?.isEmpty)! {
            
        } else {
            if txtConfPass.text == txtPassword.text {
                setTextTTFConfimPassword()
            } else  {
                lblTTFConfPassword.text =  ""
            }
        }
        
    }
    
    // MARK: -  All textfield layouts Methods
    func textfieldLayoutSet() {
        for case let textField as UITextField in self.innerView.subviews {
            
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 2.0
            textField.layer.borderColor = Global.kTextFieldProperties.BorderColor
            textField.layer.borderWidth = 0.4
            if textField == txtSalutation {
                textField.paddingviewWithCustomValue(12.0, txtfield: textField)
                textField.backgroundColor = Global.kAppColor.LightGray
                textField.placeHolderColor = UIColor.black
            } else if textField == txtUserName || textField == txtPassword || textField == txtConfPass {
                textField.paddingRightLeftviewWithCustomValue(12.0, txtfield: textField)
                textField.rightViewMode = UITextFieldViewMode .always
            } else  {
                textField.paddingviewWithCustomValue(12.0, txtfield: textField)
            }
            
            textField.leftViewMode = UITextFieldViewMode .always
            textField.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        }
    }
}

// MARK: -  All textfield delegate Methods
extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtConfPass {
            if txtConfPass.text == txtPassword.text {
                    setTextTTFConfimPassword()
                } else {
                    hideConfirmPasswordIcon()
                }
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPassword {
            hideConfirmPasswordIcon()
        } else if textField == txtConfPass {
            hideConfirmPasswordIcon()
        } else if (string == "") {
            return true
        } else if textField == txtSalutation {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtTitle {
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtFirstname || textField == txtLastName || textField == txtUserName || textField == txtPassword || textField == txtConfPass {
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtMobileNo  {
                if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
                    return false
                }
                if (txtMobileNo.text?.characters.count == 0) {
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
    
    func hideConfirmPasswordIcon() {
        lblTTFConfPassword.layer.borderColor = UIColor.clear.cgColor
        lblTTFConfPassword.layer.cornerRadius = 0
        lblTTFConfPassword.backgroundColor = UIColor.clear
        lblTTFConfPassword.text =  ""
    }
    
    func setTextTTFConfimPassword()  {
        lblTTFConfPassword.layer.borderColor = Global().RGB(r: 90, g: 167, b: 60, a: 1).cgColor
        lblTTFConfPassword.layer.cornerRadius = lblTTFConfPassword.frame.height / 2
        lblTTFConfPassword.layer.borderWidth = 1
        lblTTFConfPassword.textAlignment = .center
        lblTTFConfPassword.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(6))
        lblTTFConfPassword.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSalutation {
            textField .resignFirstResponder()
            txtTitle .becomeFirstResponder()
        } else  if textField == txtTitle {
            textField .resignFirstResponder()
            txtFirstname .becomeFirstResponder()
        } else  if textField == txtFirstname{
            textField .resignFirstResponder()
            txtLastName .becomeFirstResponder()
        } else if textField == txtLastName {
            textField .resignFirstResponder()
            txtUserName .becomeFirstResponder()
        }else if textField == txtUserName {
            textField .resignFirstResponder()
            txtEmail .becomeFirstResponder()
        } else if textField == txtEmail {
            textField .resignFirstResponder()
            txtMobileNo .becomeFirstResponder()
        }else if textField == txtMobileNo {
            textField .resignFirstResponder()
            txtPassword .becomeFirstResponder()
        }else if textField == txtPassword {
            textField .resignFirstResponder()
            txtConfPass .becomeFirstResponder()
        } else {
            textField .resignFirstResponder()
        }
        return true
    }
    
}
extension RegisterVC {
    
    // MARK: -  Registration Click Methods

    func callRegisterMethodApi_Call() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtSalutation.text!), forKey: "form[salutation]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtTitle.text!), forKey: "form[title]")
        
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtFirstname.text!), forKey: "form[firstName]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtLastName.text!), forKey: "form[lastName]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtUserName.text!), forKey: "form[username]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtEmail.text!), forKey: "form[email]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtPassword.text!), forKey: "form[plainPassword]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtMobileNo.text!), forKey: "form[phoneNumber]")
        param.setValue(Global.kDeviceTypeWS, forKey: "form[deviceType]")
        //param.setValue("12345613", forKey: "form[deviceToken]")
        param.setValue(Global.appDelegate.strDeviceToken, forKey: "form[deviceToken]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: ""), forKey: "form[verificationCode]")
        
        var dictionValue = NSMutableDictionary()
        dictionValue = param
        AFAPIMaster.sharedAPIMaster.postRegistrationCall_Completion(params:param , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            print(dictResponse)
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                Global.singleton.showSuccessAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))

                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "userId") as? String ?? "", forKey: Global.kLoggedInUserKey.Id);
                    let VarificationObj = VarificationVC(nibName: "VarificationVC", bundle: nil)
                    VarificationObj.strVarificationCode = dictData.value(forKey: "verificationCode") as? String ?? ""
                    VarificationObj.dictUserData = dictionValue
                    self.navigationController?.pushViewController(VarificationObj, animated: true)
            }
        }
    }

    
    // MARK: -  Button Click Methods
    @IBAction func btnLoginClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPasswordInfoClick(_ sender: UIButton) {
        
        popTip.bubbleColor = Global().RGB(r: 42, g: 82, b: 134, a: 1)
        popTip.show(text: Global().getLocalizeStr(key: "keyPaPPasswordPopToolTip"), direction: .left, maxWidth: 220, in: innerView, from: sender.frame)
    }

    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegisterClick(_ sender: UIButton) {
        //NextViewControllerCall()
        checkValidationForRegistration()
    }

    @IBAction func btnTPUsernameClick(_ sender: UIButton) {
        popTip.bubbleColor = Global().RGB(r: 42, g: 82, b: 134, a: 1)
        popTip.show(text:Global().getLocalizeStr(key: "keyPaPUserInfoToolTip"), direction: .left, maxWidth: 220, in: innerView, from: sender.frame)

    }
    
    @IBAction func btnTPPasswordClick(_ sender: UIButton) {
        if self.txtPassword.isSecureTextEntry {
            self.txtPassword.isSecureTextEntry = false
            self.txtConfPass.isSecureTextEntry = false
            self.lblTTFShowPassword.text = "Hide"
            self.lblTTFShowPassword.font = UIFont(name: Global.kFont.MeopinTops, size: 10)
        } else {
            self.txtPassword.isSecureTextEntry = true
            self.txtConfPass.isSecureTextEntry = true
            self.lblTTFShowPassword.text = ""
            lblTTFShowPassword.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(10))
        }
    }
    
    @IBAction func btnShowConfPasswordClick(_ sender: UIButton) {
        if txtPassword.text != txtConfPass.text {
            if self.txtConfPass.isSecureTextEntry {
                self.txtConfPass.isSecureTextEntry = false
            }else{
                self.txtConfPass.isSecureTextEntry = true
            }
        }
    }
    
    @IBAction func btnPolicyClick(_ sender: UIButton) {
        if sender.isSelected {
            btnPolicy.isSelected = false
            btnPolicy.backgroundColor = UIColor.lightGray
        } else  {
            btnPolicy.isSelected = true
            btnPolicy.backgroundColor = Global().RGB(r: 42, g: 82, b: 134, a:1)
        }
    }
    
    @IBAction func btnTearmsConClik(_ sender: UIButton) {
        if sender.isSelected {
            btnTearmsCon.isSelected = false
            btnTearmsCon.backgroundColor = UIColor.lightGray
        } else  {
            btnTearmsCon.isSelected = true
            btnTearmsCon.backgroundColor = Global().RGB(r: 42, g: 82, b: 134, a:1)
        }
    }
    
    @IBAction func btnPolicyReadClick(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: Global.kWebPageURL.PrivacyPolicy)!)
    }
    
    @IBAction func btnTearm(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: Global.kWebPageURL.TermsConditions)!)
    }
    
    
    func checkValidationForRegistration() {
        self.view.endEditing(true)
        
        txtEmail.text = txtEmail.text!.trimmingCharacters(in: .whitespaces)
        txtPassword.text = txtPassword.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtSalutation.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVSalutation"))
            return
        }
        guard (txtTitle.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVTitle"))
            return
        }
        
        guard (txtFirstname.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVFirstName"))
            return
        }
        
        guard (txtLastName.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVLastName"))
            return
        }
        guard (txtUserName.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVUserName"))
            return
        }
        
        guard (txtMobileNo.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVMobileNo"))
            return
        }
        guard Global.singleton.validatePhoneNumber(strPhone: txtMobileNo.text!) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPMobileMsg2"))
            return
        }

        guard (txtEmail.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVEmailMsg1"))
            return
        }
        
        guard Global.singleton.validateEmail(strEmail: txtEmail.text!) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVEmailMsg2"))
            return
        }
        
        guard (txtPassword.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVPassword"))
            return
        }
        guard (txtPassword.text?.characters.count)! > 5 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyLIPasswordMsg2"))
            return
        }
        guard (txtPassword.text?.validatePassword())! else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyLIPasswordMsg2"))
            return
        }
        
        
        if txtPassword.text != txtConfPass.text {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVConfPassword1"))
            return
        }
        
        if btnPolicy.isSelected == true && btnTearmsCon.isSelected == true {
            callRegisterMethodApi_Call()
        } else {
            if btnPolicy.isSelected == false {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVPrivacy"))
                return
            }
            
            if btnTearmsCon.isSelected == false  {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVTermCondition"))
                return
            }
        }
        
    }
    
    func NextViewControllerCall() {
        let VarificationObj = VarificationVC(nibName: "VarificationVC", bundle: nil)
        self.navigationController?.pushViewController(VarificationObj, animated: true)
    }
}

// MARK: -
extension RegisterVC: SingletonDelegate {
    // MARK: -  Singleton Delegate Methods
    func didSelectLanguage() {
        self.setLanguageTitles()
    }
}
