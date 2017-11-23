//
//  ProviderSchedulingVC.swift
//  Meopin
//
//  Created by Tops on 9/18/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import FSCalendar
import CalendarKit
import DateToolsSwift
import TOActionSheet
import IQKeyboardManagerSwift

class ProviderSchedulingVC: UIViewController, EventDataSource {
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var btnAppointment: UIButton!
    @IBOutlet var btnConfiguration: UIButton!
    @IBOutlet var btnTimeSlot: UIButton!
    
    @IBOutlet var viewAppointment: UIView!
    @IBOutlet var btnListCalendarView: UIButton!
    @IBOutlet var tblAppointmentList: UITableView!
    @IBOutlet var viewCalendarAppointment: UIView!
    @IBOutlet var calendarAppointment: FSCalendar!
    @IBOutlet var lblAppointmentSelDate: UILabel!
    
    @IBOutlet var timelineAppointmentView: TimelinePagerView!
    
    @IBOutlet var viewConfiguration: UIView!
    @IBOutlet var tblConfig: UITableView!
    
    @IBOutlet var viewTimeSlots: UIView!
    @IBOutlet var tblTimeSlots: UITableView!
    @IBOutlet var viewMinsPicker: UIView!
    @IBOutlet var btnCancelMins: UIButton!
    @IBOutlet var btnSaveMins: UIButton!
    @IBOutlet var pickerTimeSlotMins: UIPickerView!
    @IBOutlet var lblTimeSlotMins: UILabel!
    
    @IBOutlet var viewMinsPickerYConst: NSLayoutConstraint!
    @IBOutlet var calendarAppointmentHeightConst: NSLayoutConstraint!
    
    var mySlideViewObj: MySlideViewController?
    
    var arrAppointments: [AppointmentSObject] = [AppointmentSObject]()
    var arrAppointmentsAllDate: [AppointmentDateSObject] = [AppointmentDateSObject]()
    
    var arrDayAvailibility: [DayAvailibilitySObject] = [DayAvailibilitySObject]()
    var arrLeaves: [LeaveSObject] = [LeaveSObject]()
    var arrSpecialRules: [SpecialRuleSObject] = [SpecialRuleSObject]()
    
    var arrTimeSlots: [TimeSlotSObject] = [TimeSlotSObject]()
    
    var arrNthDay: [ScheduleNthDaySObject] = [ScheduleNthDaySObject]()
    var arrNthDate: [ScheduleNthDaySObject] = [ScheduleNthDaySObject]()
    
    var dateSelAppointment: Date = Date()
    var dateSelAppointmentOld: Date = Date()
    
    var boolIsAppointmentSel: Bool = false
    var boolIsFromSlideMenu: Bool = true
    
    var actionRejectPopup: UIAlertController?
    
    // MARK: -  Calendar Scope Gesture
    fileprivate lazy var calendarScopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarAppointment, action: #selector(self.calendarAppointment.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        
        viewMinsPickerYConst.constant = Global.screenHeight
        
        tblConfig.register(UINib(nibName: "SchedulingConfigCell", bundle: nil), forCellReuseIdentifier: "SchedulingConfigCell")
        tblTimeSlots.register(UINib(nibName: "SchedulingConfigCell", bundle: nil), forCellReuseIdentifier: "SchedulingConfigCell")
        
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
        
        self.view.addGestureRecognizer(self.calendarScopeGesture)
        
        tblAppointmentList.register(UINib(nibName: "CalendarAgendaViewCell", bundle: nil), forCellReuseIdentifier: "CalendarAgendaViewCell")
        
        btnListCalendarView.layer.masksToBounds = true
        btnListCalendarView.layer.cornerRadius = 4
        
        tblAppointmentList.isHidden = true
        
        self.fillDayAvailibilityArray()
        self.fillTimeSlotArray()
        self.fillNthDayArray()
        self.fillNthDateArray()
        
        if (boolIsAppointmentSel) {
            btnAppointment.isSelected = true
            btnConfiguration.isSelected = false
            btnTimeSlot.isSelected = false
            
            viewAppointment.isHidden = false
            viewConfiguration.isHidden = true
            viewTimeSlots.isHidden = true
        }
        else {
            btnAppointment.isSelected = false
            btnConfiguration.isSelected = true
            btnTimeSlot.isSelected = false
            
            viewAppointment.isHidden = true
            viewConfiguration.isHidden = false
            viewTimeSlots.isHidden = true
        }
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
        
        self.getProviderSchedulingConfigCall()
        
        if (btnListCalendarView.tag == 0) {
            self.getAppointmentScheduleForSelDateCall()
        }
        else {
            self.getAgendaViewAppointmentScheduleCall()
        }
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
        
        btnAppointment.setTitle(Global().getLocalizeStr(key: "keyPSAppointment"), for: .normal)
        btnConfiguration.setTitle(Global().getLocalizeStr(key: "keyPSConfiguration"), for: .normal)
        btnTimeSlot.setTitle(Global().getLocalizeStr(key: "keyPSTimeSlots"), for: .normal)
        
        lblAppointmentSelDate.text = Global.singleton.convertDateToStringWithDayFullName(dateSel: dateSelAppointment)
        
        btnCancelMins.setTitle(Global().getLocalizeStr(key: "keyCancel"), for: .normal)
        btnSaveMins.setTitle(Global().getLocalizeStr(key: "keySave"), for: .normal)
        lblTimeSlotMins.text = Global().getLocalizeStr(key: "keyPSMins")
        
