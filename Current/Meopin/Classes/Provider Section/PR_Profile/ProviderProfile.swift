//
//  ProviderProfile.swift
//  Meopin
//
//  Created by Tops on 9/4/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import SDWebImage
import TOActionSheet

class ProviderProfile: UIViewController {
    
    //Header Part
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var innerViewProfile: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnSaveBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var InnerView: UIView!
    @IBOutlet weak var txtSalution: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPracticeName: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtNo: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtFax: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var lblCameraIcon: UILabel!
    @IBOutlet var lblHeaderTitle: UILabel!

    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnEditPress: UIButton!
    
    var dictUserData: NSDictionary = NSDictionary()

    var mySlideViewObj: MySlideViewController?
    
    let imagePicker = UIImagePickerController()
    var ProfileImage =  UIImage()
    var viewSpinner: UIView = UIView()
    var dictSetUserValue = NSDictionary()
    
    var boolIsFromSlideMenu: Bool = true
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        self.textfieldLayoutSet()
        self.setLanguageTitles()
        
        self.btnProfilePic.layer.masksToBounds = true
        btnProfilePic.imageView?.contentMode = .scaleAspectFill
        btnProfilePic.contentHorizontalAlignment = .fill;
        btnProfilePic.contentVerticalAlignment = .fill;
        btnProfilePic.layer.borderWidth = 0.7
        btnProfilePic.layer.borderColor = Global.kAppColor.LightGray.cgColor

