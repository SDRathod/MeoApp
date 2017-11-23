//
//  PT_MyAppointmentsVC.swift
//  Meopin
//
//  Created by Tops on 10/6/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import FSCalendar
import CalendarKit
import DateToolsSwift
import TOActionSheet

class PT_MyAppointmentsVC: UIViewController {
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var tblSlotList: UITableView!
    @IBOutlet var lblNoDataMsg: UILabel!
    
    var mySlideViewObj: MySlideViewController?
    
    var arrAppointments: [AppointmentSObject] = [AppointmentSObject]()
    var arrAppointmentsAllDate: [AppointmentDateSObject] = [AppointmentDateSObject]()
    
    var actionRejectPopup: UIAlertController?
    
    var boolIsFromSlideMenu: Bool = true
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        tblSlotList.register(UINib(nibName: "CalendarAgendaViewCell", bundle: nil), forCellReuseIdentifier: "CalendarAgendaViewCell")
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        
        lblNoDataMsg.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        
        if (boolIsFromSlideMenu) {
            btnSlideMenu.isHidden = false
            btnBack.isHidden = true
        }
        else {
            btnSlideMenu.isHidden = true
            btnBack.isHidden = false
        }
        
        self.getMyAppointmentsListCall()
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
        
        lblTitle.text = Global().getLocalizeStr(key: "keySlMyAppointments")
        lblNoDataMsg.text = Global().getLocalizeStr(key: "keyDasNoAppointment")
    }
    
    func setDeviceSpecificFonts() {
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblNoDataMsg.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_MyAppointmentsVC {
    // MARK: -  API Call
    func getMyAppointmentsListCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        
        arrAppointments.removeAll()
        arrAppointmentsAllDate.removeAll()
        AFAPIMaster.sharedAPIMaster.getAgendaViewListDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if var arrAppo: NSArray = dictData.object(forKey: "appointments") as? NSArray {
                    arrAppo = arrAppo.reversed() as NSArray
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
                                        
                                        if let dictActions: NSDictionary = dictDetail.object(forKey: "actionButton") as? NSDictionary {
                                            shareObj.strActionApprove = dictActions.object(forKey: "approve") as? String ?? ""
                                            shareObj.strActionComplete = dictActions.object(forKey: "complete") as? String ?? ""
                                            shareObj.strActionModify = dictActions.object(forKey: "modify") as? String ?? ""
                                            shareObj.strActionCancel = dictActions.object(forKey: "cancel") as? String ?? ""
                                        }
                                        
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
                                            shareObj.strProviderId = dictProDetail.object(forKey: "provider_id") as? String ?? ""
                                        }
                                        self.arrAppointments.append(shareObj)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            for shareObj in self.arrAppointments {
                let shareObjDate: AppointmentDateSObject
                let arrFiltered = self.arrAppointmentsAllDate.filter() {$0.strDate == shareObj.strAppDate}
                if arrFiltered.count > 0 {
                    shareObjDate = arrFiltered[0]
                }
                else {
                    shareObjDate = AppointmentDateSObject()
                }
                
                shareObjDate.strDate = shareObj.strAppDate
                shareObjDate.arrSlots.append(shareObj)
                
                if (!(self.arrAppointmentsAllDate.contains(shareObjDate))) {
                    self.arrAppointmentsAllDate.append(shareObjDate)
                }
            }
            self.tblSlotList.reloadData()
            
            if (self.arrAppointments.count == 0) {
                self.lblNoDataMsg.isHidden = false
            }
            else {
                self.lblNoDataMsg.isHidden = true
            }
            let arrFiltered = self.arrAppointmentsAllDate.filter() {$0.strDate == Global.singleton.convertDateToString(dateSel: Date())}
            if arrFiltered.count > 0 {
                self.tblSlotList.scrollToRow(at: IndexPath(row: 0, section: self.arrAppointmentsAllDate.index(of: arrFiltered[0])!), at: .top, animated: true)
            }
            else {
                self.tblSlotList.setContentOffset(CGPoint.zero, animated: true)
            }
        })
    }
    
    func acceptAppointmentRequestCall(_ shareObj: AppointmentSObject) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        
        AFAPIMaster.sharedAPIMaster.acceptAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            self.getMyAppointmentsListCall()
        })
    }
    
    func rejectAppointmentRequestCall(_ shareObj: AppointmentSObject, strReason: String) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        param.setValue(strReason, forKey: "form[reason]")
        
        AFAPIMaster.sharedAPIMaster.rejectAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            self.getMyAppointmentsListCall()
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: -
extension PT_MyAppointmentsVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return arrAppointmentsAllDate.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let shareObjDate: AppointmentDateSObject = arrAppointmentsAllDate[section]
        return shareObjDate.arrSlots.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(22)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader: UIView = UIView(frame: CGRect(x: 0, y: 0, width: Global.screenWidth, height: Global.singleton.getDeviceSpecificFontSize(22)))
        viewHeader.backgroundColor = Global().RGB(r: 240, g: 240, b: 240, a: 1.0)
        
        let lblTopLine: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: Global.screenWidth, height: 1))
        lblTopLine.backgroundColor = Global().RGB(r: 210, g: 210, b: 210, a: 1.0)
        viewHeader.addSubview(lblTopLine)
        
        let lblBottomLine: UILabel = UILabel(frame: CGRect(x: 0, y: Global.singleton.getDeviceSpecificFontSize(22) - 1, width: Global.screenWidth, height: 1))
        lblBottomLine.backgroundColor = Global().RGB(r: 210, g: 210, b: 210, a: 1.0)
        viewHeader.addSubview(lblBottomLine)
        
        let lblDateTitle: UILabel = UILabel(frame: CGRect(x: 10, y: 1, width: Global.screenWidth - 20, height: Global.singleton.getDeviceSpecificFontSize(22) - 2))
        lblDateTitle.backgroundColor = .clear
        lblDateTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        
        let shareObjDate = arrAppointmentsAllDate[section]
        lblDateTitle.text = Global.singleton.convertDateToStringWithDaySmallName(dateSel: Global.singleton.convertStringToDate(strDate:  shareObjDate.strDate))
        
        if (Global.singleton.convertDateToString(dateSel: Date()) == shareObjDate.strDate) {
            lblDateTitle.textColor = Global.kAppColor.Red
        }
        else {
            lblDateTitle.textColor = Global().RGB(r: 45, g: 45, b: 45, a: 1)
        }
        viewHeader.addSubview(lblDateTitle)
        
        return viewHeader
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(32)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CalendarAgendaViewCell = tableView.dequeueReusableCell(withIdentifier: "CalendarAgendaViewCell", for: indexPath) as! CalendarAgendaViewCell
        cell.setLanguageTitles()
        
        let shareObjDate = arrAppointmentsAllDate[indexPath.section]
        let shareObj = shareObjDate.arrSlots[indexPath.row]
        
        cell.lblStartTime.text = String(shareObj.strAppStartTime.characters.dropLast(3))
        cell.lblEndTime.text = String(shareObj.strAppEndTime.characters.dropLast(3))
        if (shareObj.intAppointCount > 1) {
            cell.lblTitle.text = String(format: "%@   (%d)", shareObj.strAppTitle, shareObj.intAppointCount)
        }
        else {
            cell.lblTitle.text = shareObj.strAppTitle
        }
        
        let dictReason: NSDictionary
        let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
        if arrFiltered.count > 0 {
            dictReason = arrFiltered[0]
            cell.lblAppReason.text = dictReason.object(forKey: "name") as? String ?? ""
        }
        
        if (shareObj.strAppReason == "") {
            cell.lblAppReason.text = " - "
        }
        cell.lblStatusColor.backgroundColor = UIColor(string: shareObj.strAppBGColor)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shareObjDate: AppointmentDateSObject = arrAppointmentsAllDate[indexPath.section]
        let shareObj: AppointmentSObject = shareObjDate.arrSlots[indexPath.row]
        
        let actionSheetOption: TOActionSheet = TOActionSheet()
        actionSheetOption.title = ""
        actionSheetOption.style = .light
        
        if (shareObj.strActionApprove == "1") { //Accept
            actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyPSAccept"), tappedBlock: { () in
                let alert = UIAlertController(title: "", message: Global().getLocalizeStr(key: "keyPSApproveAlertMsg1"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyYes"), style: .default, handler: { action in
                    self.acceptAppointmentRequestCall(shareObj)
                }))
                alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyNo"), style: .cancel, handler: { action in
                }))
                self.navigationController?.present(alert, animated: true, completion: nil)
            })
        }
        if (shareObj.strActionCancel == "1") { //Reject
            actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyPSReject"), tappedBlock: { () in
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
            })
        }
        
        if (shareObj.strActionModify == "1") { //Modify
            actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyPSModify"), tappedBlock: { () in
                let pr_appointmentModifyObj = PR_AppointmentModifyVC(nibName: "PR_AppointmentModifyVC", bundle: nil)
                pr_appointmentModifyObj.strSelAppoId = shareObj.strAppId
                pr_appointmentModifyObj.strSelProviderId = shareObj.strProviderId
                self.navigationController?.pushViewController(pr_appointmentModifyObj, animated: true)
            })
        }
        actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyPSView"), tappedBlock: { () in
            let pr_appointmentDetailObj = PR_AppointmentDetailVC(nibName: "PR_AppointmentDetailVC", bundle: nil)
            pr_appointmentDetailObj.strSelDate = shareObj.strAppDate
            pr_appointmentDetailObj.strSelAppoId = shareObj.strAppId
            pr_appointmentDetailObj.strSelProviderId = shareObj.strProviderId
            self.navigationController?.pushViewController(pr_appointmentDetailObj, animated: true)
        })
        actionSheetOption.show(from: self.view, in: self.view)
    }
}

// MARK: -
extension PT_MyAppointmentsVC: UITextViewDelegate {
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
extension PT_MyAppointmentsVC {
    // MARK: -  Keyboard Hide Show Methods
    func keyboardWillShow(notification: NSNotification) {
        if (actionRejectPopup != nil) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                actionRejectPopup?.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
}
