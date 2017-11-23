//
//  SearchProviderDetialVC.swift
//  Meopin
//
//  Created by Tops on 9/21/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI

class SearchProviderDetialVC: UIViewController {
    
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblUserSpeciality: UILabel!
    @IBOutlet weak var lblDistanceCount: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMail: UIButton!
    @IBOutlet weak var lblRecomondCount: UILabel!
    
    @IBOutlet weak var btnProfessionalInfo: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnReviews: UIButton!
    
    @IBOutlet weak var webInfoView: UIWebView!
    @IBOutlet weak var tblProviderList: UITableView!
    
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var footerViewLayout: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerTextView: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSearchClose: UIButton!
    @IBOutlet weak var lblNoRecordFound: UILabel!

    var viewSpinner: UIView?
    var isNavFavScreen : Bool = false
    let tblProviderListIdentifier = "PT_MyReviewsCell"
    var strProviderId = String()
    var strProfileUrl = String()
    var responseDict = NSDictionary()
    var distanceKM  = String()
    var isFavStatus = Bool()
    var isBackClick = Bool()
    var intCurrentPage: Int = 0
    var arrReviewList: [ReviewListSObject] = [ReviewListSObject]()
    var intMaxPageCount: Int = 0
    var intPageCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblProviderList.register(UINib(nibName: "PT_MyReviewsCell", bundle: nil), forCellReuseIdentifier:
            tblProviderListIdentifier)
        txtSearchField.placeholder = Global().getLocalizeStr(key: "KeyTextSearch")
        txtSearchField.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Keyword)
        txtSearchField.paddingRightLeftviewWithCustomValue(12.0, txtfield: txtSearchField)

        footerTextView.layer.masksToBounds = true
        footerTextView.layer.cornerRadius = 5
        tblProviderList.estimatedRowHeight = 110
        tblProviderList.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.ErroFailResponseMethod), name:NSNotification.Name(rawValue: "ErroFailResponse"), object: nil)
    
        self.tblProviderList.isHidden = true

        self.btnProfessionalInfo.setTitleColor(UIColor.white, for: .normal)
        self.webInfoView.isHidden = false
        self.btnReviews.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.btnGallery.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        
        self.tblProviderList.isHidden = true
        
        setProviderProfileData()
        providerImageBorderSet()
        setDeviceSpecificFonts()
        getProfileDetailResponsParsing()
        self.viewSpinner = AFAPICaller().addShowLoaderInView(viewObj: self.view , boolShow: true, enableInteraction: false)!
        self.webInoLoadProfessionalInfoGallery()
        self.addInfiniteScrollingReview()
        self.tblProviderList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func addInfiniteScrollingReview(){
        self.tblProviderList.addInfiniteScrolling {
            self.tblProviderList.reloadData()
            if self.arrReviewList.count == 1 {
                self.tblProviderList.infiniteScrollingView.stopAnimating()
            }
            
            if self.arrReviewList.count > 1 {
                if self.intPageCount == self.intMaxPageCount {
                    self.tblProviderList.infiniteScrollingView.stopAnimating()
                } else {
                    self.getPatientMyReviewListCall(intCurrentPage: self.intPageCount)
                }
            }
        }
    }

    
    func ErroFailResponseMethod() {
        self.tblProviderList.isHidden = true
    }
    
    func providerImageBorderSet() {
        userProfileView.layer.borderWidth = 1.4
        userProfileView.layer.borderColor = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 0.5).cgColor
        userProfileView.layer.cornerRadius = 5
        imgUserProfile.layer.masksToBounds = true
        self.lblRatingCount.layer.cornerRadius = self.lblRatingCount.frame.height / 2
    }
    
    func setProviderProfileData() {
        if Global.appDelegate.isLocationOn == true {
            let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            if isNavFavScreen == true {
                let myLocation:CLLocation = CLLocation(latitude: Double(responseDict.object(forKey: "lat") as? String ?? "0")!, longitude: Double(responseDict.object(forKey: "lon") as? String ?? "0")!)
                let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                if strDistance != "" || strDistance != "0.0" {
                    lblDistanceCount.text = ("\(strDistance) km")
                } else {
                    lblDistanceCount.text = ("")
                }
            } else  {
                let myLocation:CLLocation = CLLocation(latitude: Double(responseDict.object(forKey: "lat") as? String ?? "0")!, longitude: Double(responseDict.object(forKey: "lng") as? String ?? "0")!)
                let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                if strDistance != "" || strDistance != "0.0" {
                    lblDistanceCount.text = ("\(strDistance) km")
                } else {
                    lblDistanceCount.text = ("")
                }
            }
        }
        else {
            lblDistanceCount.text = ("")
        }
        
        
        if isNavFavScreen == true {
            let arrSpeciality = responseDict.value(forKey: "specialties") as? NSArray ?? NSArray()
            let strSpeciality = arrSpeciality .componentsJoined(by: "|")
            lblUserSpeciality.text = strSpeciality
            let strRating = responseDict.object(forKey: "rating") as?
                String ?? "0.0"
            if strRating == "" || strRating == "0.0" || strRating == "0" || strRating.isEmpty {
                lblRatingCount.text = "0.0"
            } else {
                lblRatingCount.text = responseDict.object(forKey: "rating") as? String ?? "0.0"
            }
            
            if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                if ((responseDict.object(forKey: "isFavorited") as? String ?? "") == "1") {
                    btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
                }
            }
            else {
                btnFavorite.isHidden = true
            }
            
            let isFavStatus = responseDict.object(forKey: "isFavorited") as? String ?? ""
            if isFavStatus == "" || isFavStatus.isEmpty || isFavStatus == "0" {
                btnFavorite.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            } else  {
                btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
            }
            
        } else  {
            let arrSpeciality = responseDict.value(forKey: "specialty") as? NSArray ?? NSArray()
            let strSpeciality = arrSpeciality .componentsJoined(by: "|")
            lblUserSpeciality.text = strSpeciality
            
            let strRating = responseDict.object(forKey: "hospitalRating") as?
                String ?? "0.0"
            if strRating == "" || strRating == "0.0" || strRating == "0" || strRating.isEmpty {
                lblRatingCount.text = "0.0"
            } else {
                lblRatingCount.text = responseDict.object(forKey: "hospitalRating") as? String ?? "0.0"
            }
            if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                if ((responseDict.object(forKey: "isFavorite") as? String ?? "") == "1") {
                    btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
                }
            }
            else {
                btnFavorite.isHidden = true
            }
            let isFavStatus = responseDict.object(forKey: "isFavorite") as? String ?? ""
            if isFavStatus == "" || isFavStatus.isEmpty || isFavStatus == "0" {
                btnFavorite.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            } else  {
                btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
            }
        }
        
        lblRecomondCount.text = responseDict.value(forKey: "recommendationCount") as? String ?? "0"
        
        self.lblAddress.text = responseDict.value(forKey: "address") as? String ?? ""
        
        let strSalutation = responseDict.value(forKey: "salutation") as? String ?? ""
        var strFullName = String()
        if (strSalutation.characters.count > 0) {
            strFullName = "\(strSalutation) "
        }
        
        let strFirstname = responseDict.value(forKey: "firstName") as? String ?? ""
        if (strFirstname.characters.count > 0) {
            strFullName = "\(strFullName)\(strFirstname) "
        }
        let strLastname = responseDict.value(forKey: "lastName") as? String ?? ""
        if (strLastname.characters.count > 0) {
            strFullName = "\(strFullName) \(strLastname)"
        }
        
        if strFullName == "" || strFullName.isEmpty {
            self.lblUserName.text  = responseDict.value(forKey: "hospitalName") as? String ?? ""
        } else {
            self.lblUserName.text = strFullName
        }
        
        
        if let strProfilePic =  responseDict.object(forKey: "profilePictureUrl") as? String {
            if (strProfilePic.isEmpty || strProfilePic == "") {
                self.imgUserProfile.sd_setImage(with: URL.init(string: responseDict.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
            else {
                self.imgUserProfile.sd_setImage(with: URL.init(string: strProfilePic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
        }
        else {
            self.imgUserProfile.sd_setImage(with: URL.init(string: responseDict.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        
    }
    
    func distanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> String {
        let  distanceInMeters = source.distance(from: destination)
        let distanceInMiles = distanceInMeters/1000
        return String(format:"%.2f",distanceInMiles)
    }
    
    func setDeviceSpecificFonts() {
        txtSearchField.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(16))
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblAddress.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblDistanceCount.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblUserName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblUserSpeciality.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblRatingCount.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9))
        btnFavorite.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(18))
    
    }
    
    func setLanguageTitles() {
        btnProfessionalInfo.setTitle(Global().getLocalizeStr(key: "KeyProfessionalInfo"), for: .normal)
        btnGallery.setTitle(Global().getLocalizeStr(key: "KeyGallery"), for: .normal)
        btnReviews.setTitle(Global().getLocalizeStr(key: "KeyReviews"), for: .normal)
        lblNoRecordFound.text = Global().getLocalizeStr(key: "keyNoRecord")
    }
    
    func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            footerViewLayout.constant = keyboardFrame.height
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let _ = (infoKey as AnyObject).cgRectValue {
            footerViewLayout.constant = 0
        }
    }
    
    //Provider Profile Detial Get API Call
    func getProfileDetailResponsParsing() {
            AFAPIMaster.sharedAPIMaster.getProviderProfile_Completion(params:nil, strUserId: strProviderId , showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData: Any) in
                let dictData: NSDictionary = returnData as! NSDictionary
                if let dictResponse: NSDictionary = dictData.object(forKey: "userData") as? NSDictionary {
                    print(dictResponse)                    
                    let strSalutation = dictResponse.value(forKey: "salutation") as? String ?? ""
                    var strFullName = String()
                    if (strSalutation.characters.count > 0) {
                        strFullName = "\(strSalutation) "
                    }
                    
                    let strFirstname = dictResponse.value(forKey: "firstName") as? String ?? ""
                    if (strFirstname.characters.count > 0) {
                        strFullName = "\(strFullName)\(strFirstname)"
                    }
                    let strLastname = dictResponse.value(forKey: "lastName") as? String ?? ""
                    if (strLastname.characters.count > 0) {
                        strFullName = "\(strFullName) \(strLastname)"
                    }
                    self.strProfileUrl = dictResponse.value(forKey: "profile_url") as? String ?? ""
                    //self.webInoLoadProfessionalInfoGallery()
                    
                    if strFullName == "" || strFullName.isEmpty {
                        self.lblUserName.text  = self.responseDict.value(forKey: "hospitalName") as? String ?? ""
                    } else {
                        self.lblUserName.text = strFullName
                    }
                    
                    if self.isNavFavScreen == true {
                        
                    } else  {
                        let arrSpeciality = dictResponse.value(forKey: "specialties") as? NSArray ?? NSArray()
                        let strSpeciality = arrSpeciality .componentsJoined(by: "|")
                        self.lblUserSpeciality.text = strSpeciality
                    }
                    
                    
                    if let arrReviewList = dictResponse.value(forKey: "reviews") as? NSArray {
                        if arrReviewList.count > 0 {
                            
                        }
                    }
                    let isFavoritedStaus = dictResponse.value(forKey: "isFavorited") as? String ?? ""
                    
                    if isFavoritedStaus == "" || isFavoritedStaus == "0" || isFavoritedStaus.isEmpty {
                        self.btnFavorite.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                        self.isFavStatus = false
                    } else {
                        self.btnFavorite.setTitleColor(UIColor.red, for: UIControlState.normal)
                        self.isFavStatus = true
                    }
                    
                    
                    let strUserImageUrl = dictResponse.object(forKey: "profilePictureUrl") as? String ?? ""
                    if strUserImageUrl.isEmpty || strUserImageUrl == "" {
                        self.imgUserProfile.image =  UIImage(named: "ProfileView")
                    } else {
                        self.imgUserProfile.sd_setImage(with: URL(string: strUserImageUrl)!, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                            if (image != nil) {
                                self.imgUserProfile.image = image!
                            }
                            else {
                                self.imgUserProfile.image =  UIImage(named: "ProfileView")
                            }
                        })
                    }
                }
            }
        }
}


