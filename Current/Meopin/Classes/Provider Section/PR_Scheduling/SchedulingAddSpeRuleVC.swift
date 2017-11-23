//
//  SchedulingAddSpeRuleVC.swift
//  Meopin
//
//  Created by Tops on 9/26/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingAddSpeRuleVC: UIViewController {
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblSpeRule: UILabel!
    @IBOutlet var tblRuleOptions: UITableView!
    @IBOutlet var viewTimePicker: UIView!
    @IBOutlet var pickerFromTime: UIDatePicker!
    @IBOutlet var lblToTime: UILabel!
    @IBOutlet var pickerToTime: UIDatePicker!
    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var tblRuleOptionsHeightConst: NSLayoutConstraint!
    
    var arrNthDay: [ScheduleNthDaySObject] = [ScheduleNthDaySObject]()
    var arrNthDate: [ScheduleNthDaySObject] = [ScheduleNthDaySObject]()
    
    var strSelRuleId: String = ""
    var shareObjSpeRule: SpecialRuleSObject = SpecialRuleSObject()
    
    var dropMenuWeek: KPDropMenu = KPDropMenu()
    var dropMenuDay: KPDropMenu = KPDropMenu()
    var dropMenuOfEveryMonth: KPDropMenu = KPDropMenu()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerFromTime.locale = Locale(identifier: "NL")
        pickerToTime.locale = Locale(identifier: "NL")
        
        tblRuleOptions.register(UINib(nibName: "SchedulingAddSpeRuleCell", bundle: nil), forCellReuseIdentifier: "SchedulingAddSpeRuleCell")
        
        tblRuleOptionsHeightConst.constant = Global.singleton.getDeviceSpecificFontSize(35) * 3
        
        self.dropMenuAllocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        if (strSelRuleId == "") { //Add
            btnDelete.isHidden = true
            viewTimePicker.alpha = 0.6
            viewTimePicker.isUserInteractionEnabled = false
        }
        else { //Edit
            if (shareObjSpeRule.strRuleType == "3" && shareObjSpeRule.strRuleFromTime != "" && shareObjSpeRule.strRuleToTime != "") {
                pickerFromTime.setDate(Global.singleton.convertStringTimeToDateTime(strTime: shareObjSpeRule.strRuleFromTime), animated: true)
                pickerToTime.setDate(Global.singleton.convertStringTimeToDateTime(strTime: shareObjSpeRule.strRuleToTime), animated: true)
                viewTimePicker.alpha = 1.0
                viewTimePicker.isUserInteractionEnabled = true
            }
            else if (shareObjSpeRule.strRuleType == "2") {
                viewTimePicker.alpha = 0.6
                viewTimePicker.isUserInteractionEnabled = false
            }
            btnDelete.isHidden = false
        }
        self.setLanguageTitles()
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
        lblSpeRule.text = Global().getLocalizeStr(key: "keyPSSpecialRule")
        lblToTime.text = Global().getLocalizeStr(key: "keyPSTo")
        btnDelete.setTitle(Global().getLocalizeStr(key: "keyPSDelete"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnCancel.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        btnSave.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblSpeRule.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblToTime.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnDelete.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension SchedulingAddSpeRuleVC {
    // MARK: -  API Call
    func addProviderSpecialRuleCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObjSpeRule.strRuleType, forKey: "form[ruleType]")
        param.setValue(shareObjSpeRule.strRuleNthDay, forKey: "form[nthDay]")
        param.setValue(shareObjSpeRule.strRuleNthDate, forKey: "form[nthDate]")
        param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerFromTime.date), forKey: "form[fromTime]")
        param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerToTime.date), forKey: "form[toTime]")
        
        AFAPIMaster.sharedAPIMaster.addProviderSpecialRuleDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func editProviderSpecialRuleCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(shareObjSpeRule.strRuleType, forKey: "form[ruleType]")
        param.setValue(shareObjSpeRule.strRuleNthDay, forKey: "form[nthDay]")
        param.setValue(shareObjSpeRule.strRuleNthDate, forKey: "form[nthDate]")
        param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerFromTime.date), forKey: "form[fromTime]")
        param.setValue(Global.singleton.convertDateTimeToStringTime(dateSel: pickerToTime.date), forKey: "form[toTime]")
        param.setValue(self.shareObjSpeRule.strRuleId, forKey: "form[ruleId]")
        
        AFAPIMaster.sharedAPIMaster.editProviderSpecialRuleDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func deleteProviderSpecialRuleCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(self.shareObjSpeRule.strRuleId, forKey: "form[ruleId]")
        
        AFAPIMaster.sharedAPIMaster.deleteProviderSpecialRuleDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
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
        guard (shareObjSpeRule.strRuleNthDay != "") else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleDayMsg1"))
            return
        }
        guard (shareObjSpeRule.strRuleNthDate != "") else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleDateMsg1"))
            return
        }
        guard (shareObjSpeRule.strRuleType != "") else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleTypeMsg1"))
            return
        }
        if (shareObjSpeRule.strRuleType == "3") {
            guard (NSCalendar.current.dateComponents([.minute], from: Global.singleton.removeDateFromTime(dateSel: pickerFromTime.date), to: Global.singleton.removeDateFromTime(dateSel: pickerToTime.date)).minute! > 0) else {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSRuleTimeMsg1"))
                return
            }
        }

        if (self.strSelRuleId == "") {
            self.addProviderSpecialRuleCall()
        }
        else {
            self.editProviderSpecialRuleCall()
        }
    }
    
    @IBAction func btnDeleteClick(_ sender: Any) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "", message: Global().getLocalizeStr(key: "keyPSDeleteSpeRuleMsg1"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyYes"), style: UIAlertActionStyle.default, handler: { action in
            self.deleteProviderSpecialRuleCall()
        }))
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyNo"), style: UIAlertActionStyle.cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -  Drop Menu Allocation and add Methods
    func dropMenuAllocation() {
        //week
        dropMenuWeek.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        self.dropMenuWeek.delegate = self
        self.dropMenuWeek = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:self.dropMenuWeek)
        
        var arrWeekIds: [String] = [String]()
        var arrWeekValues: [String] = [String]()
        for shareObj in arrNthDay {
            arrWeekIds.append(shareObj.strDayId)
            arrWeekValues.append(shareObj.strDayValue)
        }
        self.dropMenuWeek.items = arrWeekValues
        self.dropMenuWeek.itemsIDs = arrWeekIds
        
        //Day
        dropMenuDay.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        self.dropMenuDay.delegate = self
        self.dropMenuDay = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:self.dropMenuDay)
        
        var arrDayIds: [String] = [String]()
        var arrDayValues: [String] = [String]()
        for shareObj in arrNthDate {
            arrDayIds.append(shareObj.strDayId)
            arrDayValues.append(shareObj.strDayValue)
        }
        self.dropMenuDay.items = arrDayValues
        self.dropMenuDay.itemsIDs = arrDayIds
        
        //Of every month
        dropMenuOfEveryMonth.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        self.dropMenuOfEveryMonth.delegate = self
        self.dropMenuOfEveryMonth = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:self.dropMenuOfEveryMonth)
        
        self.dropMenuOfEveryMonth.items = [Global().getLocalizeStr(key: "keyPSRuleOffDay"), Global().getLocalizeStr(key: "keyPSHasSpecialTime")]
        self.dropMenuOfEveryMonth.itemsIDs = ["2", "3"]
        
        self.addDropDown(dropMenu: dropMenuWeek, inView: self.view, with: CGRect(x: Global.screenWidth - 175, y: tblRuleOptions.frame.origin.y, width: 170, height: Global.singleton.getDeviceSpecificFontSize(35)))
        self.addDropDown(dropMenu: dropMenuDay, inView: self.view, with: CGRect(x: Global.screenWidth - 175, y: tblRuleOptions.frame.origin.y + Global.singleton.getDeviceSpecificFontSize(35), width: 170, height: Global.singleton.getDeviceSpecificFontSize(35)))
        self.addDropDown(dropMenu: dropMenuOfEveryMonth, inView: self.view, with: CGRect(x: Global.screenWidth - 200, y: tblRuleOptions.frame.origin.y + (Global.singleton.getDeviceSpecificFontSize(35) * 2), width: 195, height: Global.singleton.getDeviceSpecificFontSize(35)))
    }
    
    func addDropDown(dropMenu: KPDropMenu, inView: UIView, with frame: CGRect) {
        dropMenu.frame = frame
        inView.addSubview(dropMenu)
    }
}