        self.btnCity.isUserInteractionEnabled = false
        self.txtCity.textColor = UIColor.lightGray
        self.getProfileDetailResponsParsing()
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
    }
    
    override func viewDidLayoutSubviews() {
        self.btnProfilePic.layer.borderColor = UIColor.lightGray.cgColor
        self.btnProfilePic.layer.borderWidth = 1.0
        self.btnProfilePic.layer.cornerRadius = self.btnProfilePic.frame.size.height/2
    }
    
    func setDisableEnableControl()  {
        if Global.appDelegate.isVarifyCode == false {
            self.btnEditPress.alpha = 0.5
            self.btnEditPress.isUserInteractionEnabled = true
            //self.btnClose.isHidden = true
            self.txtCity.textColor = UIColor.lightGray
            self.btnCity.isUserInteractionEnabled = false
            InnerView.isUserInteractionEnabled = false
            innerViewProfile.isUserInteractionEnabled = false
            textfieldLayoutSet()
            if (btnProfilePic.image(for: .normal) == nil) {
                lblCameraIcon.textColor = Global().RGB(r: 175.0, g: 175.0, b: 175.0, a: 1.0)
            }
            else {
                lblCameraIcon.textColor = UIColor.white
            }
            btnProfilePic.isUserInteractionEnabled = false
            self.btnSaveBottomLayout.constant = -50.0
            self.btnSave.isHidden = true

        } else  {
            self.btnSaveBottomLayout.constant = 70.0
            self.btnSave.isHidden = false
            //self.btnClose.isHidden =  false
            self.btnEditPress.alpha = 1
            self.btnEditPress.isUserInteractionEnabled = false
            self.textfieldLayoutEditSet()
            self.InnerView.alpha = 1
            self.InnerView.isUserInteractionEnabled = true
            self.innerViewProfile.isUserInteractionEnabled = true
            self.InnerView.backgroundColor = UIColor.clear
            txtCity.textColor = UIColor.lightGray
           // self.btnClose.isUserInteractionEnabled = true
            self.btnProfilePic.isUserInteractionEnabled = true
            InnerView.isUserInteractionEnabled = true
            if (btnProfilePic.image(for: .normal) == nil) {
                lblCameraIcon.textColor = Global().RGB(r: 175.0, g: 175.0, b: 175.0, a: 1.0)
            }
            else {
                lblCameraIcon.textColor = UIColor.white
            }
            btnProfilePic.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Global.countrySingleton.delegate = self
        Global.countrySingleton.addCountryDropDownList(inView: self.InnerView, with: CGRect(x: btnCountry.frame.origin.x - 45, y: btnCountry.frame.origin.y, width: btnCountry.frame.size.width + 90, height: btnCountry.frame.size.height))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.appDelegate.isVarifyCode = true
        setDisableEnableControl()
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        Global.countrySingleton.delegate = nil
        Global.countrySingleton.removeCountryDropMenu()
        
        Global.citySingleton.delegate = nil
        Global.citySingleton.removeCityDropMenu()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        setDeviceSpecificFonts()
        lblCameraIcon.text = Global().getLocalizeStr(key: "keyPaPUpload")
        lblHeaderTitle.text = Global().getLocalizeStr(key: "keyPaPMyProfile")
        txtSalution.placeholder = Global().getLocalizeStr(key: "KeyPEPSalutation")
        txtTitle.placeholder = Global().getLocalizeStr(key: "KeyPEPTitle")
        txtFirstname.placeholder = Global().getLocalizeStr(key: "KeyPEPFirstName")
        txtLastname.placeholder = Global().getLocalizeStr(key: "KeyPEPLastName")
        txtEmail.placeholder = Global().getLocalizeStr(key: "KeyPEPEmailAddress")
        txtPracticeName.placeholder = Global().getLocalizeStr(key: "KeyPEPPracticeName")
        txtStreet.placeholder = Global().getLocalizeStr(key: "KeyPEPStreet")
        txtNo.placeholder = Global().getLocalizeStr(key: "KeyPEPNo")
        txtCity.placeholder = Global().getLocalizeStr(key: "KeyPEPCity")
        txtCountry.placeholder = Global().getLocalizeStr(key: "KeyPEPCountry")
        txtWebsite.placeholder = Global().getLocalizeStr(key: "KeyPEPWebsite")
        txtFax.placeholder = Global().getLocalizeStr(key: "KeyPEPFax")
        txtPassword.placeholder = Global().getLocalizeStr(key: "KeyPEPPassword")
        txtMobileNumber.placeholder = Global().getLocalizeStr(key: "keyFPMobile")
        btnChangePassword.setTitle(Global().getLocalizeStr(key: "KeyPEPChangePassword"), for: .normal)
        btnEditPress.setTitle(Global().getLocalizeStr(key: "KeyPEPEditProfile"), for: .normal)
        btnSave.setTitle(Global().getLocalizeStr(key: "KeyPEPSave"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblHeaderTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblCameraIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        btnSave.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        btnEditPress.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        btnChangePassword.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        if (Global.kLoggedInUserData().ProfilePic != nil && Global.kLoggedInUserData().ProfilePic != "") {
            btnProfilePic.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(0))
        }
        else {
            btnProfilePic.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        }
    }
    
    // MARK: -  All textfield layouts Methods
    func textfieldLayoutSet() {
        for case let textField as UITextField in self.InnerView.subviews {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 2.0
            textField.layer.borderColor = Global.kTextFieldProperties.BorderColor
            textField.layer.borderWidth = 0.4
            textField.paddingviewWithCustomValue(12.0, txtfield: textField)
            textField.leftViewMode = UITextFieldViewMode .always
            textField.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
            textField.textColor = UIColor.lightGray
            textField.isUserInteractionEnabled = false
            
        }
        for case let textField as UITextField in self.innerViewProfile.subviews {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 2.0
            textField.layer.borderColor = Global.kTextFieldProperties.BorderColor
            textField.layer.borderWidth = 0.4
            textField.paddingviewWithCustomValue(12.0, txtfield: textField)
            textField.leftViewMode = UITextFieldViewMode .always
            textField.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
            textField.textColor = UIColor.lightGray
            textField.isUserInteractionEnabled = false
        }

    }

    // MARK: -  All textfield layouts Methods
    func textfieldLayoutEditSet() {
        for case let textField as UITextField in self.InnerView.subviews {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 2.0
            textField.layer.borderColor = Global.kTextFieldProperties.BorderColor
            textField.layer.borderWidth = 0.4
            textField.paddingviewWithCustomValue(12.0, txtfield: textField)
            textField.leftViewMode = UITextFieldViewMode .always
            textField.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
            textField.alpha = 1
            textField.textColor = Global.kAppColor.GrayDark
            textField.isUserInteractionEnabled = true
            if textField == txtCity || textField == txtCountry {
                textField.isUserInteractionEnabled = false
            }
        }
        
        for case let textField as UITextField in self.innerViewProfile.subviews {
            textField.layer.masksToBounds = true
            textField.layer.cornerRadius = 2.0
            textField.layer.borderColor = Global.kTextFieldProperties.BorderColor
            textField.layer.borderWidth = 0.4
            textField.paddingviewWithCustomValue(12.0, txtfield: textField)
            textField.leftViewMode = UITextFieldViewMode .always
            textField.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13.2))
            textField.alpha = 1
            textField.textColor = Global.kAppColor.GrayDark
            textField.isUserInteractionEnabled = true
            if textField == txtCity || textField == txtCountry {
                textField.isUserInteractionEnabled = false
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory Issue")
    }
}

extension ProviderProfile  {
    // MARK: -  All Button Click Method
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
        actionSheetOption.show(from: self.view, in: self.view)
    }
    
    @IBAction func btnEditProfileClick(_ sender: UIButton) {
        Global.appDelegate.isVarifyCode = true
        self.setDisableEnableControl()
    }
    
    @IBAction func btnCityClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCountryClick(_ sender: UIButton) {
    }
    
    @IBAction func btnChangePassClick(_ sender: UIButton) {
        let changePasswordVCObj = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
        changePasswordVCObj.dictUserData = self.dictSetUserValue
        self.navigationController?.pushViewController(changePasswordVCObj, animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        checkValidationForRegistration()
    }
 
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.textfieldLayoutSet()
        Global.appDelegate.isVarifyCode = false
        self.setDisableEnableControl()
    }
    
    // MARK: -  Check Validataion Method On Submit
    func checkValidationForRegistration() {
        self.view.endEditing(true)
        txtEmail.text = txtEmail.text!.trimmingCharacters(in: .whitespaces)
        txtPassword.text = txtPassword.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtSalution.text?.characters.count)! > 0 else {
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
        
        guard (txtLastname.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVLastName"))
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
        
        guard (txtPracticeName.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "KeyPSPracticeName"))
            return
        }
        guard (txtStreet.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "KeyPSStreet"))
            return
        }
        
        guard (txtCity.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "KeyPSCity"))
            return
        }
        
        guard (txtCountry.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "KeyPSCountry"))
            return
        }
        
        guard (txtWebsite.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "KeyPSWebsite"))
            return
        }
        guard (txtFax.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "KeyPSFax"))
            return
        }
        
        guard (txtMobileNumber.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVMobileNo"))
            return
        }
        guard Global.singleton.validatePhoneNumber(strPhone: txtMobileNumber.text!) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyFPMobileMsg2"))
            return
        }
        
        if txtFirstname.text == dictSetUserValue.value(forKey: "firstName")as? String && txtLastname.text == dictSetUserValue.value(forKey: "lastName")as? String && txtEmail.text == dictSetUserValue.value(forKey: "email")as? String && txtMobileNumber.text == dictSetUserValue.value(forKey: "phoneNumber")as? String {
            editProviderProfileAPI_Call()
        } else  {
            callSendVarificationCodeAPiCall()
        }
    }
    
    // MARK: -  Get Generic Parameter Method
    func passDictParameterToWS() -> NSMutableDictionary {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtSalution.text!), forKey: "form[salutation]")
        param.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtTitle.text!), forKey: "form[title]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtFirstname.text!), forKey: "form[firstName]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtLastname.text!), forKey: "form[lastName]")
        let userName = self.dictSetUserValue.value(forKey: "username") as! String
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: userName), forKey: "form[username]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtEmail.text!), forKey: "form[email]")
        
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtPracticeName.text!), forKey: "form[practiceName]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtMobileNumber.text!), forKey: "form[phoneNumber]")
        
        let address = self.dictSetUserValue.value(forKey: "address") as! String
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText:address), forKey: "form[address]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText:txtCity.text!), forKey: "form[city]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText:txtCountry.text!), forKey: "form[country]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText:txtWebsite.text!), forKey: "form[website]")
        param.setValue(Global.singleton.emojisEncodedConvertedString(strText:txtFax.text!), forKey: "form[fax]")
        param.setValue(Global.kDeviceTypeWS, forKey: "form[deviceType]")
        param.setValue(Global.appDelegate.strDeviceToken, forKey: "form[deviceToken]")
        return param
    }
    
    // MARK: -  All API call Method
    //Provider Profile Detial Get API Call
    func getProfileDetailResponsParsing() {
        //  Global.kLoggedInUserData().Id
        AFAPIMaster.sharedAPIMaster.getProviderProfileCall_Completion(params:nil, strUserId: Global.kLoggedInUserData().Id! , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictData: NSDictionary = returnData as! NSDictionary
            if let dictResponse: NSDictionary = dictData.object(forKey: "userData") as? NSDictionary {
                
                self.dictSetUserValue = dictResponse
                self.txtSalution.text = dictResponse.value(forKey: "salutation") as? String
                self.txtTitle.text = dictResponse.value(forKey: "title") as? String
                self.txtFirstname.text = dictResponse.value(forKey: "firstName") as? String
                self.txtLastname.text = dictResponse.value(forKey: "lastName") as? String
                self.txtEmail.text = dictResponse.value(forKey: "email") as? String
                self.txtPracticeName.text = dictResponse.value(forKey: "practiceName") as? String
                self.txtStreet.text = dictResponse.value(forKey: "address") as? String
                self.txtNo.text = dictResponse.value(forKey: "address") as? String
                self.txtCity.text = dictResponse.value(forKey: "city") as? String
                self.txtCountry.text = dictResponse.value(forKey: "country") as? String
                self.txtWebsite.text = dictResponse.value(forKey: "website") as? String
                self.txtFax.text = dictResponse.value(forKey: "fax") as? String
                self.txtMobileNumber.text = dictResponse.value(forKey: "phoneNumber") as? String
                Global.singleton.saveToUserDefaults(value: dictData.value(forKeyPath: "userData.profilePictureUrl") as? String ?? "", forKey: Global.kLoggedInUserKey.ProfilePic);
                
                if (Global.kLoggedInUserData().ProfilePic != nil && Global.kLoggedInUserData().ProfilePic != "") {
                    self.btnProfilePic.setImageFor(.normal, with: URL(string: Global.kLoggedInUserData().ProfilePic!)!)
                    self.lblCameraIcon.textColor = UIColor.white
                }
                else {
                    self.lblCameraIcon.textColor = Global().RGB(r: 175.0, g: 175.0, b: 175.0, a: 1.0)
                }
                self.txtUserName.text = dictResponse.value(forKey: "username") as? String
            }
        }
    }
    
    //Provider Profile Varification API call
    func callSendVarificationCodeAPiCall() {
        let dictParaValuePass: NSMutableDictionary = NSMutableDictionary()
        dictParaValuePass.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        AFAPIMaster.sharedAPIMaster.postEditProviderProfileVarificationCall_Completion(params:dictParaValuePass , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            print(dictResponse)
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                let VarificationObj = ProviderVarificationVC(nibName: "ProviderVarificationVC", bundle: nil)
                VarificationObj.dictUserData = self.passDictParameterToWS()
                if (self.btnProfilePic.image(for: .normal) != nil) {
                    VarificationObj.imgUserPic = self.btnProfilePic.image(for: .normal)!
                }
                self.navigationController?.pushViewController(VarificationObj, animated: true)
            }
        }
    }
    
    //Provider Profile Edit data send API call
    func editProviderProfileAPI_Call() {
        //form[profilePic]
        AFAPIMaster.sharedAPIMaster.postEditProviderProfileCall_Completion(params: self.passDictParameterToWS(), userProfileImage: btnProfilePic.image(for: .normal), showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            print(dictResponse)
            if (self.btnProfilePic.image(for: .normal) == nil) {
                self.lblCameraIcon.textColor = Global().RGB(r: 175.0, g: 175.0, b: 175.0, a: 1.0)
            }
            else {
                self.lblCameraIcon.textColor = UIColor.white
            }
            self.btnProfilePic.isUserInteractionEnabled = false
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                self.dictSetUserValue = dictData
              //  Global.appDelegate.isVarifyCode = false
                self.setDisableEnableControl()
            }
        }
    }
}

