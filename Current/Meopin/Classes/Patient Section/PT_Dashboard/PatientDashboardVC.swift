//
//  PatientDashboardVC.swift
//  Meopin
//
//  Created by Tops on 9/9/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import HMSegmentedControl
import TOActionSheet

class PatientDashboardVC: STableViewController {
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var segmentAppoint: HMSegmentedControl!
    @IBOutlet var tblAppointmentList: UITableView!
    @IBOutlet var lblNoDataMsg: UILabel!
    @IBOutlet var btnMyAppointment: UIButton!
    @IBOutlet var btnMyReviews: UIButton!
    @IBOutlet var btnHelpDesk: UIButton!
    
    var arrTodayAppointmentList: [AppointmentDateSObject] = [AppointmentDateSObject]()
    var arrWaitingAppointmentList: [AppointmentDateSObject] = [AppointmentDateSObject]()
    
    var intTodayCurrentPage: Int = 0
    var intWaitingCurrentPage: Int = 0
    
    var actionRejectPopup: UIAlertController?
    
    var mySlideViewObj: MySlideViewController?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        
        segmentAppoint.sectionTitles = [Global().getLocalizeStr(key: "keyDasToday"), Global().getLocalizeStr(key: "keyDasWaiting")]
        segmentAppoint.selectedSegmentIndex = 0
        segmentAppoint.selectionIndicatorColor = .white
        segmentAppoint.selectionIndicatorLocation = .none
        segmentAppoint.selectionIndicatorHeight = 0;
        segmentAppoint.selectionStyle = .fullWidthStripe;
        segmentAppoint.backgroundColor = Global().RGB(r: 28, g: 55, b: 91, a: 1)
        segmentAppoint.titleTextAttributes = [NSForegroundColorAttributeName : Global.kAppColor.GrayLight, NSFontAttributeName : UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(9))!]
        segmentAppoint.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(9))!]
        segmentAppoint.addTarget(self, action: #selector(segmentAppointValueChanged), for: .valueChanged)
        
        self.tableView.frame = CGRect(x: tblAppointmentList.frame.origin.x, y: tblAppointmentList.frame.origin.y, width: Global.screenWidth, height: tblAppointmentList.frame.size.height)
        
        var nib: [AnyObject] = Bundle.main.loadNibNamed("DemoTableHeaderView", owner: self, options: nil)! as [AnyObject]
        let headerView: DemoTableHeaderView = (nib[0] as! DemoTableHeaderView)
        self.headerView = headerView
        
        nib = Bundle.main.loadNibNamed("DemoTableFooterView", owner: self, options: nil)! as [AnyObject]
        let footerView: DemoTableFooterView = (nib[0] as! DemoTableFooterView)
        self.footerView = footerView
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.canLoadMore = true
        self.pullToRefreshEnabled = true
        
        self.tableView.register(UINib(nibName: "CalendarAgendaViewCell", bundle: nil), forCellReuseIdentifier: "CalendarAgendaViewCell")
        
        lblNoDataMsg.isHidden = true
        self.view.bringSubview(toFront: lblNoDataMsg)
        
        btnMyAppointment.titleLabel?.adjustsFontSizeToFitWidth = true
        btnMyReviews.titleLabel?.adjustsFontSizeToFitWidth = true
        btnHelpDesk.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        
        if (segmentAppoint.selectedSegmentIndex == 0) {
            intTodayCurrentPage = 0
            self.getPatientTodayAppointmentList()
        }
        else {
            intWaitingCurrentPage = 0
            self.getPatientWaitingAppointmentList()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = tblAppointmentList.frame
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyDasTitle")
        segmentAppoint.sectionTitles = [Global().getLocalizeStr(key: "keyDasToday"), Global().getLocalizeStr(key: "keyDasWaiting")]
        lblNoDataMsg.text = Global().getLocalizeStr(key: "keyDasNoAppointment")
        btnMyAppointment.setTitle(Global().getLocalizeStr(key: "keyDasMyAppointment"), for: .normal)
        btnMyReviews.setTitle(Global().getLocalizeStr(key: "keyDasMyReview"), for: .normal)
        btnHelpDesk.setTitle(Global().getLocalizeStr(key: "keyDasHelpDesk"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblNoDataMsg.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        btnMyAppointment.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnMyReviews.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnHelpDesk.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PatientDashboardVC {
    // MARK: -  API Call Methods
    func getPatientTodayAppointmentList() {
        let intPageIndex: Int = intTodayCurrentPage
        
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue("\(intTodayCurrentPage)", forKey: "form[page]")
        
        var boolLoader: Bool = false
        if (self.arrTodayAppointmentList.count <= 0) {
            boolLoader = true
            self.lblNoDataMsg.isHidden = true
        }
        
        let intTempArrayCount = self.arrTodayAppointmentList.count
        AFAPIMaster.sharedAPIMaster.getPatientTodaysAppointmentListDataCall_Completion(params: param, showLoader: boolLoader, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if (intPageIndex == 0) {
                self.arrTodayAppointmentList.removeAll()
            }
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if let arrAppo: NSArray = dictData.object(forKey: "appointments") as? NSArray {
                    for i in 0 ..< arrAppo.count {
                        if let dictAppo: NSDictionary = arrAppo.object(at: i) as? NSDictionary {
                            let shareObjDate: AppointmentDateSObject = AppointmentDateSObject()
                            
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
                                        shareObjDate.strDate = shareObj.strAppDate
                                        
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
                                        shareObjDate.arrSlots.append(shareObj)
                                    }
                                }
                            }
                            self.arrTodayAppointmentList.append(shareObjDate)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            
            if (self.arrTodayAppointmentList.count > intTempArrayCount || intPageIndex == 0) {
                self.tableView.reloadData()
            }
            
            self.loadMoreCompleted()
            self.refreshCompleted()
            
            if (self.segmentAppoint.selectedSegmentIndex == 0) {
                if (self.arrTodayAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
            }
            else {
                if (self.arrWaitingAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
                
            }
        }, onFailure: { () in
            self.loadMoreCompleted()
            self.refreshCompleted()
            
            if (self.segmentAppoint.selectedSegmentIndex == 0) {
                if (self.arrTodayAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
            }
            else {
                if (self.arrWaitingAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
                
            }
        })
    }
    
    func getPatientWaitingAppointmentList() {
        let intPageIndex: Int = intWaitingCurrentPage
        
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue("\(intWaitingCurrentPage)", forKey: "form[page]")
        
        var boolLoader: Bool = false
        if (self.arrWaitingAppointmentList.count <= 0) {
            boolLoader = true
            self.lblNoDataMsg.isHidden = true
        }
        
        let intTempArrayCount = self.arrWaitingAppointmentList.count
        AFAPIMaster.sharedAPIMaster.getPatientWaitingAppointmentListDataCall_Completion(params: param, showLoader: boolLoader, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if (intPageIndex == 0) {
                self.arrWaitingAppointmentList.removeAll()
            }
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if let arrAppo: NSArray = dictData.object(forKey: "appointments") as? NSArray {
                    for i in 0 ..< arrAppo.count {
                        if let dictAppo: NSDictionary = arrAppo.object(at: i) as? NSDictionary {
                            let shareObjDate: AppointmentDateSObject = AppointmentDateSObject()
                            
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
                                        shareObjDate.strDate = shareObj.strAppDate
                                        
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
                                        shareObjDate.arrSlots.append(shareObj)
                                    }
                                }
                            }
                            self.arrWaitingAppointmentList.append(shareObjDate)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            if (self.arrWaitingAppointmentList.count > intTempArrayCount || intPageIndex == 0) {
                self.tableView.reloadData()
            }
            
            self.loadMoreCompleted()
            self.refreshCompleted()
            
            if (self.segmentAppoint.selectedSegmentIndex == 0) {
                if (self.arrTodayAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
            }
            else {
                if (self.arrWaitingAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
                
            }
        }, onFailure: { () in
            self.loadMoreCompleted()
            self.refreshCompleted()
            
            if (self.segmentAppoint.selectedSegmentIndex == 0) {
                if (self.arrTodayAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
            }
            else {
                if (self.arrWaitingAppointmentList.count == 0) {
                    self.lblNoDataMsg.isHidden = false
                }
                else {
                    self.lblNoDataMsg.isHidden = true
                }
                
            }
        })
    }
    
    func acceptAppointmentRequestCall(_ shareObj: AppointmentSObject) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        
        AFAPIMaster.sharedAPIMaster.acceptAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            if (self.segmentAppoint.selectedSegmentIndex == 0) {
                self.intTodayCurrentPage = 0
                self.getPatientTodayAppointmentList()
            }
            else {
                self.intWaitingCurrentPage = 0
                self.getPatientWaitingAppointmentList()
            }
        })
    }
    
    func rejectAppointmentRequestCall(_ shareObj: AppointmentSObject, strReason: String) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        param.setValue(strReason, forKey: "form[reason]")
        
        AFAPIMaster.sharedAPIMaster.rejectAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            if (self.segmentAppoint.selectedSegmentIndex == 0) {
                self.intTodayCurrentPage = 0
                self.getPatientTodayAppointmentList()
            }
            else {
                self.intWaitingCurrentPage = 0
                self.getPatientWaitingAppointmentList()
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnMyAppointmentClick(_ sender: Any) {
        let pt_myAppointmentsObj = PT_MyAppointmentsVC(nibName: "PT_MyAppointmentsVC", bundle: nil)
        pt_myAppointmentsObj.boolIsFromSlideMenu = false
        self.navigationController?.pushViewController(pt_myAppointmentsObj, animated: true)
    }
    
    @IBAction func btnMyReviewsClick(_ sender: Any) {
        let pt_myReviewsObj = PT_MyReviewsVC(nibName: "PT_MyReviewsVC", bundle: nil)
        pt_myReviewsObj.boolIsFromSlideMenu = false
        self.navigationController?.pushViewController(pt_myReviewsObj, animated: true)
    }
    
    @IBAction func btnHelpDeskClick(_ sender: Any) {
        let pt_helpDeskObj = PT_HelpDeskVC(nibName: "PT_HelpDeskVC", bundle: nil)
        pt_helpDeskObj.boolIsFromSlideMenu = false
        self.navigationController?.pushViewController(pt_helpDeskObj, animated: true)
    }
    
    // MARK: -  Segment Change Method
    func segmentAppointValueChanged() {
        if (segmentAppoint.selectedSegmentIndex == 0) {
//            if (arrTodayAppointmentList.count == 0) {
                self.tableView.reloadData()
                intTodayCurrentPage = 0
                self.getPatientTodayAppointmentList()
//            }
//            else {
//                self.lblNoDataMsg.isHidden = true
//                self.tableView.reloadData()
//            }
        }
        else {
//            if (arrWaitingAppointmentList.count == 0) {
                self.tableView.reloadData()
                intWaitingCurrentPage = 0
                self.getPatientWaitingAppointmentList()
//            }
//            else {
//                self.lblNoDataMsg.isHidden = true
//                self.tableView.reloadData()
//            }
        }
    }
}

// MARK: -
extension PatientDashboardVC {
    // MARK: -  UITableView DataSource & Delegate Methods
    public override func numberOfSections(in tableView: UITableView) -> Int {
        if (segmentAppoint.selectedSegmentIndex == 0) {
            return arrTodayAppointmentList.count
        }
        else {
            return arrWaitingAppointmentList.count
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentAppoint.selectedSegmentIndex == 0) {
            let shareObjDate: AppointmentDateSObject = arrTodayAppointmentList[section]
            return shareObjDate.arrSlots.count
        }
        else {
            let shareObjDate: AppointmentDateSObject = arrWaitingAppointmentList[section]
            return shareObjDate.arrSlots.count
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(22)
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        
        let shareObjDate: AppointmentDateSObject
        if (segmentAppoint.selectedSegmentIndex == 0) {
            if arrWaitingAppointmentList.count > 0 {
                lblNoDataMsg.isHidden = true
            }
            shareObjDate = arrTodayAppointmentList[section]
        }
        else {
            shareObjDate = arrWaitingAppointmentList[section]
        }
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
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(32)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CalendarAgendaViewCell = tableView.dequeueReusableCell(withIdentifier: "CalendarAgendaViewCell", for: indexPath) as! CalendarAgendaViewCell
        cell.setLanguageTitles()
        
        let shareObjDate: AppointmentDateSObject
        if (segmentAppoint.selectedSegmentIndex == 0) {
            shareObjDate = arrTodayAppointmentList[indexPath.section]
        }
        else {
            shareObjDate = arrWaitingAppointmentList[indexPath.section]
        }
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
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shareObjDate: AppointmentDateSObject
        if (segmentAppoint.selectedSegmentIndex == 0) {
            shareObjDate = arrTodayAppointmentList[indexPath.section]
        }
        else {
            shareObjDate = arrWaitingAppointmentList[indexPath.section]
        }
        
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
            pr_appointmentDetailObj.strSelAppoId = shareObj.strAppId
            pr_appointmentDetailObj.strSelProviderId = shareObj.strProviderId
            self.navigationController?.pushViewController(pr_appointmentDetailObj, animated: true)
        })
        actionSheetOption.show(from: self.view, in: self.view)
    }
}

// MARK: -
extension PatientDashboardVC: UITextViewDelegate {
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
extension PatientDashboardVC {
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
extension PatientDashboardVC {
    // MARK: -  STableViewController Methods
    override func pinHeaderView() {
        super.pinHeaderView()
        let hv: DemoTableHeaderView = (self.headerView as! DemoTableHeaderView)
        hv.activityIndicator.startAnimating()
        hv.title.text = Global().getLocalizeStr(key: "keyPRTLoading")
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        hv.arrowImage.isHidden = true
        CATransaction.commit()
        self.perform(#selector(self.addItemsOnTop), with: nil, afterDelay: 0.0)
    }
    
    override func unpinHeaderView() {
        super.unpinHeaderView()
        (self.headerView as! DemoTableHeaderView).activityIndicator.stopAnimating()
    }
    
    override func headerViewDidScroll(_ willRefreshOnRelease: Bool, scrollView: UIScrollView) {
        let hv: DemoTableHeaderView = (self.headerView as! DemoTableHeaderView)
        if willRefreshOnRelease {
            hv.title.text = Global().getLocalizeStr(key: "keyPRTReleaseRefresh")
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.18)
            hv.arrowImage.transform = CATransform3DMakeRotation((.pi/180.0)*180.0, 0.0, 0.0, 1.0)
            CATransaction.commit()
        }
        else {
            hv.title.text = Global().getLocalizeStr(key: "keyPRTDownRefresh")
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.18)
            hv.arrowImage.transform = CATransform3DIdentity
            CATransaction.commit()
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            hv.arrowImage.isHidden = false
            hv.arrowImage.transform = CATransform3DIdentity
            CATransaction.commit()
        }
    }
    
    override func refresh() -> Bool {
        if !super.refresh() {
            return false
        }
        return true
    }
    
    override func willBeginLoadingMore() {
        super.willBeginLoadingMore()
        let fv: DemoTableFooterView = (self.footerView as! DemoTableFooterView)
        fv.activityIndicator.startAnimating()
        self.perform(#selector(self.addItemsOnBottom), with: nil, afterDelay: 0.0)
    }
    
    override func loadMoreCompleted() {
        super.loadMoreCompleted()
        
        let fv: DemoTableFooterView = (self.footerView as! DemoTableFooterView)
        fv.activityIndicator.stopAnimating()
        if !self.canLoadMore {
            fv.infoLabel.isHidden = false
        }
    }
    
    func loadMoreCompletedNoRecords() {
        super.loadMoreCompleted()
        
        let fv: DemoTableFooterView = (self.footerView as! DemoTableFooterView)
        fv.activityIndicator.stopAnimating()
        
        fv.infoLabel.isHidden = false
        fv.infoLabel.alpha = 0.0
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            fv.infoLabel.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
            Global().delay(delay: 2, closure: {
                fv.infoLabel.alpha = 1.0
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                    fv.infoLabel.alpha = 0.0
                }, completion: {(finished: Bool) -> Void in
                    fv.infoLabel.isHidden = true
                })
            })
        })
    }
    
    override func loadMore() -> Bool {
        if !super.loadMore() {
            return false
        }
        return true
    }
    
    func addItemsOnTop() {
        if (segmentAppoint.selectedSegmentIndex == 0) {
            intTodayCurrentPage = 0
            self.getPatientTodayAppointmentList()
        }
        else {
            intWaitingCurrentPage = 0
            self.getPatientWaitingAppointmentList()
        }
    }
    
    func addItemsOnBottom() {
        if (segmentAppoint.selectedSegmentIndex == 0) {
            intTodayCurrentPage = intTodayCurrentPage + 1
            self.getPatientTodayAppointmentList()
        }
        else {
            intWaitingCurrentPage = intWaitingCurrentPage + 1
            self.getPatientWaitingAppointmentList()
        }
        self.canLoadMore = true
    }
}
