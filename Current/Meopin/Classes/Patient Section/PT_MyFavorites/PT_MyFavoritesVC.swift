//
//  PT_MyFavoritesVC.swift
//  Meopin
//
//  Created by Tops on 10/6/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MessageUI

class PT_MyFavoritesVC: UIViewController {
    
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet weak var tblFavList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var footerViewLayout: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerTextView: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSearchClose: UIButton!
    @IBOutlet weak var inboxBlurView: UIView!
    @IBOutlet weak var lblBGBlur: UILabel!

    var tapGesture = UITapGestureRecognizer()
    var isViewDismiss = false


    let tblSliderCellIdentifier = "FavoriteProviderCell"
    var arrFavoraitList : NSMutableArray = NSMutableArray()
    var arrFavListTemp : NSMutableArray = NSMutableArray()
    var mySlideViewObj: MySlideViewController?
    var isBackClick = Bool()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSearchField.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Keyword)
        footerTextView.layer.masksToBounds = true
        footerTextView.layer.cornerRadius = 5
        txtSearchField.paddingRightLeftviewWithCustomValue(12.0, txtfield: txtSearchField)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.InboxListBlurGestureTapped(_:)))
        inboxBlurView.addGestureRecognizer(tapGesture)
        inboxBlurView.isUserInteractionEnabled = true
        
        inboxBlurView.alpha = 1
        inboxBlurView.backgroundColor = UIColor.clear
        
        IQKeyboardManager.sharedManager().enable = false

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        tblFavList.register(UINib(nibName: "FavoriteProviderCell", bundle: nil), forCellReuseIdentifier: tblSliderCellIdentifier)
        tblFavList.estimatedRowHeight = 70.0
        tblFavList.rowHeight = UITableViewAutomaticDimension
    }
    
    
    func InboxListBlurGestureTapped(_ sender: UITapGestureRecognizer) {
        self.inboxBlurView.isHidden = true
        isViewDismiss = true
        isBackClick = true
        txtSearchField.resignFirstResponder()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        
        getPatientProviderFavorait()
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.lblTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleFavoriteProviderList")
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        txtSearchField.placeholder = Global().getLocalizeStr(key: "KeyTextSearch")
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnFilter.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))

        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
    }
    func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            footerViewLayout.constant = keyboardFrame.height
            inboxBlurView.backgroundColor = UIColor.black
            inboxBlurView.alpha = 0.6
            inboxBlurView.isHidden = false

        }
    }
    
    func keyboardHide(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let _ = (infoKey as AnyObject).cgRectValue {
            footerViewLayout.constant = 0
            lblBGBlur.backgroundColor = UIColor.clear
            inboxBlurView.backgroundColor = UIColor.clear
            inboxBlurView.alpha = 1
            inboxBlurView.isHidden = true
        }
    }
}

//MARK: -
extension PT_MyFavoritesVC {
    
