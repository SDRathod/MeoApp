//
//  PR_ReceivedReqListVC.swift
//  Meopin
//
//  Created by Tops on 10/16/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PR_ReceivedReqListVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblRecReqList: UITableView!
    
    var arrRecReqList: [AppointmentSObject] = [AppointmentSObject]()
    
    var indexPathLastSel: IndexPath?
    
    var strSelDate: String = ""
    var strSelFromTime: String = ""
    var strSelToTime: String = ""
    var strSelProviderId: String = ""
    
    var actionRejectPopup: UIAlertController?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        tblRecReqList.register(UINib(nibName: "PR_ReceivedReqListCell", bundle: nil), forCellReuseIdentifier: "PR_ReceivedReqListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        self.getReceivedRequestListCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        let strDateTemp = Global.singleton.convertStringToDateWithDayName(strDate: strSelDate)
        let strFromTemp = Global.singleton.convertServerTimeToNewTime(strStartDate: strSelFromTime)
        let strToTemp = Global.singleton.convertServerTimeToNewTime(strStartDate: strSelToTime)
        lblTitle.text = "\(strDateTemp) \(strFromTemp) - \(strToTemp)"
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
        
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PR_ReceivedReqListVC {
    // MARK: -  API Call
    func getReceivedRequestListCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(self.strSelDate, forKey: "form[fromDate]")
        param.setValue(self.strSelDate, forKey: "form[toDate]")
        param.setValue(self.strSelFromTime, forKey: "form[fromTime]")
        param.setValue(self.strSelToTime, forKey: "form[toTime]")
        if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient && self.strSelProviderId != "") {
            param.setValue(self.strSelProviderId, forKey: "form[providerId]")
        }
        
        print(param)
        AFAPIMaster.sharedAPIMaster.getReceivedRequestListDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            self.arrRecReqList.removeAll()
            self.indexPathLastSel = nil
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if let arrAppo: NSArray = dictData.object(forKey: "appointments") as? NSArray {
                    for i in 0 ..< arrAppo.count {
                        if let dictAppo: NSDictionary = arrAppo.object(at: i) as? NSDictionary {
                            if let arrReqTemp: NSArray = dictAppo.object(forKey: "appointmentdetails") as? NSArray {
                                for j in 0 ..< arrReqTemp.count {
                                    if let dictDetail: NSDictionary = arrReqTemp.object(at: j) as? NSDictionary {
                                        let shareObj: AppointmentSObject = AppointmentSObject()
                                        
                                        shareObj.strAppId = dictDetail.object(forKey: "id") as? String ?? ""
                                        shareObj.strAppTitle = String(format: "%@ %@", dictDetail.object(forKey: "firstName") as? String ?? "", dictDetail.object(forKey: "lastName") as? String ?? "")
                                        shareObj.strAppBGColor = dictDetail.object(forKey: "color") as? String ?? ""
                                        shareObj.strAppTextColor = dictDetail.object(forKey: "textColor") as? String ?? ""
                                        shareObj.strAppDate = dictDetail.object(forKey: "appointmentDate") as? String ?? ""
                                        shareObj.strAppStartTime = dictDetail.object(forKey: "startTime") as? String ?? ""
                                        shareObj.strAppEndTime = dictDetail.object(forKey: "endTime") as? String ?? ""
                                        shareObj.strAppReason = dictDetail.object(forKey: "reasonFor") as? String ?? ""
                                        shareObj.strPatProPic = dictDetail.object(forKey: "profilePatientPictureUrl") as? String ?? ""
                                        
                                        if let dictActions: NSDictionary = dictDetail.object(forKey: "actionButton") as? NSDictionary {
                                            shareObj.strActionApprove = dictActions.object(forKey: "approve") as? String ?? ""
                                            shareObj.strActionComplete = dictActions.object(forKey: "complete") as? String ?? ""
                                            shareObj.strActionModify = dictActions.object(forKey: "modify") as? String ?? ""
                                            shareObj.strActionCancel = dictActions.object(forKey: "cancel") as? String ?? ""
                                        }
                                        
                                        if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
                                            if let dictProDetail: NSDictionary = dictDetail.object(forKey: "provider") as? NSDictionary {
                                                let strSalutation = dictProDetail.object(forKey: "salutation") as? String ?? ""
                                                let strFName = dictProDetail.object(forKey: "firstName") as? String ?? ""
                                                let strLName = dictProDetail.object(forKey: "lastName") as? String ?? ""
                                                
                                                shareObj.strAppTitle = ""
                                                if (strSalutation.characters.count > 0) {
                                                    shareObj.strAppTitle = "\(strSalutation) "
                                                }
                                                if (strFName.characters.count > 0) {
                                                    shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strFName) "
                                                }
                                                shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strLName)"
                                                shareObj.strPatProPic = dictProDetail.object(forKey: "profilePictureUrl") as? String ?? ""
                                                shareObj.strProviderId = dictProDetail.object(forKey: "provider_id") as? String ?? "0"

                                            }
                                        }
                                        self.arrRecReqList.append(shareObj)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            self.tblRecReqList.reloadData()
        })
    }
    
    func acceptAppointmentRequestCall(_ shareObj: AppointmentSObject) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        AFAPIMaster.sharedAPIMaster.acceptAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            self.getReceivedRequestListCall()
        })
    }
    
    func rejectAppointmentRequestCall(_ shareObj: AppointmentSObject, strReason: String) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        param.setValue(strReason, forKey: "form[reason]")
        
        AFAPIMaster.sharedAPIMaster.rejectAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            self.getReceivedRequestListCall()
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnArrowClick(sender: UIButton) {
        let indexPathTempNew: IndexPath = tblRecReqList.indexPathForRow(at: sender.convert(.zero, to: tblRecReqList))!
        if (indexPathLastSel == indexPathTempNew) {
            indexPathLastSel = nil
            
            tblRecReqList.beginUpdates()
            tblRecReqList.reloadRows(at: [indexPathTempNew], with: .none)
            tblRecReqList.endUpdates()
        }
        else {
            if (indexPathLastSel != nil) {
                let indexPathTempOld: IndexPath = indexPathLastSel!
                indexPathLastSel = indexPathTempNew
                tblRecReqList.beginUpdates()
                tblRecReqList.reloadRows(at: [indexPathTempOld, indexPathLastSel!], with: .none)
                tblRecReqList.endUpdates()
            }
            else {
                indexPathLastSel = indexPathTempNew
                tblRecReqList.beginUpdates()
                tblRecReqList.reloadRows(at: [indexPathLastSel!], with: .none)
                tblRecReqList.endUpdates()
            }
        }
    }
    
    func btnAcceptClick(sender: UIButton) {
        let indexPath: IndexPath = tblRecReqList.indexPathForRow(at: sender.convert(.zero, to: tblRecReqList))!
        let shareObj: AppointmentSObject = arrRecReqList[indexPath.row]
        
        let alert = UIAlertController(title: "", message: Global().getLocalizeStr(key: "keyPSApproveAlertMsg1"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyYes"), style: .default, handler: { action in
            self.acceptAppointmentRequestCall(shareObj)
        }))
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyNo"), style: .cancel, handler: { action in
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func btnRejectClick(sender: UIButton) {
        let indexPath: IndexPath = tblRecReqList.indexPathForRow(at: sender.convert(.zero, to: tblRecReqList))!
        let shareObj: AppointmentSObject = arrRecReqList[indexPath.row]
        
        self.actionRejectPopup = UIAlertController(title: "\n\n\n", message: "", preferredStyle: .actionSheet)
        
        let txtReason: UITextView = UITextView(frame: CGRect(x: 8, y: 8, width: self.actionRejectPopup!.view.bounds.size.width-30, height: 90))
        txtReason.backgroundColor = .clear
        txtReason.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        txtReason.textColor = Global.kAppColor.GrayLight
        txtReason.text = Global().getLocalizeStr(key: "keyPSRejectReason")
        txtReason.delegate = self
        self.actionRejectPopup?.view.addSubview(txtReason)
        
        let actionReject = UIAlertAction(title: Global().getLocalizeStr(key: "keyPSRejectAppointment"), style: .default, handler: { action in
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
    
    func btnModifyClick(sender: UIButton) {
        let indexPath: IndexPath = tblRecReqList.indexPathForRow(at: sender.convert(.zero, to: tblRecReqList))!
        let shareObj: AppointmentSObject = arrRecReqList[indexPath.row]
        
        let pr_appointmentModifyObj = PR_AppointmentModifyVC(nibName: "PR_AppointmentModifyVC", bundle: nil)
        pr_appointmentModifyObj.strSelAppoId = shareObj.strAppId
        if Global.kLoggedInUserData().Role == Global.kUserRole.Patient {
            pr_appointmentModifyObj.strSelProviderId = shareObj.strProviderId
        } else {
            pr_appointmentModifyObj.strSelProviderId = self.strSelProviderId
        }
        self.navigationController?.pushViewController(pr_appointmentModifyObj, animated: true)
    }
    
    func btnViewDetailClick(sender: UIButton) {
        let indexPath: IndexPath = tblRecReqList.indexPathForRow(at: sender.convert(.zero, to: tblRecReqList))!
        let shareObj: AppointmentSObject = arrRecReqList[indexPath.row]
        let pr_appointmentDetailObj = PR_AppointmentDetailVC(nibName: "PR_AppointmentDetailVC", bundle: nil)
        pr_appointmentDetailObj.strSelAppoId = shareObj.strAppId
        pr_appointmentDetailObj.strSelProviderId = strSelProviderId
        self.navigationController?.pushViewController(pr_appointmentDetailObj, animated: true)
    }
}

// MARK: -
extension PR_ReceivedReqListVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRecReqList.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == indexPathLastSel) {
            return Global.singleton.getDeviceSpecificFontSize(85)
        }
        else {
            return Global.singleton.getDeviceSpecificFontSize(48)
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PR_ReceivedReqListCell = tableView.dequeueReusableCell(withIdentifier: "PR_ReceivedReqListCell", for: indexPath) as! PR_ReceivedReqListCell
        cell.setLanguageTitles()
        
        cell.btnArrow.addTarget(self, action: #selector(btnArrowClick(sender:)), for: .touchUpInside)
        cell.btnAccept.addTarget(self, action: #selector(btnAcceptClick(sender:)), for: .touchUpInside)
        cell.btnReject.addTarget(self, action: #selector(btnRejectClick(sender:)), for: .touchUpInside)
        cell.btnModify.addTarget(self, action: #selector(btnModifyClick(sender:)), for: .touchUpInside)
        cell.btnViewDetail.addTarget(self, action: #selector(btnViewDetailClick(sender:)), for: .touchUpInside)
        
        let shareObj: AppointmentSObject = arrRecReqList[indexPath.row]
        
        cell.imgProPic.sd_setImage(with: URL.init(string: shareObj.strPatProPic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        cell.lblAppStatus.backgroundColor = UIColor(string: shareObj.strAppBGColor)
        cell.lblPatientName.text = shareObj.strAppTitle
        
        //reason
        let dictReason: NSDictionary
        let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
        if arrFiltered.count > 0 {
            dictReason = arrFiltered[0]
            cell.lblAppReason.text = dictReason.object(forKey: "name") as? String ?? ""
        }
        if (shareObj.strAppReason == "") {
            cell.lblAppReason.text = " - "
        }
        
        if (indexPath != indexPathLastSel) {
            cell.btnAccept.isHidden = true
            cell.btnReject.isHidden = true
            cell.btnModify.isHidden = true
            cell.btnViewDetail.isHidden = true
            
            cell.btnArrow.setTitle("", for: .normal)
        }
        else {
            cell.btnAccept.isHidden = false
            cell.btnReject.isHidden = false
            cell.btnModify.isHidden = false
            cell.btnViewDetail.isHidden = false
            
            cell.btnArrow.setTitle("", for: .normal)
            
            //action buttons
            var intTempActCount: Int = 1
            if (shareObj.strActionApprove == "1") { intTempActCount += 1 }
            if (shareObj.strActionCancel == "1") { intTempActCount += 1 }
            if (shareObj.strActionModify == "1") { intTempActCount += 1 }
            
            let floatActWidth: CGFloat = Global.screenWidth / CGFloat(intTempActCount)
            cell.btnViewDetailWidthConst.constant = floatActWidth
            if (shareObj.strActionApprove == "0") {
                cell.btnAccept.isHidden = true
                cell.btnAcceptWidthConst.constant = 0
            }
            else {
                cell.btnAccept.isHidden = false
                cell.btnAcceptWidthConst.constant = floatActWidth
            }
            
            if (shareObj.strActionCancel == "0") {
                cell.btnReject.isHidden = true
                cell.btnRejectWidthConst.constant = 0
            }
            else {
                cell.btnReject.isHidden = false
                cell.btnRejectWidthConst.constant = floatActWidth
            }
            
            if (shareObj.strActionModify == "0") {
                cell.btnModify.isHidden = true
                cell.btnModifyWidthConst.constant = 0
            }
            else {
                cell.btnModify.isHidden = false
                cell.btnModifyWidthConst.constant = floatActWidth
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: PR_ReceivedReqListCell = tblRecReqList.cellForRow(at: indexPath) as! PR_ReceivedReqListCell
        self.btnArrowClick(sender: cell.btnArrow)
    }
}

// MARK: -
extension PR_ReceivedReqListVC: UITextViewDelegate {
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
extension PR_ReceivedReqListVC {
    // MARK: -  Keyboard Hide Show Methods
    func keyboardWillShow(notification: NSNotification) {
        if (actionRejectPopup != nil) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                actionRejectPopup?.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
}

