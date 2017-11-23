//
//  HomeVC.swift
//  Meopin
//
//  Created by Tops on 8/29/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet var lblVersion: UILabel!
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var lblUserLogin: UILabel!
    @IBOutlet var btnUserLogin: UIButton!
    @IBOutlet var btnUserProfile: UIButton!
    @IBOutlet var lblWelcome: UILabel!
    @IBOutlet var lblMeopin: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var tblOptions: UITableView!
    @IBOutlet var lblOfferedIn: UILabel!
    
    var mySlideViewObj: MySlideViewController?
    
    var arrOption: [HomeSObject] = [HomeSObject]()

    var indexPathSelected: IndexPath?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblOptions.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        
        btnUserLogin.layer.masksToBounds = true
        btnUserLogin.layer.cornerRadius = 7
        btnUserLogin.layer.borderWidth = 1.5;
        btnUserLogin.layer.borderColor = UIColor.white.cgColor
        
        btnUserProfile.layer.masksToBounds = true
        btnUserProfile.layer.borderWidth = 0.5;
        btnUserProfile.layer.borderColor = btnUserProfile.backgroundColor?.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        lblVersion.text = "Version: " + (Bundle.main.infoDictionary?["CFBundleVersion"] as! String)

       // lblVersion.text = "Version: " + (Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
        self.tblOptions.reloadData()

        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            btnSlideMenu.isHidden = false
            btnUserLogin.isHidden = true
            lblUserLogin.isHidden = true
            btnUserProfile.isHidden = false
            
            btnUserProfile.sd_setImage(with: URL.init(string: Global.kLoggedInUserData().ProfilePic!), for: .normal, placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        else {
            btnSlideMenu.isHidden = true
            btnUserLogin.isHidden = false
            lblUserLogin.isHidden = false
            btnUserProfile.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Global.singleton.delegate = self
        Global.singleton.addLanguageScrollView(inView: self.view, with: CGRect(x: 0, y: Global.screenHeight - Global.singleton.getDeviceSpecificFontSize(45), width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(30)), textColor: Global.kAppColor.BlueLight, selTextColor: .white)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        btnUserProfile.layer.cornerRadius = btnUserProfile.frame.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblWelcome.text = Global().getLocalizeStr(key: "keyHomeWelcomeMsg")
        lblSubTitle.text = Global().getLocalizeStr(key: "keyHomeSubTitle")
        
        lblUserLogin.attributedText = Global.singleton.setButtonStringMeopinFontBaseLine(Global().getLocalizeStr(key: "keyHomeLogin"), floatIconFontSize: 14, floatTextFontSize: 9, floatBase: 3, intIconPos: 1)
        lblUserLogin.sizeToFit()
        
        lblOfferedIn.text = Global().getLocalizeStr(key: "keyHomeOfferedIn")
        
        self.fillOptionArray()
    }
    
    func setDeviceSpecificFonts() {
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblUserLogin.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(13))
        lblWelcome.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblMeopin.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(36))
        lblSubTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblOfferedIn.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    // MARK: -  Fill Option Array
    func fillOptionArray() {
        arrOption.removeAll()
        
        let shareObj1 = HomeSObject()
        shareObj1.strHomeIcon = ""
        shareObj1.strHomeTitle = Global().getLocalizeStr(key: "keyHomeSearch")
        shareObj1.strHomeSubTitle = Global().getLocalizeStr(key: "keyHomeSearchSub")
        arrOption.append(shareObj1)
        
        let shareObj2 = HomeSObject()
        shareObj2.strHomeIcon = ""
        shareObj2.strHomeTitle = Global().getLocalizeStr(key: "keyHomeWriteReview")
        shareObj2.strHomeSubTitle = Global().getLocalizeStr(key: "keyHomeWriteReviewSub")
        arrOption.append(shareObj2)
        
        let shareObj3 = HomeSObject()
        shareObj3.strHomeIcon = ""
        shareObj3.strHomeTitle = Global().getLocalizeStr(key: "keyHomeMakeApp")
        shareObj3.strHomeSubTitle = Global().getLocalizeStr(key: "keyHomeMakeAppSub")
        arrOption.append(shareObj3)
        
        let shareObj4 = HomeSObject()
        shareObj4.strHomeIcon = ""
        shareObj4.strHomeTitle = Global().getLocalizeStr(key: "keyHomeReadArticle")
        shareObj4.strHomeSubTitle = Global().getLocalizeStr(key: "keyHomeReadArticleSub")
        arrOption.append(shareObj4)
        
        tblOptions.reloadData()
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        Global.singleton.delegate = nil
        Global.singleton.removeLanguageScrollView()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

// MARK: -
extension HomeVC {
    // MARK: -  API Call
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnUserLoginClick(_ sender: Any) {
        let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
        loginObj.boolUserIsPatient = true
        self.navigationController?.pushViewController(loginObj, animated: true)
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    @IBAction func btnUserProfileClick(_ sender: Any) {
        if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
            let patientViewProfileObj = PatientViewProfileVC(nibName: "PatientViewProfileVC", bundle: nil)
            patientViewProfileObj.boolIsFromSlideMenu = false
            self.navigationController?.pushViewController(patientViewProfileObj, animated: true)
        }
        else {
            let providerProfileObj = ProviderViewProfileVC(nibName: "ProviderViewProfileVC", bundle: nil)
            providerProfileObj.boolIsFromSlideMenu = false
            self.navigationController?.pushViewController(providerProfileObj, animated: true)
        }
    }
}

// MARK: -

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOption.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblOptions.frame.size.height / 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.setLanguageTitles()
        
        let shareObj = arrOption[indexPath.row]
        cell.lblIconOpt.text = shareObj.strHomeIcon
        cell.lblTitleOpt.text = shareObj.strHomeTitle
        cell.lblSubTitleOpt.text = shareObj.strHomeSubTitle
    
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPathSelected != nil) {
            let cell: HomeCell = tblOptions.cellForRow(at: indexPathSelected!) as! HomeCell
            cell.contentView.backgroundColor = Global.kAppColor.BlueDark
            cell.lblSubTitleOpt.textColor = Global.kAppColor.BlueLight
        }
        
        if (Global.kLoggedInUserData().Role == Global.kUserRole.Provider) {
            if ( indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
                ) {
                return
            }
        }
        
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            let loginObj = SearchProviderVC(nibName: "SearchProviderVC", bundle: nil)
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
        else {
            let blogVCObj = PR_BlogsVC(nibName: "PR_BlogsVC", bundle: nil)
            blogVCObj.isNavFromSlideMenu = false
            self.navigationController?.pushViewController(blogVCObj, animated: true)
        }
        
        
//        let cell: HomeCell = tblOptions.cellForRow(at: indexPath) as! HomeCell
//        cell.contentView.backgroundColor = Global.kAppColor.GreenDark
//        cell.lblSubTitleOpt.textColor = Global.kAppColor.GreenLight
//        indexPathSelected = indexPath
//        tblOptions.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: HomeCell = tblOptions.cellForRow(at: indexPath) as! HomeCell
        cell.contentView.backgroundColor = Global.kAppColor.BlueDark
        cell.lblSubTitleOpt.textColor = Global.kAppColor.BlueLight
    }
}

// MARK: -
extension HomeVC: SingletonDelegate {
    // MARK: -  Singleton Delegate Methods
    func didSelectLanguage() {
        self.setLanguageTitles()
    }
}
