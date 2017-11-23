//
//  PR_AppointmentModifyVC.swift
//  Meopin
//
//  Created by Tops on 10/24/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import FSCalendar
import CalendarKit
import DateToolsSwift
import TOActionSheet
import IQKeyboardManagerSwift
import SDWebImage

class PR_AppointmentModifyVC: UIViewController, EventDataSource {
    
    @IBOutlet weak var selectAppointmentView: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnAnimation: UIButton!
    @IBOutlet var scrView: UIScrollView!
    
    @IBOutlet var lblAppointmentSelDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblReasonTitle: UILabel!
    @IBOutlet var lblFullName: UILabel!
    @IBOutlet var lblFromDate: UILabel!
    @IBOutlet var lblFromTime: UILabel!
    @IBOutlet var lblPersonalMessage: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var txtReasonMessage: UITextView!
    
    @IBOutlet var btnSendInquiry: UIButton!
    @IBOutlet var calendarAppointment: FSCalendar!
    @IBOutlet var timelineAppointmentView: TimelinePagerView!
    @IBOutlet var timelineAppointmentBlankSloatView: TimelinePagerView!
    @IBOutlet var lblSelectTimeTitle: UILabel!
    @IBOutlet var lblDateAndTime: UILabel!
    
    @IBOutlet weak var CenterView: UIView!
    @IBOutlet var animationConst: NSLayoutConstraint!
    @IBOutlet var calendarAppointmentHeightConst: NSLayoutConstraint!
    @IBOutlet var selectAppointmentViewHeightCont: NSLayoutConstraint!
    @IBOutlet var scrConstrint: NSLayoutConstraint!
    
    var strSelAppoId: String = ""
    var strSelDate: String = ""
    var strSelFromTime: String = ""
    var strSelToTime: String = ""
    var strSelProviderId: String = ""
    var dictSelProviderData = NSDictionary()
    var strSelectedDate : String = ""
    var isCheckedId = NSMutableArray()
    
    var strAppointmentStartTime: String = ""
    var strAppointmentEndTime: String = ""
    var dateAppointmentModify: Date = Date()

    var dateSelAppointment: Date = Date()
    var dateSelAppointmentOld: Date = Date()
    
    var boolIsAppointmentSel: Bool = false
    var actionRejectPopup: UIAlertController?
    var appointmentSloatDetail = NSMutableArray()
    var appointmentDetail = NSMutableArray()
    
    var arrAppointments: [AppointmentSObject] = [AppointmentSObject]()
    var arrAppointmentsAllDate: [AppointmentDateSObject] = [AppointmentDateSObject]()
    
    var boolIsCalendarTimeline: Bool = false
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSelectTimeTitle.text = Global().getLocalizeStr(key: "keySelectedAppontmentTitle")
        lblAppointmentSelDate.text = Global.singleton.convertDateToStringWithDayFullName(dateSel: dateSelAppointment)

        imgProfilePic.layer.masksToBounds = true
        imgProfilePic.layer.borderWidth = 1
        imgProfilePic.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        animationConst.constant = 0
        self.selectAppointmentViewHeightCont.constant = 50
        
        IQKeyboardManager.sharedManager().enable = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //calendar properties
        calendarAppointment.scope = .week
        calendarAppointment.select(Date())
        calendarAppointment.firstWeekday = 1
        calendarAppointment.clipsToBounds = true
        calendarAppointment.appearance.headerMinimumDissolvedAlpha = 0
        
        calendarAppointment.appearance.selectionColor = Global.kAppColor.Red
        
        calendarAppointment.headerHeight = Global.singleton.getDeviceSpecificFontSize(40)
        calendarAppointment.weekdayHeight = Global.singleton.getDeviceSpecificFontSize(18)
        
