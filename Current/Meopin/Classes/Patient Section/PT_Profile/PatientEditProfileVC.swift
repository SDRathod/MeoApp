//
//  PatientEditProfileVC.swift
//  Meopin
//
//  Created by Tops on 9/4/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import TOActionSheet
import IQKeyboardManagerSwift

class PatientEditProfileVC: UIViewController {
    @IBOutlet var scrollObj: UIScrollView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var lblCameraIcon: UILabel!
    
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var txtFname: UITextField!
    @IBOutlet var txtLName: UITextField!
    
    @IBOutlet var viewBasicInfo: UIView!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var btnUserNameInfo: UIButton!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnEditDetails: UIButton!
    @IBOutlet var btnChangePwd: UIButton!
    
    var dictUserData: NSDictionary = NSDictionary()
    
    var usernameToolTip = PopTip()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnProfilePic.layer.masksToBounds = true
        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.width / 2
        self.btnProfilePic.layer.borderColor = Global().RGB(r: 185, g: 185, b: 185, a: 1).cgColor
        self.btnProfilePic.layer.borderWidth = 1
        
        self.setTextFieldProperties()
        
        self.displayUserDataFromNSDefault()
        self.getPatientProfileCall()
        
        btnProfilePic.imageView?.contentMode = .scaleAspectFill
        btnProfilePic.contentHorizontalAlignment = .fill;
        btnProfilePic.contentVerticalAlignment = .fill;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.setLanguageTitles()
        
        btnEditDetails.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyPaPMyProfile")
        lblCameraIcon.text = Global().getLocalizeStr(key: "keyPaPUpload")
        
        txtTitle.placeholder = Global().getLocalizeStr(key: "keyPaPTitle")
        txtFname.placeholder = Global().getLocalizeStr(key: "keyPaPFirstName")
        txtLName.placeholder = Global().getLocalizeStr(key: "keyPaPLastName")
        txtUserName.placeholder = Global().getLocalizeStr(key: "keyPaPUsername")
        txtEmail.placeholder = Global().getLocalizeStr(key: "keyPaPE-mail")
        txtPhone.placeholder = Global().getLocalizeStr(key: "keyFPMobile")
        
