//
//  PT_CreateAppointmentSlotVC.swift
//  Meopin
//
//  Created by Tops on 10/11/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import FSCalendar
import CalendarKit
import DateToolsSwift
import TOActionSheet
import SDWebImage

class PT_CreateAppointmentSlotVC: UIViewController, EventDataSource {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewProviderDetail: UIView!
    @IBOutlet var viewProfilePicBG: UIView!
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblFullName: UILabel!
    @IBOutlet var lblSpeciality: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var btnFavorite: UIButton!
    
    @IBOutlet var btnListCalendarView: UIButton!
    @IBOutlet var tblSlotList: UITableView!
    
    @IBOutlet var viewCalendarSlot: UIView!
    @IBOutlet var calendarAppointment: FSCalendar!
    @IBOutlet var lblAppointmentSelDate: UILabel!
    @IBOutlet var timelineAppointmentView: TimelinePagerView!
    
    @IBOutlet var calendarAppointmentHeightConst: NSLayoutConstraint!
    
    var strSelProviderId: String = ""
    var dictSelProviderData: NSDictionary!
    var isNavFavScreen : Bool = false
    var arrAppointments: [AppointmentSObject] = [AppointmentSObject]()
    var arrAppointmentsAllDate: [AppointmentDateSObject] = [AppointmentDateSObject]()
    
    var dateSelAppointment: Date = Date()
    var dateSelAppointmentOld: Date = Date()
    
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
        
        viewProfilePicBG.layer.masksToBounds = true
        viewProfilePicBG.layer.cornerRadius = 4
        viewProfilePicBG.layer.borderWidth = 1
        viewProfilePicBG.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        
        lblRating.layer.masksToBounds = true
        
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
        
        tblSlotList.register(UINib(nibName: "CalendarAgendaViewCell", bundle: nil), forCellReuseIdentifier: "CalendarAgendaViewCell")
        
        btnListCalendarView.layer.masksToBounds = true
        btnListCalendarView.layer.cornerRadius = 4
        
        tblSlotList.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        if (btnListCalendarView.tag == 0) {
            self.getAppointmentScheduleForSelDateCall(true)
        }
        else {
            self.getAppointmentScheduleForSelDateCall(false)
        }
        
        self.displayProviderDetail()
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
        lblTitle.text = Global().getLocalizeStr(key: "keyCAMakeAppointment")
        lblAppointmentSelDate.text = Global.singleton.convertDateToStringWithDayFullName(dateSel: dateSelAppointment)
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblRating.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblFullName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        lblSpeciality.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10.25))
        lblAddress.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9.75))
        lblDistance.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9.25))
        btnFavorite.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(18))
        
        btnListCalendarView.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        lblAppointmentSelDate.font = UIFont(name: "HelveticaNeue", size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
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
        
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_CreateAppointmentSlotVC {
    // MARK: -  API Call
    func getAppointmentScheduleForSelDateCall(_ boolIsCalendar: Bool) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(self.strSelProviderId, forKey: "form[providerId]")
        
        if (boolIsCalendar) {
            param.setValue(Global.singleton.convertDateToString(dateSel: dateSelAppointment), forKey: "form[startDate]")
            param.setValue(Global.singleton.convertDateToString(dateSel: dateSelAppointment), forKey: "form[endDate]")
        }
        else {
            let calendar = Calendar.current
            param.setValue(Global.singleton.convertDateToString(dateSel: Date()), forKey: "form[startDate]")
            param.setValue(Global.singleton.convertDateToString(dateSel: calendar.date(byAdding: .month, value: 3, to: dateSelAppointment)!), forKey: "form[endDate]")
        }
        
        AFAPIMaster.sharedAPIMaster.getProviderAppointmentTimelineDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            self.arrAppointments.removeAll()
            self.arrAppointmentsAllDate.removeAll()
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
                            shareObj.strCategoryName = dictAppData.object(forKey: "category") as? String ?? ""
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
                            if let dictProDetail: NSDictionary = dictAppData.object(forKey: "provider") as? NSDictionary {
                                let strSalutation = dictProDetail.object(forKey: "salutation") as? String ?? ""
                                let strFName = dictProDetail.object(forKey: "firstName") as? String ?? ""
                                let strLName = dictProDetail.object(forKey: "lastName") as? String ?? ""
                                shareObj.strProviderId = dictProDetail.object(forKey: "provider_id") as? String ?? ""
                                shareObj.strAppTitle = ""
                                if (strSalutation.characters.count > 0) {
                                    shareObj.strAppTitle = "\(strSalutation) "
                                }
                                if (strFName.characters.count > 0) {
                                    shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strFName) "
                                }
                                shareObj.strAppTitle = "\(shareObj.strAppTitle)\(strLName)"
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
                
                if (boolIsCalendar) {
                    self.timelineAppointmentView.autoScrollToFirstEvent = true
                    if (self.dateSelAppointmentOld != self.dateSelAppointment) {
                        self.timelineAppointmentView.changeDateSelection(from: self.dateSelAppointmentOld, to: self.dateSelAppointment)
                    }
                    self.timelineAppointmentView.dataSource = self
                    self.timelineAppointmentView.delegate = self
                    self.timelineAppointmentView.reloadData()
                    self.dateSelAppointmentOld = self.dateSelAppointment
                }
                else {
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
                    let arrFiltered = self.arrAppointmentsAllDate.filter() {$0.strDate == Global.singleton.convertDateToString(dateSel: self.dateSelAppointment)}
                    if arrFiltered.count > 0 {
                        self.tblSlotList.scrollToRow(at: IndexPath(row: 0, section: self.arrAppointmentsAllDate.index(of: arrFiltered[0])!), at: .top, animated: true)
                    }
                    else {
                        self.tblSlotList.setContentOffset(CGPoint.zero, animated: true)
                    }
                }
            }
        })
    }
    
    
    func acceptAppointmentRequestCall(_ shareObj: AppointmentSObject) {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObj.strAppId, forKey: "form[appointmentId]")
        
        AFAPIMaster.sharedAPIMaster.acceptAppointmentRequestDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            if (self.btnListCalendarView.tag == 0) {
                self.getAppointmentScheduleForSelDateCall(true)
            }
            else {
                self.getAppointmentScheduleForSelDateCall(false)
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
                self.getAppointmentScheduleForSelDateCall(true)
            }
            else {
                self.getAppointmentScheduleForSelDateCall(false)
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnListCalendarViewClick(_ sender: Any) {
        if (btnListCalendarView.tag == 0) {
            viewCalendarSlot.isHidden = true
            tblSlotList.isHidden = false
            btnListCalendarView.tag = 1
            btnListCalendarView.setTitleColor(.white, for: .normal)
            btnListCalendarView.backgroundColor = Global.kAppColor.Red
            
            self.getAppointmentScheduleForSelDateCall(false)
        }
        else {
            viewCalendarSlot.isHidden = false
            tblSlotList.isHidden = true
            btnListCalendarView.tag = 0
            btnListCalendarView.setTitleColor(Global.kAppColor.Red, for: .normal)
            btnListCalendarView.backgroundColor = .clear
            
            self.getAppointmentScheduleForSelDateCall(true)
        }
    }
}