extension ProviderProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            
            ProfileImage = img!
        }
        
        picker.dismiss(animated: false, completion: {() in
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {() in
        })
    }
}


extension ProviderProfile: UITextFieldDelegate {
    // MARK: -  Textfield Delegate call Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string == "") {
            return true
        }
        else if textField == txtSalution {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtTitle {
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtFirstname || textField == txtLastname || textField == txtPracticeName {
            let maxLength = 25
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if (textField == txtMobileNumber ) {
            if (txtMobileNumber.text?.characters.count == 0) {
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
        if textField == txtSalution {
            textField .resignFirstResponder()
            txtTitle .becomeFirstResponder()
        } else  if textField == txtTitle {
            textField .resignFirstResponder()
            txtFirstname .becomeFirstResponder()
        } else  if textField == txtFirstname{
            textField .resignFirstResponder()
            txtLastname .becomeFirstResponder()
        } else if textField == txtLastname {
            textField .resignFirstResponder()
            txtEmail .becomeFirstResponder()
        } else if textField == txtEmail {
            textField .resignFirstResponder()
            txtPracticeName .becomeFirstResponder()
        }else if textField == txtPracticeName {
            textField .resignFirstResponder()
            txtStreet .becomeFirstResponder()
        }else if textField == txtStreet {
            textField .resignFirstResponder()
            txtNo .becomeFirstResponder()
        }else if textField == txtNo {
            textField .resignFirstResponder()
            txtWebsite .becomeFirstResponder()
        }else if textField == txtWebsite {
            textField .resignFirstResponder()
            txtFax .becomeFirstResponder()
        }else if textField == txtFax {
            textField .resignFirstResponder()
            txtMobileNumber .becomeFirstResponder()
        } else if textField == txtMobileNumber {
            textField .resignFirstResponder()
        }
        return true
    }
}

// MARK: -  Singleton Country DropDown Delegate Methods
extension ProviderProfile : CountryDropDowbDelegate {
    func startLoaderUntilDataFromCountry(strCountryName: String) {
        Global.citySingleton.delegate = self
        Global.citySingleton.addCityDropDownList(inView: InnerView, with: CGRect(x: btnCity.frame.origin.x - 45, y: btnCity.frame.origin.y, width: btnCity.frame.size.width + 90, height: btnCity.frame.size.height))
        txtCountry.text = strCountryName
        txtCity.text = ""
        self.viewSpinner = AFAPICaller().addShowLoaderInView(viewObj: self.view , boolShow: true, enableInteraction: false)!
    }
    
    func stopLoaderWithCityData() {
        Global().delay(delay: 0.5) {
            AFAPICaller().hideRemoveLoaderFromView(removableView: self.viewSpinner, mainView: self.view)
            Global.citySingleton.dropMenuCity.items = Global.appDelegate.arrCityFromCountry
            Global.citySingleton.dropMenuCity.tblView.reloadData()
        }
    }
}

// MARK: -  Singleton City DropDown Delegate Methods
extension ProviderProfile : CityDropDownDelegate {
    func didSelectCity(strCityName: String) {
        txtCity.text = strCityName
        txtCity.textColor = Global.kAppColor.GrayDark
    }
}
