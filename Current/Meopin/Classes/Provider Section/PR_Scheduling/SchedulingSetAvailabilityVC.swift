//
//  SchedulingSetAvailabilityVC.swift
//  Meopin
//
//  Created by Tops on 9/27/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingSetAvailabilityVC: UIViewController {
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblDayTitle: UILabel!
    
    @IBOutlet var viewShift1: UIView!
    @IBOutlet var swtShift1: UISwitch!
    @IBOutlet var pickerShift1From: UIDatePicker!
    @IBOutlet var pickerShift1To: UIDatePicker!
    @IBOutlet var lblShift1To: UILabel!
    
    @IBOutlet var viewShift2: UIView!
    @IBOutlet var swtShift2: UISwitch!
    @IBOutlet var pickerShift2From: UIDatePicker!
    @IBOutlet var pickerShift2To: UIDatePicker!
    @IBOutlet var lblShift2To: UILabel!
    
    @IBOutlet var tblRepeat: UITableView!
    @IBOutlet var btnReset: UIButton!
    
    var dropMenuRepeat: KPDropMenuMultiRepeat = KPDropMenuMultiRepeat()
    
    var arrDayAvailibility: [DayAvailibilitySObject] = [DayAvailibilitySObject]()
    var intSelDayIndex: Int = 0
    
    var arrSelRepeatIndex: NSMutableArray = NSMutableArray()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swtShift1.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
        swtShift2.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
        
        pickerShift1From.locale = Locale(identifier: "NL")
        pickerShift1To.locale = Locale(identifier: "NL")
        pickerShift2From.locale = Locale(identifier: "NL")
        pickerShift2To.locale = Locale(identifier: "NL")
        
        tblRepeat.register(UINib(nibName: "SchedulingAddSpeRuleCell", bundle: nil), forCellReuseIdentifier: "SchedulingAddSpeRuleCell")
        
        self.dropMenuAllocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        self.displayDayAvailabilityData()
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
        
        btnCancel.setTitle(Global().getLocalizeStr(key: "keyCancel"), for: .normal)
        btnSave.setTitle(Global().getLocalizeStr(key: "keySave"), for: .normal)
        lblShift1To.text = Global().getLocalizeStr(key: "keyPSTo")
        lblShift2To.text = Global().getLocalizeStr(key: "keyPSTo")
        btnReset.setTitle(Global().getLocalizeStr(key: "keyPSReset"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnCancel.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        btnSave.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblDayTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblShift1To.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblShift2To.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnReset.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    func displayDayAvailabilityData() {
        let shareObj = arrDayAvailibility[intSelDayIndex]
        lblDayTitle.text = Global().getLocalizeStr(key: shareObj.strDayTitle)
        swtShift1.isOn = false
        swtShift2.isOn = false
        
        pickerShift1From.isEnabled = false
        pickerShift1To.isEnabled = false
        pickerShift2From.isEnabled = false
        pickerShift2To.isEnabled = false
        
        for i in 0 ..< shareObj.arrDayShift.count {
            let shareObjShift = shareObj.arrDayShift[i]
            if (i == 0) {
                swtShift1.isOn = true
                pickerShift1From.isEnabled = true
                pickerShift1To.isEnabled = true
                
                pickerShift1From.setDate(Global.singleton.convertStringTimeToDateTime(strTime: shareObjShift.strShiftStartTime), animated: true)
                pickerShift1To.setDate(Global.singleton.convertStringTimeToDateTime(strTime: shareObjShift.strShiftEndTime), animated: true)
            }
            else if (i == 1) {
                swtShift2.isOn = true
                pickerShift2From.isEnabled = true
                pickerShift2To.isEnabled = true
                
                pickerShift2From.setDate(Global.singleton.convertStringTimeToDateTime(strTime: shareObjShift.strShiftStartTime), animated: true)
                pickerShift2To.setDate(Global.singleton.convertStringTimeToDateTime(strTime: shareObjShift.strShiftEndTime), animated: true)
            }
        }
        
        arrSelRepeatIndex = NSMutableArray()
        for i in 0 ..< arrDayAvailibility.count {
            if (i != intSelDayIndex) {
                let shareObjOther = arrDayAvailibility[i]
                
                if (shareObj.arrDayShift.count == shareObjOther.arrDayShift.count) {
                    var boolMatch = true
                    for j in 0 ..< shareObjOther.arrDayShift.count {
                        let shareObjShift = shareObj.arrDayShift[j]
                        let shareObjOtherShift = shareObjOther.arrDayShift[j]
                        
                        if (shareObjShift.strShiftStartTime != shareObjOtherShift.strShiftStartTime || shareObjShift.strShiftEndTime != shareObjOtherShift.strShiftEndTime) {
                            boolMatch = false
                        }
                    }
                    if (boolMatch) {
                        arrSelRepeatIndex.add(NSNumber(integerLiteral: (i < intSelDayIndex) ? i : i - 1))
                    }
                }
            }
        }
        
        var strRepeatVal: String = String()
        for i in 0 ..< arrSelRepeatIndex.count {
            let index: NSNumber = arrSelRepeatIndex.object(at: i) as? NSNumber ?? 0
            let shareObj = arrDayAvailibility[index.intValue < intSelDayIndex ? index.intValue : index.intValue + 1]
            
            strRepeatVal = "\(strRepeatVal)\(String(Global().getLocalizeStr(key: shareObj.strDayTitle).characters.prefix(3))) "
        }
        if (strRepeatVal.characters.count > 0) {
            strRepeatVal = String(strRepeatVal.characters.dropLast())
        }
        
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        let cell: SchedulingAddSpeRuleCell? = tblRepeat.cellForRow(at: indexPath) as? SchedulingAddSpeRuleCell
        if (strRepeatVal.characters.count > 0) {
            cell?.lblValue.text = strRepeatVal
        }
        else {
            cell?.lblValue.text = Global().getLocalizeStr(key: "keyPSSelect")
        }
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension SchedulingSetAvailabilityVC {
    // MARK: -  API Call
    func setProviderAvailabilityCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        
        for i in 0 ..< arrDayAvailibility.count {
            let shareObj = arrDayAvailibility[i]
            
            if (i == intSelDayIndex || arrSelRepeatIndex.contains(NSNumber(value: (i < intSelDayIndex) ? i : i-1))) {
                param.setValue(swtShift1.isOn ? "1" : "0", forKey: "form[availabilities][\(shareObj.strDayWSKey)][week]")
                if (swtShift1.isOn) {
                    param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerShift1From.date), forKey: "form[availabilities][\(shareObj.strDayWSKey)][0][fromTime]")
                    param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerShift1To.date), forKey: "form[availabilities][\(shareObj.strDayWSKey)][0][toTime]")
                }
                if (swtShift2.isOn) {
                    param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerShift2From.date), forKey: "form[availabilities][\(shareObj.strDayWSKey)][1][fromTime]")
                    param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerShift2To.date), forKey: "form[availabilities][\(shareObj.strDayWSKey)][1][toTime]")
                }
            }
            else {
                param.setValue(shareObj.arrDayShift.count > 0 ? "1" : "0", forKey: "form[availabilities][\(shareObj.strDayWSKey)][week]")
                if (shareObj.arrDayShift.count > 0) {
                    let shareObjShift = shareObj.arrDayShift[0]
                    param.setValue(shareObjShift.strShiftStartTime, forKey: "form[availabilities][\(shareObj.strDayWSKey)][0][fromTime]")
                    param.setValue(shareObjShift.strShiftEndTime, forKey: "form[availabilities][\(shareObj.strDayWSKey)][0][toTime]")
                }
                if (shareObj.arrDayShift.count > 1) {
                    let shareObjShift = shareObj.arrDayShift[1]
                    param.setValue(shareObjShift.strShiftStartTime, forKey: "form[availabilities][\(shareObj.strDayWSKey)][1][fromTime]")
                    param.setValue(shareObjShift.strShiftEndTime, forKey: "form[availabilities][\(shareObj.strDayWSKey)][1][toTime]")
                }
            }
        }
        
        AFAPIMaster.sharedAPIMaster.setProviderAvailabilityDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        if (swtShift1.isOn == true) {
            guard (NSCalendar.current.dateComponents([.minute], from: Global.singleton.removeDateFromTime(dateSel: pickerShift1From.date), to: Global.singleton.removeDateFromTime(dateSel: pickerShift1To.date)).minute! > 0) else {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleTimeMsg1"))
                return
            }
        }
        if (swtShift2.isOn == true) {
            guard (NSCalendar.current.dateComponents([.minute], from: Global.singleton.removeDateFromTime(dateSel: pickerShift2From.date), to: Global.singleton.removeDateFromTime(dateSel: pickerShift2To.date)).minute! > 0) else {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleTimeMsg1"))
                return
            }
            if (Global.singleton.removeDateFromTime(dateSel: pickerShift1From.date) == Global.singleton.removeDateFromTime(dateSel: pickerShift2From.date) || Global.singleton.removeDateFromTime(dateSel: pickerShift1From.date) == Global.singleton.removeDateFromTime(dateSel: pickerShift2To.date) || Global.singleton.removeDateFromTime(dateSel: pickerShift1To.date) == Global.singleton.removeDateFromTime(dateSel: pickerShift2From.date) || Global.singleton.removeDateFromTime(dateSel: pickerShift1To.date) == Global.singleton.removeDateFromTime(dateSel: pickerShift2To.date)) {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleTimeMsg2"))
                return
            }
            var boolValid = false
            if ((Global.singleton.removeDateFromTime(dateSel: pickerShift2From.date) < Global.singleton.removeDateFromTime(dateSel: pickerShift1From.date)) && (Global.singleton.removeDateFromTime(dateSel: pickerShift2To.date) < Global.singleton.removeDateFromTime(dateSel: pickerShift1From.date))) {
                boolValid = true
            }
            else if ((Global.singleton.removeDateFromTime(dateSel: pickerShift2From.date) > Global.singleton.removeDateFromTime(dateSel: pickerShift1To.date)) && (Global.singleton.removeDateFromTime(dateSel: pickerShift2To.date) > Global.singleton.removeDateFromTime(dateSel: pickerShift1To.date))) {
                boolValid = true
            }
            
            if (boolValid == false) {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleTimeMsg2"))
                return
            }
        }
        self.setProviderAvailabilityCall()
    }
    
    @IBAction func btnResetClick(_ sender: Any) {
        swtShift1.isOn = false
        swtShift2.isOn = false
        self.setProviderAvailabilityCall()
    }
    
    // MARK: -  Switch Change Methods
    @IBAction func swtShift1Change(_ sender: Any) {
        if (swtShift1.isOn) {
            pickerShift1From.isEnabled = true
            pickerShift1To.isEnabled = true
        }
        else {
            pickerShift1From.isEnabled = false
            pickerShift1To.isEnabled = false
            swtShift2.isOn = false
        }
    }
    
    @IBAction func swtShift2Change(_ sender: Any) {
        if (swtShift2.isOn) {
            if (swtShift1.isOn) {
                pickerShift2From.isEnabled = true
                pickerShift2To.isEnabled = true
            }
            else {
                swtShift2.isOn = false
            }
        }
        else {
            pickerShift2From.isEnabled = false
            pickerShift2To.isEnabled = false
        }
    }
    
    // MARK: -  Drop Menu Allocation and add Methods
    func dropMenuAllocation() {
        //week
        dropMenuRepeat.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        self.dropMenuRepeat.delegate = self
        self.dropMenuRepeat = Global.appDelegate.GenericDropDownMenuMultiRepeatAllocation(genericDropDown: self.dropMenuRepeat)
        self.dropMenuRepeat.directionDown = false
        
        var arrRepeatIds: [String] = [String]()
        var arrRepeatValues: [String] = [String]()
        for i in 0 ..< arrDayAvailibility.count {
            if (i != intSelDayIndex) {
                let shareObj = arrDayAvailibility[i]
                arrRepeatIds.append(shareObj.strDayId)
                arrRepeatValues.append(Global().getLocalizeStr(key: shareObj.strDayTitle))
            }
        }
        self.dropMenuRepeat.items = arrRepeatValues
        self.dropMenuRepeat.itemsIDs = arrRepeatIds
        
        Global().delay(delay: 0.3) { 
            self.addDropDown(dropMenu: self.dropMenuRepeat, inView: self.view, with: CGRect(x: Global.screenWidth - 205, y: self.tblRepeat.frame.origin.y, width: 200, height: Global.singleton.getDeviceSpecificFontSize(35)))
        }
    }
    
    func addDropDown(dropMenu: KPDropMenuMultiRepeat, inView: UIView, with frame: CGRect) {
        dropMenu.frame = frame
        inView.addSubview(dropMenu)
    }
}