extension SearchProviderDetialVC  {
    
    // MARK: -  API Call Methods
    func getPatientMyReviewListCall(intCurrentPage:Int) {
        let param: NSMutableDictionary = NSMutableDictionary()
        
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
                param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[patientId]")
            }
        }
        param.setValue(strProviderId, forKey: "form[providerId]")
        param.setValue("\(intCurrentPage)", forKey: "form[page]")
        AFAPIMaster.sharedAPIMaster.getPatientMyReviewsListDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let arrData: NSArray = dictResponse.object(forKey: "userData") as? NSArray {
            
                if let dictData: NSDictionary = arrData.object(at: 0) as? NSDictionary {
                    self.intMaxPageCount = Int(dictData.value(forKey: "maxPages")as? String ?? "") ?? 0
                    if self.intMaxPageCount == self.intPageCount {
                        
                    } else {
                        if self.intPageCount == 1 {
                            self.intPageCount = self.intPageCount + 1
                            self.arrReviewList.removeAll()
                        } else  {
                            self.intPageCount = self.intPageCount + 1
                        }
                    }
                    if let arrResultData: NSArray = dictData.object(forKey: "result") as? NSArray {
                        for i in 0 ..< arrResultData.count {
                            if let dictReview: NSDictionary = arrResultData.object(at: i) as? NSDictionary {
                                let shareObj: ReviewListSObject = ReviewListSObject()
                                
                                shareObj.strReviewId = dictReview.object(forKey: "reviewId") as? String ?? ""
                                shareObj.strPatientId = dictReview.object(forKey: "userId") as? String ?? ""
                                shareObj.strReviewTime = dictReview.object(forKey: "addedTimeBefore") as? String ?? ""
                                shareObj.strRevieDesc = dictReview.object(forKey: "reviewText") as? String ?? ""
                                shareObj.strGlobalRating = dictReview.object(forKey: "myScore") as? String ?? ""
                                
                                shareObj.strProfilePic = dictReview.object(forKey: "profilePictureUrl") as? String ?? ""
                                shareObj.strHospitalPic = dictReview.object(forKey: "profilePictureUrl") as? String ?? ""

                                shareObj.strSalutation = dictReview.object(forKey: "salutation") as? String ?? ""
                                shareObj.strFirstName = dictReview.object(forKey: "firstName") as? String ?? ""
                                shareObj.strLastName = dictReview.object(forKey: "lastName") as? String ?? ""
                                
                                if let dictProvider: NSDictionary = dictReview.object(forKey: "provider") as? NSDictionary {
                                    shareObj.strProviderId = dictProvider.object(forKey: "userId") as? String ?? ""
                                }
                                if let arrRatingData: NSArray = dictReview.object(forKey: "grade") as? NSArray {
                                    for j in 0 ..< arrRatingData.count {
                                        if let dictRating: NSDictionary = arrRatingData.object(at: j) as? NSDictionary {
                                            if (j == 0) {
                                                shareObj.strReviewRatingTitle1 = dictRating.object(forKey: "name") as? String ?? ""
                                                shareObj.strReviewRatingRating1 = dictRating.object(forKey: "grade") as? String ?? ""
                                            }
                                            else if (j == 1) {
                                                shareObj.strReviewRatingTitle2 = dictRating.object(forKey: "name") as? String ?? ""
                                                shareObj.strReviewRatingRating2 = dictRating.object(forKey: "grade") as? String ?? ""
                                            }
                                            else if (j == 2) {
                                                shareObj.strReviewRatingTitle3 = dictRating.object(forKey: "name") as? String ?? ""
                                                shareObj.strReviewRatingRating3 = dictRating.object(forKey: "grade") as? String ?? ""
                                            }
                                        }
                                    }
                                }
                                
                                self.arrReviewList.append(shareObj)
                            }
                        }
                        self.tblProviderList.infiniteScrollingView.stopAnimating()
                        self.tblProviderList.reloadData()
                    } else  if self.arrReviewList.count <= 0 {
                        self.tblProviderList.infiniteScrollingView.stopAnimating()
                        self.lblNoRecordFound.isHidden = false
                    }
                } else
                if self.arrReviewList.count <= 0 {
                    self.tblProviderList.infiniteScrollingView.stopAnimating()
                    self.lblNoRecordFound.isHidden = false
                }
            }
            if self.arrReviewList.count <= 0 {
                self.lblNoRecordFound.isHidden = true
            }
            self.webInfoView.isHidden = true
            self.tblProviderList.isHidden = false
            self.tblProviderList.reloadData()
            
        }, onFailure: { () in
            if self.arrReviewList.count <= 0 {
                self.tblProviderList.infiniteScrollingView.stopAnimating()
                self.lblNoRecordFound.isHidden = true
            }
        })
    }
    func webInoLoadProfessionalInfoGallery() {
        self.webInfoView.isHidden = false
        self.webInfoView.loadRequest(NSURLRequest(url: NSURL(string: self.strProfileUrl)! as URL) as URLRequest)
        self.webInfoView.delegate = self
    }
    
    @IBAction func btnProfessionalInfoClick(_ sender: UIButton) {
        self.btnProfessionalInfo.setTitleColor(UIColor.white, for: .normal)
        self.btnReviews.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.btnGallery.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.viewSpinner = AFAPICaller().addShowLoaderInView(viewObj: self.view , boolShow: true, enableInteraction: false)!
        self.tblProviderList.isHidden = true
        self.webInoLoadProfessionalInfoGallery()
    }
    
    @IBAction func btnGalleryClick(_ sender: UIButton) {
        self.btnReviews.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.btnProfessionalInfo.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.btnGallery.setTitleColor(UIColor.white, for: .normal)
        self.viewSpinner = AFAPICaller().addShowLoaderInView(viewObj: self.view , boolShow: true, enableInteraction: false)!
        self.tblProviderList.isHidden = true
        self.webInoLoadProfessionalInfoGallery()
    }
    
    @IBAction func btnReviewsClick(_ sender: UIButton) {
        self.webInfoView.isHidden = true
        self.btnProfessionalInfo.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.btnReviews.setTitleColor(UIColor.white, for: .normal)
        self.btnGallery.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.btnProfessionalInfo.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        self.getPatientMyReviewListCall(intCurrentPage:self.intPageCount)
    }
    
    @IBAction func btnSearchCloseClick(_ sender: UIButton) {
        self.txtSearchField.text = ""
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        isBackClick = true
        view.endEditing(true)
        AFAPICaller().hideRemoveLoaderFromView(removableView: self.viewSpinner!, mainView: self.view)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCallClick(_ sender: UIButton) {
        var strPhoneNo = responseDict.value(forKey: "phoneNumber") as? String ?? ""
        strPhoneNo = strPhoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        if strPhoneNo.isEmpty || strPhoneNo == "" {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyNoMobileNoAlert"))
            
            return
        }
        
        if let phoneCallURL = URL(string: "tel://\(strPhoneNo)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: { (finish) in
                    })
                } else {
                    UIApplication.shared.openURL(phoneCallURL)
                }
            }
        }
    }
    
    @IBAction func btnFavoraitClickClick(_ sender: UIButton) {
        //Generic Webservice call for Fav UnFav provider
        
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            
            if isFavStatus == false {
                let dictParam: NSMutableDictionary = NSMutableDictionary()
                dictParam.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
                var strApiName = String()
                if self.isFavStatus == false{
                    dictParam.setValue(self.strProviderId, forKey: "form[providerId]")
                    strApiName = "user/favorite-provider/add"
                }
                
                AFAPIMaster.sharedAPIMaster.addProviderFavoraiteApi_Completion(strServiceName: strApiName, params: dictParam, showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData:Any) in
                    
                    let dictResponse: NSDictionary = returnData as! NSDictionary
                    Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
                    
                    if self.isFavStatus == true {
                        self.btnFavorite.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                        self.isFavStatus = false
                    } else {
                        self.isFavStatus = true
                        self.btnFavorite.setTitleColor(UIColor.red, for: UIControlState.normal)
                    }
                }

            } else  {
                var strAlertMessage : String = String()
                    strAlertMessage = Global().getLocalizeStr(key: "keyRemoveFavorite")
                let alertView = UIAlertController(title: "Alert", message:strAlertMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    let dictParam: NSMutableDictionary = NSMutableDictionary()
                    dictParam.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
                    var strApiName = String()
                    
                    if self.isFavStatus == false{
                        dictParam.setValue(self.strProviderId, forKey: "form[providerId]")
                        strApiName = "user/favorite-provider/add"
                    }
                    else {
                        dictParam.setValue(self.strProviderId, forKey: "form[providerId]")
                        strApiName = "user/favorite-provider/remove"
                    }
                    
                    AFAPIMaster.sharedAPIMaster.addProviderFavoraiteApi_Completion(strServiceName: strApiName, params: dictParam, showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData:Any) in
                        
                        let dictResponse: NSDictionary = returnData as! NSDictionary
                        Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
                        
                        if self.isFavStatus == true {
                            self.btnFavorite.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                            self.isFavStatus = false
                        } else {
                            self.isFavStatus = true
                            self.btnFavorite.setTitleColor(UIColor.red, for: UIControlState.normal)
                        }
                    }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(cancelAction)
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
            }
        } else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    @IBAction func btnLikeClick(_ sender: UIButton) {
    }
    
    @IBAction func btnEmailClick(_ sender: UIButton) {
        let strEmail = responseDict.value(forKey: "email") as? String ?? ""
        if strEmail.isEmpty || strEmail == "" {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyNoEmailAlert"))
            return
        }
        else {
            let mailComposeViewController = configuredMailComposeViewController(strRecipients: strEmail)
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
            else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    @IBAction func btnMessageClick(_ sender: UIButton) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let pt_writeReviewStep1Obj = PT_WriteReviewStep1VC(nibName: "PT_WriteReviewStep1VC", bundle: nil)
            pt_writeReviewStep1Obj.strSelProviderId = strProviderId
            pt_writeReviewStep1Obj.dictSelProviderData = responseDict
            pt_writeReviewStep1Obj.isNavFavScreen = isNavFavScreen
            self.navigationController?.pushViewController(pt_writeReviewStep1Obj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    @IBAction func btnCalenderClick(_ sender: UIButton) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let pt_CreateAppointmentSlotObj = PT_CreateAppointmentSlotVC(nibName: "PT_CreateAppointmentSlotVC", bundle: nil)
            pt_CreateAppointmentSlotObj.strSelProviderId = strProviderId
            pt_CreateAppointmentSlotObj.dictSelProviderData = responseDict
            pt_CreateAppointmentSlotObj.isNavFavScreen = isNavFavScreen
            self.navigationController?.pushViewController(pt_CreateAppointmentSlotObj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        footerViewLayout.constant = 0
        let providerFilterVCObj = ProviderFilterVC(nibName: "ProviderFilterVC", bundle: nil)
        self.navigationController?.pushViewController(providerFilterVCObj, animated: true)
    }
    
    func showSendMailErrorAlert() {
        Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyDeviceEmailNotSupportAlert"))
    }
}


extension SearchProviderDetialVC : MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController(strRecipients:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([strRecipients])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SearchProviderDetialVC:UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        AFAPICaller().hideRemoveLoaderFromView(removableView: self.viewSpinner!, mainView: self.view)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        AFAPICaller().hideRemoveLoaderFromView(removableView: self.viewSpinner!, mainView: self.view)
    }
}

// MARK: -
extension SearchProviderDetialVC : UITextFieldDelegate {
    
    // MARK: -  UITextfield Delegate Methods
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
        } else {
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isBackClick == false {
            Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.Page)
            let strTrim = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (strTrim?.characters.count)! > 0 {
                Global.singleton.saveToUserDefaults(value: strTrim!, forKey: Global.kSearchFilterParamKey.Keyword)
            } else {
                Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
            }
            var isVCFound = false
            for viewcontrol in (self.navigationController?.viewControllers)! {
                if viewcontrol is SearchListMapProviderVC {
                    isVCFound = true
                    // self.delegate?.filterApplyDelegateMethod()
                    self.navigationController?.popToViewController(viewcontrol, animated: true)
                }
            }
            
            if isVCFound == false {
                // self.delegate?.filterApplyDelegateMethod()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
// MARK: -
extension SearchProviderDetialVC : UITableViewDataSource,UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReviewList.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PT_MyReviewsCell = tableView.dequeueReusableCell(withIdentifier: "PT_MyReviewsCell", for: indexPath) as! PT_MyReviewsCell
        cell.setLanguageTitles()
        
        let shareObj: ReviewListSObject = self.arrReviewList[indexPath.row]
        
        cell.imgProfilePic.image = #imageLiteral(resourceName: "ProfileView")
        if (shareObj.strProfilePic != "") {
            cell.imgProfilePic.sd_setImage(with: URL.init(string: shareObj.strProfilePic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        
        var strFullName: String = ""
        if (shareObj.strSalutation.characters.count > 0) {
            strFullName = "\(shareObj.strSalutation) "
        }
        if (shareObj.strFirstName.characters.count > 0) {
            strFullName = "\(strFullName)\(shareObj.strFirstName) "
        }
        strFullName = "\(strFullName)\(shareObj.strLastName)"
        cell.lblUserName.text = strFullName
        
        cell.lblReviewTime.text = shareObj.strReviewTime
        cell.lblReviewDesc.text = shareObj.strRevieDesc
        cell.lblReviewRating.text = "\(Global().getLocalizeStr(key: "keyMRGlobalRating")) \(shareObj.strGlobalRating)"
        cell.lblReviewAllRating.text = "\(shareObj.strReviewRatingTitle1) \(shareObj.strReviewRatingRating1)  | \(shareObj.strReviewRatingTitle2) \(shareObj.strReviewRatingRating2)  | \(shareObj.strReviewRatingTitle3) \(shareObj.strReviewRatingRating3)"
        cell.sizeToFit()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let shareObj = arrReviewList[indexPath.row]
            let pt_reviewDetailObj = PT_ReviewDetailVC(nibName: "PT_ReviewDetailVC", bundle: nil)
            pt_reviewDetailObj.strSelReviewId = shareObj.strReviewId
            self.navigationController?.pushViewController(pt_reviewDetailObj, animated: true)
        }
    }
}
