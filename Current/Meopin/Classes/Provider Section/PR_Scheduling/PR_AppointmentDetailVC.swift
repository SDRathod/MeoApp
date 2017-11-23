//
//  PR_AppointmentDetailVC.swift
//  Meopin
//
//  Created by Tops on 10/16/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import FSCalendar
import CalendarKit
import DateToolsSwift
import TOActionSheet
import Foundation
import IQKeyboardManagerSwift
import SDWebImage

class PR_AppointmentDetailVC: UIViewController,EventDataSource {
    
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblFromTIme: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lblProviderNameReason: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBOutlet weak var btnModifyWidthLayout: NSLayoutConstraint!
    @IBOutlet weak var btnRejectWidhtLayout: NSLayoutConstraint!
    @IBOutlet weak var btnAcceptWidthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessageTitle: UILabel!
    @IBOutlet weak var lblTitileHeader: UILabel!
    @IBOutlet weak var lblTitileDate: UILabel!
    
    @IBOutlet var timelineAppointmentView: TimelinePagerView!
    
    var strSelAppoId: String = ""
    var dictSelProviderData = NSDictionary()
    var strSelDate: String = ""
    var strSelFromTime: String = ""
    var strSelToTime: String = ""
    var strSelProviderId: String = ""
    var arrAppointmentDetail = NSMutableArray()
    var actionRejectPopup: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        patientViewAppointmentApi_Call()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        setLanguageTitles()
         patientViewAppointmentApi_Call()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
    }
    
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitileHeader.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        
        lblStatusTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(20))
        lblFromDate.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblFromTIme.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        
        lblProviderNameReason.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblEmail.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        
        lblMessageTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(16))
        
        lblMessageTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        
        btnAccept.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        
        btnModify.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        
        btnReject.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        // lblTitileDate.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnAccept.setTitle(Global().getLocalizeStr(key: "keyPSAccept"), for: UIControlState.normal)
        btnModify.setTitle(Global().getLocalizeStr(key: "keyPSModify"), for: UIControlState.normal)
        btnReject.setTitle(Global().getLocalizeStr(key: "keyPSReject"), for: UIControlState.normal)
        lblMessageTitle.text = Global().getLocalizeStr(key: "KeyPersonalMessageSmall")
        
    }
}

extension PR_AppointmentDetailVC {
    @IBAction func btnBackClick(_ sender: UIButton) {
        var isVCFound = false
        for viewcontrol in (self.navigationController?.viewControllers)! {
            if viewcontrol is PT_CreateAppointmentSlotVC {
                isVCFound = true
                self.navigationController?.popToViewController(viewcontrol, animated: true)
            }
        }
        
        if isVCFound == false {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnModifyClick(_ sender: UIButton) {
        let pr_appointmentModifyObj = PR_AppointmentModifyVC(nibName: "PR_AppointmentModifyVC", bundle: nil)
        pr_appointmentModifyObj.strSelAppoId = strSelAppoId
        let shareObj: AppointmentSObject = arrAppointmentDetail[0] as! AppointmentSObject
        if strSelProviderId == "" {
            pr_appointmentModifyObj.strSelProviderId = shareObj.strProviderId
        } else{
            pr_appointmentModifyObj.strSelProviderId = strSelProviderId
        }
        self.navigationController?.pushViewController(pr_appointmentModifyObj, animated: true)
    }
    
    @IBAction func btnAcceptClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: Global().getLocalizeStr(key: "keyPSApproveAlertMsg1"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyYes"), style: .default, handler: { action in
            let shareObj: AppointmentSObject = self.arrAppointmentDetail.object(at: 0) as! AppointmentSObject
            self.acceptAppointmentRequestCall(shareObj)
        }))
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyNo"), style: .cancel, handler: { action in
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
        
