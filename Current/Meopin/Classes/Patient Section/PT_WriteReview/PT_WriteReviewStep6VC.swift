//
//  PT_WriteReviewStep6VC.swift
//  Meopin
//
//  Created by Tops on 11/10/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import SDWebImage

class PT_WriteReviewStep6VC: UIViewController {
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
    
    @IBOutlet var lblReviewIcon: UILabel!
    @IBOutlet var lblThankYou: UILabel!
    @IBOutlet var lblModeration: UILabel!
    
    @IBOutlet var lblRating1: UILabel!
    @IBOutlet var lblRating2: UILabel!
    @IBOutlet var lblRating3: UILabel!
    @IBOutlet var lblRatingTitle1: UILabel!
    @IBOutlet var lblRatingTitle2: UILabel!
    @IBOutlet var lblRatingTitle3: UILabel!
    
    @IBOutlet var lblOverallScore: UILabel!
    @IBOutlet var lblScoreRating: UILabel!
    
    @IBOutlet var btnReturnToHome: UIButton!
    
    @IBOutlet weak var lblReviewIconYConst: NSLayoutConstraint!
    @IBOutlet weak var lblThankYouYConst: NSLayoutConstraint!
    @IBOutlet weak var viewAllRatingYConst: NSLayoutConstraint!
    @IBOutlet weak var lblOverallScoreYConst: NSLayoutConstraint!
    @IBOutlet weak var lblScoreRatingYConst: NSLayoutConstraint!
    
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
        lblScoreRating.layer.masksToBounds = true
        
        if (Global.is_iPhone._4) {
            lblReviewIconYConst.constant = 0
            lblThankYouYConst.constant = 0
            viewAllRatingYConst.constant = 1
            lblOverallScoreYConst.constant = -5
            lblScoreRatingYConst.constant = 2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        self.displayProviderDetail()
        self.displayReviewScoreDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Global().delay(delay: 0.1) {
            self.scrollObj.contentSize = CGSize(width: Global.screenWidth, height: self.btnReturnToHome.y + self.btnReturnToHome.height)
        }
        lblRating.layer.cornerRadius = lblRating.frame.size.width / 2
        lblScoreRating.layer.cornerRadius = lblScoreRating.frame.size.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyHomeWriteReview")
        lblThankYou.text = Global().getLocalizeStr(key: "keyRVW6ThankYou")
        lblModeration.text = Global().getLocalizeStr(key: "keyRVW6Moderation")
        lblOverallScore.text = Global().getLocalizeStr(key: "keyRVW6OverallScore")
        
        btnReturnToHome.setTitle(Global().getLocalizeStr(key: "keyRVW6ReturnHome"), for: .normal)
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
        
        lblReviewIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(60))
        lblThankYou.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(21))
        lblModeration.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        
        lblRating1.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(19))
        lblRating2.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(19))
        lblRating3.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(19))
        lblRatingTitle1.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblRatingTitle2.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblRatingTitle3.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        
        lblOverallScore.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(24))
        lblScoreRating.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(35))
        
        btnReturnToHome.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_WriteReviewStep6VC {
    // MARK: -  API Call
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        
        let arrVC = self.navigationController?.viewControllers
        for vc in arrVC! {
            if (vc is PT_MyFavoritesVC || vc is SearchListMapProviderVC || vc is SearchProviderDetialVC) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnReturnToHomeClick(_ sender: Any) {
        self.view.endEditing(true)
        
        let arrVC = self.navigationController?.viewControllers
        for vc in arrVC! {
            if (vc is PT_MyFavoritesVC || vc is SearchListMapProviderVC || vc is SearchProviderDetialVC) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: -  Other Methods
    func displayReviewScoreDetail() {
        for i in 0 ..< shareObjReview.arrReviewGroupList.count {
            let shareObjGroup = shareObjReview.arrReviewGroupList[i]
            
            if (i == 0) {
                lblRating1.text = shareObjGroup.strRwGroupRating
                lblRatingTitle1.text = shareObjGroup.strRWGroupTitle
            }
            else if (i == 1) {
                lblRating2.text = shareObjGroup.strRwGroupRating
                lblRatingTitle2.text = shareObjGroup.strRWGroupTitle
            }
            else if (i == 2) {
                lblRating3.text = shareObjGroup.strRwGroupRating
                lblRatingTitle3.text = shareObjGroup.strRWGroupTitle
            }
        }
        
        lblScoreRating.text = shareObjReview.strReviewGlobalRating
        if (Float(shareObjReview.strReviewGlobalRating)! >= Float(0) && Float(shareObjReview.strReviewGlobalRating)! < Float(1)) {
            self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate0
        }
        else if (Float(shareObjReview.strReviewGlobalRating)! >= Float(1) && Float(shareObjReview.strReviewGlobalRating)! < Float(2)) {
            self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate1
        }
        else if (Float(shareObjReview.strReviewGlobalRating)! >= Float(2) && Float(shareObjReview.strReviewGlobalRating)! < Float(3)) {
            self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate2
        }
        else if (Float(shareObjReview.strReviewGlobalRating)! >= Float(3) && Float(shareObjReview.strReviewGlobalRating)! < Float(4)) {
            self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate3
        }
        else if (Float(shareObjReview.strReviewGlobalRating)! >= Float(4) && Float(shareObjReview.strReviewGlobalRating)! < Float(5)) {
            self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate4
        }
        else if (Float(shareObjReview.strReviewGlobalRating)! >= Float(5)) {
            self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate5
        }
    }
}

//MARK: -
extension PT_WriteReviewStep6VC {
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