    @IBAction func btnFavoraiteClick(_ sender: UIButton) {
        
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let alertView = UIAlertController(title: "Alert", message:Global().getLocalizeStr(key: "keyRemoveFavorite"), preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                let shareFavoraiteObj = self.arrFavoraitList.object(at: sender.tag) as! ProviderFavoraiteObject
                var strApiName = String()
                let isFavStatus = shareFavoraiteObj.strIsFavorited
                let dictParam: NSMutableDictionary = NSMutableDictionary()
                dictParam.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
                if isFavStatus == "" || isFavStatus.isEmpty || isFavStatus == "0"{
                    dictParam.setValue(shareFavoraiteObj.strUserId, forKey: "form[providerId]")
                    strApiName = "user/favorite-provider/add"
                } else  {
                    dictParam.setValue(shareFavoraiteObj.strUserId, forKey: "form[providerId]")
                    strApiName = "user/favorite-provider/remove"
                }
                AFAPIMaster.sharedAPIMaster.addProviderFavoraiteApi_Completion(strServiceName: strApiName, params: dictParam, showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData:Any) in
                    let dictResponse: NSDictionary = returnData as! NSDictionary
                    Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
                    self.getPatientProviderFavorait()
                }

            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in
                
            })
            alertView.addAction(cancelAction)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)

            
        } else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
        
    }
    
    @IBAction func btnCalenderClick(_ sender: UIButton) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let diction = arrFavListTemp.object(at: sender.tag) as! NSDictionary
            
            let shareFavoraiteObj = self.arrFavoraitList.object(at: sender.tag) as! ProviderFavoraiteObject
            let pt_CreateAppointmentSlotObj = PT_CreateAppointmentSlotVC(nibName: "PT_CreateAppointmentSlotVC", bundle: nil)
            pt_CreateAppointmentSlotObj.dictSelProviderData = diction
            pt_CreateAppointmentSlotObj.isNavFavScreen = true
            pt_CreateAppointmentSlotObj.strSelProviderId = shareFavoraiteObj.strUserId
            self.navigationController?.pushViewController(pt_CreateAppointmentSlotObj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    @IBAction func btnLikeClick(_ sender: UIButton) {
    }
    
    func btnMessageClick(_ sender: UIButton) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let diction = arrFavListTemp.object(at: sender.tag) as! NSDictionary
            
            let shareFavoraiteObj = self.arrFavoraitList.object(at: sender.tag) as! ProviderFavoraiteObject
            
            let pt_writeReviewStep1Obj = PT_WriteReviewStep1VC(nibName: "PT_WriteReviewStep1VC", bundle: nil)
            pt_writeReviewStep1Obj.strSelProviderId = shareFavoraiteObj.strUserId
            pt_writeReviewStep1Obj.dictSelProviderData = diction
            pt_writeReviewStep1Obj.isNavFavScreen = true
            self.navigationController?.pushViewController(pt_writeReviewStep1Obj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    @IBAction func btnCallClick(_ sender: UIButton) {
        let shareFavoraiteObj = self.arrFavoraitList.object(at: sender.tag) as! ProviderFavoraiteObject
        
        var strPhoneNo = shareFavoraiteObj.strPhoneNumber
        strPhoneNo = strPhoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        if strPhoneNo.isEmpty || strPhoneNo == "" {
            Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoMobileNoAlert"))
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
    
    @IBAction func btnEmailClick(_ sender: UIButton) {
        let shareFavoraiteObj = self.arrFavoraitList.object(at: sender.tag) as! ProviderFavoraiteObject
        
        let strEmail = shareFavoraiteObj.strEmail
        if strEmail.isEmpty || strEmail == "" {
            Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoEmailAlert"))
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
    
    @IBAction func btnSearchCloseClick(_ sender: UIButton) {
        self.txtSearchField.text = ""
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
    }

    // MARK: -  Get Petient Provider Favoraite API Methods
    func getPatientProviderFavorait() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        AFAPIMaster.sharedAPIMaster.sendPatientProviderFavoraiteCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData:Any) in
            let dictData: NSDictionary = returnData as! NSDictionary
            print(dictData)
            if let dictResponse: NSDictionary = dictData.object(forKey: "userData") as? NSDictionary {
                if let arrFavoraite : NSArray = dictResponse.object(forKey: "favoriteProviders") as? NSArray {
                    if arrFavoraite.count > 0 {
                        self.arrFavListTemp.removeAllObjects()
                        self.arrFavoraitList.removeAllObjects()
                        print(arrFavoraite)
                        for (index,element) in (arrFavoraite.enumerated()) {
                            print("\(index) \(element)")
                            let dictData = element as? NSDictionary ?? NSDictionary()
                            let shareFavoraiteObj: ProviderFavoraiteObject = ProviderFavoraiteObject()
                            shareFavoraiteObj.strAddress = dictData.object(forKey: "address") as? String ?? ""
                            shareFavoraiteObj.strAppointMentButton = dictData.object(forKey: "appointmentButton") as? String ?? ""
                            shareFavoraiteObj.strCategory = dictData.object(forKey: "category") as? String ?? ""
                            shareFavoraiteObj.strCity = dictData.object(forKey: "city") as? String ?? ""
                            shareFavoraiteObj.arrSpeciality = dictData.object(forKey: "specialties") as? NSArray ?? NSArray()
                            shareFavoraiteObj.strCountry = dictData.object(forKey: "country") as? String ?? ""
                            shareFavoraiteObj.strEmail = dictData.object(forKey: "email") as? String ?? ""
                            shareFavoraiteObj.strFax = dictData.object(forKey: "fax") as? String ?? ""
                            shareFavoraiteObj.strFirstName = dictData.object(forKey: "firstName") as? String ?? ""
                            shareFavoraiteObj.strIsFavorited = dictData.object(forKey: "isFavorited") as? String ?? ""
                            shareFavoraiteObj.strLastName = dictData.object(forKey: "lastName") as? String ?? ""
                            shareFavoraiteObj.strLat = dictData.object(forKey: "lat") as? String ?? "0"
                            shareFavoraiteObj.strLong = dictData.object(forKey: "lon") as? String ?? "0"
                            shareFavoraiteObj.strLikes = dictData.object(forKey: "likes") as? String ?? ""
                            shareFavoraiteObj.strPhoneNumber = dictData.object(forKey: "phoneNumber") as? String ?? ""
                            shareFavoraiteObj.strPracticeName = dictData.object(forKey: "practiceName") as? String ?? ""
                            shareFavoraiteObj.strProfilePictureUrl = dictData.object(forKey: "profilePictureUrl") as? String ?? ""
                            shareFavoraiteObj.strRecomondationCount = dictData.value(forKey: "likes") as? String ?? "0"
                            shareFavoraiteObj.strRating = dictData.object(forKey: "rating") as? String ?? ""
                            shareFavoraiteObj.strReviewButton = dictData.object(forKey: "reviewButton") as? String ?? ""
                            shareFavoraiteObj.strSalutation = dictData.object(forKey: "salutation") as? String ?? ""
                            shareFavoraiteObj.strTitle = dictData.object(forKey: "title") as? String ?? ""
                            shareFavoraiteObj.strUserId = dictData.object(forKey: "userId") as? String ?? ""
                            shareFavoraiteObj.strUserName = dictData.object(forKey: "username") as? String ?? ""
                            shareFavoraiteObj.strUserName = dictData.object(forKey: "website") as? String ?? ""
                            self.arrFavListTemp.add(dictData)
                            self.arrFavoraitList.add(shareFavoraiteObj)
                        }
                        self.tblFavList.reloadData()
                    } else {
                        self.arrFavListTemp.removeAllObjects()
                        self.arrFavoraitList.removeAllObjects()

                        Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoRecord"))
                        self.tblFavList.reloadData()
                    }
                } else {
                    self.arrFavListTemp.removeAllObjects()
                    self.arrFavoraitList.removeAllObjects()

                    Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoRecord"))
                    self.tblFavList.reloadData()
                }
            }
        }
    }
    
    func distanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> String {
        let  distanceInMeters = source.distance(from: destination)
        let distanceInMiles = distanceInMeters/1000
        return String(format:"%.2f",distanceInMiles)
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        isBackClick = true
        view.endEditing(true)
        
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    @IBAction func btnFilterClick(_ sender: UIButton) {
        footerViewLayout.constant = 0
        let providerFilterVCObj = ProviderFilterVC(nibName: "ProviderFilterVC", bundle: nil)
        self.navigationController?.pushViewController(providerFilterVCObj, animated: true)
    }
}

// MARK: -
extension PT_MyFavoritesVC : UITableViewDelegate {
    // MARK: - 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let diction = arrFavListTemp.object(at: indexPath.row) as! NSDictionary
            let searchProviderDetialVCObj = SearchProviderDetialVC(nibName: "SearchProviderDetialVC", bundle: nil)
            searchProviderDetialVCObj.responseDict = diction
            let strProviderId = diction.value(forKey: "userId") as? String ?? ""
            searchProviderDetialVCObj.strProviderId = strProviderId
            searchProviderDetialVCObj.isNavFavScreen = true
            self.navigationController?.pushViewController(searchProviderDetialVCObj, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: -
extension PT_MyFavoritesVC : UITableViewDataSource {
    // MARK: - 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoriteProviderCell = tableView.dequeueReusableCell(withIdentifier: tblSliderCellIdentifier, for: indexPath) as! FavoriteProviderCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let shareFavoraiteObj = self.arrFavoraitList.object(at: indexPath.row) as! ProviderFavoraiteObject
    
        var strFullName: String = ""
        if (shareFavoraiteObj.strSalutation.characters.count > 0) {
            strFullName = "\(shareFavoraiteObj.strSalutation) "
        }
        if (shareFavoraiteObj.strFirstName.characters.count > 0) {
            strFullName = "\(strFullName)\(shareFavoraiteObj.strFirstName) "
        }
        strFullName = "\(strFullName)\(shareFavoraiteObj.strLastName)"
        cell.lblProviderName.text = strFullName
        
        if (shareFavoraiteObj.strAddress.characters.count > 0) {
            cell.lblAddress.text = shareFavoraiteObj.strAddress
        } else {
            cell.lblAddress.text = ""
        }
        
        if Global.appDelegate.isLocationOn == true {
            let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            let myLocation = CLLocation(latitude:Double(shareFavoraiteObj.strLat)! , longitude: Double(shareFavoraiteObj.strLong)!)
            let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
            if strDistance != "" || strDistance != "0.0" {
                cell.lblDistance.text = ("\(strDistance) km")
            }
            else {
                cell.lblDistance.text = ("")
            }
        } else {
            cell.lblDistance.text = ("")
        }
        
        if (shareFavoraiteObj.strProfilePictureUrl.characters.count > 0) {
            if (shareFavoraiteObj.strProfilePictureUrl.isEmpty || shareFavoraiteObj.strProfilePictureUrl == "") {
                cell.profileImage.sd_setImage(with: URL.init(string: shareFavoraiteObj.strProfilePictureUrl), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            } else {
                cell.profileImage.sd_setImage(with: URL.init(string: shareFavoraiteObj.strProfilePictureUrl), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
        }else {
            cell.profileImage.sd_setImage(with: URL.init(string: shareFavoraiteObj.strProfilePictureUrl), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        
        if (shareFavoraiteObj.strRating.characters.count == 0 || shareFavoraiteObj.strRating.isEmpty || shareFavoraiteObj.strRating == "0")  {
            cell.lblRatingScore.text = "0.0"
        } else  {
            cell.lblRatingScore.text = shareFavoraiteObj.strRating
        }
        
        cell.btnAppointment.tag = indexPath.row
        cell.btnCall.tag     = indexPath.row
        cell.btnMessage.tag  = indexPath.row
        cell.btnEmail.tag    = indexPath.row
        cell.btnFavoraite.tag = indexPath.row
        
        cell.btnFavoraite.addTarget(self, action: #selector(btnFavoraiteClick(_:)), for: .touchUpInside)
        cell.btnCall.addTarget(self, action: #selector(btnCallClick(_:)), for: .touchUpInside)
        cell.btnAppointment.addTarget(self, action: #selector(btnCalenderClick(_:)), for: .touchUpInside)
        cell.btnEmail.addTarget(self, action: #selector(btnEmailClick(_:)), for: .touchUpInside)
        cell.btnMessage.addTarget(self, action: #selector(btnMessageClick(_:)), for: .touchUpInside)
        cell.lblRecomondation.text = shareFavoraiteObj.strRecomondationCount
        
        if shareFavoraiteObj.arrSpeciality.count > 0 {
            let strArrList = shareFavoraiteObj.arrSpeciality.componentsJoined(by: "|")
            cell.lblSpeciality.text = strArrList
        } else {
            cell.lblSpeciality.text = ""
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFavoraitList.count
    }
}

// MARK: -
extension PT_MyFavoritesVC : MFMailComposeViewControllerDelegate {
    // MARK: -  MFMailComposeViewControllerDelegate Delegate Methods
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
    func showSendMailErrorAlert() {
        Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyDeviceEmailNotSupportAlert"))
    }
}

// MARK: -
extension PT_MyFavoritesVC : UITextFieldDelegate {
    
    // MARK: -  UITextfield Delegate Methods
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isViewDismiss = false
        self.inboxBlurView.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
            btnSearchClose.isHidden = true
        } else {
            btnSearchClose.isHidden = false
        }
        return true
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
            Global.singleton.saveToUserDefaults(value: "1" , forKey: Global.kSearchFilterParamKey.isFromFavorite)
            Global.appDelegate.mySlideViewObj?.setGoToSearchMapViewControllerController()
        }
    }
}