        self.actionRejectPopup = UIAlertController(title: "\n\n\n", message: "", preferredStyle: .actionSheet)
    }
    
    @IBAction func btnRejectClick(_ sender: UIButton) {
        self.actionRejectPopup = UIAlertController(title: "\n\n\n", message: "", preferredStyle: .actionSheet)
        let txtReason: UITextView = UITextView(frame: CGRect(x: 8, y: 8, width: self.actionRejectPopup!.view.bounds.size.width-30, height: 90))
        txtReason.backgroundColor = .clear
        txtReason.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        txtReason.textColor = Global.kAppColor.GrayLight
        txtReason.text = Global().getLocalizeStr(key: "keyPSRejectReason")
        txtReason.delegate = self
        self.actionRejectPopup?.view.addSubview(txtReason)
        
        let actionReject = UIAlertAction(title: Global().getLocalizeStr(key: "keyPSRejectAppointment"), style: .default, handler: { action in
            let shareObj: AppointmentSObject = self.arrAppointmentDetail.object(at: 0) as! AppointmentSObject
            self.rejectAppointmentRequestCall(shareObj, strReason: txtReason.text)
        })
        actionReject.setValue(UIColor.red, forKey: "titleTextColor")
        actionReject.isEnabled = false
        self.actionRejectPopup?.addAction(actionReject)
        self.actionRejectPopup?.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyCancel"), style: .cancel, handler: { action in
        }))
        
        DispatchQueue.main.async {
            self.navigationController?.present(self.actionRejectPopup!, animated: true, completion: nil)
        }
        
    }
    
    func acceptAppointmentRequestCall(_ shareObj: AppointmentSObject) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        AFAPIMaster.sharedAPIMaster.acceptAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func rejectAppointmentRequestCall(_ shareObj: AppointmentSObject, strReason: String) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        param.setValue(strReason, forKey: "form[reason]")
        AFAPIMaster.sharedAPIMaster.rejectAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func patientViewAppointmentApi_Call() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(strSelAppoId, forKey: "form[appointmentId]")
        
        print(param)
        AFAPIMaster.sharedAPIMaster.PatientProviderAppointmentDetialApi_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if let dictDetail: NSDictionary = dictData.object(forKey: "appointment") as? NSDictionary {
                    print(dictDetail)
                    self.arrAppointmentDetail.removeAllObjects()
                        let shareObj: AppointmentSObject = AppointmentSObject()
                        
                        shareObj.strAppId = dictDetail.object(forKey: "id") as? String ?? ""
                        shareObj.strCategoryName = dictDetail.object(forKey: "category") as? String ?? ""
                    
                        shareObj.strAppTitle = String(format: "%@ %@", dictDetail.object(forKey: "firstName") as? String ?? "", dictDetail.object(forKey: "lastName") as? String ?? "")
                        shareObj.strHospitalName = dictDetail.value(forKey: "hospitalName") as? String ?? ""
                        shareObj.strFirstNameLastName = String(format: "%@ %@ %@", dictDetail.object(forKey: "salutation") as? String ?? "",dictDetail.object(forKey: "firstName") as? String ?? "", dictDetail.object(forKey: "lastName") as? String ?? "")
                        print(shareObj.strFirstNameLastName)
                    
                        shareObj.strAppBGColor = dictDetail.object(forKey: "color") as? String ?? ""
                        shareObj.strEmail = dictDetail.object(forKey: "email") as? String ?? ""
                        
                        shareObj.strAppTextColor = dictDetail.object(forKey: "textColor") as? String ?? ""
                        shareObj.strAppDate = dictDetail.object(forKey: "appointmentDate") as? String ?? ""
                        shareObj.strCreateDate = dictDetail.object(forKey: "create_at") as? String ?? ""
                        shareObj.strModifyDate = dictDetail.object(forKey: "updated_at") as? String ?? ""
                        
                        shareObj.strAppStartTime = dictDetail.object(forKey: "startTime") as? String ?? ""
                        shareObj.strAppEndTime = dictDetail.object(forKey: "endTime") as? String ?? ""
                        shareObj.strAppReason = dictDetail.object(forKey: "reasonFor") as? String ?? ""
                        shareObj.strPatProPic = dictDetail.object(forKey: "profilePatientPictureUrl") as? String ?? ""
                        shareObj.strStausTitle = dictDetail.object(forKey: "statusLable") as? String ?? ""
                        shareObj.strStausId = dictDetail.object(forKey: "statusId") as? String ?? ""
                        shareObj.strHospitalName = dictDetail.object(forKey: "hospitalName") as? String ?? ""
                        let strFName = dictDetail.object(forKey: "firstName") as? String ?? ""
                        let strLName = dictDetail.object(forKey: "lastName") as? String ?? ""
                        shareObj.strFirstName = strFName
                        shareObj.strLastName = strLName
                        
                        shareObj.strPersonalMessage = dictDetail.object(forKey: "personalMessage") as? String ?? ""
                
                    if let dictActions: NSDictionary = dictDetail.object(forKey: "actionButton") as? NSDictionary {
                            shareObj.strActionApprove = dictActions.object(forKey: "approve") as? String ?? ""
                            shareObj.strActionComplete = dictActions.object(forKey: "complete") as? String ?? ""
                            shareObj.strActionModify = dictActions.object(forKey: "modify") as? String ?? ""
                            shareObj.strActionCancel = dictActions.object(forKey: "cancel") as? String ?? ""
                        }
                        
                        if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
                            if let dictProDetail: NSDictionary = dictDetail.object(forKey: "provider") as? NSDictionary {
                                
                                let strSalutation = dictProDetail.object(forKey: "salutation") as? String ?? ""
                                if shareObj.strStausId == "2" || shareObj.strStausId == "4" {
                                    let strFName = dictDetail.object(forKey: "firstName") as? String ?? ""
                                    let strLName = dictDetail.object(forKey: "lastName") as? String ?? ""
                                    shareObj.strFirstName = strFName
                                    shareObj.strLastName = strLName
                                } else {
                                    let strFName = dictProDetail.object(forKey: "firstName") as? String ?? ""
                                    let strLName = dictProDetail.object(forKey: "lastName") as? String ?? ""
                                    shareObj.strFirstName = strFName
                                    shareObj.strLastName = strLName
                                }
                                
                                shareObj.strHospitalName = dictProDetail.value(forKey: "hospitalName") as? String ?? ""
                                shareObj.strFirstNameLastName = String(format: "%@ %@ %@", dictProDetail.object(forKey: "salutation") as? String ?? "",dictProDetail.object(forKey: "firstName") as? String ?? "", dictProDetail.object(forKey: "lastName") as? String ?? "")
                                print(shareObj.strFirstNameLastName)

                                shareObj.strProviderId = dictProDetail.object(forKey: "provider_id") as? String ?? ""
                                shareObj.strAppTitle = ""
                                if (strSalutation.characters.count > 0) {
                                    shareObj.strAppTitle = "\(strSalutation) "
                                }
                                if (strFName.characters.count > 0) {
                                    shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strFName) "
                                }
                                shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strLName)"
                               // shareObj.strPatProPic = dictProDetail.object(forKey: "profilePictureUrl") as? String ?? ""
                            }
                        }
                        self.arrAppointmentDetail.add(shareObj)
                        self.timelineAppointmentView.autoScrollToFirstEvent = true
                        self.timelineAppointmentView.changeDateSelection(from: Date() , to: Global.singleton.convertStringToDate(strDate: shareObj.strAppDate))
                        self.timelineAppointmentView.dataSource = self
                        self.timelineAppointmentView.delegate = self
                        self.timelineAppointmentView.reloadData()
                        self.timelineAppointmentView.isUserInteractionEnabled = false
                        self.setAppointmentDetail()

                }
            }
        })
    }
    
    func setAppointmentDetail() {
        if arrAppointmentDetail.count > 0 {
            
            let shareObj: AppointmentSObject = arrAppointmentDetail[0] as! AppointmentSObject
            let strModifyTemp = Global.singleton.convertDateToStringWithDayFullName1(dateSel: Global.singleton.convertStringToDate(strDate:shareObj.strAppDate))
            lblFromDate.text = strModifyTemp
            let tempFromTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppStartTime)
            let tempToTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppEndTime)
            lblFromTIme.text = ("from \(tempFromTime) to \(tempToTime)")
          
            let dictReason: NSDictionary
            let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
            if arrFiltered.count > 0 {
                dictReason = arrFiltered[0]
                lblStatusTitle.text = dictReason.object(forKey: "name") as? String ?? ""
            } else {
                lblStatusTitle.text = ""
            }
            
            
            if let strUrl = URL(string:shareObj.strPatProPic){
                self.imgProfile.sd_setImage(with: strUrl, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                    if (image != nil) {
                        self.imgProfile.image = image!
                    }
                    else  {
                        self.imgProfile.image = #imageLiteral(resourceName: "ProfileView")
                    }
                })
            }else{
                self.imgProfile.image = #imageLiteral(resourceName: "ProfileView")
            }
            
            if (Global.kLoggedInUserData().Role == Global.kUserRole.Provider) {
                if shareObj.strStausId == "2" && shareObj.strActionApprove == "1" {

                    let strFirstNameLastName = ("\(shareObj.strFirstName) \(shareObj.strLastName)")
                    lblProviderNameReason.text = strFirstNameLastName
                    let dictReason: NSDictionary
                    let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
                    if arrFiltered.count > 0 {
                        dictReason = arrFiltered[0]
                        lblEmail.text = dictReason.object(forKey: "name") as? String ?? ""
                    } else {
                        lblEmail.text = ""
                    }
                    
                } else if shareObj.strStausId == "2" && shareObj.strActionApprove == "0" {
                    
                    let strFirstNameLastName = ("\(shareObj.strFirstName) \(shareObj.strLastName)")
                    lblProviderNameReason.text = strFirstNameLastName
                    let dictReason: NSDictionary
                    let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
                    if arrFiltered.count > 0 {
                        dictReason = arrFiltered[0]
                        lblEmail.text = dictReason.object(forKey: "name") as? String ?? ""
                    } else {
                        lblEmail.text = ""
                    }
                } else if shareObj.strStausId == "3" && shareObj.strActionApprove == "1" {
                    
                   /* if (shareObj.strPatProPic.isEmpty || shareObj.strPatProPic == "") {
                        imgProfile.sd_setImage(with: URL.init(string: dictSelProviderData.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                    }
                    else {
                        imgProfile.sd_setImage(with: URL.init(string: shareObj.strPatProPic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                    }*/
                    let dictReason: NSDictionary
                    let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
                    if arrFiltered.count > 0 {
                        dictReason = arrFiltered[0]
                        lblEmail.text = dictReason.object(forKey: "name") as? String ?? ""
                    } else {
                        lblEmail.text = ""
                    }
//                    let tempFromTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppStartTime)
//                    let tempToTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppEndTime)
//                    lblEmail.text = (" \(strModifyTemp) from \(tempFromTime) to \(tempToTime)")
                    let strFirstNameLastName = ("\(shareObj.strFirstName) \(shareObj.strLastName)")
                    /*let strProposeTime = Global().getLocalizeStr(key: "keyProposNewTime")

                    let strMixText = ("\(strFirstNameLastName) \(strProposeTime)")
                    
                    let range = (strMixText as NSString).range(of: strProposeTime)
                    let attributedString = NSMutableAttributedString(string:strMixText)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black , range: range)*/
                
                    lblProviderNameReason.text = strFirstNameLastName
                } else {
                    let strFirstNameLastName = ("\(shareObj.strFirstName) \(shareObj.strLastName)")
                    lblProviderNameReason.text = strFirstNameLastName
                    let dictReason: NSDictionary
                    let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
                    if arrFiltered.count > 0 {
                        dictReason = arrFiltered[0]
                        lblEmail.text = dictReason.object(forKey: "name") as? String ?? ""
                    } else {
                        lblEmail.text = ""
                    }
                }
                lblTitileHeader.text =  shareObj.strFirstNameLastName

            }
            if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
                if shareObj.strStausId == "2" || shareObj.strStausId == "4"{
                    
                    if shareObj.strHospitalName == "" {
                        let strFirstNameLastName = ("\(shareObj.strFirstName) \(shareObj.strLastName)")
                        lblProviderNameReason.text = strFirstNameLastName
                    } else  {
                        lblProviderNameReason.text = shareObj.strHospitalName
                    }
                    
                    let dictReason: NSDictionary
                    let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
                    if arrFiltered.count > 0 {
                        dictReason = arrFiltered[0]
                        lblEmail.text = dictReason.object(forKey: "name") as? String ?? ""
                    } else {
                        lblEmail.text = ""
                    }
                } else if shareObj.strStausId == "3" {

//                    if (shareObj.strPatProPic.isEmpty || shareObj.strPatProPic == "") {
//                        imgProfile.sd_setImage(with: URL.init(string: dictSelProviderData.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
//                    }
//                    else {
//                        imgProfile.sd_setImage(with: URL.init(string: shareObj.strPatProPic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
//                    }
                    
                    let dictReason: NSDictionary
                    let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
                    if arrFiltered.count > 0 {
                        dictReason = arrFiltered[0]
                        lblEmail.text = dictReason.object(forKey: "name") as? String ?? ""
                    } else {
                        lblEmail.text = ""
                    }
                    
//                    let tempFromTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppStartTime)
//                    let tempToTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppEndTime)
//                    lblEmail.text = (" \(strModifyTemp) from \(tempFromTime) to \(tempToTime)")
                    let strFirstNameLastName = ("\(shareObj.strFirstName) \(shareObj.strLastName)")
                   /* let strProposeTime = Global().getLocalizeStr(key: "keyProposNewTime")
                    let strMixText = ("\(strFirstNameLastName) \(strProposeTime)")
                    
                    let range = (strMixText as NSString).range(of: strProposeTime)
                    let attributedString = NSMutableAttributedString(string:strMixText)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black , range: range)*/
                    lblProviderNameReason.text = strFirstNameLastName
                }
                lblTitileHeader.text =  shareObj.strFirstNameLastName
            }
           
            lblMessage.text = shareObj.strPersonalMessage
            btnAccept.isHidden = true
            btnReject.isHidden = true
            btnModify.isHidden = true
            
            if (shareObj.strActionApprove == "1") { //Accept
                btnAccept.isHidden = false
            }
            if (shareObj.strActionCancel == "1") { //Reject Or Cancel
                btnReject.isHidden = false
            }
            if (shareObj.strActionModify == "1") { //Modify
                btnModify.isHidden = false
            }
            if shareObj.strActionApprove == "1" && shareObj.strActionCancel == "1" && shareObj.strActionModify == "1" {
                let strWidhCount = (Global.screenWidth - 60 ) / 3
                btnAcceptWidthLayout.constant = strWidhCount
                btnRejectWidhtLayout.constant =  strWidhCount
                btnModifyWidthLayout.constant =   strWidhCount
            } else if shareObj.strActionModify == "1" && shareObj.strActionCancel == "1" {
                let strWidhCount = (Global.screenWidth - 45 ) / 2
                btnRejectWidhtLayout.constant = strWidhCount
                btnModifyWidthLayout.constant = strWidhCount
                btnAcceptWidthLayout.constant = 0
            }
            else if shareObj.strActionCancel == "1" {
                let strWidhCount = (Global.screenWidth) - 30
                btnAcceptWidthLayout.constant = 0
                btnModifyWidthLayout.constant = 0
                btnRejectWidhtLayout.constant = strWidhCount
            }
            if (shareObj.strActionApprove == "0" && shareObj.strActionModify == "0" && shareObj.strActionCancel == "0") {
                footerView.backgroundColor = UIColor.clear
            }
            
        }
    }
    
    // MARK: -  EventDataSource Methods of CalendarKit
    open func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        let shareObj: AppointmentSObject = arrAppointmentDetail[0] as! AppointmentSObject
        
        let eventApp: Event = Event()
        let dictReason: NSDictionary
        let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
        if arrFiltered.count > 0 {
            dictReason = arrFiltered[0]
            eventApp.text = dictReason.object(forKey: "name") as? String ?? ""
        }
        
        eventApp.color = UIColor(string: shareObj.strAppBGColor)
        eventApp.backgroundColor = UIColor(string: shareObj.strAppBGColor, forAlpha: 3.3)
        eventApp.textColor = UIColor(string: shareObj.strAppBGColor)
        eventApp.datePeriod = TimePeriod(beginning: Global.singleton.convertStringToDateTime(strDate: "\(shareObj.strAppDate) \(shareObj.strAppStartTime)"), end: Global.singleton.convertStringToDateTime(strDate: "\(shareObj.strAppDate) \(shareObj.strAppEndTime)"))
        eventApp.userInfo = shareObj
        events.append(eventApp)
        return events
    }
}