        btnSubmit.setTitle(Global().getLocalizeStr(key: "keyPaPSave"), for: .normal)
        btnEditDetails.setTitle(Global().getLocalizeStr(key: "keyPaPEditDetails"), for: .normal)
        btnChangePwd.setTitle(Global().getLocalizeStr(key: "keyPaPChangePassword"), for: .normal)
        btnUserNameInfo.setTitle(Global().getLocalizeStr(key: "keyPaPUserNameInfo"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblCameraIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        txtTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtFname.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtLName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtUserName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtEmail.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtPhone.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        
        btnSubmit.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        btnEditDetails.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnChangePwd.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        btnUserNameInfo.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PatientEditProfileVC {
    // MARK: -  API Call
    func getPatientProfileCall() {
        AFAPIMaster.sharedAPIMaster.getPatientProfileDataCall_Completion(params: nil, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                self.dictUserData = dictData
                //store login data in NSUserDefaults
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "userId") as? String ?? "", forKey: Global.kLoggedInUserKey.Id);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "salutation") as? String ?? "", forKey: Global.kLoggedInUserKey.Salutation);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "title") as? String ?? "", forKey: Global.kLoggedInUserKey.Title);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "firstName") as? String ?? "", forKey: Global.kLoggedInUserKey.FirstName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "lastName") as? String ?? "", forKey: Global.kLoggedInUserKey.LastName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "username") as? String ?? "", forKey: Global.kLoggedInUserKey.UserName);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "email") as? String ?? "", forKey: Global.kLoggedInUserKey.Email);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "phoneNumber") as? String ?? "", forKey: Global.kLoggedInUserKey.PhoneNumber);
                Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "profilePictureUrl") as? String ?? "", forKey: Global.kLoggedInUserKey.ProfilePic);
                
                self.displayUserDataFromNSDefault()
            }
        })
    }
    
    func sendEditProfileVerificationCodeCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.sendPatientProfileVerificationCodeCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let shareObj: UserSObject = UserSObject()
            shareObj.strTitle = self.txtTitle.text!
            shareObj.strFName = self.txtFname.text!
            shareObj.strLName = self.txtLName.text!
            shareObj.strUserName = self.txtUserName.text!
            shareObj.strEmail = self.txtEmail.text!
            shareObj.strPhoneNumber = self.txtPhone.text!
            
            let patientProfileVerificationObj = PatientProfileVerificationVC(nibName: "PatientProfileVerificationVC", bundle: nil)
            patientProfileVerificationObj.shareObjUserData = shareObj
            if (self.btnProfilePic.image(for: .normal) != nil) {
                patientProfileVerificationObj.imgUserPic = self.btnProfilePic.image(for: .normal)!
            }
            self.navigationController?.pushViewController(patientProfileVerificationObj, animated: true)
        })
    }
    
    func editProfileCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(txtTitle.text, forKey: "form[title]")
        param.setValue(txtFname.text, forKey: "form[firstName]")
        param.setValue(txtLName.text, forKey: "form[lastName]")
        param.setValue(txtEmail.text, forKey: "form[email]")
        param.setValue(txtUserName.text, forKey: "form[username]")
        param.setValue(txtPhone.text, forKey: "form[phoneNumber]")
        param.setValue("", forKey: "form[verificationCode]")
        
        AFAPIMaster.sharedAPIMaster.postEditPatientProfileCall_Completion(params: param, img: btnProfilePic.image(for: .normal), imgName: "form[profilePic]", showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            
            Global.appDelegate.isVarifyCode = false
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                self.dictUserData = dictData
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
            Global.appDelegate.mySlideViewObj?.addDynamicDataSource()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProfilePicClick(_ sender: Any) {
        let actionSheetOption: TOActionSheet = TOActionSheet()
        actionSheetOption.title = ""
        actionSheetOption.style = .light
        
        actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyTakePhoto"), tappedBlock: { () in
            if UIImagePickerController.isSourceTypeAvailable (UIImagePickerControllerSourceType.camera) {
                let imgPickerObj: UIImagePickerController = UIImagePickerController()
                imgPickerObj.sourceType = UIImagePickerControllerSourceType.camera
                imgPickerObj.delegate = self
                imgPickerObj.allowsEditing = true
                self.present(imgPickerObj, animated: true, completion: nil)
            }
            else {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyNoCamera"))
            }
        })
        actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyChoosePhoto"), tappedBlock: { () in
            let imgPickerObj: UIImagePickerController = UIImagePickerController()
            imgPickerObj.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imgPickerObj.delegate = self
            imgPickerObj.allowsEditing = true
            self.present(imgPickerObj, animated: true, completion: nil)
        })
        //        actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyRemovePhoto"), tappedBlock: { () in
        //            self.btnProfilePic.setImage(nil, for: .normal)
        //            self.lblCameraIcon.textColor = Global().RGB(r: 175.0, g: 175.0, b: 175.0, a: 1.0)
        //        })
        actionSheetOption.show(from: self.view, in: self.view)
    }
    
    @IBAction func btnUserNameInfoClick(_ sender: Any) {
        usernameToolTip.bubbleColor = Global.kAppColor.BlueDark
        usernameToolTip.show(text: Global().getLocalizeStr(key: "keyPaPUserInfoToolTip"), direction: .left, maxWidth: Global.screenWidth - 50, in: viewBasicInfo, from: btnUserNameInfo.frame)
    }
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        self.view.endEditing(true)
        
        txtTitle.text = txtTitle.text!.trimmingCharacters(in: .whitespaces)
        txtFname.text = txtFname.text!.trimmingCharacters(in: .whitespaces)
        txtLName.text = txtLName.text!.trimmingCharacters(in: .whitespaces)
        txtUserName.text = txtUserName.text!.trimmingCharacters(in: .whitespaces)
        txtEmail.text = txtEmail.text!.trimmingCharacters(in: .whitespaces)
        txtPhone.text = txtPhone.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtTitle.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPTitleMsg1"))
            return
        }
        guard (txtTitle.text?.characters.count)! > 1 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPTitleMsg2"))
            return
        }
        guard (txtFname.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPFirstNameMsg1"))
            return
        }
        guard (txtFname.text?.characters.count)! > 2 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPFirstNameMsg2"))
            return
        }
        guard (txtLName.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPLastName1"))
            return
        }
        guard (txtLName.text?.characters.count)! > 2 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPLastName2"))
            return
        }
        guard (txtUserName.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPUsernameMsg1"))
            return
        }
        guard (txtUserName.text?.characters.count)! > 2 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPUsernameMsg2"))
            return
        }
        guard (txtEmail.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPE-mailMsg1"))
            return
        }
        guard Global.singleton.validateEmail(strEmail: txtEmail.text!) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPE-mailMsg2"))
            return
        }
        guard (txtPhone.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPPhoneNumberMsg1"))
            return
        }
        guard Global.singleton.validatePhoneNumber(strPhone: txtPhone.text!) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPPhoneNumberMsg2"))
            return
        }
        self.checkWhichInfoUpdated()
    }
    
    @IBAction func btnChangePwdClick(_ sender: Any) {
        let changePasswordObj = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
        changePasswordObj.dictUserData = NSMutableDictionary(dictionary: self.dictUserData)
        self.navigationController?.pushViewController(changePasswordObj, animated: true)
    }
    
    // MARK: -  Check which Information is edited
    func checkWhichInfoUpdated() {
        if (Global.kLoggedInUserData().FirstName != txtFname.text || Global.kLoggedInUserData().LastName != txtLName.text || Global.kLoggedInUserData().Email != txtEmail.text || Global.kLoggedInUserData().PhoneNumber != txtPhone.text || Global.kLoggedInUserData().UserName != txtUserName.text) {
            self.sendEditProfileVerificationCodeCall()
        }
        else {
            self.editProfileCall()
        }
    }
}