        calendarAppointment.appearance.headerTitleFont = UIFont(name: "HelveticaNeue", size: Global.singleton.getDeviceSpecificFontSize(14))
        calendarAppointment.appearance.weekdayFont = UIFont(name: "HelveticaNeue", size: Global.singleton.getDeviceSpecificFontSize(9))
        calendarAppointment.appearance.titleFont = UIFont(name: "HelveticaNeue", size: Global.singleton.getDeviceSpecificFontSize(15))
        calendarAppointment.accessibilityIdentifier = "calendar"
        self.patientViewAppointmentApi_Call()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.setLanguageTitles()
        self.getAppointmentScheduleForSelDateCall()
    }
    
    func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            scrConstrint.constant = keyboardFrame.height + 44
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let _ = (infoKey as AnyObject).cgRectValue {
            scrConstrint.constant = 44
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.width / 2
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        txtReasonMessage.text = Global().getLocalizeStr(key: "keyReasonForChange")
    }
    
    func setDeviceSpecificFonts() {
        txtReasonMessage.layer.masksToBounds = true
        txtReasonMessage.layer.cornerRadius = 2.0
        txtReasonMessage.layer.borderColor = Global.kTextFieldProperties.BorderColor
        txtReasonMessage.layer.borderWidth = 0.4
        
        txtReasonMessage.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnAnimation.setTitle("", for: UIControlState.normal)
        lblReasonTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        lblSelectTimeTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblDateAndTime.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        
        lblFromDate.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        lblFromTime.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(14))
        
        lblFullName.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblEmail.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblMessage.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
    }
}

// MARK: -
extension PR_AppointmentModifyVC: FSCalendarDataSource, FSCalendarDelegate {
    // MARK: -  FSCalendar DataSource & Dlegate Methods
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarAppointmentHeightConst.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateSelAppointment = date
        dateAppointmentModify = date
        lblAppointmentSelDate.text = Global.singleton.convertDateToStringWithDayFullName(dateSel: date)
        getAppointmentScheduleForSelDateCall()
    }
}