// MARK: -
extension SchedulingAddSpeRuleVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(35)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchedulingAddSpeRuleCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingAddSpeRuleCell", for: indexPath) as! SchedulingAddSpeRuleCell
        cell.setLanguageTitles()
        
        cell.lblValue.text = Global().getLocalizeStr(key: "keyPSSelect")
        if (indexPath.row == 0) {
            cell.lblTitle.text = Global().getLocalizeStr(key: "keyPSWeek")
            if (strSelRuleId != "") {
                let shareObjNthDay = arrNthDay[Int(shareObjSpeRule.strRuleNthDay)! - 1]
                cell.lblValue.text = shareObjNthDay.strDayValue
                dropMenuWeek.selectedIndex = Int32(shareObjSpeRule.strRuleNthDay)! - 1
            }
        }
        else if (indexPath.row == 1) {
            cell.lblTitle.text = Global().getLocalizeStr(key: "keyPSOnDay")
            if (strSelRuleId != "") {
                let shareObjNthDate = arrNthDate[Int(shareObjSpeRule.strRuleNthDate)! - 1]
                cell.lblValue.text = shareObjNthDate.strDayValue
                dropMenuDay.selectedIndex = Int32(shareObjSpeRule.strRuleNthDate)! - 1
            }
        }
        else if (indexPath.row == 2) {
            cell.lblTitle.text = Global().getLocalizeStr(key: "keyPSOfEveryMonth")
            if (strSelRuleId != "") {
                if (shareObjSpeRule.strRuleType == "2") {
                    cell.lblValue.text = Global().getLocalizeStr(key: "keyPSRuleOffDay")
                    dropMenuOfEveryMonth.selectedIndex = 0
                }
                else if (shareObjSpeRule.strRuleType == "3") {
                    cell.lblValue.text = Global().getLocalizeStr(key: "keyPSHasSpecialTime")
                    dropMenuOfEveryMonth.selectedIndex = 1
                }
            }
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: -
extension SchedulingAddSpeRuleVC: KPDropMenuDelegate {
    // MARK: -  KPDropMenu Delegate Methods
    func didShow(_ dropMenu: KPDropMenu!) {

    }
    
    func didSelectItem(_ dropMenu: KPDropMenu!, at atIndex: Int32) {
        var cell: SchedulingAddSpeRuleCell?
        if (dropMenu == dropMenuWeek) {
            let indexPath: IndexPath = IndexPath(row: 0, section: 0)
            cell = tblRuleOptions.cellForRow(at: indexPath) as? SchedulingAddSpeRuleCell
            shareObjSpeRule.strRuleNthDay = dropMenu.itemsIDs[Int(atIndex)] as? String ?? ""
        }
        else if (dropMenu == dropMenuDay) {
            let indexPath: IndexPath = IndexPath(row: 1, section: 0)
            cell = tblRuleOptions.cellForRow(at: indexPath) as? SchedulingAddSpeRuleCell
            shareObjSpeRule.strRuleNthDate = dropMenu.itemsIDs[Int(atIndex)] as? String ?? ""
        }
        else if (dropMenu == dropMenuOfEveryMonth) {
            let indexPath: IndexPath = IndexPath(row: 2, section: 0)
            cell = tblRuleOptions.cellForRow(at: indexPath) as? SchedulingAddSpeRuleCell
            shareObjSpeRule.strRuleType = dropMenu.itemsIDs[Int(atIndex)] as? String ?? ""
            
            if (atIndex == 0) {
                viewTimePicker.alpha = 0.6
                viewTimePicker.isUserInteractionEnabled = false
            }
            else if (atIndex == 1) {
                viewTimePicker.alpha = 1.0
                viewTimePicker.isUserInteractionEnabled = true
            }
        }
        cell?.lblValue.text = dropMenu.items[Int(atIndex)] as? String ?? ""
    }
}
