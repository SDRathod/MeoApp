//
//  SchedulingOnLeaveVC.swift
//  Meopin
//
//  Created by Tops on 9/18/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingOnLeaveVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblLeaveTitle: UILabel!
    @IBOutlet var btnAddLeave: UIButton!
    
    @IBOutlet var tblLeaves: UITableView!
    
    var arrLeaves: [LeaveSObject] = [LeaveSObject]()
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblLeaves.register(UINib(nibName: "SchedulingOnLeaveCell", bundle: nil), forCellReuseIdentifier: "SchedulingOnLeaveCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        
        self.setLanguageTitles()
        
        self.getProviderSchedulingConfigCall()
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
        
        lblLeaveTitle.text = Global().getLocalizeStr(key: "keyPSOnLeave")
        lblTitle.text = Global().getLocalizeStr(key: "keyPSOnLeave")
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblLeaveTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        btnAddLeave.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(40))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension SchedulingOnLeaveVC {
    // MARK: -  API Call
    func getProviderSchedulingConfigCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.getProviderSchedulingDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
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
                self.tblLeaves.reloadData()
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddLeaveClick(_ sender: Any) {
        let schedulingAddLeaveObj = SchedulingAddLeaveVC(nibName: "SchedulingAddLeaveVC", bundle: nil)
        self.navigationController?.pushViewController(schedulingAddLeaveObj, animated: true)
    }
}

// MARK: -
extension SchedulingOnLeaveVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLeaves.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(67)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchedulingOnLeaveCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingOnLeaveCell", for: indexPath) as! SchedulingOnLeaveCell
        cell.setLanguageTitles()
        
        let shareObj: LeaveSObject = arrLeaves[indexPath.row]
        if (shareObj.strLeaveDays == "1") {
            cell.lblTotDays.text = "\(shareObj.strLeaveDays) \(Global().getLocalizeStr(key: "keyPSOnDay"))"
            cell.lblStartEndDate.text = "\(Global.singleton.convertStringToDateWithDayName(strDate: shareObj.strLeaveStartDate))"
        }
        else {
            cell.lblTotDays.text = "\(shareObj.strLeaveDays) \(Global().getLocalizeStr(key: "keyPSOnDays"))"
            cell.lblStartEndDate.text = "\(Global.singleton.convertStringToDateWithDayName(strDate: shareObj.strLeaveStartDate)) \(Global().getLocalizeStr(key: "keyPSOnToSmall")) \(Global.singleton.convertStringToDateWithDayName(strDate: shareObj.strLeaveEndDate))"
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shareObj: LeaveSObject = arrLeaves[indexPath.row]
        let schedulingAddLeaveObj = SchedulingAddLeaveVC(nibName: "SchedulingAddLeaveVC", bundle: nil)
        schedulingAddLeaveObj.strSelLeaveId = shareObj.strLeaveId
        schedulingAddLeaveObj.shareObjLeave = shareObj
        self.navigationController?.pushViewController(schedulingAddLeaveObj, animated: true)
    }
}