// MARK: -
extension PR_AppointmentModifyVC: TimelinePagerViewDelegate {
    // MARK: -  TimelinePagerView Delegate Methods
    public func timelinePagerDidSelectEventView(_ eventView: EventView) {
        let eventApp: Event = eventView.descriptor as! Event
        let shareObj: AppointmentSObject = eventApp.userInfo as! AppointmentSObject
        let tempFromTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppStartTime)
        let tempFromEndTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppEndTime)
        self.lblDateAndTime.text = String("\(shareObj.strAppDate) AT \(tempFromTime) To \(tempFromEndTime)")
        strAppointmentStartTime = shareObj.strAppStartTime
        strAppointmentEndTime = shareObj.strAppEndTime
        self.selectAppointmentView.isHidden = false
        self.lblSelectTimeTitle.text = Global().getLocalizeStr(key: "keySelectedAppontmentTitle")
        Global.singleton.showSuccessAlert(withMsg: "\(Global().getLocalizeStr(key: "keySelectedAppontmentDateAlert")) \(shareObj.strAppDate) AT \(tempFromTime) To \(tempFromEndTime).\(Global().getLocalizeStr(key: "keySelectedAppontmentDateAlert1"))")
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
extension PR_AppointmentModifyVC {
    // MARK: -   Appointment Schedule Selected Date Api Call Method
    func getAppointmentScheduleForSelDateCall() {
        
        let param: NSMutableDictionary = NSMutableDictionary()
        
        if (Global.kLoggedInUserData().Role == Global.kUserRole.Provider) {
            if self.strSelProviderId == "" {
                param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[providerId]")
            } else {
                param.setValue(self.strSelProviderId, forKey: "form[providerId]")
            }
            //param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        } else {
            param.setValue(self.strSelProviderId, forKey: "form[providerId]")
            param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        }
    
        param.setValue(Global.singleton.convertDateToString(dateSel: dateSelAppointment), forKey: "form[startDate]")
        param.setValue(Global.singleton.convertDateToString(dateSel: dateSelAppointment), forKey: "form[endDate]")
        print(param)
        AFAPIMaster.sharedAPIMaster.getProviderAppointmentTimelineDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            self.arrAppointments.removeAll()
            if let arrData: NSArray = dictResponse.object(forKey: "userData") as? NSArray {
                for i in 0 ..< arrData.count {
                    let dictApp: NSDictionary = arrData.object(at: i) as! NSDictionary
                    
                    var boolAppoExist: Bool = false
                    if let arrAppoint: NSArray = dictApp.object(forKey: "appointments") as? NSArray {
                        for i in 0 ..< arrAppoint.count {
                            boolAppoExist = true
                            
                            let dictAppData: NSDictionary = arrAppoint.object(at: i) as! NSDictionary
                            
                            let strIsbooked = dictAppData.value(forKey: "is_booked") as? String ?? ""
                            if strIsbooked == "No" {
                                let shareObj: AppointmentSObject = AppointmentSObject()
                                
                                shareObj.strAppId = dictAppData.object(forKey: "id") as? String ?? ""
                                shareObj.strAppTitle = String(format: "%@ %@", dictAppData.object(forKey: "firstName") as? String ?? "", dictAppData.object(forKey: "lastName") as? String ?? "")
                                
                                shareObj.strAppBGColor = dictAppData.object(forKey: "color") as? String ?? ""
                                shareObj.strAppTextColor = dictAppData.object(forKey: "textColor") as? String ?? ""
                                shareObj.strAppDate = dictAppData.object(forKey: "appointmentDate") as? String ?? ""
                                shareObj.strAppStartTime = dictAppData.object(forKey: "startTime") as? String ?? ""
                                shareObj.strAppEndTime = dictAppData.object(forKey: "endTime") as? String ?? ""
                                shareObj.strAppReason = dictAppData.object(forKey: "reasonFor") as? String ?? ""
                                
                                if let dictActions: NSDictionary = dictAppData.object(forKey: "actionButton") as? NSDictionary {
                                    shareObj.strActionApprove = dictActions.object(forKey: "approve") as? String ?? ""
                                    shareObj.strActionComplete = dictActions.object(forKey: "complete") as? String ?? ""
                                    shareObj.strActionModify = dictActions.object(forKey: "modify") as? String ?? ""
                                    shareObj.strActionCancel = dictActions.object(forKey: "cancel") as? String ?? ""
                                }
                                shareObj.strAppIsBooked = dictApp.object(forKey: "is_booked") as? String ?? ""
                                shareObj.intAppointCount = arrAppoint.count
                                self.arrAppointments.append(shareObj)

                            }
                        }
                    }

                    if (boolAppoExist == false) {
                        let shareObj: AppointmentSObject = AppointmentSObject()
                        
                        shareObj.strAppId = String(describing: dictApp.object(forKey: "") as? NSNumber ?? 0)
                        shareObj.strAppTitle = dictApp.object(forKey: "title") as? String ?? ""
                        shareObj.strAppBGColor = dictApp.object(forKey: "color") as? String ?? ""
                        shareObj.strAppTextColor = dictApp.object(forKey: "textColor") as? String ?? ""
                        shareObj.strAppDate = dictApp.object(forKey: "hidden_date") as? String ?? ""
                        shareObj.strAppStartTime = dictApp.object(forKey: "hidden_start_time") as? String ?? ""
                        shareObj.strAppEndTime = dictApp.object(forKey: "hidden_end_time") as? String ?? ""
                        shareObj.strAppIsBooked = dictApp.object(forKey: "is_booked") as? String ?? ""

                        self.arrAppointments.append(shareObj)
                    }
                }
                self.timelineAppointmentBlankSloatView.autoScrollToFirstEvent = true
                print(self.dateSelAppointmentOld)
                print(self.dateSelAppointment)
                if (self.dateSelAppointmentOld != self.dateSelAppointment) {
                    self.timelineAppointmentBlankSloatView.changeDateSelection(from: self.dateSelAppointmentOld, to: self.dateSelAppointment)
                }
                self.boolIsCalendarTimeline = true
                self.timelineAppointmentBlankSloatView.dataSource = self
                self.timelineAppointmentBlankSloatView.delegate = self
                self.timelineAppointmentBlankSloatView.reloadData()
                self.dateSelAppointmentOld = self.dateSelAppointment
            }
        })
    }
    
    
    // MARK: -  Patient View Appointment Api Call Method
    func patientViewAppointmentApi_Call() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(strSelAppoId, forKey: "form[appointmentId]")
        AFAPIMaster.sharedAPIMaster.PatientProviderAppointmentDetialApi_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if let dictDetail: NSDictionary = dictData.object(forKey: "appointment") as? NSDictionary {
                    print(dictDetail)
                    
                    let shareObj: AppointmentSObject = AppointmentSObject()
                    
                    shareObj.strAppId = dictDetail.object(forKey: "id") as? String ?? ""
                    shareObj.strAppTitle = String(format: "%@ %@", dictDetail.object(forKey: "firstName") as? String ?? "", dictDetail.object(forKey: "lastName") as? String ?? "")
                    shareObj.strFirstNameLastName = String(format: "%@ %@", dictDetail.object(forKey: "firstName") as? String ?? "", dictDetail.object(forKey: "lastName") as? String ?? "")
                    shareObj.strFirstName = dictDetail.object(forKey: "firstName") as? String ?? ""
                    shareObj.strLastName = dictDetail.object(forKey: "lastName") as? String ?? ""
                    
                    shareObj.strAppBGColor = dictDetail.object(forKey: "color") as? String ?? ""
                    shareObj.strEmail = dictDetail.object(forKey: "email") as? String ?? ""
                    
                    shareObj.strAppTextColor = dictDetail.object(forKey: "textColor") as? String ?? ""
                    self.strSelectedDate = dictDetail.object(forKey: "appointmentDate") as? String ?? ""
                    shareObj.strAppDate = dictDetail.object(forKey: "appointmentDate") as? String ?? ""
                    
                    shareObj.strAppStartTime = dictDetail.object(forKey: "startTime") as? String ?? ""
                    shareObj.strAppEndTime = dictDetail.object(forKey: "endTime") as? String ?? ""
                    shareObj.strAppReason = dictDetail.object(forKey: "reasonFor") as? String ?? ""
                    shareObj.strPatProPic = dictDetail.object(forKey: "profilePatientPictureUrl") as? String ?? ""
                    shareObj.strStausTitle = dictDetail.object(forKey: "statusLable") as? String ?? ""
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
                            let strFName = dictProDetail.object(forKey: "firstName") as? String ?? ""
                            let strLName = dictProDetail.object(forKey: "lastName") as? String ?? ""
                            shareObj.strFirstName = dictDetail.object(forKey: "firstName") as? String ?? ""
                            shareObj.strLastName = dictDetail.object(forKey: "lastName") as? String ?? ""
                            
                            shareObj.strAppTitle = ""
                            if (strSalutation.characters.count > 0) {
                                shareObj.strAppTitle = "\(strSalutation) "
                            }
                            if (strFName.characters.count > 0) {
                                shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strFName) "
                            }
                            shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strLName)"
                            //shareObj.strPatProPic = dictProDetail.object(forKey: "profilePictureUrl") as? String ?? ""
                        }
                    }
                    
                    self.appointmentDetail.add(shareObj)
                    self.timelineAppointmentView.autoScrollToFirstEvent = true
                    
                    self.timelineAppointmentView.changeDateSelection(from: Date() , to: Global.singleton.convertStringToDate(strDate: shareObj.strAppDate))
                    
                    self.boolIsCalendarTimeline = false
                    self.timelineAppointmentView.dataSource = self
                    self.timelineAppointmentView.delegate = self
                    self.timelineAppointmentView.reloadData()
                    self.timelineAppointmentView.isUserInteractionEnabled = false
                    self.setAppointmentDetailMethod()
                    
                }
            }
        })
    }
    
    // MARK: -  Set Patient Appointment Response Set Method
    func setAppointmentDetailMethod() {
        if appointmentDetail.count > 0 {
            let shareObj: AppointmentSObject = appointmentDetail[0] as! AppointmentSObject
            let dictReason: NSDictionary
            let arrFiltered = Global.appDelegate.arrReasonList.filter() {$0["id"] as? String ?? "" == shareObj.strAppReason}
            if arrFiltered.count > 0 {
                dictReason = arrFiltered[0]
                lblReasonTitle.text = dictReason.object(forKey: "name") as? String ?? ""
                lblReasonTitle.text =  dictReason.object(forKey: "name") as? String ?? ""
                lblEmail.text = dictReason.object(forKey: "name") as? String ?? ""
            } else {
                lblEmail.text = ""
            }
            
            let strModifyTemp = Global.singleton.convertDateToStringWithDayFullName(dateSel: Global.singleton.convertStringToDate(strDate:shareObj.strAppDate))

            lblFromDate.text = strModifyTemp
            
            let tempFromTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppStartTime)
            let tempToTime = Global.singleton.convertServerTimeToNewTime(strStartDate: shareObj.strAppEndTime)

            lblFromTime.text = ("\(tempFromTime) to \(tempToTime)")
            self.lblDateAndTime.text = String("\(strSelectedDate) AT \(tempFromTime) to \(tempToTime)")

            lblFullName.text = shareObj.strFirstNameLastName
            lblMessage.text = shareObj.strPersonalMessage
            
            
            if let strUrl = URL(string:shareObj.strPatProPic){
                self.imgProfilePic.sd_setImage(with: strUrl, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                    if (image != nil) {
                        self.imgProfilePic.image = image!
                    }
                    else  {
                        self.imgProfilePic.image = #imageLiteral(resourceName: "ProfileView")
                    }
                })
            }else{
                self.imgProfilePic.image = UIImage(named: "ProfileView")
            }
        }
    }
    
    // MARK: -  EventDataSource Methods of CalendarKit
    open func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        if (boolIsCalendarTimeline == true) {
            for shareObj in arrAppointments {
                let eventApp: Event = Event()
                eventApp.text = shareObj.strAppTitle
                eventApp.color = UIColor(string: shareObj.strAppBGColor)
                eventApp.backgroundColor = UIColor(string: shareObj.strAppBGColor, forAlpha: 3.3)
                eventApp.textColor = UIColor(string: shareObj.strAppBGColor)
                eventApp.datePeriod = TimePeriod(beginning: Global.singleton.convertStringToDateTime(strDate: "\(shareObj.strAppDate) \(shareObj.strAppStartTime)"), end: Global.singleton.convertStringToDateTime(strDate: "\(shareObj.strAppDate) \(shareObj.strAppEndTime)"))
                eventApp.userInfo = shareObj
                events.append(eventApp)
            }
        }
        else {
            
            for i in 0..<self.appointmentDetail.count {
                let shareObj: AppointmentSObject = self.appointmentDetail.object(at: i) as! AppointmentSObject
                let eventApp: Event = Event()
                eventApp.text = shareObj.strAppTitle

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
                
            }
        }
        return events
    }
}

