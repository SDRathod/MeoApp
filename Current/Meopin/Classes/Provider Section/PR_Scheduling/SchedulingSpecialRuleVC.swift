//
//  SchedulingSpecialRuleVC.swift
//  Meopin
//
//  Created by Tops on 9/18/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingSpecialRuleVC: UIViewController {
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblSpecialRuleTitle: UILabel!
    @IBOutlet var btnAddSpecialRule: UIButton!
    
    @IBOutlet var tblSpecialRules: UITableView!
    
    var arrSpecialRules: [SpecialRuleSObject] = [SpecialRuleSObject]()
    var arrNthDay: [ScheduleNthDaySObject] = [ScheduleNthDaySObject]()
    var arrNthDate: [ScheduleNthDaySObject] = [ScheduleNthDaySObject]()
        
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSpecialRules.register(UINib(nibName: "SchedulingSpecialRuleCell", bundle: nil), forCellReuseIdentifier: "SchedulingSpecialRuleCell")
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
        
        lblTitle.text = Global().getLocalizeStr(key: "keyPSSpcRuleHalfTitle")
        lblSpecialRuleTitle.text = Global().getLocalizeStr(key: "keyPSSpcRuleTitle")
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblSpecialRuleTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        btnAddSpecialRule.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(40))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension SchedulingSpecialRuleVC {
    // MARK: -  API Call
    func getProviderSchedulingConfigCall() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        
        AFAPIMaster.sharedAPIMaster.getProviderSchedulingDataCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
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
                self.tblSpecialRules.reloadData()
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnAddSpecialRuleClick(_ sender: Any) {
        let schedulingAddSpeRuleObj = SchedulingAddSpeRuleVC(nibName: "SchedulingAddSpeRuleVC", bundle: nil)
        schedulingAddSpeRuleObj.arrNthDay = self.arrNthDay
        schedulingAddSpeRuleObj.arrNthDate = self.arrNthDate
        self.navigationController?.pushViewController(schedulingAddSpeRuleObj, animated: true)
    }
}

// MARK: -
extension SchedulingSpecialRuleVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: -  UITableView DataSource & Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSpecialRules.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Global.singleton.getDeviceSpecificFontSize(67)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchedulingSpecialRuleCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingSpecialRuleCell", for: indexPath) as! SchedulingSpecialRuleCell
        cell.setLanguageTitles()
        
        let shareObj: SpecialRuleSObject = arrSpecialRules[indexPath.row]
        cell.lblRuleTitle.text = shareObj.strRuleTitle
        if (shareObj.strRuleType == "2") {
            cell.lblRuleType.text = Global().getLocalizeStr(key: "keyPSRuleOffDay")
            cell.lblRuleDetail.text = Global().getLocalizeStr(key: "keyPSOfEveryMonth")
        }
        else {
            cell.lblRuleType.text = Global().getLocalizeStr(key: "keyPSRuleSpeDay")
            cell.lblRuleDetail.text = "\(Global().getLocalizeStr(key: "keyPSOfEveryMonth")) - \(shareObj.strRuleFromTime) \(Global().getLocalizeStr(key: "keyPSOnToSmall")) \(shareObj.strRuleToTime)"
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shareObj: SpecialRuleSObject = arrSpecialRules[indexPath.row]
        let schedulingAddSpeRuleObj = SchedulingAddSpeRuleVC(nibName: "SchedulingAddSpeRuleVC", bundle: nil)
        schedulingAddSpeRuleObj.strSelRuleId = shareObj.strRuleId
        schedulingAddSpeRuleObj.shareObjSpeRule = shareObj
        schedulingAddSpeRuleObj.arrNthDay = self.arrNthDay
        schedulingAddSpeRuleObj.arrNthDate = self.arrNthDate
        self.navigationController?.pushViewController(schedulingAddSpeRuleObj, animated: true)
    }
}
