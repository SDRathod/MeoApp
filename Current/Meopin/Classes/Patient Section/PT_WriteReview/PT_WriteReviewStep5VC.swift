//
//  PT_WriteReviewStep5VC.swift
//  Meopin
//
//  Created by Tops on 11/10/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import SDWebImage

class PT_WriteReviewStep5VC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var scrollObj: UIScrollView!
    @IBOutlet var viewProviderDetail: UIView!
    @IBOutlet var viewProfilePicBG: UIView!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblFullName: UILabel!
    @IBOutlet var lblSpeciality: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var btnFavorite: UIButton!
    
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var btnGenderMan: UIButton!
    @IBOutlet var btnGenderWoman: UIButton!
    
    @IBOutlet var lblMyAge: UILabel!
    @IBOutlet var btnMyAge1: UIButton!
    @IBOutlet var btnMyAge2: UIButton!
    @IBOutlet var btnMyAge3: UIButton!
    @IBOutlet var btnMyAge4: UIButton!
    
    @IBOutlet var lblAnonymously: UILabel!
    @IBOutlet var btnAnonymously1: UIButton!
    @IBOutlet var btnAnonymously2: UIButton!
    @IBOutlet var btnAnonymously3: UIButton!
    @IBOutlet var btnAnonymously4: UIButton!
    @IBOutlet var lblAnonymously1: MDHTMLLabel!
    @IBOutlet var lblAnonymously2: MDHTMLLabel!
    @IBOutlet var lblAnonymously3: MDHTMLLabel!
    @IBOutlet var lblAnonymously4: MDHTMLLabel!
    @IBOutlet var btnAnonymouslyChangeIt: UIButton!
    
    @IBOutlet var lblSubmitReview: UILabel!
    @IBOutlet var lblHereByDeclare: UILabel!
    @IBOutlet var btnHereByDeclare1: UIButton!
    @IBOutlet var btnHereByDeclare2: UIButton!
    @IBOutlet var btnHereByDeclare3: UIButton!
    @IBOutlet var btnHereByDeclare4: UIButton!
    @IBOutlet var lblHereByDeclare1: MDHTMLLabel!
    @IBOutlet var lblHereByDeclare2: MDHTMLLabel!
    @IBOutlet var lblHereByDeclare3: MDHTMLLabel!
    @IBOutlet var lblHereByDeclare4: MDHTMLLabel!
    
    @IBOutlet var btnSubmitReview: UIButton!
    
    var strSelProviderId: String!
    var dictSelProviderData: NSDictionary!
    var isNavFavScreen : Bool = false
    
    var shareObjReview: ReviewSObject!

    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewProfilePicBG.layer.masksToBounds = true
        viewProfilePicBG.layer.cornerRadius = 4
        viewProfilePicBG.layer.borderWidth = 1
        viewProfilePicBG.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        
        lblRating.layer.masksToBounds = true
        
        lblHereByDeclare3.delegate = self
        lblHereByDeclare4.delegate = self
        
        lblHereByDeclare3.linkAttributes = [NSForegroundColorAttributeName: Global.kAppColor.BlueLight]
        lblHereByDeclare4.linkAttributes = [NSForegroundColorAttributeName: Global.kAppColor.BlueLight]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        self.displayProviderDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Global().delay(delay: 0.1) {
            self.scrollObj.contentSize = CGSize(width: Global.screenWidth, height: self.btnSubmitReview.y + self.btnSubmitReview.height)
        }
        lblRating.layer.cornerRadius = lblRating.frame.size.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyHomeWriteReview")
        lblGender.text = Global().getLocalizeStr(key: "keyRVW5Gender")
        btnGenderMan.setTitle(Global().getLocalizeStr(key: "keyRVW5GenderMan"), for: .normal)
        btnGenderWoman.setTitle(Global().getLocalizeStr(key: "keyRVW5GenderWoman"), for: .normal)
        
        lblMyAge.text = Global().getLocalizeStr(key: "keyRVW5Age")
        btnMyAge1.setTitle(Global().getLocalizeStr(key: "keyRVW5Age1"), for: .normal)
        btnMyAge2.setTitle(Global().getLocalizeStr(key: "keyRVW5Age2"), for: .normal)
        btnMyAge3.setTitle(Global().getLocalizeStr(key: "keyRVW5Age3"), for: .normal)
        btnMyAge4.setTitle(Global().getLocalizeStr(key: "keyRVW5Age4"), for: .normal)
        
        lblAnonymously.text = Global().getLocalizeStr(key: "keyRVW5PublishAnonymously")
        lblAnonymously1.htmlText = Global().getLocalizeStr(key: "keyRVW5AnonymouslyYes")
        lblAnonymously2.htmlText = String(format: "%@ (%@)", Global().getLocalizeStr(key: "keyRVW5AnonymouslyNo"), Global.kLoggedInUserData().UserName!)
        lblAnonymously3.htmlText = Global().getLocalizeStr(key: "keyRVW5AnonymouslyRecommend")
        lblAnonymously4.htmlText = Global().getLocalizeStr(key: "keyRVW5IAgree")
        btnAnonymouslyChangeIt.setTitle(Global().getLocalizeStr(key: "keyRVW5AnonymouslyChangeIt"), for: .normal)
        
        lblSubmitReview.text = Global().getLocalizeStr(key: "keyRVW5SubmitReview")
        lblHereByDeclare.text = Global().getLocalizeStr(key: "keyRVW5HerebyDeclare")
        lblHereByDeclare1.htmlText = Global().getLocalizeStr(key: "keyRVW5HerebyDeclare1")
        lblHereByDeclare2.htmlText = Global().getLocalizeStr(key: "keyRVW5HerebyDeclare2")
        
        lblHereByDeclare3.htmlText = String(format: "%@<a href='%@'>%@</a>", Global().getLocalizeStr(key: "keyRVW5HerebyDeclare3_1"), Global.kWebPageURL.TermsConditions, Global().getLocalizeStr(key: "keyRVW5HerebyDeclare3_2"))
        
        lblHereByDeclare4.htmlText = String(format: "%@<a href='%@'>%@</a>%@<a href='%@'>%@</a>%@", Global().getLocalizeStr(key: "keyRVW5HerebyDeclare4_1"), Global.kWebPageURL.DataProtection, Global().getLocalizeStr(key: "keyRVW5HerebyDeclare4_2"), Global().getLocalizeStr(key: "keyRVW5HerebyDeclare4_3"), Global.kWebPageURL.PrivacyPolicy, Global().getLocalizeStr(key: "keyRVW5HerebyDeclare4_4"), Global().getLocalizeStr(key: "keyRVW5HerebyDeclare4_5"))
        
        btnSubmitReview.setTitle(Global().getLocalizeStr(key: "keyRVW5SubmitButton"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblRating.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblFullName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        lblSpeciality.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10.25))
        lblAddress.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9.75))
        lblDistance.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9.25))
        btnFavorite.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(18))
        
        lblGender.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnGenderMan.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnGenderWoman.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        lblMyAge.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnMyAge1.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnMyAge2.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnMyAge3.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnMyAge4.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        lblAnonymously.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))
        lblAnonymously1.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        lblAnonymously2.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        lblAnonymously3.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        lblAnonymously4.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        btnAnonymouslyChangeIt.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        lblSubmitReview.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(19))
        lblHereByDeclare.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11.7))
        lblHereByDeclare1.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        lblHereByDeclare2.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        lblHereByDeclare3.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        lblHereByDeclare4.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.9))
        
        btnSubmitReview.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_WriteReviewStep5VC {
    // MARK: -  API Call
    func submitReviewCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id, forKey: "form[userId]")
        param.setValue(strSelProviderId, forKey: "form[providerId]")
        param.setValue(shareObjReview.strReviewTitle, forKey: "form[title]")
        param.setValue(shareObjReview.strReviewFeedback, forKey: "form[feedback]")
        param.setValue(shareObjReview.strReviewVisitDate, forKey: "form[visitedAt]")
        
        for i in 0 ..< shareObjReview.arrReviewGroupList.count {
            let shareObjGroup = shareObjReview.arrReviewGroupList[i]
            
            param.setValue(shareObjGroup.strRWGroupId, forKey: "form[group][\(i)][id]")
            param.setValue(shareObjGroup.strRWGroupLikeText, forKey: "form[group][\(i)][note]")
            
            for j in 0 ..< shareObjGroup.arrRWGroupQueList.count {
                let shareObjQue = shareObjGroup.arrRWGroupQueList[j]
                
                param.setValue(shareObjQue.strRWQueId, forKey: "form[group][\(i)][question_list][\(j)][id]")
                param.setValue("\(shareObjQue.intRWQueRating)", forKey: "form[group][\(i)][question_list][\(j)][grade]")
            }
        }
        param.setValue(btnGenderMan.tag == 1 ? "m" : "f", forKey: "form[gender]")
        if (btnMyAge1.tag == 1) {
            param.setValue("< 25", forKey: "form[age]")
        }
        else if (btnMyAge2.tag == 1) {
            param.setValue("26 - 40", forKey: "form[age]")
        }
        else if (btnMyAge3.tag == 1) {
            param.setValue("41 - 55", forKey: "form[age]")
        }
        else if (btnMyAge4.tag == 1) {
            param.setValue("> 55", forKey: "form[age]")
        }
        param.setValue(btnAnonymously1.tag == 1 ? "1" : "0", forKey: "form[anonymous]")
        param.setValue(btnAnonymously3.tag == 1 ? "1" : "0", forKey: "form[recommend]")
        param.setValue(btnAnonymously4.tag == 1 ? "1" : "0", forKey: "form[contact]")
        
        AFAPIMaster.sharedAPIMaster.submitReviewDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                print(dictData)
                if let arrGrade: NSArray = dictData.object(forKey: "grade") as? NSArray {
                    for i in 0 ..< arrGrade.count {
                        let dictGrade: NSDictionary = arrGrade.object(at: i) as! NSDictionary
                        
                        if (self.shareObjReview.arrReviewGroupList.count > i) {
                            let shareObjGroup = self.shareObjReview.arrReviewGroupList[i]
                            
                            if (shareObjGroup.strRWGroupId == "\(dictGrade.object(forKey: "id") as? NSNumber ?? 0)") {
                                shareObjGroup.strRwGroupRating = dictGrade.object(forKey: "grade") as? String ?? ""
                            }
                        }
                    }
                }
                self.shareObjReview.strReviewId = dictData.object(forKey: "id") as? String ?? ""
                self.shareObjReview.strReviewGlobalRating = dictData.object(forKey: "myScore") as? String ?? ""
                
                let pt_writeReviewStep6Obj = PT_WriteReviewStep6VC(nibName: "PT_WriteReviewStep6VC", bundle: nil)
                pt_writeReviewStep6Obj.strSelProviderId = self.strSelProviderId
                pt_writeReviewStep6Obj.dictSelProviderData = self.dictSelProviderData
                pt_writeReviewStep6Obj.isNavFavScreen = self.isNavFavScreen
                pt_writeReviewStep6Obj.shareObjReview = self.shareObjReview
                self.navigationController?.pushViewController(pt_writeReviewStep6Obj, animated: true)
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitReviewClick(_ sender: Any) {
        self.view.endEditing(true)
        
        if (btnGenderMan.tag == 0 && btnGenderWoman.tag == 0) {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVW5GenderMsg1"))
            return
        }
        
        if (btnMyAge1.tag == 0 && btnMyAge2.tag == 0 && btnMyAge3.tag == 0 && btnMyAge4.tag == 0) {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVW5AgeMsg1"))
            return
        }
        
        if (btnAnonymously1.tag == 0 && btnAnonymously2.tag == 0) {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVW5AnonymouslyMsg1"))
            return
        }
        
        if (btnHereByDeclare1.tag == 0 || btnHereByDeclare2.tag == 0 || btnHereByDeclare3.tag == 0 || btnHereByDeclare4.tag == 0) {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVW5HereByDeclareMsg1"))
            return
        }
        self.submitReviewCall()
    }
    
    @IBAction func btnGenderManClick(_ sender: Any) {
        if (btnGenderMan.tag == 0) {
            btnGenderMan.tag = 1
            btnGenderMan.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnGenderWoman.tag = 0
            btnGenderWoman.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnGenderWomanClick(_ sender: Any) {
        if (btnGenderWoman.tag == 0) {
            btnGenderWoman.tag = 1
            btnGenderWoman.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnGenderMan.tag = 0
            btnGenderMan.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnMyAge1Click(_ sender: Any) {
        if (btnMyAge1.tag == 0) {
            btnMyAge1.tag = 1
            btnMyAge1.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnMyAge2.tag = 0
            btnMyAge2.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge3.tag = 0
            btnMyAge3.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge4.tag = 0
            btnMyAge4.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnMyAge2Click(_ sender: Any) {
        if (btnMyAge2.tag == 0) {
            btnMyAge2.tag = 1
            btnMyAge2.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnMyAge1.tag = 0
            btnMyAge1.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge3.tag = 0
            btnMyAge3.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge4.tag = 0
            btnMyAge4.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnMyAge3Click(_ sender: Any) {
        if (btnMyAge3.tag == 0) {
            btnMyAge3.tag = 1
            btnMyAge3.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnMyAge1.tag = 0
            btnMyAge1.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge2.tag = 0
            btnMyAge2.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge4.tag = 0
            btnMyAge4.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnMyAge4Click(_ sender: Any) {
        if (btnMyAge4.tag == 0) {
            btnMyAge4.tag = 1
            btnMyAge4.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnMyAge1.tag = 0
            btnMyAge1.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge2.tag = 0
            btnMyAge2.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
            btnMyAge3.tag = 0
            btnMyAge3.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnAnonymously1Click(_ sender: Any) {
        if (btnAnonymously1.tag == 0) {
            btnAnonymously1.tag = 1
            btnAnonymously1.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnAnonymously2.tag = 0
            btnAnonymously2.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnAnonymously2Click(_ sender: Any) {
        if (btnAnonymously2.tag == 0) {
            btnAnonymously2.tag = 1
            btnAnonymously2.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
            
            btnAnonymously1.tag = 0
            btnAnonymously1.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnAnonymously3Click(_ sender: Any) {
        if (btnAnonymously3.tag == 0) {
            btnAnonymously3.tag = 1
            btnAnonymously3.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
        }
        else {
            btnAnonymously3.tag = 0
            btnAnonymously3.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnAnonymously4Click(_ sender: Any) {
        if (btnAnonymously4.tag == 0) {
            btnAnonymously4.tag = 1
            btnAnonymously4.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
        }
        else {
            btnAnonymously4.tag = 0
            btnAnonymously4.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnAnonymouslyChangeItClick(_ sender: Any) {
    }
    
    @IBAction func btnHereByDeclare1Click(_ sender: Any) {
        if (btnHereByDeclare1.tag == 0) {
            btnHereByDeclare1.tag = 1
            btnHereByDeclare1.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
        }
        else {
            btnHereByDeclare1.tag = 0
            btnHereByDeclare1.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnHereByDeclare2Click(_ sender: Any) {
        if (btnHereByDeclare2.tag == 0) {
            btnHereByDeclare2.tag = 1
            btnHereByDeclare2.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
        }
        else {
            btnHereByDeclare2.tag = 0
            btnHereByDeclare2.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnHereByDeclare3Click(_ sender: Any) {
        if (btnHereByDeclare3.tag == 0) {
            btnHereByDeclare3.tag = 1
            btnHereByDeclare3.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
        }
        else {
            btnHereByDeclare3.tag = 0
            btnHereByDeclare3.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
    
    @IBAction func btnHereByDeclare4Click(_ sender: Any) {
        if (btnHereByDeclare4.tag == 0) {
            btnHereByDeclare4.tag = 1
            btnHereByDeclare4.setImage(#imageLiteral(resourceName: "imgCheckmarkSel"), for: .normal)
        }
        else {
            btnHereByDeclare4.tag = 0
            btnHereByDeclare4.setImage(#imageLiteral(resourceName: "imgCheckmark"), for: .normal)
        }
    }
}

//MARK: -
extension PT_WriteReviewStep5VC : MDHTMLLabelDelegate {
    // MARK: -  MDHTMLLabel Delegate Methods
    func htmlLabel(_ label: MDHTMLLabel!, didSelectLinkWith URL: URL!) {
        UIApplication.shared.openURL(URL)
    }
}

//MARK: -
extension PT_WriteReviewStep5VC {
    // MARK: -  Display Provider Detail
    func displayProviderDetail() {
        if Global.appDelegate.isLocationOn == true {
            let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            if isNavFavScreen == true {
                let myLocation:CLLocation = CLLocation(latitude: Double(dictSelProviderData.object(forKey: "lat") as? String ?? "0")!, longitude: Double(dictSelProviderData.object(forKey: "lon") as? String ?? "0")!)
                let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                if strDistance != "" || strDistance != "0.0" {
                    lblDistance.text = ("\(strDistance) km")
                } else {
                    lblDistance.text = ("")
                }
            } else  {
                let myLocation:CLLocation = CLLocation(latitude: Double(dictSelProviderData.object(forKey: "lat") as? String ?? "0")!, longitude: Double(dictSelProviderData.object(forKey: "lng") as? String ?? "0")!)
                let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                if strDistance != "" || strDistance != "0.0" {
                    lblDistance.text = ("\(strDistance) km")
                } else {
                    lblDistance.text = ("")
                }
            }
        }
        else {
            lblDistance.text = ("")
        }
        
        if isNavFavScreen == true {
            lblSpeciality.text = (dictSelProviderData.object(forKey: "specialties") as? NSArray ?? NSArray()).componentsJoined(by: " | ")
            let strRating = dictSelProviderData.object(forKey: "rating") as?
                String ?? "0.0"
            if strRating == "" || strRating == "0.0" || strRating == "0" || strRating.isEmpty {
                lblRating.text = "0.0"
            } else {
                lblRating.text = dictSelProviderData.object(forKey: "rating") as? String ?? "0.0"
            }
            
            if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                if ((dictSelProviderData.object(forKey: "isFavorited") as? String ?? "") == "1") {
                    btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
                }
            }
            else {
                btnFavorite.isHidden = true
            }
            
            let isFavStatus = dictSelProviderData.object(forKey: "isFavorited") as? String ?? ""
            if isFavStatus == "" || isFavStatus.isEmpty || isFavStatus == "0" {
                btnFavorite.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            } else  {
                btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
            }
        }
        else  {
            lblSpeciality.text = (dictSelProviderData.object(forKey: "specialty") as? NSArray ?? NSArray()).componentsJoined(by: " | ")
            
            let strRating = dictSelProviderData.object(forKey: "hospitalRating") as?
                String ?? "0.0"
            if strRating == "" || strRating == "0.0" || strRating == "0" || strRating.isEmpty {
                lblRating.text = "0.0"
            } else {
                lblRating.text = dictSelProviderData.object(forKey: "hospitalRating") as? String ?? "0.0"
            }
            if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                if ((dictSelProviderData.object(forKey: "isFavorite") as? String ?? "") == "1") {
                    btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
                }
            }
            else {
                btnFavorite.isHidden = true
            }
            let isFavStatus = dictSelProviderData.object(forKey: "isFavorite") as? String ?? ""
            if isFavStatus == "" || isFavStatus.isEmpty || isFavStatus == "0" {
                btnFavorite.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            } else  {
                btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
            }
        }
        
        self.lblAddress.text = dictSelProviderData.value(forKey: "address") as? String ?? ""
        
        let strSalutation = dictSelProviderData.value(forKey: "salutation") as? String ?? ""
        var strFullName = String()
        if (strSalutation.characters.count > 0) {
            strFullName = "\(strSalutation) "
        }
        
        let strFirstname = dictSelProviderData.value(forKey: "firstName") as? String ?? ""
        if (strFirstname.characters.count > 0) {
            strFullName = "\(strFullName)\(strFirstname) "
        }
        let strLastname = dictSelProviderData.value(forKey: "lastName") as? String ?? ""
        if (strLastname.characters.count > 0) {
            strFullName = "\(strFullName) \(strLastname)"
        }
        
        if strFullName == "" || strFullName.isEmpty {
            self.lblFullName.text  = dictSelProviderData.value(forKey: "hospitalName") as? String ?? ""
        }
        else {
            self.lblFullName.text = strFullName
        }
        
        if let strHospitalImgUrl = dictSelProviderData.value(forKey: "profilePictureUrl") as? String {
            if strHospitalImgUrl == "" || strHospitalImgUrl.isEmpty {
                self.imgProfilePic.image = UIImage(named: "ProfileView")
            }
            else {
                self.imgProfilePic.sd_setImage(with: URL(string:strHospitalImgUrl)!, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                    if (image != nil) {
                        self.imgProfilePic.image = image!
                    }
                    else  {
                        self.imgProfilePic.image = UIImage(named: "ProfileView")
                    }
                })
            }
        } else  {
            let strProfileImage = dictSelProviderData.value(forKey: "hospitalImg") as? String ?? ""
            if strProfileImage == "" || strProfileImage.isEmpty {
                self.imgProfilePic.image = UIImage(named: "ProfileView")
            } else {
                self.imgProfilePic.sd_setImage(with: URL(string: strProfileImage)!, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                    if (image != nil) {
                        self.imgProfilePic.image = image!
                    }
                    else  {
                        self.imgProfilePic.image = UIImage(named: "ProfileView")
                    }
                })
            }
        }
    }
    
    func distanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> String {
        let  distanceInMeters = source.distance(from: destination)
        let distanceInMiles = distanceInMeters/1000
        return String(format:"%.2f",distanceInMiles)
    }
}