// MARK: -
extension PR_AppointmentModifyVC {
    
    // MARK: -  Button Send Inquiry Click Method
    @IBAction func btnSendInquiryClick(_ sender: UIButton) {
        if  txtReasonMessage.text == Global().getLocalizeStr(key: "keyReasonForChange") {
            self.txtReasonMessage.becomeFirstResponder()
        } else if self.txtReasonMessage.text.characters.count == 0 || txtReasonMessage.text.isEmpty || self.txtReasonMessage.text == "" {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyReasonAlert"))
        }else {
            let param: NSMutableDictionary = NSMutableDictionary()
            let shareObj: AppointmentSObject = self.appointmentDetail.object(at: 0) as! AppointmentSObject
            print(shareObj)
            param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
            
            
            if (Global.kLoggedInUserData().Role == Global.kUserRole.Provider) {
                if self.strSelProviderId == "" {
                    param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[providerId]")
                } else {
                    param.setValue(self.strSelProviderId, forKey: "form[providerId]")
                }
                //param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
            } else {
                param.setValue(self.strSelProviderId, forKey: "form[providerId]")
            }
            
            
            param.setValue(Global.singleton.emojisEncodedConvertedString(strText:shareObj.strFirstName), forKey: "form[firstName]")
            param.setValue(Global.singleton.emojisEncodedConvertedString(strText: shareObj.strLastName), forKey: "form[lastName]")
            param.setValue(Global.singleton.emojisEncodedConvertedString(strText: ""), forKey: "form[phoneNumber]")
            param.setValue(Global.singleton.emojisEncodedConvertedString(strText: txtReasonMessage.text), forKey: "form[personalMessage]")
            param.setValue(Global.singleton.emojisEncodedConvertedString(strText:shareObj.strEmail), forKey: "form[email]")
            
            if (self.dateSelAppointmentOld == self.dateAppointmentModify) {
                param.setValue(Global.singleton.convertDateToString(dateSel: self.dateAppointmentModify), forKey: "form[appointmentDate]")
                param.setValue(strAppointmentStartTime, forKey: "form[appointmentFromTime]")
                param.setValue(strAppointmentEndTime, forKey: "form[appointmentToTime]")
            } else {
                param.setValue(shareObj.strAppDate, forKey: "form[appointmentDate]")
                param.setValue(shareObj.strAppStartTime, forKey: "form[appointmentFromTime]")
                param.setValue(shareObj.strAppEndTime, forKey: "form[appointmentToTime]")
            }
            
            param.setValue(shareObj.strAppReason, forKey: "form[reason]")
            param.setValue(strSelAppoId, forKey: "form[appointmentId]")
            
            print(param)
            
            AFAPIMaster.sharedAPIMaster.PatientCreateAppointmentApi_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
                let dictResponse: NSDictionary = returnData as! NSDictionary
                Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
                if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                    print(dictData)
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
            })
        }
    }
    
    // MARK: -  Button Back Click Method
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: -  Button Animation Click Method
    @IBAction func btnAnimationClick(_ sender: UIButton) {
        if animationConst.constant == 0 {
            animationConst.constant = 337
            btnAnimation.setTitle("", for: UIControlState.normal)
            self.scrView.contentSize = CGSize(width: scrView.frame.width, height: scrView.contentSize.height + 337)
        } else {
            self.scrView.contentSize = CGSize(width: scrView.frame.width, height: scrView.contentSize.height - 337)
            scrView.scrollToTop()
            animationConst.constant = 0
            btnAnimation.setTitle("", for: UIControlState.normal)
        }
    }
}

// MARK: -
extension PR_AppointmentModifyVC: UITextViewDelegate {
    
    // MARK: -  UITextView Delegate
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == txtReasonMessage) {
            if (textView.text == Global().getLocalizeStr(key: "keyReasonForChange")) {
                textView.text = ""
                textView.textColor = Global.kAppColor.GrayDark
                
            }
        } else {
            if (textView.text == Global().getLocalizeStr(key: "keyPSRejectReason")) {
                textView.text = ""
                textView.textColor = Global.kAppColor.GrayDark
            }
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
        if (textView == txtReasonMessage) {
            if (textView.text == "") {
                textView.text = Global().getLocalizeStr(key: "keyReasonForChange")
                textView.textColor = Global.kAppColor.GrayLight
            }
        } else {
            if (textView.text == "") {
                textView.text = Global().getLocalizeStr(key: "keyPSRejectReason")
                textView.textColor = Global.kAppColor.GrayLight
            }
        }
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