        tblConfig.reloadData()
        tblTimeSlots.reloadData()
    }
    
    func setDeviceSpecificFonts() {
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        btnAppointment.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        btnConfiguration.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        btnTimeSlot.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        
        lblAppointmentSelDate.font = UIFont(name: "HelveticaNeue", size: Global.singleton.getDeviceSpecificFontSize(13))
        
        btnCancelMins.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        btnSaveMins.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblTimeSlotMins.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(19))
    }
        
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension ProviderSchedulingVC {
    // MARK: -  API Call
    func getProviderSchedulingConfigCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.getProviderSchedulingDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                //Availabilities
                for shareObj in self.arrDayAvailibility {
                    shareObj.arrDayShift.removeAll()
                }
                if let dictAvailable: NSDictionary = dictData.object(forKey: "availabilities") as? NSDictionary {
                    //Monday
                    if let arrMonday: NSArray = dictAvailable.object(forKey: "monday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[0]
                        for i in 0 ..< arrMonday.count {
                            if let dictShift: NSDictionary = arrMonday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Tuesday
                    if let arrTuesday: NSArray = dictAvailable.object(forKey: "tuesday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[1]
                        for i in 0 ..< arrTuesday.count {
                            if let dictShift: NSDictionary = arrTuesday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Wednesday
                    if let arrWednesday: NSArray = dictAvailable.object(forKey: "wednesday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[2]
                        for i in 0 ..< arrWednesday.count {
                            if let dictShift: NSDictionary = arrWednesday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Thursday
                    if let arrThursday: NSArray = dictAvailable.object(forKey: "thursday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[3]
                        for i in 0 ..< arrThursday.count {
                            if let dictShift: NSDictionary = arrThursday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Friday
                    if let arrFriday: NSArray = dictAvailable.object(forKey: "friday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[4]
                        for i in 0 ..< arrFriday.count {
                            if let dictShift: NSDictionary = arrFriday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Saturday
                    if let arrSaturday: NSArray = dictAvailable.object(forKey: "saturday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[5]
                        for i in 0 ..< arrSaturday.count {
                            if let dictShift: NSDictionary = arrSaturday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Sunday
                    if let arrSunday: NSArray = dictAvailable.object(forKey: "sunday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[6]
                        for i in 0 ..< arrSunday.count {
                            if let dictShift: NSDictionary = arrSunday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                }
                
                //Time Slots
                let strTimeSlot: String = dictData.object(forKey: "appointmentInterval") as? String ?? ""
                var boolSlotIsFound: Bool = false
                for i in 0 ..< self.arrTimeSlots.count {
                    let shareObj: TimeSlotSObject = self.arrTimeSlots[i]
                    if (shareObj.strTimeSlotMins == strTimeSlot) {
                        shareObj.boolIsSelected = true
                        boolSlotIsFound = true
                    }
                    else {
                        shareObj.boolIsSelected = false
                    }
                    
                    if (i == 7 && boolSlotIsFound == false) {
                        shareObj.strTimeSlotMins = strTimeSlot
                        shareObj.boolIsSelected = true
                    }
                }
                self.pickerTimeSlotMins.selectRow(Int(strTimeSlot)!-1, inComponent: 0, animated: false)
                
                //Leave
                self.arrLeaves.removeAll()
                if let arrTempLeaves: NSArray = dictData.object(forKey: "leaves") as? NSArray {
                    for i in 0 ..< arrTempLeaves.count {
                        if let dictLeaves: NSDictionary = arrTempLeaves.object(at: i) as? NSDictionary {
                            let shareObjLeave: LeaveSObject = LeaveSObject()
                            shareObjLeave.strLeaveId = dictLeaves.object(forKey: "id") as? String ?? ""
                            shareObjLeave.strLeaveStartDate = dictLeaves.object(forKey: "fromTime") as? String ?? ""
                            shareObjLeave.strLeaveEndDate = dictLeaves.object(forKey: "toTime") as? String ?? ""
                            shareObjLeave.strLeaveDays = dictLeaves.object(forKey: "totalDays") as? String ?? ""
                            self.arrLeaves.append(shareObjLeave)
                        }
                    }
                }
                
                //nth Day
                self.arrNthDay.removeAll()
                if let dictTempNthDay: NSDictionary = dictData.object(forKey: "nthDay") as? NSDictionary {
                    for i in 1 ..< dictTempNthDay.count+1 {
                        let shareObj: ScheduleNthDaySObject = ScheduleNthDaySObject()
                        shareObj.strDayId = "\(i)"
                        shareObj.strDayValue = dictTempNthDay.object(forKey: "\(i)") as? String ?? ""
                        self.arrNthDay.append(shareObj)
                    }
                }
                
                //nth Date
                self.arrNthDate.removeAll()
                if let dictTempNthDate: NSDictionary = dictData.object(forKey: "nthDate") as? NSDictionary {
                    for i in 1 ..< dictTempNthDate.count+1 {
                        let shareObj: ScheduleNthDaySObject = ScheduleNthDaySObject()
                        shareObj.strDayId = "\(i)"
                        shareObj.strDayValue = dictTempNthDate.object(forKey: "\(i)") as? String ?? ""
                        self.arrNthDate.append(shareObj)
                    }
                }
                
                //Special Rules
                self.arrSpecialRules.removeAll()
                if let arrTempRules: NSArray = dictData.object(forKey: "specialRules") as? NSArray {
                    for i in 0 ..< arrTempRules.count {
                        if let dictRules: NSDictionary = arrTempRules.object(at: i) as? NSDictionary {
                            let shareObj: SpecialRuleSObject = SpecialRuleSObject()
                            shareObj.strRuleId = dictRules.object(forKey: "id") as? String ?? ""
                            shareObj.strRuleType = dictRules.object(forKey: "ruleType") as? String ?? ""
                            shareObj.strRuleNthDay = dictRules.object(forKey: "nthDay") as? String ?? ""
                            shareObj.strRuleNthDate = dictRules.object(forKey: "nthDate") as? String ?? ""
                            shareObj.strRuleFromTime = dictRules.object(forKey: "fromTime") as? String ?? ""
                            shareObj.strRuleToTime = dictRules.object(forKey: "toTime") as? String ?? ""
                            shareObj.strRuleTitle = dictRules.object(forKey: "label") as? String ?? ""
                            self.arrSpecialRules.append(shareObj)
                        }
                    }
                }

                self.tblConfig.reloadData()
                self.tblTimeSlots.reloadData()
            }
        })
    }
    
    func setProviderTimeSlotCall(strMins: String) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(strMins, forKey: "form[appointmentInterval]")
        
        AFAPIMaster.sharedAPIMaster.setProviderTimeSlotDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                //Availabilities
                for shareObj in self.arrDayAvailibility {
                    shareObj.arrDayShift.removeAll()
                }
                if let dictAvailable: NSDictionary = dictData.object(forKey: "availabilities") as? NSDictionary {
                    //Monday
                    if let arrMonday: NSArray = dictAvailable.object(forKey: "monday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[0]
                        for i in 0 ..< arrMonday.count {
                            if let dictShift: NSDictionary = arrMonday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Tuesday
                    if let arrTuesday: NSArray = dictAvailable.object(forKey: "tuesday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[1]
                        for i in 0 ..< arrTuesday.count {
                            if let dictShift: NSDictionary = arrTuesday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Wednesday
                    if let arrWednesday: NSArray = dictAvailable.object(forKey: "wednesday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[2]
                        for i in 0 ..< arrWednesday.count {
                            if let dictShift: NSDictionary = arrWednesday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Thursday
                    if let arrThursday: NSArray = dictAvailable.object(forKey: "thursday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[3]
                        for i in 0 ..< arrThursday.count {
                            if let dictShift: NSDictionary = arrThursday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Friday
                    if let arrFriday: NSArray = dictAvailable.object(forKey: "friday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[4]
                        for i in 0 ..< arrFriday.count {
                            if let dictShift: NSDictionary = arrFriday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Saturday
                    if let arrSaturday: NSArray = dictAvailable.object(forKey: "saturday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[5]
                        for i in 0 ..< arrSaturday.count {
                            if let dictShift: NSDictionary = arrSaturday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                    
                    //Sunday
                    if let arrSunday: NSArray = dictAvailable.object(forKey: "sunday") as? NSArray {
                        let shareObj = self.arrDayAvailibility[6]
                        for i in 0 ..< arrSunday.count {
                            if let dictShift: NSDictionary = arrSunday.object(at: i) as? NSDictionary {
                                let shareObjShift: DayShiftSObject = DayShiftSObject()
                                shareObjShift.strShiftId = dictShift.object(forKey: "id") as? String ?? ""
                                shareObjShift.strShiftStartTime = dictShift.object(forKey: "fromTime") as? String ?? ""
                                shareObjShift.strShiftEndTime = dictShift.object(forKey: "toTime") as? String ?? ""
                                
                                shareObj.arrDayShift.append(shareObjShift)
                            }
                        }
                    }
                }
                
                //Time Slots
                let strTimeSlot: String = dictData.object(forKey: "appointmentInterval") as? String ?? ""
                var boolSlotIsFound: Bool = false
                for i in 0 ..< self.arrTimeSlots.count {
                    let shareObj: TimeSlotSObject = self.arrTimeSlots[i]
                    if (shareObj.strTimeSlotMins == strTimeSlot) {
                        shareObj.boolIsSelected = true
                        boolSlotIsFound = true
                    }
                    else {
                        shareObj.boolIsSelected = false
                    }
                    
                    if (i == 7 && boolSlotIsFound == false) {
                        shareObj.strTimeSlotMins = strTimeSlot
                        shareObj.boolIsSelected = true
                    }
                }
                self.pickerTimeSlotMins.selectRow(Int(strTimeSlot)!-1, inComponent: 0, animated: false)
                
                //Leave
                self.arrLeaves.removeAll()
                if let arrTempLeaves: NSArray = dictData.object(forKey: "leaves") as? NSArray {
                    for i in 0 ..< arrTempLeaves.count {
                        if let dictLeaves: NSDictionary = arrTempLeaves.object(at: i) as? NSDictionary {
                            let shareObjLeave: LeaveSObject = LeaveSObject()
                            shareObjLeave.strLeaveId = dictLeaves.object(forKey: "id") as? String ?? ""
                            shareObjLeave.strLeaveStartDate = dictLeaves.object(forKey: "fromTime") as? String ?? ""
                            shareObjLeave.strLeaveEndDate = dictLeaves.object(forKey: "toTime") as? String ?? ""
                            shareObjLeave.strLeaveDays = dictLeaves.object(forKey: "totalDays") as? String ?? ""
                            self.arrLeaves.append(shareObjLeave)
                        }
                    }
                }
                
                
                //nth Day
                self.arrNthDay.removeAll()
                if let dictTempNthDay: NSDictionary = dictData.object(forKey: "nthDay") as? NSDictionary {
                    for i in 1 ..< dictTempNthDay.count+1 {
                        let shareObj: ScheduleNthDaySObject = ScheduleNthDaySObject()
                        shareObj.strDayId = "\(i)"
                        shareObj.strDayValue = dictTempNthDay.object(forKey: "\(i)") as? String ?? ""
                        self.arrNthDay.append(shareObj)
                    }
                }
                
                //nth Date
                self.arrNthDate.removeAll()
                if let dictTempNthDate: NSDictionary = dictData.object(forKey: "nthDate") as? NSDictionary {
                    for i in 1 ..< dictTempNthDate.count+1 {
                        let shareObj: ScheduleNthDaySObject = ScheduleNthDaySObject()
                        shareObj.strDayId = "\(i)"
                        shareObj.strDayValue = dictTempNthDate.object(forKey: "\(i)") as? String ?? ""
                        self.arrNthDate.append(shareObj)
                    }
                }
                
                //Special Rules
                self.arrSpecialRules.removeAll()
                if let arrTempRules: NSArray = dictData.object(forKey: "specialRules") as? NSArray {
                    for i in 0 ..< arrTempRules.count {
                        if let dictRules: NSDictionary = arrTempRules.object(at: i) as? NSDictionary {
                            let shareObj: SpecialRuleSObject = SpecialRuleSObject()
                            shareObj.strRuleId = dictRules.object(forKey: "id") as? String ?? ""
                            shareObj.strRuleType = dictRules.object(forKey: "ruleType") as? String ?? ""
                            shareObj.strRuleNthDay = dictRules.object(forKey: "nthDay") as? String ?? ""
                            shareObj.strRuleNthDate = dictRules.object(forKey: "nthDate") as? String ?? ""
                            shareObj.strRuleFromTime = dictRules.object(forKey: "fromTime") as? String ?? ""
                            shareObj.strRuleToTime = dictRules.object(forKey: "toTime") as? String ?? ""
                            shareObj.strRuleTitle = dictRules.object(forKey: "label") as? String ?? ""
                            self.arrSpecialRules.append(shareObj)
                        }
                    }
                }
                
                self.tblConfig.reloadData()
                self.tblTimeSlots.reloadData()
            }
        })
    }
    
    func getAppointmentScheduleForSelDateCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[providerId]")
        param.setValue(Global.singleton.convertDateToString(dateSel: dateSelAppointment), forKey: "form[startDate]")
        param.setValue(Global.singleton.convertDateToString(dateSel: dateSelAppointment), forKey: "form[endDate]")
        
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
                self.timelineAppointmentView.autoScrollToFirstEvent = true
                if (self.dateSelAppointmentOld != self.dateSelAppointment) {
                    self.timelineAppointmentView.changeDateSelection(from: self.dateSelAppointmentOld, to: self.dateSelAppointment)
                }
                self.timelineAppointmentView.dataSource = self
                self.timelineAppointmentView.delegate = self
                self.timelineAppointmentView.reloadData()
                self.dateSelAppointmentOld = self.dateSelAppointment
            }
        })
    }
    
    func getAgendaViewAppointmentScheduleCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
//        param.setValue(Global.singleton.convertDateToString(dateSel: Date()), forKey: "form[fromDate]")
//        let calendar = Calendar.current
//        param.setValue(Global.singleton.convertDateToString(dateSel: calendar.date(byAdding: .month, value: 3, to: dateSelAppointment)!), forKey: "form[toDate]")
        
        arrAppointments.removeAll()
        arrAppointmentsAllDate.removeAll()
        AFAPIMaster.sharedAPIMaster.getAgendaViewListDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
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
                                        
                                        if let dictActions: NSDictionary = dictDetail.object(forKey: "actionButton") as? NSDictionary {
                                            shareObj.strActionApprove = dictActions.object(forKey: "approve") as? String ?? ""
                                            shareObj.strActionComplete = dictActions.object(forKey: "complete") as? String ?? ""
                                            shareObj.strActionModify = dictActions.object(forKey: "modify") as? String ?? ""
                                            shareObj.strActionCancel = dictActions.object(forKey: "cancel") as? String ?? ""
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
            self.tblAppointmentList.reloadData()
            
            let arrFiltered = self.arrAppointmentsAllDate.filter() {$0.strDate == Global.singleton.convertDateToString(dateSel: self.dateSelAppointment)}
            if arrFiltered.count > 0 {
                self.tblAppointmentList.scrollToRow(at: IndexPath(row: 0, section: self.arrAppointmentsAllDate.index(of: arrFiltered[0])!), at: .top, animated: true)
            }
            else {
                self.tblAppointmentList.setContentOffset(CGPoint.zero, animated: true)
            }
        })
    }
    
    func acceptAppointmentRequestCall(_ shareObj: AppointmentSObject) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        
        AFAPIMaster.sharedAPIMaster.acceptAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            if (self.btnListCalendarView.tag == 0) {
                self.getAppointmentScheduleForSelDateCall()
            }
            else {
                self.getAgendaViewAppointmentScheduleCall()
            }
        })
    }
    
    func rejectAppointmentRequestCall(_ shareObj: AppointmentSObject, strReason: String) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        param.setValue(strReason, forKey: "form[reason]")
        
        AFAPIMaster.sharedAPIMaster.rejectAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            if (self.btnListCalendarView.tag == 0) {
                self.getAppointmentScheduleForSelDateCall()
            }
            else {
                self.getAgendaViewAppointmentScheduleCall()
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAppointmentClick(_ sender: Any) {
        btnAppointment.isSelected = true
        btnConfiguration.isSelected = false
        btnTimeSlot.isSelected = false
        
        viewAppointment.isHidden = false
        viewConfiguration.isHidden = true
        viewTimeSlots.isHidden = true
        
        if (btnListCalendarView.tag == 0) {
            self.getAppointmentScheduleForSelDateCall()
        }
        else {
            self.getAgendaViewAppointmentScheduleCall()
        }
    }
    
    @IBAction func btnConfigurationClick(_ sender: Any) {
        btnAppointment.isSelected = false
        btnConfiguration.isSelected = true
        btnTimeSlot.isSelected = false
        
        viewAppointment.isHidden = true
        viewConfiguration.isHidden = false
        viewTimeSlots.isHidden = true
    }
    
    @IBAction func btnTimeSlotClick(_ sender: Any) {
        btnAppointment.isSelected = false
        btnConfiguration.isSelected = false
        btnTimeSlot.isSelected = true
        
        viewAppointment.isHidden = true
        viewConfiguration.isHidden = true
        viewTimeSlots.isHidden = false
    }
    
    @IBAction func btnCancelMinsClick(_ sender: Any) {
        self.viewMinsPickerYConst.constant = Global.screenHeight
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnListCalendarViewClick(_ sender: Any) {
        if (btnListCalendarView.tag == 0) {
            viewCalendarAppointment.isHidden = true
            tblAppointmentList.isHidden = false
            btnListCalendarView.tag = 1
            btnListCalendarView.setTitleColor(.white, for: .normal)
            btnListCalendarView.backgroundColor = Global.kAppColor.Red
            
            self.getAgendaViewAppointmentScheduleCall()
        }
        else {
            viewCalendarAppointment.isHidden = false
            tblAppointmentList.isHidden = true
            btnListCalendarView.tag = 0
            btnListCalendarView.setTitleColor(Global.kAppColor.Red, for: .normal)
            btnListCalendarView.backgroundColor = .clear
            
            self.getAppointmentScheduleForSelDateCall()
        }
    }
    
    @IBAction func btnSaveMinsClick(_ sender: Any) {
        self.viewMinsPickerYConst.constant = Global.screenHeight
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        self.setProviderTimeSlotCall(strMins: "\(pickerTimeSlotMins.selectedRow(inComponent: 0)+1)")
    }
    
    // MARK: -  Fill Array Method
    func fillDayAvailibilityArray() {
        arrDayAvailibility.removeAll()
        
        let shareObj1: DayAvailibilitySObject = DayAvailibilitySObject()
        shareObj1.strDayId = "1"
        shareObj1.strDayWSKey = "monday"
        shareObj1.strDayTitle = "keyPSMonday"
        arrDayAvailibility.append(shareObj1)
        
        let shareObj2: DayAvailibilitySObject = DayAvailibilitySObject()
        shareObj2.strDayId = "2"
        shareObj2.strDayWSKey = "tuesday"
        shareObj2.strDayTitle = "keyPSTuesday"
        arrDayAvailibility.append(shareObj2)
        
        let shareObj3: DayAvailibilitySObject = DayAvailibilitySObject()
        shareObj3.strDayId = "3"
        shareObj3.strDayWSKey = "wednesday"
        shareObj3.strDayTitle = "keyPSWednesday"
        arrDayAvailibility.append(shareObj3)
        
        let shareObj4: DayAvailibilitySObject = DayAvailibilitySObject()
        shareObj4.strDayId = "4"
        shareObj4.strDayWSKey = "thursday"
        shareObj4.strDayTitle = "keyPSThursday"
        arrDayAvailibility.append(shareObj4)
        
        let shareObj5: DayAvailibilitySObject = DayAvailibilitySObject()
        shareObj5.strDayId = "5"
        shareObj5.strDayWSKey = "friday"
        shareObj5.strDayTitle = "keyPSFriday"
        arrDayAvailibility.append(shareObj5)
        
        let shareObj6: DayAvailibilitySObject = DayAvailibilitySObject()
        shareObj6.strDayId = "6"
        shareObj6.strDayWSKey = "saturday"
        shareObj6.strDayTitle = "keyPSSaturday"
        arrDayAvailibility.append(shareObj6)
        
        let shareObj7: DayAvailibilitySObject = DayAvailibilitySObject()
        shareObj7.strDayId = "7"
        shareObj7.strDayWSKey = "sunday"
        shareObj7.strDayTitle = "keyPSSunday"
        arrDayAvailibility.append(shareObj7)
    }
    
    func fillTimeSlotArray() {
        arrTimeSlots.removeAll()
        
        let shareObj1: TimeSlotSObject = TimeSlotSObject()
        shareObj1.strTimeSlotId = "1"
        shareObj1.strTimeSlotMins = "15"
        arrTimeSlots.append(shareObj1)
        
        let shareObj2: TimeSlotSObject = TimeSlotSObject()
        shareObj2.strTimeSlotId = "2"
        shareObj2.strTimeSlotMins = "20"
        arrTimeSlots.append(shareObj2)
        
        let shareObj3: TimeSlotSObject = TimeSlotSObject()
        shareObj3.strTimeSlotId = "3"
        shareObj3.strTimeSlotMins = "30"
        arrTimeSlots.append(shareObj3)
        
        let shareObj4: TimeSlotSObject = TimeSlotSObject()
        shareObj4.strTimeSlotId = "4"
        shareObj4.strTimeSlotMins = "45"
        arrTimeSlots.append(shareObj4)
        
        let shareObj5: TimeSlotSObject = TimeSlotSObject()
        shareObj5.strTimeSlotId = "5"
        shareObj5.strTimeSlotMins = "60"
        arrTimeSlots.append(shareObj5)
        
        let shareObj6: TimeSlotSObject = TimeSlotSObject()
        shareObj6.strTimeSlotId = "6"
        shareObj6.strTimeSlotMins = "90"
        arrTimeSlots.append(shareObj6)
        
        let shareObj7: TimeSlotSObject = TimeSlotSObject()
        shareObj7.strTimeSlotId = "7"
        shareObj7.strTimeSlotMins = "120"
        arrTimeSlots.append(shareObj7)
        
        let shareObj8: TimeSlotSObject = TimeSlotSObject()
        shareObj8.strTimeSlotId = "8"
        shareObj8.strTimeSlotMins = ""
        shareObj8.boolIsTypeDefualt = false
        arrTimeSlots.append(shareObj8)
    }
    
    func fillNthDayArray() {
        let shareObj1: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj1.strDayId = "1"
        shareObj1.strDayValue = "First"
        arrNthDay.append(shareObj1)
        
        let shareObj2: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj2.strDayId = "2"
        shareObj2.strDayValue = "Second"
        arrNthDay.append(shareObj2)
        
        let shareObj3: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj3.strDayId = "3"
        shareObj3.strDayValue = "Third"
        arrNthDay.append(shareObj3)
        
        let shareObj4: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj4.strDayId = "4"
        shareObj4.strDayValue = "Fourth"
        arrNthDay.append(shareObj4)
        
        let shareObj5: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj5.strDayId = "5"
        shareObj5.strDayValue = "Last"
        arrNthDay.append(shareObj5)
    }
    
    func fillNthDateArray() {
        let shareObj1: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj1.strDayId = "1"
        shareObj1.strDayValue = "Day"
        arrNthDate.append(shareObj1)
        
        let shareObj2: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj2.strDayId = "2"
        shareObj2.strDayValue = "Weekday"
        arrNthDate.append(shareObj2)
        
        let shareObj3: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj3.strDayId = "3"
        shareObj3.strDayValue = "Weekend"
        arrNthDate.append(shareObj3)
        
        let shareObj4: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj4.strDayId = "4"
        shareObj4.strDayValue = "Monday"
        arrNthDate.append(shareObj4)
        
        let shareObj5: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj5.strDayId = "5"
        shareObj5.strDayValue = "Tuesday"
        arrNthDate.append(shareObj5)
        
        let shareObj6: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj6.strDayId = "6"
        shareObj6.strDayValue = "Wednesday"
        arrNthDate.append(shareObj6)
        
        let shareObj7: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj7.strDayId = "7"
        shareObj7.strDayValue = "Thursday"
        arrNthDate.append(shareObj7)
        
        let shareObj8: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj8.strDayId = "8"
        shareObj8.strDayValue = "Friday"
        arrNthDate.append(shareObj8)
        
        let shareObj9: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj9.strDayId = "9"
        shareObj9.strDayValue = "Saturday"
        arrNthDate.append(shareObj9)
        
        let shareObj10: ScheduleNthDaySObject = ScheduleNthDaySObject()
        shareObj10.strDayId = "10"
        shareObj10.strDayValue = "Sunday"
        arrNthDate.append(shareObj10)
    }
}

// MARK: -
extension ProviderSchedulingVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == tblConfig) {
            return 3
        }
        else if (tableView == tblTimeSlots) {
            return 2
        }
        else if (tableView == tblAppointmentList) {
            return arrAppointmentsAllDate.count
        }
        else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tblConfig) {
            if (section == 0) {
                return arrDayAvailibility.count
            }
            else {
                return 1
            }
        }
        else if (tableView == tblTimeSlots) {
            if (section == 0) {
                return arrTimeSlots.count - 1
            }
            else {
                return 1
            }
        }
        else if (tableView == tblAppointmentList) {
            let shareObjDate: AppointmentDateSObject = arrAppointmentsAllDate[section]
            return shareObjDate.arrSlots.count
        }
        else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (tableView == tblAppointmentList) {
            return Global.singleton.getDeviceSpecificFontSize(22)
        }
        if (section == 0) {
            return 21
        }
        else {
            return 40
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (tableView == tblAppointmentList) {
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
            
            if (Global.singleton.convertDateToString(dateSel: dateSelAppointment) == shareObjDate.strDate) {
                lblDateTitle.textColor = Global.kAppColor.Red
            }
            else {
                lblDateTitle.textColor = Global().RGB(r: 45, g: 45, b: 45, a: 1)
            }
            viewHeader.addSubview(lblDateTitle)
            
            return viewHeader
        }
        else {
            return UIView()
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == tblAppointmentList) {
            return Global.singleton.getDeviceSpecificFontSize(32)
        }
        else {
            return Global.singleton.getDeviceSpecificFontSize(38)
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tblAppointmentList) {
            let cell: CalendarAgendaViewCell = tableView.dequeueReusableCell(withIdentifier: "CalendarAgendaViewCell", for: indexPath) as! CalendarAgendaViewCell
            cell.setLanguageTitles()
            
            let shareObjDate = arrAppointmentsAllDate[indexPath.section]
            let shareObj = shareObjDate.arrSlots[indexPath.row]
            
            cell.lblStartTime.text = String(shareObj.strAppStartTime.characters.dropLast(3))
            cell.lblEndTime.text = String(shareObj.strAppEndTime.characters.dropLast(3))
            cell.lblTitle.text = shareObj.strAppTitle
            
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
        else if (tableView == tblConfig) {
            let cell: SchedulingConfigCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingConfigCell", for: indexPath) as! SchedulingConfigCell
            cell.setLanguageTitles()
            
            cell.btnSelected.isHidden = true
            
            if (indexPath.section == 0) {
                let shareObj = arrDayAvailibility[indexPath.row]
                cell.lblTitle.text = Global().getLocalizeStr(key: shareObj.strDayTitle)
                
                if (shareObj.arrDayShift.count <= 0) {
                    cell.btnValue.setTitle(Global().getLocalizeStr(key: "keyPSSelect"), for: .normal)
                }
                else {
                    var strValue: String = ""
                    for i in 0 ..< shareObj.arrDayShift.count {
                        let shareObjShift = shareObj.arrDayShift[i]
                        strValue = "\(strValue)\(shareObjShift.strShiftStartTime) \(Global().getLocalizeStr(key: "keyPSTo")) \(shareObjShift.strShiftEndTime)  |  "
                    }
                    if (strValue.characters.count > 0) {
                        let strIndex = strValue.index(strValue.startIndex, offsetBy: strValue.characters.count - 5)
                        strValue = strValue.substring(to: strIndex)
                    }
                    cell.btnValue.setTitle(strValue, for: .normal)
                }
            }
            else if (indexPath.section == 1) {
                cell.lblTitle.text = Global().getLocalizeStr(key: "keyPSOnLeave")
                cell.btnValue.setTitle(String(arrLeaves.count), for: .normal)
            }
            else if (indexPath.section == 2) {
                cell.lblTitle.text = Global().getLocalizeStr(key: "keyPSSpecialRules")
                cell.btnValue.setTitle(String(arrSpecialRules.count), for: .normal)
            }
            return cell
        }
        else if (tableView == tblTimeSlots) {
            let cell: SchedulingConfigCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingConfigCell", for: indexPath) as! SchedulingConfigCell
            cell.setLanguageTitles()
            
            cell.btnValue.isHidden = true
            cell.btnArrow.isHidden = true
            
            var shareObj = arrTimeSlots[indexPath.row]
            if (indexPath.section == 1) {
                shareObj = arrTimeSlots[arrTimeSlots.count-1]
            }
            if (Int(shareObj.strTimeSlotMins) ?? 0 < 60) {
                cell.lblTitle.text = "\(shareObj.strTimeSlotMins) \(Global().getLocalizeStr(key: "keyPSMins"))"
            }
            else {
                let strTemp: String = String(format: "%g", (Float(shareObj.strTimeSlotMins) ?? 0) / 60.0)
                if (strTemp == "1") {
                    cell.lblTitle.text = "\(strTemp) \(Global().getLocalizeStr(key: "keyPSHour"))"
                }
                else {
                    cell.lblTitle.text = "\(strTemp) \(Global().getLocalizeStr(key: "keyPSHours"))"
                }
            }
            shareObj.boolIsSelected ? (cell.btnSelected.isEnabled = true) : (cell.btnSelected.isEnabled = false)
            
            if (indexPath.section == 1) {
                cell.btnValue.isHidden = false
                cell.btnArrow.isHidden = false
                cell.btnSelected.isHidden = true
                
                if (shareObj.boolIsSelected) {
                    cell.btnValue.setTitle(cell.lblTitle.text, for: .normal)
                    cell.btnValue.setTitleColor(Global().RGB(r: 40, g: 40, b: 40, a: 1), for: .normal)
                }
                else {
                    cell.btnValue.setTitle(Global().getLocalizeStr(key: "keyPSNone"), for: .normal)
                    cell.btnValue.setTitleColor(Global().RGB(r: 140, g: 140, b: 140, a: 1), for: .normal)
                }
                cell.lblTitle.text = Global().getLocalizeStr(key: "keyPSCustom")
            }
            return cell
        }
        else {
            let cell: SchedulingConfigCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingConfigCell", for: indexPath) as! SchedulingConfigCell
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == tblAppointmentList) {
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
                    pr_appointmentModifyObj.strSelProviderId = Global.kLoggedInUserData().Id!
                    self.navigationController?.pushViewController(pr_appointmentModifyObj, animated: true)
                })
            }
            actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyPSView"), tappedBlock: { () in
                let pr_appointmentDetailObj = PR_AppointmentDetailVC(nibName: "PR_AppointmentDetailVC", bundle: nil)
                pr_appointmentDetailObj.strSelAppoId = shareObj.strAppId
                pr_appointmentDetailObj.strSelProviderId = Global.kLoggedInUserData().Id!
                pr_appointmentDetailObj.strSelDate = shareObj.strAppDate
                self.navigationController?.pushViewController(pr_appointmentDetailObj, animated: true)
            })
            actionSheetOption.show(from: self.view, in: self.view)
        }
        else if (tableView == tblConfig) {
            if (indexPath.section == 0) {
                let schedulingSetAvailabilityObj = SchedulingSetAvailabilityVC(nibName: "SchedulingSetAvailabilityVC", bundle: nil)
                schedulingSetAvailabilityObj.arrDayAvailibility = self.arrDayAvailibility
                schedulingSetAvailabilityObj.intSelDayIndex = indexPath.row
                self.navigationController?.pushViewController(schedulingSetAvailabilityObj, animated: true)
            }
            else if (indexPath.section == 1) {
                let schedulingOnLeaveObj = SchedulingOnLeaveVC(nibName: "SchedulingOnLeaveVC", bundle: nil)
                schedulingOnLeaveObj.arrLeaves = self.arrLeaves
                self.navigationController?.pushViewController(schedulingOnLeaveObj, animated: true)
            }
            else if (indexPath.section == 2) {
                let schedulingSpecialRuleObj = SchedulingSpecialRuleVC(nibName: "SchedulingSpecialRuleVC", bundle: nil)
                schedulingSpecialRuleObj.arrSpecialRules = self.arrSpecialRules
                schedulingSpecialRuleObj.arrNthDay = self.arrNthDay
                schedulingSpecialRuleObj.arrNthDate = self.arrNthDate
                self.navigationController?.pushViewController(schedulingSpecialRuleObj, animated: true)
            }
        }
        else if (tableView == tblTimeSlots) {
            if (indexPath.section == 0) {
                let shareObj = arrTimeSlots[indexPath.row]
                self.setProviderTimeSlotCall(strMins: shareObj.strTimeSlotMins)
            }
            else if (indexPath.section == 1) {
                self.viewMinsPickerYConst.constant = Global.screenHeight - 240
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}

// MARK: -
extension ProviderSchedulingVC: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: -  UIPickerView DataSource & Delegate Methods
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 600
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

// MARK: -
extension ProviderSchedulingVC: UITextViewDelegate {
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
extension ProviderSchedulingVC {
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
extension ProviderSchedulingVC: UIGestureRecognizerDelegate {
    // MARK: -  UIGestureRecognizer Delegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity = self.calendarScopeGesture.velocity(in: self.view)
        switch self.calendarAppointment.scope {
        case .month:
            return velocity.y < 0
        case .week:
            return velocity.y > 0
        }
    }
}

// MARK: -
extension ProviderSchedulingVC: FSCalendarDataSource, FSCalendarDelegate {
    // MARK: -  FSCalendar DataSource & Dlegate Methods
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarAppointmentHeightConst.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateSelAppointment = date
        lblAppointmentSelDate.text = Global.singleton.convertDateToStringWithDayFullName(dateSel: date)
        self.getAppointmentScheduleForSelDateCall()
    }
}

// MARK: -
extension ProviderSchedulingVC: TimelinePagerViewDelegate {
    // MARK: -  TimelinePagerView Delegate Methods
    public func timelinePagerDidSelectEventView(_ eventView: EventView) {
        let eventApp: Event = eventView.descriptor as! Event
        let shareObj: AppointmentSObject = eventApp.userInfo as! AppointmentSObject
        
        if (shareObj.strAppIsBooked.lowercased() == "yes") {
            if (shareObj.intAppointCount == 1) {
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
                        pr_appointmentModifyObj.strSelProviderId = Global.kLoggedInUserData().Id!
                        self.navigationController?.pushViewController(pr_appointmentModifyObj, animated: true)
                    })
                }
                actionSheetOption.addButton(withTitle: Global().getLocalizeStr(key: "keyPSView"), tappedBlock: { () in
                    let pr_appointmentDetailObj = PR_AppointmentDetailVC(nibName: "PR_AppointmentDetailVC", bundle: nil)
                    pr_appointmentDetailObj.strSelAppoId = shareObj.strAppId
                    pr_appointmentDetailObj.strSelProviderId = Global.kLoggedInUserData().Id!
                    pr_appointmentDetailObj.strSelDate = shareObj.strAppDate
                    self.navigationController?.pushViewController(pr_appointmentDetailObj, animated: true)
                })
                actionSheetOption.show(from: self.view, in: self.view)
            }
            else {
                let pr_receivedReqListObj = PR_ReceivedReqListVC(nibName: "PR_ReceivedReqListVC", bundle: nil)
                pr_receivedReqListObj.strSelDate = shareObj.strAppDate
                pr_receivedReqListObj.strSelFromTime = shareObj.strAppStartTime
                pr_receivedReqListObj.strSelToTime = shareObj.strAppEndTime
                let strproviderId = Global.kLoggedInUserData().Id!
                pr_receivedReqListObj.strSelProviderId = strproviderId
                self.navigationController?.pushViewController(pr_receivedReqListObj, animated: true)
            }
        }
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
extension ProviderSchedulingVC {
    // MARK: -  EventDataSource Methods of CalendarKit
    open func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
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
        return events
    }
}