// MARK: -
extension PR_AppointmentDetailVC: TimelinePagerViewDelegate {
    // MARK: -  TimelinePagerView Delegate Methods
    public func timelinePagerDidSelectEventView(_ eventView: EventView) {
        
    }
    
    public func timelinePagerDidLongPressEventView(_ eventView: EventView) {
    }
    
    
    public func timelinePagerDidLongPressTimelineAtHour(_ hour: Int) {
    }
    
    public func timelinePager(timelinePager: TimelinePagerView, willMoveTo date: Date) {
    }
    
    public func timelinePager(timelinePager: TimelinePagerView, didMoveTo  date: Date) {
    }
}

// MARK: -
extension PR_AppointmentDetailVC: UITextViewDelegate {
    // MARK: -  UITextView Delegate
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == Global().getLocalizeStr(key: "keyPSRejectReason")) {
            textView.text = ""
            textView.textColor = Global.kAppColor.GrayDark
        }
        
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        let strTemp: NSString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        if (strTemp.length > 0) {
            self.actionRejectPopup?.actions[0].isEnabled = true
        }
        else {
            self.actionRejectPopup?.actions[0].isEnabled = false
        }
        
        if (text == "") {
            return true
        }
        if ((textView.text?.characters.count)! > 200) {
            return false
        }
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = Global().getLocalizeStr(key: "keyPSRejectReason")
            textView.textColor = Global.kAppColor.GrayLight
        }
    }
}


// MARK: -
extension PR_AppointmentDetailVC {
    // MARK: -  Keyboard Hide Show Methods
    func keyboardWillShow(notification: NSNotification) {
        if (actionRejectPopup != nil) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                actionRejectPopup?.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
}


// MARK: -
//extension PR_AppointmentDetailVC {
//    // MARK: -  Keyboard Hide Show Methods
//    
//    func keyboardShown(notification: NSNotification) {
//        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
//            let rawFrame = (infoKey as AnyObject).cgRectValue {
//            let keyboardFrame = view.convert(rawFrame, from: nil)
//            actionRejectPopup?.view.frame.origin.y = keyboardFrame.height + 44
//        }
//    }
//    
//    func keyboardHide(notification: NSNotification) {
//        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
//            let rawFrame = (infoKey as AnyObject).cgRectValue {
//            let keyboardFrame = view.convert(rawFrame, from: nil)
//            actionRejectPopup?.view.frame.origin.y = keyboardFrame.height - 44
//        }
//    }
//}
//