// MARK: -
extension PatientEditProfileVC: UITextFieldDelegate {
    // MARK: -  UITextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji" || !((textField.textInputMode?.primaryLanguage) != nil)) {
            return false
        }
        if (string == "") {
            return true
        }
        if (textField == txtTitle || textField == txtFname || textField == txtLName || textField == txtUserName) {
            if ((textField.text?.characters.count)! > 30) {
                return false
            }
        }
        else if (textField == txtEmail) {
            if ((textField.text?.characters.count)! > 50) {
                return false
            }
        }
        else if (textField == txtPhone) {
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
        if (textField == txtTitle) {
            txtFname.becomeFirstResponder()
        }
        else if (textField == txtFname) {
            txtLName.becomeFirstResponder()
        }
        else if (textField == txtLName) {
            txtUserName.becomeFirstResponder()
        }
        else if (textField == txtUserName) {
            txtEmail.becomeFirstResponder()
        }
        else if (textField == txtEmail) {
            txtPhone.becomeFirstResponder()
        }
        return true
    }
}

// MARK: -
extension PatientEditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: -  UIImagePickerController Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var img: UIImage? = info[UIImagePickerControllerEditedImage] as! UIImage?
        if (img == nil) {
            img = info[UIImagePickerControllerOriginalImage] as! UIImage?
        }
        
        let height: CGFloat = 100
        let oldHeight: CGFloat = (img?.size.height)!
        let scaleFactor: CGFloat = height / oldHeight
        let newWidth: CGFloat = img!.size.width * scaleFactor
        let newHeight: CGFloat = oldHeight * scaleFactor
        
        img = img?.resizedImage(CGSize(width: newWidth, height: newHeight), interpolationQuality: CGInterpolationQuality(rawValue: 3)!)
        
        let imgData: NSData = NSData(data: UIImagePNGRepresentation(img!)!)
        let imageSize: Int = imgData.length
        if ((Double(imageSize) / 1024.0) > 2048) {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPaPProfilePicSizeMsg1"))
        }
        else {
            btnProfilePic.setImage(img, for: .normal)
            self.lblCameraIcon.textColor = UIColor.white
        }
        Global.appDelegate.isVarifyCode = true
        picker.dismiss(animated: false, completion: {() in
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {() in
            Global.appDelegate.isVarifyCode = true
        })
    }
}

// MARK: -
extension PatientEditProfileVC {
    // MARK: -  Control Settings
    func setTextFieldProperties() {
        txtTitle.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtTitle.leftViewMode = .always
        
        txtFname.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtFname.leftViewMode = .always
        
        txtLName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtLName.leftViewMode = .always
        
        txtUserName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtUserName.leftViewMode = .always
        
        txtEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtEmail.leftViewMode = .always
        
        txtPhone.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtPhone.leftViewMode = .always
        
        txtTitle.layer.masksToBounds = true
        txtTitle.layer.cornerRadius = 2.0
        txtTitle.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtTitle.layer.borderWidth = 0.4
        
        txtFname.layer.masksToBounds = true
        txtFname.layer.cornerRadius = 2.0
        txtFname.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtFname.layer.borderWidth = 0.4
        
        txtLName.layer.masksToBounds = true
        txtLName.layer.cornerRadius = 2.0
        txtLName.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtLName.layer.borderWidth = 0.4
        
        txtUserName.layer.masksToBounds = true
        txtUserName.layer.cornerRadius = 2.0
        txtUserName.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtUserName.layer.borderWidth = 0.4
        
        txtEmail.layer.masksToBounds = true
        txtEmail.layer.cornerRadius = 2.0
        txtEmail.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtEmail.layer.borderWidth = 0.4
        
        txtPhone.layer.masksToBounds = true
        txtPhone.layer.cornerRadius = 2.0
        txtPhone.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtPhone.layer.borderWidth = 0.4
        
        txtTitle.text = ""
        txtFname.text = ""
        txtLName.text = ""
        txtUserName.text = ""
        txtEmail.text = ""
        txtPhone.text = ""
    }
    
    func displayUserDataFromNSDefault() {
        txtTitle.text = Global.kLoggedInUserData().Title!
        txtFname.text = Global.kLoggedInUserData().FirstName!
        txtLName.text = Global.kLoggedInUserData().LastName!
        txtUserName.text = Global.kLoggedInUserData().UserName!
        txtEmail.text = Global.kLoggedInUserData().Email!
        txtPhone.text = Global.kLoggedInUserData().PhoneNumber!
        
        if (Global.kLoggedInUserData().ProfilePic != nil && Global.kLoggedInUserData().ProfilePic != "") {
            btnProfilePic.sd_setImage(with: URL(string: Global.kLoggedInUserData().ProfilePic!)!, for: .normal, placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        else {
            btnProfilePic.setImage(#imageLiteral(resourceName: "ProfileView"), for: .normal)
        }
    }
}
