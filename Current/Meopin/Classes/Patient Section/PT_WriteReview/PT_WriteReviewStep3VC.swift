//
//  PT_WriteReviewStep3VC.swift
//  Meopin
//
//  Created by Tops on 11/8/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage

class PT_WriteReviewStep3VC: UIViewController {
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
    @IBOutlet var lblSchoolNotes: UILabel!
    @IBOutlet var lblScoreDetail: UILabel!
    
    @IBOutlet var tblGroupQuestion: UITableView!
    
    @IBOutlet var lblMyScore: UILabel!
    @IBOutlet var lblMyScoreSub: UILabel!
    @IBOutlet var lblScoreRating: UILabel!
    @IBOutlet var lblMyMessage: UILabel!
    
    @IBOutlet var txtParticularLike: UITextView!
    
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet weak var tblGroupQuestionHeightConst: NSLayoutConstraint!
    
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
        
        txtParticularLike.layer.masksToBounds = true
        txtParticularLike.layer.cornerRadius = 2.0
        txtParticularLike.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtParticularLike.layer.borderWidth = 0.4
        
        txtParticularLike.textContainerInset = UIEdgeInsetsMake(8, 10, 8, 10)
        
        txtParticularLike.text = Global().getLocalizeStr(key: "keyRVWYouLikeInParticular")
        txtParticularLike.textColor = Global().RGB(r: 200, g: 200, b: 200, a: 1)
        
        tblGroupQuestion.register(UINib(nibName: "Pt_WriteReviewQueCell", bundle: nil), forCellReuseIdentifier: "Pt_WriteReviewQueCell")
        
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            
            self.lblMyScore.text = "\(Global().getLocalizeStr(key: "keyRVWMyScoreFor"))\(shareObjGroup.strRWGroupTitle)"
            self.lblMyMessage.text = "\(Global().getLocalizeStr(key: "keyRVWMeMessage1"))\(shareObjGroup.strRWGroupTitle)\(Global().getLocalizeStr(key: "keyRVWMeMessage2"))"
            
            self.tblGroupQuestion.reloadData()
            Global().delay(delay: 0.1, closure: {
                self.tblGroupQuestionHeightConst.constant = self.tblGroupQuestion.contentSize.height
            })
            self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate0
            self.lblScoreRating.text = "0.0"
            
            self.calculateTotalRating()
            
            if (shareObjGroup.strRWGroupLikeText != "") {
                txtParticularLike.textColor = Global().RGB(r: 40, g: 40, b: 40, a: 1)
                txtParticularLike.text = shareObjGroup.strRWGroupLikeText
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.setLanguageTitles()
        
        self.displayProviderDetail()
        
        tblGroupQuestion.estimatedRowHeight = 44
        tblGroupQuestion.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Global().delay(delay: 0.2) {
            self.scrollObj.contentSize = CGSize(width: Global.screenWidth, height: self.btnNext.y + self.btnNext.height)
        }
        lblRating.layer.cornerRadius = lblRating.frame.size.width / 2
        lblScoreRating.layer.cornerRadius = lblScoreRating.frame.size.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyHomeWriteReview")
        lblSchoolNotes.text = Global().getLocalizeStr(key: "keyRVWSchoolNotes")
        lblScoreDetail.text = Global().getLocalizeStr(key: "keyRVWScoreDetail")
        lblMyScore.text = Global().getLocalizeStr(key: "keyRVWMyScoreFor")
        lblMyScoreSub.text = Global().getLocalizeStr(key: "keyRVWBasedNotes")
        lblMyMessage.text = "\(Global().getLocalizeStr(key: "keyRVWMeMessage1"))\(Global().getLocalizeStr(key: "keyRVWMeMessage2"))"
        
        if (txtParticularLike.textColor == Global().RGB(r: 200, g: 200, b: 200, a: 1)) {
            txtParticularLike.text = Global().getLocalizeStr(key: "keyRVWYouLikeInParticular")
        }
        btnNext.setTitle(Global().getLocalizeStr(key: "keyRVWNext"), for: .normal)
        
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            
            self.lblMyScore.text = "\(Global().getLocalizeStr(key: "keyRVWMyScoreFor"))\(shareObjGroup.strRWGroupTitle)"
            self.lblMyMessage.text = "\(Global().getLocalizeStr(key: "keyRVWMeMessage1"))\(shareObjGroup.strRWGroupTitle)\(Global().getLocalizeStr(key: "keyRVWMeMessage2"))"
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
        
        lblReviewIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(37))
        lblSchoolNotes.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(19))
        lblScoreDetail.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))
        
        lblMyScore.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(20))
        lblMyScoreSub.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))
        lblScoreRating.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(35))
        lblMyMessage.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        txtParticularLike.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13.2))
        
        btnNext.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_WriteReviewStep3VC {
    // MARK: -  API Call
    
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        self.view.endEditing(true)
        
        txtParticularLike.text = txtParticularLike.text!.trimmingCharacters(in: .whitespaces)
        
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            
            guard (Float(lblScoreRating.text!)! > Float(0)) else {
                Global.singleton.showWarningAlert(withMsg: "\(Global().getLocalizeStr(key: "keyRVWRateMsg1"))\(shareObjGroup.strRWGroupTitle)")
                return
            }
            
            for i in 0 ..< shareObjGroup.arrRWGroupQueList.count {
                let shareObjQue = shareObjGroup.arrRWGroupQueList[i]
                if (shareObjQue.intRWQueRating == 0) {
                    Global.singleton.showWarningAlert(withMsg: "\(Global().getLocalizeStr(key: "keyRVWRateMsg1"))\(shareObjGroup.strRWGroupTitle)")
                    return
                }
            }
            guard (txtParticularLike.text?.characters.count)! > 0 else {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVWYouLikeInParticularMsg1"))
                return
            }
            guard (txtParticularLike.text != Global().getLocalizeStr(key: "keyRVWYouLikeInParticular")) else {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyRVWYouLikeInParticularMsg1"))
                return
            }
            
            shareObjGroup.strRWGroupLikeText = txtParticularLike.text
            
            let pt_writeReviewStep4Obj = PT_WriteReviewStep4VC(nibName: "PT_WriteReviewStep4VC", bundle: nil)
            pt_writeReviewStep4Obj.strSelProviderId = self.strSelProviderId
            pt_writeReviewStep4Obj.dictSelProviderData = self.dictSelProviderData
            pt_writeReviewStep4Obj.isNavFavScreen = self.isNavFavScreen
            pt_writeReviewStep4Obj.shareObjReview = self.shareObjReview
            self.navigationController?.pushViewController(pt_writeReviewStep4Obj, animated: true)
        }
    }
}

