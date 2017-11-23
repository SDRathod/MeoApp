//
//  PT_ReviewDetailVC.swift
//  Meopin
//
//  Created by Tops on 11/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PT_ReviewDetailVC: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewProviderDetail: UIView!
    @IBOutlet weak var viewProfilePicBG: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var lblAllScoreRating: UILabel!
    
    @IBOutlet weak var tblReviewGroupQueList: UITableView!
    
    var shareObjReview: ReviewSObject = ReviewSObject()
    var strSelReviewId: String = ""
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewProfilePicBG.layer.masksToBounds = true
        viewProfilePicBG.layer.cornerRadius = 4
        viewProfilePicBG.layer.borderWidth = 1
        viewProfilePicBG.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        
        lblRating.layer.masksToBounds = true
        
        lblDistance.isHidden = true
        
        tblReviewGroupQueList.register(UINib(nibName: "PT_ReviewDetailCell", bundle: nil), forCellReuseIdentifier: "PT_ReviewDetailCell")
        
        self.getReviewDetailCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        tblReviewGroupQueList.estimatedRowHeight = 44
        tblReviewGroupQueList.rowHeight = UITableViewAutomaticDimension
        
        tblReviewGroupQueList.estimatedSectionFooterHeight = 44
        tblReviewGroupQueList.sectionFooterHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lblRating.layer.cornerRadius = lblRating.frame.size.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyRDTitle")
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
        
        lblAllScoreRating.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(9.7))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_ReviewDetailVC {
    // MARK: -  API Call
    func getReviewDetailCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        if (Global.kLoggedInUserData().Role == Global.kUserRole.Provider) {
            param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[providerId]")
        }
        else {
            param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        }
        param.setValue(strSelReviewId, forKey: "form[reviewId]")
        
        AFAPIMaster.sharedAPIMaster.getReviewDetailDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                self.displayUserInfo(dictData: dictData)
                
                if let arrAllRating: NSArray = dictData.object(forKey: "recAvg") as? NSArray {
                    self.lblAllScoreRating.text = ""
                    for i in 0 ..< arrAllRating.count {
                        if let dictRating: NSDictionary = arrAllRating.object(at: i) as? NSDictionary {
                            let strGroup: String = dictRating.object(forKey: "name") as? String ?? ""
                            let strRating: String = dictRating.object(forKey: "grade") as? String ?? ""
                            if (i == 0) {
                                self.lblAllScoreRating.text = "\(strRating) \(strGroup)"
                            }
                            else {
                                self.lblAllScoreRating.text = "\(self.lblAllScoreRating.text ?? "")  |  \(strRating) \(strGroup)"
                            }
                        }
                        
                    }
                }
                
                if let arrAllGroup: NSArray = dictData.object(forKey: "question_list") as? NSArray {
                    for i in 0 ..< arrAllGroup.count {
                        if let dictGroup: NSDictionary = arrAllGroup.object(at: i) as? NSDictionary {
                            let shareObjGroup: ReviewGroupSObject = ReviewGroupSObject()
                            shareObjGroup.strRWGroupId = dictGroup.object(forKey: "id") as? String ?? ""
                            shareObjGroup.strRWGroupTitle = dictGroup.object(forKey: "name") as? String ?? ""
                            shareObjGroup.strRWGroupLikeText = dictGroup.object(forKey: "notes") as? String ?? ""
                            
                            if let arrAllQue: NSArray = dictGroup.object(forKey: "question_list") as? NSArray {
                                for j in 0 ..< arrAllQue.count {
                                    if let dictQue: NSDictionary = arrAllQue.object(at: j) as? NSDictionary {
                                        let shareObjQue: ReviewQueSObject = ReviewQueSObject()
                                        shareObjQue.strRWQueId = dictQue.object(forKey: "id") as? String ?? ""
                                        shareObjQue.strRWQueText = dictQue.object(forKey: "name") as? String ?? ""
                                        shareObjQue.intRWQueRating = Int(dictQue.object(forKey: "answers") as? NSNumber ?? 0)
                                        
                                        shareObjGroup.arrRWGroupQueList.append(shareObjQue)
                                    }
                                }
                                self.shareObjReview.arrReviewGroupList.append(shareObjGroup)
                            }
                        }
                    }
                }
                self.tblReviewGroupQueList.reloadData()
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: -
extension PT_ReviewDetailVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return shareObjReview.arrReviewGroupList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let shareObjGroup = shareObjReview.arrReviewGroupList[section]
        return shareObjGroup.arrRWGroupQueList.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return Global.singleton.getDeviceSpecificFontSize(50)
        }
        else {
            return Global.singleton.getDeviceSpecificFontSize(50+15)
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var tempFloatGap: CGFloat = 0
        if (section != 0) {
            tempFloatGap = Global.singleton.getDeviceSpecificFontSize(15)
        }
        
        let viewHeader: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(50) + tempFloatGap))
        viewHeader.backgroundColor = Global().RGB(r: 230, g: 230, b: 230, a: 1)
        
        let viewSubHeader: UIView = UIView(frame: CGRect(x: 0, y: 0 + tempFloatGap, width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(50)))
        viewSubHeader.backgroundColor = .white
        viewHeader.addSubview(viewSubHeader)
        
        let lblGroupTitle: UILabel = UILabel(frame: CGRect(x: 20, y: Global.singleton.getDeviceSpecificFontSize(15), width: Global.screenWidth-40, height: Global.singleton.getDeviceSpecificFontSize(35)))
        lblGroupTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(20))
        lblGroupTitle.textColor = Global.kAppColor.BlueDark
        
        let shareObjGroup = shareObjReview.arrReviewGroupList[section]
        lblGroupTitle.text = shareObjGroup.strRWGroupTitle
        viewSubHeader.addSubview(lblGroupTitle)
        
        return viewHeader
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let shareObjGroup = shareObjReview.arrReviewGroupList[section]
        
        return 10 + Global.singleton.getDeviceSpecificFontSize(20) + Global.singleton.getSizeFromString(str: shareObjGroup.strRWGroupLikeText, stringWidth: Global.screenWidth-40, fontname: UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))!, maxHeight: CGFloat(MAXFLOAT)).height + 10
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(50)))
        viewFooter.backgroundColor = .white
        
        let shareObjGroup = shareObjReview.arrReviewGroupList[section]
        
        let lblGroupTitle: UILabel = UILabel(frame: CGRect(x: 20, y: 10, width: Global.screenWidth-40, height: Global.singleton.getDeviceSpecificFontSize(20)))
        lblGroupTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        lblGroupTitle.textColor = Global().RGB(r: 35, g: 35, b: 35, a: 1)
        lblGroupTitle.text = "\(Global().getLocalizeStr(key: "keyRDNoteFor")) \(shareObjGroup.strRWGroupTitle.lowercased())"
        viewFooter.addSubview(lblGroupTitle)
        
        let lblGroupNote: UILabel = UILabel(frame: CGRect(x: 20, y: 10 + Global.singleton.getDeviceSpecificFontSize(20), width: Global.screenWidth-40, height: Global.singleton.getDeviceSpecificFontSize(20)))
        lblGroupNote.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))
        lblGroupNote.textColor = Global().RGB(r: 85, g: 85, b: 85, a: 1)
        lblGroupNote.text = shareObjGroup.strRWGroupLikeText
        lblGroupNote.numberOfLines = 0
        lblGroupNote.lineBreakMode = .byWordWrapping
        lblGroupNote.sizeToFit()
        viewFooter.addSubview(lblGroupNote)
        
        return viewFooter
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PT_ReviewDetailCell = tableView.dequeueReusableCell(withIdentifier: "PT_ReviewDetailCell", for: indexPath) as! PT_ReviewDetailCell
        cell.setLanguageTitles()
        
        let shareObjGroup = shareObjReview.arrReviewGroupList[indexPath.section]
        let shareObjQue = shareObjGroup.arrRWGroupQueList[indexPath.row]
        
        cell.lblRevQues.text = shareObjQue.strRWQueText
        if (shareObjQue.intRWQueRating <= 0) {
            cell.lblRevAns.text = "\(Global().getLocalizeStr(key: "keyRDAnswer")) \(Global().getLocalizeStr(key: "keyRVWNoInformation"))"
        }
        else if (shareObjQue.intRWQueRating == 1) {
            cell.lblRevAns.text = "\(Global().getLocalizeStr(key: "keyRDAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore1"))"
        }
        else if (shareObjQue.intRWQueRating == 2) {
            cell.lblRevAns.text = "\(Global().getLocalizeStr(key: "keyRDAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore2"))"
        }
        else if (shareObjQue.intRWQueRating == 3) {
            cell.lblRevAns.text = "\(Global().getLocalizeStr(key: "keyRDAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore3"))"
        }
        else if (shareObjQue.intRWQueRating == 4) {
            cell.lblRevAns.text = "\(Global().getLocalizeStr(key: "keyRDAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore4"))"
        }
        else if (shareObjQue.intRWQueRating == 5) {
            cell.lblRevAns.text = "\(Global().getLocalizeStr(key: "keyRDAnswer")) \(shareObjQue.intRWQueRating) = \(Global().getLocalizeStr(key: "keyRVWScore5"))"
        }
        cell.lblRevQues.sizeToFit()
        cell.sizeToFit()
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: -
extension PT_ReviewDetailVC {
    // MARK: -  Display User Info
    func displayUserInfo(dictData: NSDictionary) {
        if (Global.kLoggedInUserData().Role == Global.kUserRole.Provider) {
            if let dictPatData: NSDictionary = dictData.object(forKey: "patientsDetails") as? NSDictionary {
                self.lblRating.isHidden = true
                self.lblAddress.isHidden = true
                self.btnFavorite.isHidden = true
                
                self.imgProfilePic.image = #imageLiteral(resourceName: "ProfileView")
                if (dictPatData.object(forKey: "profilePictureUrl") as? String ?? "" != "") {
                    self.imgProfilePic.sd_setImage(with: URL.init(string: dictPatData.object(forKey: "profilePictureUrl") as! String), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                }
                
                var strFullName: String = ""
                if ((dictPatData.object(forKey: "firstName") as? String ?? "").characters.count > 0) {
                    strFullName = "\(strFullName)\(dictPatData.object(forKey: "firstName") as? String ?? "") "
                }
                self.lblFullName.text = "\(strFullName)\(dictPatData.object(forKey: "lastName") as? String ?? "")"
                self.lblSpeciality.text = dictPatData.object(forKey: "email") as? String ?? ""
            }
        }
        else {
            if let dictProData: NSDictionary = dictData.object(forKey: "medicalProvider") as? NSDictionary {
                self.lblRating.text = dictProData.object(forKey: "rating") as? String ?? "0.0"
                
                self.imgProfilePic.image = #imageLiteral(resourceName: "ProfileView")
                if (dictProData.object(forKey: "profilePictureUrl") as? String ?? "" != "") {
                    self.imgProfilePic.sd_setImage(with: URL.init(string: dictProData.object(forKey: "profilePictureUrl") as! String), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                }
                
                var strFullName: String = ""
                if ((dictProData.object(forKey: "salutation") as? String ?? "").characters.count > 0) {
                    strFullName = "\(dictProData.object(forKey: "salutation") as? String ?? "") "
                }
                if ((dictProData.object(forKey: "firstName") as? String ?? "").characters.count > 0) {
                    strFullName = "\(strFullName)\(dictProData.object(forKey: "firstName") as? String ?? "") "
                }
                self.lblFullName.text = "\(strFullName)\(dictProData.object(forKey: "lastName") as? String ?? "")"
                
                if let arrSpeciality: NSArray = dictProData.object(forKey: "specialties") as? NSArray {
                    self.lblSpeciality.text = arrSpeciality.componentsJoined(by: " | ")
                }
                
                self.lblAddress.text = "\(dictProData.object(forKey: "address") as? String ?? "") \(dictProData.object(forKey: "city") as? String ?? "") \(dictProData.object(forKey: "country") as? String ?? "")"
                
                if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                    if ((dictProData.object(forKey: "favourite") as? String ?? "") == "1") {
                        self.btnFavorite.setTitleColor(Global.kAppColor.Red, for: .normal)
                    }
                }
                else {
                    self.btnFavorite.isHidden = true
                }
                
            }
        }
    }
}