// MARK: -
extension PT_CreateAppointmentSlotVC: UITableViewDataSource, UITableViewDelegate {
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
        
        if (Global.singleton.convertDateToString(dateSel: dateSelAppointment) == shareObjDate.strDate) {
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
        
        if (arrAppointmentsAllDate.count < indexPath.section) {
            return cell
        }
        let shareObjDate = arrAppointmentsAllDate[indexPath.section]
        let shareObj = shareObjDate.arrSlots[indexPath.row]
        
        cell.lblStartTime.text = String(shareObj.strAppStartTime.characters.dropLast(3))
        cell.lblEndTime.text = String(shareObj.strAppEndTime.characters.dropLast(3))
        cell.lblTitle.text = shareObj.strAppTitle
        cell.lblAppReason.text = shareObj.strAppReason
        
        if (shareObj.strAppReason == "") {
            cell.lblAppReason.text = " - "
        }
        cell.lblStatusColor.backgroundColor = UIColor(string: shareObj.strAppBGColor)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: -
extension PT_CreateAppointmentSlotVC: UITextViewDelegate {
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
extension PT_CreateAppointmentSlotVC {
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
extension PT_CreateAppointmentSlotVC: UIGestureRecognizerDelegate {
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
extension PT_CreateAppointmentSlotVC: FSCalendarDataSource, FSCalendarDelegate {
    // MARK: -  FSCalendar DataSource & Dlegate Methods
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarAppointmentHeightConst.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateSelAppointment = date
        lblAppointmentSelDate.text = Global.singleton.convertDateToStringWithDayFullName(dateSel: date)
        getAppointmentScheduleForSelDateCall(true)
    }
}

// MARK: -
extension PT_CreateAppointmentSlotVC: TimelinePagerViewDelegate {
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
                        pr_appointmentModifyObj.strSelProviderId = shareObj.strProviderId
                        pr_appointmentModifyObj.strSelAppoId = shareObj.strAppId
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
            else {
                let pr_receivedReqListObj = PR_ReceivedReqListVC(nibName: "PR_ReceivedReqListVC", bundle: nil)
                pr_receivedReqListObj.strSelDate = shareObj.strAppDate
                pr_receivedReqListObj.strSelFromTime = shareObj.strAppStartTime
                pr_receivedReqListObj.strSelToTime = shareObj.strAppEndTime
                pr_receivedReqListObj.strSelProviderId = self.strSelProviderId
                self.navigationController?.pushViewController(pr_receivedReqListObj, animated: true)
            }
        }
        else {
            let pt_createAppointmentObj = PT_CreateAppointmentVC(nibName: "PT_CreateAppointmentVC", bundle: nil)
            pt_createAppointmentObj.strSelDate = shareObj.strAppDate
            pt_createAppointmentObj.strSelFromTime = shareObj.strAppStartTime
            pt_createAppointmentObj.strSelToTime = shareObj.strAppEndTime
            pt_createAppointmentObj.strSelProviderId = self.strSelProviderId
            pt_createAppointmentObj.dictSelProviderData = dictSelProviderData
            self.navigationController?.pushViewController(pt_createAppointmentObj, animated: true)
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
extension PT_CreateAppointmentSlotVC {
    // MARK: -  EventDataSource Methods of CalendarKit
    open func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        for shareObj in arrAppointments {
            let eventApp: Event = Event()
            eventApp.text = shareObj.strAppTitle
            eventApp.color = UIColor(string: shareObj.strAppBGColor)
            eventApp.backgroundColor = UIColor(string: shareObj.strAppBGColor, forAlpha: 3.3)
            eventApp.textColor = UIColor(string: shareObj.strAppBGColor)  //(shareObj.strAppTextColor.hasPrefix("#")) ? UIColor(string: shareObj.strAppTextColor) : UIColor.white
            eventApp.datePeriod = TimePeriod(beginning: Global.singleton.convertStringToDateTime(strDate: "\(shareObj.strAppDate) \(shareObj.strAppStartTime)"), end: Global.singleton.convertStringToDateTime(strDate: "\(shareObj.strAppDate) \(shareObj.strAppEndTime)"))
            eventApp.userInfo = shareObj
            events.append(eventApp)
        }
        return events
    }
}