// MARK: -
extension PT_WriteReviewStep3VC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            return shareObjGroup.arrRWGroupQueList.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Pt_WriteReviewQueCell = tableView.dequeueReusableCell(withIdentifier: "Pt_WriteReviewQueCell", for: indexPath) as! Pt_WriteReviewQueCell
        cell.setLanguageTitles()
        
        cell.btnCheckNoInfo.isHidden = true
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            
            let shareObjQue = shareObjGroup.arrRWGroupQueList[indexPath.row]
            
            cell.lblRWQueText.htmlText = String(format: "%@   <a href='%@' style='display:block;padding:10px'></a>", shareObjQue.strRWQueText)
            cell.lblRWQueText.delegate = self
            cell.lblRWQueText.sizeToFit()
            
            cell.tpRatingView.rating = CGFloat(shareObjQue.intRWQueRating)
            cell.tpRatingView.delegate = self
            
            if (shareObjQue.intRWQueRating == 0) {
                cell.tpRatingView.fullSelectedImage = #imageLiteral(resourceName: "imgRate0")
                cell.lblRWAnswer.text = "\(Global().getLocalizeStr(key: "keyRVWYourAnswer")) \(shareObjQue.intRWQueRating)"
            }
            else if (shareObjQue.intRWQueRating == 1) {
                cell.tpRatingView.fullSelectedImage = #imageLiteral(resourceName: "imgRate1")
                cell.lblRWAnswer.text = "\(Global().getLocalizeStr(key: "keyRVWYourAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore1"))"
            }
            else if (shareObjQue.intRWQueRating == 2) {
                cell.tpRatingView.fullSelectedImage = #imageLiteral(resourceName: "imgRate2")
                cell.lblRWAnswer.text = "\(Global().getLocalizeStr(key: "keyRVWYourAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore2"))"
            }
            else if (shareObjQue.intRWQueRating == 3) {
                cell.tpRatingView.fullSelectedImage = #imageLiteral(resourceName: "imgRate3")
                cell.lblRWAnswer.text = "\(Global().getLocalizeStr(key: "keyRVWYourAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore3"))"
            }
            else if (shareObjQue.intRWQueRating == 4) {
                cell.tpRatingView.fullSelectedImage = #imageLiteral(resourceName: "imgRate4")
                cell.lblRWAnswer.text = "\(Global().getLocalizeStr(key: "keyRVWYourAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore4"))"
            }
            else if (shareObjQue.intRWQueRating == 5) {
                cell.tpRatingView.fullSelectedImage = #imageLiteral(resourceName: "imgRate5")
                cell.lblRWAnswer.text = "\(Global().getLocalizeStr(key: "keyRVWYourAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore5"))"
            }
            
            if (shareObjQue.intRWQueRating == 0) {
                cell.lblRWAnswer.isHidden = true
            }
            else {
                cell.lblRWAnswer.isHidden = false
            }
        }
        cell.sizeToFit()
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: -
extension PT_WriteReviewStep3VC : TPFloatRatingViewDelegate {
    // MARK: -  TPFloatRatingView Delegate Methods
    func floatRatingView(_ ratingView: TPFloatRatingView!, ratingDidChange rating: CGFloat) {
        let touchPoint: CGPoint = ratingView.convert(CGPoint.zero, to: self.tblGroupQuestion)
        let indexPath = tblGroupQuestion.indexPathForRow(at: touchPoint)
        
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            
            let shareObjQue = shareObjGroup.arrRWGroupQueList[(indexPath?.row)!]
            shareObjQue.intRWQueRating = Int(rating)
            
            tblGroupQuestion.beginUpdates()
            tblGroupQuestion.reloadRows(at: [indexPath!], with: .none)
            tblGroupQuestion.endUpdates()
            
            self.calculateTotalRating()
        }
    }
    
    func calculateTotalRating() {
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            
            var floatTotRating: Float = 0
            for i in 0 ..< shareObjGroup.arrRWGroupQueList.count {
                let shareObjQue = shareObjGroup.arrRWGroupQueList[i]
                
                floatTotRating = floatTotRating + Float(shareObjQue.intRWQueRating)
            }
            self.lblScoreRating.text = String(format: "%.1f", floatTotRating/Float(shareObjGroup.arrRWGroupQueList.count))
            shareObjGroup.strRwGroupRating = self.lblScoreRating.text!
            
            if (Float(shareObjGroup.strRwGroupRating)! >= Float(0) && Float(shareObjGroup.strRwGroupRating)! < Float(1)) {
                self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate0
            }
            else if (Float(shareObjGroup.strRwGroupRating)! >= Float(1) && Float(shareObjGroup.strRwGroupRating)! < Float(2)) {
                self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate1
            }
            else if (Float(shareObjGroup.strRwGroupRating)! >= Float(2) && Float(shareObjGroup.strRwGroupRating)! < Float(3)) {
                self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate2
            }
            else if (Float(shareObjGroup.strRwGroupRating)! >= Float(3) && Float(shareObjGroup.strRwGroupRating)! < Float(4)) {
                self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate3
            }
            else if (Float(shareObjGroup.strRwGroupRating)! >= Float(4) && Float(shareObjGroup.strRwGroupRating)! < Float(5)) {
                self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate4
            }
            else if (Float(shareObjGroup.strRwGroupRating)! >= Float(5)) {
                self.lblScoreRating.backgroundColor = Global.kReviewRatingColor.Rate5
            }
        }
    }
}