// MARK: -
extension SchedulingSetAvailabilityVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(35)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchedulingAddSpeRuleCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingAddSpeRuleCell", for: indexPath) as! SchedulingAddSpeRuleCell
        cell.setLanguageTitles()
        
        cell.lblTitle.text = Global().getLocalizeStr(key: "keyPSRepeat")
        cell.lblValue.text = Global().getLocalizeStr(key: "keyPSSelect")
        var strRepeatVal: String = String()
        for i in 0 ..< arrSelRepeatIndex.count {
            let index: NSNumber = arrSelRepeatIndex.object(at: i) as? NSNumber ?? 0
            let shareObj = arrDayAvailibility[index.intValue < intSelDayIndex ? index.intValue : index.intValue + 1]
            
            strRepeatVal = "\(strRepeatVal)\(String(Global().getLocalizeStr(key: shareObj.strDayTitle).characters.prefix(3))) "
        }
        if (strRepeatVal.characters.count > 0) {
            strRepeatVal = String(strRepeatVal.characters.dropLast())
        }
        
        if (strRepeatVal.characters.count > 0) {
            cell.lblValue.text = strRepeatVal
        }
        else {
            cell.lblValue.text = Global().getLocalizeStr(key: "keyPSSelect")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: -
extension SchedulingSetAvailabilityVC: KPDropMenuMultiRepeatDelegate {
    // MARK: -  KPDropMenu Delegate Methods
    func didShow(_ dropMenu: KPDropMenuMultiRepeat!) {
        dropMenuRepeat.arrIndexItems = arrSelRepeatIndex
        self.dropMenuRepeat.tblView.reloadData()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenuMultiRepeat!, arrSelectedIndex selectedIndex: NSMutableArray!) {
        selectedIndex.sort(using: #selector(NSNumber.compare(_:)))
        var strRepeatVal: String = String()
        for i in 0 ..< selectedIndex.count {
            let index: NSNumber = selectedIndex.object(at: i) as? NSNumber ?? 0
            let shareObj = arrDayAvailibility[index.intValue < intSelDayIndex ? index.intValue : index.intValue + 1]
            
            strRepeatVal = "\(strRepeatVal)\(String(Global().getLocalizeStr(key: shareObj.strDayTitle).characters.prefix(3))) "
        }
        if (strRepeatVal.characters.count > 0) {
            strRepeatVal = String(strRepeatVal.characters.dropLast())
        }
        
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        let cell: SchedulingAddSpeRuleCell = tblRepeat.cellForRow(at: indexPath) as! SchedulingAddSpeRuleCell
        if (strRepeatVal.characters.count > 0) {
            cell.lblValue.text = strRepeatVal
        }
        else {
            cell.lblValue.text = Global().getLocalizeStr(key: "keyPSSelect")
        }
        
        arrSelRepeatIndex = selectedIndex
    }
}
