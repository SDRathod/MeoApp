//
//  PT_WriteReviewStep1VC.swift
//  Meopin
//
//  Created by Tops on 11/7/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage

class PT_WriteReviewStep1VC: UIViewController {
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

    @IBOutlet var lblTipsTitle: UILabel!
    @IBOutlet var lblTipsSubTitle: UILabel!
    @IBOutlet var lblTipsPoints: UILabel!
    
    @IBOutlet var txtReviewTitle: UITextField!
    @IBOutlet var txtMyFeedback: UITextView!
    @IBOutlet var txtVisitDate: UITextField!
    @IBOutlet var btnVisitDate: UIButton!
    
    @IBOutlet var btnProceed: UIButton!
    
    @IBOutlet var viewDateSelection: UIView!
    @IBOutlet var datePickerVisit: UIDatePicker!
    @IBOutlet var btnCancelPicker: UIButton!
    @IBOutlet var btnDonePicker: UIButton!
    
    var strSelProviderId: String!
    var dictSelProviderData: NSDictionary!
    var isNavFavScreen : Bool = false
    
    var strSelVisitDate: String!
    
    var shareObjReview: ReviewSObject = ReviewSObject()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewProfilePicBG.layer.masksToBounds = true
        viewProfilePicBG.layer.cornerRadius = 4
        viewProfilePicBG.layer.borderWidth = 1
        viewProfilePicBG.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        
        lblRating.layer.masksToBounds = true
        
        txtReviewTitle.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtReviewTitle.leftViewMode = .always
        txtVisitDate.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        txtVisitDate.leftViewMode = .always
        
        txtReviewTitle.layer.masksToBounds = true
        txtReviewTitle.layer.cornerRadius = 2.0
        txtReviewTitle.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtReviewTitle.layer.borderWidth = 0.4
        
        txtMyFeedback.layer.masksToBounds = true
        txtMyFeedback.layer.cornerRadius = 2.0
        txtMyFeedback.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtMyFeedback.layer.borderWidth = 0.4
        
        txtVisitDate.layer.masksToBounds = true
        txtVisitDate.layer.cornerRadius = 2.0
        txtVisitDate.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtVisitDate.layer.borderWidth = 0.4
        
        txtMyFeedback.textContainerInset = UIEdgeInsetsMake(8, 12, 8, 12)
        
        txtReviewTitle.text = ""
        txtVisitDate.text = Global.singleton.convertDateToStringWithDaySmallName(dateSel: Date())
        strSelVisitDate = Global.singleton.convertDateToString(dateSel: Date())
        
        txtMyFeedback.text = Global().getLocalizeStr(key: "keyRVWMyFeedback")
        txtMyFeedback.textColor = Global().RGB(r: 200, g: 200, b: 200, a: 1)
        
        datePickerVisit.maximumDate = Date()
        
        self.getReviewQuestionsListCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.setLanguageTitles()
        self.displayProviderDetail()
        
        viewDateSelection.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Global().delay(delay: 0.1) { 
            self.scrollObj.contentSize = CGSize(width: Global.screenWidth, height: self.btnProceed.y + self.btnProceed.height)
        }
        
        lblRating.layer.cornerRadius = lblRating.frame.size.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyHomeWriteReview")
        
        lblTipsTitle.text = Global().getLocalizeStr(key: "keyRVWTipsForYou")
        lblTipsSubTitle.text = Global().getLocalizeStr(key: "keyRVWTipsSubTitle")
        lblTipsPoints.text = Global().getLocalizeStr(key: "keyRVWTipsPoints")
        txtReviewTitle.placeholder = Global().getLocalizeStr(key: "keyRVWReviewTitle")
        txtMyFeedback.placeholderText = Global().getLocalizeStr(key: "keyRVWMyFeedback")
        txtVisitDate.placeholder = Global().getLocalizeStr(key: "keyRVWVisitDate")
        btnProceed.setTitle(Global().getLocalizeStr(key: "keyRVWPrceedSteps"), for: .normal)
        
        if (txtMyFeedback.textColor == Global().RGB(r: 200, g: 200, b: 200, a: 1)) {
            txtMyFeedback.text = Global().getLocalizeStr(key: "keyRVWMyFeedback")
        }
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
        
        lblTipsTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(19))
        lblTipsSubTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11.7))
        lblTipsPoints.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))
        
        txtReviewTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtMyFeedback.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        txtVisitDate.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        
        btnProceed.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_WriteReviewStep1VC {
    // MARK: -  API Call
    func getReviewQuestionsListCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(strSelProviderId, forKey: "form[providerId]")
        
        shareObjReview.arrReviewGroupList.removeAll()
        AFAPIMaster.sharedAPIMaster.getReviewQuestionsListDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if let arrData: NSArray = dictData.object(forKey: "data") as? NSArray {
                    for i in 0 ..< arrData.count {
                        if let dictGroup: NSDictionary = arrData.object(at: i) as? NSDictionary {
                            let shareObjGroup: ReviewGroupSObject = ReviewGroupSObject()
                            
                            shareObjGroup.strRWGroupId = "\(dictGroup.object(forKey: "id") as? NSNumber ?? 0)"
                            shareObjGroup.strRWGroupTitle = dictGroup.object(forKey: "name") as? String ?? ""
                            if let arrQueData: NSArray = dictGroup.object(forKey: "question_list") as? NSArray {
                                for j in 0 ..< arrQueData.count {
                                    if let dictQue: NSDictionary = arrQueData.object(at: j) as? NSDictionary {
                                        let shareObjQue: ReviewQueSObject = ReviewQueSObject()
                                        
                                        shareObjQue.strRWQueId = "\(dictQue.object(forKey: "id") as? NSNumber ?? 0)"
                                        shareObjQue.strRWQueText = dictQue.object(forKey: "name") as? String ?? ""
                                        shareObjQue.strRWQueInfoText = dictQue.object(forKey: "desc") as? String ?? ""
                                        shareObjQue.intRWQueRating = 0
                                        
                                        shareObjGroup.arrRWGroupQueList.append(shareObjQue)
                                    }
                                }
                            }
                            self.shareObjReview.arrReviewGroupList.append(shareObjGroup)
                        }
                    }
                }
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVisitDateClick(_ sender: Any) {
        viewDateSelection.isHidden = false
    }
    
    @IBAction func btnProceedClick(_ sender: Any) {
        self.view.endEditing(true)
        
        txtReviewTitle.text = txtReviewTitle.text!.trimmingCharacters(in: .whitespaces)
        txtMyFeedback.text = txtMyFeedback.text!.trimmingCharacters(in: .whitespaces)
        
        guard (txtReviewTitle.text?.characters.count)! > 0 else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVWReviewTitleMsg1"))
            return
        }
        guard (txtMyFeedback.text.characters.count > 0) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVWMyFeedbackMsg1"))
            return
        }
        guard (txtMyFeedback.text != Global().getLocalizeStr(key: "keyRVWMyFeedback")) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVWMyFeedbackMsg1"))
            return
        }
        guard (shareObjReview.arrReviewGroupList.count > 0) else {
            self.getReviewQuestionsListCall()
            return
        }
        
        shareObjReview.strReviewProviderId = self.strSelProviderId
        shareObjReview.strReviewPatientId = Global.kLoggedInUserData().Id!
        shareObjReview.strReviewTitle = txtReviewTitle.text!
        shareObjReview.strReviewFeedback = txtMyFeedback.text
        shareObjReview.strReviewVisitDate = strSelVisitDate
        
        let pt_writeReviewStep2Obj = PT_WriteReviewStep2VC(nibName: "PT_WriteReviewStep2VC", bundle: nil)
        pt_writeReviewStep2Obj.strSelProviderId = self.strSelProviderId
        pt_writeReviewStep2Obj.dictSelProviderData = self.dictSelProviderData
        pt_writeReviewStep2Obj.isNavFavScreen = self.isNavFavScreen
        pt_writeReviewStep2Obj.shareObjReview = self.shareObjReview
        self.navigationController?.pushViewController(pt_writeReviewStep2Obj, animated: true)
    }
    
    @IBAction func btnCancelPickerClick(_ sender: Any) {
        viewDateSelection.isHidden = true
    }
    
    @IBAction func btnDonePickerClick(_ sender: Any) {
        txtVisitDate.text = Global.singleton.convertDateToStringWithDaySmallName(dateSel: datePickerVisit.date)
        strSelVisitDate = Global.singleton.convertDateToString(dateSel: datePickerVisit.date)
        viewDateSelection.isHidden = true
        
        shareObjReview.strReviewVisitDate = strSelVisitDate
    }
}

//MARK: -
extension PT_WriteReviewStep1VC : UITextFieldDelegate {
    // MARK: -  UITextField Delegate Methods
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "") {
            return true
        }
        if (textField == txtReviewTitle && (textField.text?.characters.count)! >= 160) {
            return false
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == txtReviewTitle) {
            shareObjReview.strReviewTitle = txtReviewTitle.text!
        }
    }
}

//MARK: -
extension PT_WriteReviewStep1VC : UITextViewDelegate {
    // MARK: -  UITextView Delegate Methods
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if (txtMyFeedback.text == Global().getLocalizeStr(key: "keyRVWMyFeedback")) {
            txtMyFeedback.text = ""
        }
        txtMyFeedback.textColor = Global().RGB(r: 40, g: 40, b: 40, a: 1)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if (txtMyFeedback.text.isEmpty) {
            txtMyFeedback.text = Global().getLocalizeStr(key: "keyRVWMyFeedback")
            txtMyFeedback.textColor = Global().RGB(r: 200, g: 200, b: 200, a: 1)
        }
        else {
            shareObjReview.strReviewFeedback = txtMyFeedback.text
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "") {
            return true
        }
        if (txtMyFeedback.text.characters.count >= 500) {
            return false
        }
        return true
    }
}

//MARK: -
extension PT_WriteReviewStep1VC {
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
