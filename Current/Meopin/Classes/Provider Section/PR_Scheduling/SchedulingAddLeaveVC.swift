//
//  SchedulingAddLeaveVC.swift
//  Meopin
//
//  Created by Tops on 9/23/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingAddLeaveVC: UIViewController {
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblOnLeave: UILabel!
    @IBOutlet var lblFromDate: UILabel!
    @IBOutlet var pickerFromDate: UIDatePicker!
    @IBOutlet var lblToDate: UILabel!
    @IBOutlet var pickerToDate: UIDatePicker!
    @IBOutlet var btnDelete: UIButton!
    
    var strSelLeaveId: String = ""
    var shareObjLeave: LeaveSObject?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        if (strSelLeaveId == "") { //Add
            btnDelete.isHidden = true
        }
        else { //Edit
            pickerFromDate.setDate(Global.singleton.convertStringToDate(strDate: (shareObjLeave?.strLeaveStartDate)!), animated: true)
            pickerToDate.setDate(Global.singleton.convertStringToDate(strDate: (shareObjLeave?.strLeaveEndDate)!), animated: true)
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
        lblOnLeave.text = Global().getLocalizeStr(key: "keyPSOnLeaveCaps")
        lblFromDate.text = Global().getLocalizeStr(key: "keyPSFrom")
        lblToDate.text = Global().getLocalizeStr(key: "keyPSTo")
        btnDelete.setTitle(Global().getLocalizeStr(key: "keyPSDelete"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        btnCancel.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        btnSave.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblOnLeave.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblFromDate.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(14))
        lblToDate.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(14))
        btnDelete.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension SchedulingAddLeaveVC {
    // MARK: -  API Call
    func addProviderLeaveCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(Global.singleton.convertDateToString(dateSel: pickerFromDate.date), forKey: "form[fromDate]")
        param.setValue(Global.singleton.convertDateToString(dateSel: pickerToDate.date), forKey: "form[toDate]")
        
        AFAPIMaster.sharedAPIMaster.addProviderLeaveDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func editProviderLeaveCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(Global.singleton.convertDateToString(dateSel: pickerFromDate.date), forKey: "form[fromDate]")
        param.setValue(Global.singleton.convertDateToString(dateSel: pickerToDate.date), forKey: "form[toDate]")
        param.setValue(self.shareObjLeave?.strLeaveId, forKey: "form[leaveId]")
        
        AFAPIMaster.sharedAPIMaster.editProviderLeaveDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            Global.singleton.showSuccessAlert(withMsg: dictResponse.object(forKey: "message") as? String ?? "")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func deleteProviderLeaveCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(self.shareObjLeave?.strLeaveId, forKey: "form[leaveId]")
        
        AFAPIMaster.sharedAPIMaster.deleteProviderLeaveDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
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
        if (self.strSelLeaveId == "") {
            print(pickerFromDate.date, Date())
            guard (Global.singleton.removeTimeFromDate(dateSel: pickerFromDate.date) >= Global.singleton.removeTimeFromDate(dateSel: Date())) else {
                Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSDateMsg1"))
                return
            }
        }
        guard (NSCalendar.current.dateComponents([.day], from: pickerFromDate.date, to: pickerToDate.date).day! >= 0) else {
            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyPSDateMsg2"))
            return
        }
        if (self.strSelLeaveId == "") {
            self.addProviderLeaveCall()
        }
        else {
            self.editProviderLeaveCall()
        }
    }
    
    @IBAction func btnDeleteClick(_ sender: Any) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "", message: Global().getLocalizeStr(key: "keyPSDeleteMsg1"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyYes"), style: UIAlertActionStyle.default, handler: { action in
            self.deleteProviderLeaveCall()
        }))
        alert.addAction(UIAlertAction(title: Global().getLocalizeStr(key: "keyNo"), style: UIAlertActionStyle.cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

