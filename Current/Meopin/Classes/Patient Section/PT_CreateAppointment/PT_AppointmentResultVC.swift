//
//  PT_AppointmentResultVC.swift
//  Meopin
//
//  Created by Tops on 10/25/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PT_AppointmentResultVC: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSmile: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblMessage2: UILabel!
    @IBOutlet weak var btnAppointmentDetail: UIButton!
    
    var dictSelProviderData = NSDictionary()
    var dictPatietnDetail = NSDictionary()
    
    var strSelDate: String = ""
    var strSelFromTime: String = ""
    var strSelToTime: String = ""
    var strSelProviderId: String = ""
    var strAppoimentID: String = ""
    var appointmentDetail = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfile.layer.masksToBounds = true
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
        self.patientViewAppointmentApi_Call()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;

        self.setDeviceSpecificFont()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
    }
    
    func setDeviceSpecificFont() {
        btnAppointmentDetail.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(13))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        lblReason.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblPatientName.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblSmile.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(80))
        lblMessage.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(20))
        lblMessage2.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        
        self.setLanguageTitles()
    }
    
    func setLanguageTitles() {
        lblTitle.text = Global().getLocalizeStr(key:  "keyRVW6ThankYou")
        lblSmile.text = Global().getLocalizeStr(key:  "")
        lblMessage.text = Global().getLocalizeStr(key:  "keyRequestSentMsg")
        lblMessage2.text = Global().getLocalizeStr(key: "keyRequestSentMsg1")
        btnAppointmentDetail.setTitle(Global().getLocalizeStr(key:  "keyGoAppointmentDetail"), for: .normal)
    }
    func patientViewAppointmentApi_Call() {
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        param.setValue(strAppoimentID, forKey: "form[appointmentId]")
        
        print(param)
        AFAPIMaster.sharedAPIMaster.PatientProviderAppointmentDetialApi_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                if let dictDetail: NSDictionary = dictData.object(forKey: "appointment") as? NSDictionary {
                    print(dictDetail)
                    
                    let shareObj: AppointmentSObject = AppointmentSObject()
                    
                    shareObj.strAppId = dictDetail.object(forKey: "id") as? String ?? ""
                    shareObj.strAppTitle = String(format: "%@ %@", dictDetail.object(forKey: "firstName") as? String ?? "", dictDetail.object(forKey: "lastName") as? String ?? "")
                    
                    shareObj.strFirstNameLastName = String(format: "%@ %@", dictDetail.object(forKey: "firstName") as? String ?? "", dictDetail.object(forKey: "lastName") as? String ?? "")
                    shareObj.strAppBGColor = dictDetail.object(forKey: "color") as? String ?? ""
                    shareObj.strEmail = dictDetail.object(forKey: "email") as? String ?? ""
                    
                    shareObj.strAppTextColor = dictDetail.object(forKey: "textColor") as? String ?? ""
                    shareObj.strAppDate = dictDetail.object(forKey: "appointmentDate") as? String ?? ""
                    shareObj.strAppStartTime = dictDetail.object(forKey: "startTime") as? String ?? ""
                    shareObj.strAppEndTime = dictDetail.object(forKey: "endTime") as? String ?? ""
                    shareObj.strAppReason = dictDetail.object(forKey: "reasonFor") as? String ?? ""
                    shareObj.strPatProPic = dictDetail.object(forKey: "profilePatientPictureUrl") as? String ?? ""
                    shareObj.strStausTitle = dictDetail.object(forKey: "statusLable") as? String ?? ""
                    shareObj.strPersonalMessage = dictDetail.object(forKey: "personalMessage") as? String ?? ""

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
                        }
                    }
                    self.appointmentDetail.add(shareObj)
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
                lblReason.text = dictReason.object(forKey: "name") as? String ?? ""
            }
            lblPatientName.text = shareObj.strFirstNameLastName
            if shareObj.strPatProPic == ""  {
                imgProfile.sd_setImage(with: URL.init(string: dictSelProviderData.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
            else {
                imgProfile.sd_setImage(with: URL.init(string: shareObj.strPatProPic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAppointmentDetialClicked(_ sender: UIButton) {
        let PR_AppointmentDetailVCObj = PR_AppointmentDetailVC(nibName: "PR_AppointmentDetailVC", bundle: nil)
        PR_AppointmentDetailVCObj.dictSelProviderData = self.dictSelProviderData
        PR_AppointmentDetailVCObj.strSelDate = self.strSelDate
        PR_AppointmentDetailVCObj.strSelFromTime = self.strSelFromTime
        PR_AppointmentDetailVCObj.strSelToTime = self.strSelToTime
        PR_AppointmentDetailVCObj.strSelAppoId = self.strAppoimentID
        PR_AppointmentDetailVCObj.strSelProviderId = self.strSelProviderId
        self.navigationController?.pushViewController(PR_AppointmentDetailVCObj, animated: true)
    }
}
