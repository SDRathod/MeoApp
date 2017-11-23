
//
//  PatientViewProfileVC.swift
//  Meopin
//
//  Created by Tops on 11/6/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PatientViewProfileVC: UIViewController {
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnProfilePic: UIButton!
    @IBOutlet var lblUserFullName: UILabel!
    @IBOutlet var lblUserNamePhone: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var btnEditDetails: UIButton!
    @IBOutlet var btnChangePwd: UIButton!
    
    var dictUserData: NSDictionary = NSDictionary()
    
    var boolIsFromSlideMenu: Bool = true
    
    var mySlideViewObj: MySlideViewController?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnProfilePic.layer.masksToBounds = true
        self.btnProfilePic.layer.cornerRadius = Global.singleton.getDeviceSpecificFontSize(307) / 2
        self.btnProfilePic.layer.borderColor = Global().RGB(r: 185, g: 185, b: 185, a: 1).cgColor
        self.btnProfilePic.layer.borderWidth = 1
        
        self.displayUserDataFromNSDefault()
        self.getPatientProfileCall()
        
        btnProfilePic.imageView?.contentMode = .scaleAspectFill
        btnProfilePic.contentHorizontalAlignment = .fill;
        btnProfilePic.contentVerticalAlignment = .fill;
        btnProfilePic.layer.borderWidth = 0.7
        btnProfilePic.layer.borderColor = Global.kAppColor.LightGray.cgColor

        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        
        if (boolIsFromSlideMenu) {
            btnSlideMenu.isHidden = false
            btnBack.isHidden = true
        }
        else {
            btnSlideMenu.isHidden = true
            btnBack.isHidden = false
        }
        self.displayUserDataFromNSDefault()
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
        
        btnEditDetails.setTitle(Global().getLocalizeStr(key: "keyPaPEditDetails"), for: .normal)
        btnChangePwd.setTitle(Global().getLocalizeStr(key: "keyPaPChangePassword"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblUserFullName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(23.5))
        lblUserNamePhone.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        lblEmail.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        btnEditDetails.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnChangePwd.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PatientViewProfileVC {
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
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditDetailsClick(_ sender: Any) {
        let patientEditProfileObj = PatientEditProfileVC(nibName: "PatientEditProfileVC", bundle: nil)
        patientEditProfileObj.dictUserData = NSMutableDictionary(dictionary: self.dictUserData)
        self.navigationController?.pushViewController(patientEditProfileObj, animated: true)
    }
    
    @IBAction func btnChangePwdClick(_ sender: Any) {
        let changePasswordObj = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
        changePasswordObj.dictUserData = NSMutableDictionary(dictionary: self.dictUserData)
        changePasswordObj.isNavigateFormEdit = true
        self.navigationController?.pushViewController(changePasswordObj, animated: true)
    }
}

// MARK: -
extension PatientViewProfileVC {
    func displayUserDataFromNSDefault() {
        var strFullName: String = ""
        if (Global.kLoggedInUserData().Salutation!.characters.count > 0) {
            strFullName = "\(Global.kLoggedInUserData().Salutation!) "
        }
        if (Global.kLoggedInUserData().FirstName!.characters.count > 0) {
            strFullName = "\(strFullName)\(Global.kLoggedInUserData().FirstName!) "
        }
        strFullName = "\(strFullName)\(Global.kLoggedInUserData().LastName!)"
        lblUserFullName.text = strFullName
        
        var strUserNamePhone: String = ""
        if (Global.kLoggedInUserData().UserName!.characters.count > 0) {
            strUserNamePhone  = "\(Global.kLoggedInUserData().UserName!)"
        }
        if (strUserNamePhone.characters.count > 0 && Global.kLoggedInUserData().PhoneNumber!.characters.count > 0) {
            strUserNamePhone  = "\(strUserNamePhone)     |     \(Global.kLoggedInUserData().PhoneNumber!)"
        }
        lblUserNamePhone.text = strUserNamePhone
        lblEmail.text = Global.kLoggedInUserData().Email
        
        if (Global.kLoggedInUserData().ProfilePic != nil && Global.kLoggedInUserData().ProfilePic != "") {
            btnProfilePic.sd_setImage(with: URL(string: Global.kLoggedInUserData().ProfilePic!)!, for: .normal, placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        else {
            btnProfilePic.setImage(#imageLiteral(resourceName: "ProfileView"), for: .normal)
        }
    }
}