//MARK: -
extension PT_WriteReviewStep3VC : MDHTMLLabelDelegate {
    // MARK: -  MDHTMLLabel Delegate Methods
    func htmlLabel(_ label: MDHTMLLabel!, didSelectLinkWith URL: URL!) {
        let touchPoint: CGPoint = label.convert(CGPoint.zero, to: self.tblGroupQuestion)
        let indexPath = tblGroupQuestion.indexPathForRow(at: touchPoint)
        let cell = tblGroupQuestion.cellForRow(at: indexPath!)
        
        if (shareObjReview.arrReviewGroupList.count > 1) {
            let shareObjGroup = shareObjReview.arrReviewGroupList[1]
            
            let shareObjQue = shareObjGroup.arrRWGroupQueList[(indexPath?.row)!]
            
            let queToolTip = PopTip()
            queToolTip.bubbleColor = Global.kAppColor.BlueDark
            queToolTip.show(text: shareObjQue.strRWQueInfoText, direction: .down, maxWidth: Global.screenWidth - 50, in: cell!, from: label.frame)
        }
    }
}

//MARK: -
extension PT_WriteReviewStep3VC : UITextViewDelegate {
    // MARK: -  UITextView Delegate Methods
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if (txtParticularLike.text == Global().getLocalizeStr(key: "keyRVWYouLikeInParticular")) {
            txtParticularLike.text = ""
        }
        txtParticularLike.textColor = Global().RGB(r: 40, g: 40, b: 40, a: 1)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if (txtParticularLike.text.isEmpty) {
            txtParticularLike.text = Global().getLocalizeStr(key: "keyRVWYouLikeInParticular")
            txtParticularLike.textColor = Global().RGB(r: 200, g: 200, b: 200, a: 1)
        }
        else {
            if (shareObjReview.arrReviewGroupList.count > 1) {
                let shareObjGroup = shareObjReview.arrReviewGroupList[1]
                shareObjGroup.strRWGroupLikeText = txtParticularLike.text
            }
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "") {
            return true
        }
        if (txtParticularLike.text.characters.count >= 500) {
            return false
        }
        return true
    }
}

//MARK: -
extension PT_WriteReviewStep3VC {
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
