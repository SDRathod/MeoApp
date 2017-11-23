//
//  PT_InboxVC.swift
//  Meopin
//
//  Created by Tops on 10/6/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PT_InboxVC: UIViewController {
    
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var tblPatientInbox: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var footerViewLayout: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerTextView: UIView!
    @IBOutlet weak var lblBGBlur: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSearchClose: UIButton!
    @IBOutlet weak var lblInboxCount: UILabel!
    @IBOutlet weak var inboxBlurView: UIView!

    let tblSliderCellIdentifier = "PT_InboxTableCell"
    var mySlideViewObj: MySlideViewController?
    var arrPatineInbox = NSMutableArray()
    var MaxPage : String = ""
    var currentPage : String = ""
    var isBackClick = Bool()
    var intMaxPageCount: Int = 0
    var intPageCount: Int = 1
    var tapGesture = UITapGestureRecognizer()
    var isViewDismiss = false
    
  
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inboxBlurView.isHidden = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.InboxListBlurGestureTapped(_:)))
        inboxBlurView.addGestureRecognizer(tapGesture)
        inboxBlurView.isUserInteractionEnabled = true
        
        inboxBlurView.alpha = 1
        inboxBlurView.backgroundColor = UIColor.clear

        if (Global.kLoggedInUserData().Role == Global.kUserRole.Patient) {
            self.footerView.isHidden = false
            footerViewLayout.constant = 0
            self.footerView.isHidden = false
            
        }else {
            self.footerView.isHidden = true
            footerViewLayout.constant = 0
            self.footerView.isHidden = true
        }
        
        IQKeyboardManager.sharedManager().enable = false
        lblInboxCount.layer.masksToBounds = true
        lblInboxCount.layer.cornerRadius = 5
        txtSearchField.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Keyword)
        footerTextView.layer.masksToBounds = true
        footerTextView.layer.cornerRadius = 5
        txtSearchField.paddingRightLeftviewWithCustomValue(12.0, txtfield: txtSearchField)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tblPatientInbox.estimatedRowHeight = 100.0
        tblPatientInbox.rowHeight = UITableViewAutomaticDimension

        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        tblPatientInbox.register(UINib(nibName: "PT_InboxTableCell", bundle: nil), forCellReuseIdentifier: tblSliderCellIdentifier)
        self.addInfiniteScrollingInbox()
        self.getPatientInboxAPI_Call(strInitialCall:"",intCurrentPage:self.intPageCount)
    }
    
    
    func InboxListBlurGestureTapped(_ sender: UITapGestureRecognizer) {
        self.inboxBlurView.isHidden = true
        isViewDismiss = true
        isBackClick = true
        txtSearchField.resignFirstResponder()
    }
    
    
    func addInfiniteScrollingInbox(){
        self.tblPatientInbox.addInfiniteScrolling {
            self.tblPatientInbox.reloadData()
            if self.arrPatineInbox.count == 1 {
                self.tblPatientInbox.infiniteScrollingView.stopAnimating()
            }
            
            if self.arrPatineInbox.count > 1 {
                if self.intPageCount == self.intMaxPageCount {
                    self.tblPatientInbox.infiniteScrollingView.stopAnimating()
                } else {
                    self.intPageCount = self.intPageCount + 1
                    self.getPatientInboxAPI_Call(strInitialCall:"No",intCurrentPage:self.intPageCount)
                }
            }
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        
        txtSearchField.placeholder = Global().getLocalizeStr(key: "KeyTextSearch")
        lblTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleInbox")
        self.setDeviceSpecificFonts()
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        super.viewWillDisappear(animated)
    }
    
    func getPatientInboxAPI_Call(strInitialCall:String, intCurrentPage:Int){
        //inbox-list
        
        let dictParameter = NSMutableDictionary()
        dictParameter.setValue(Global.kLoggedInUserData().Id!, forKey: "form[userId]")
        dictParameter.setValue("0", forKey: "form[page]")
        AFAPIMaster.sharedAPIMaster.patientInboxCall_Completion(params: dictParameter, showLoader: true, enableInteraction: false, viewObj: self.view) { (returnData:Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if strInitialCall == "" {
                self.arrPatineInbox.removeAllObjects()
            }

            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                self.intMaxPageCount = Int(dictData.value(forKey: "maxPages")as? String ?? "") ?? 0
                if let arrNotificationList = dictData.value(forKey: "notifications") as? NSArray {
                    if intCurrentPage == 1 {
                        self.arrPatineInbox.removeAllObjects()
                    }
                    print(arrNotificationList)
                    for element in arrNotificationList {
                        var dictNotificaiton = NSDictionary()
                        dictNotificaiton = element as! NSDictionary
                        let shareInboxListObj: InboxListSObject = InboxListSObject()
                        shareInboxListObj.strAppointmentID = dictNotificaiton.value(forKey: "appointmentId") as? String ?? ""
                        shareInboxListObj.strUserID = dictNotificaiton.value(forKey: "user") as? String ?? ""
                        shareInboxListObj.strNotification_Type = dictNotificaiton.value(forKey: "notification_type") as? String ?? ""
                        shareInboxListObj.strStatus = dictNotificaiton.value(forKey: "status") as? String ?? ""
                        shareInboxListObj.strDiscription = dictNotificaiton.value(forKey: "description") as? String ?? ""
                        let strDate = dictNotificaiton.value(forKey: "date") as? String ?? ""
                        let strConvertDate = Global.singleton.convertInboxDateTostringFormate(dateSel: strDate)
                        
                        shareInboxListObj.strNotificationDate = strConvertDate
                        self.arrPatineInbox.add(shareInboxListObj)
                    }
                    if self.arrPatineInbox.count > 0 {
                        self.lblInboxCount.text =  String(" \(self.arrPatineInbox.count) ")
                        self.lblInboxCount.isHidden = false
                    } else {
                        self.lblInboxCount.text =  ""
                        self.lblInboxCount.isHidden = true
                    }
                    self.tblPatientInbox.infiniteScrollingView.stopAnimating()
                    self.tblPatientInbox.reloadData()
                }
            }
        }
    }
    
    func setDeviceSpecificFonts() {
        
        btnFilter.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblInboxCount.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
    }
    
    func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            footerViewLayout.constant = keyboardFrame.height
            inboxBlurView.backgroundColor = UIColor.black
            inboxBlurView.alpha = 0.6
            inboxBlurView.isHidden = false

        }
    }
    
    func keyboardHide(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let _ = (infoKey as AnyObject).cgRectValue {
            footerViewLayout.constant = 0
            lblBGBlur.backgroundColor = UIColor.clear
            inboxBlurView.backgroundColor = UIColor.clear
            inboxBlurView.alpha = 1
            inboxBlurView.isHidden = true

        }
    }
}

//MARK: -
extension PT_InboxVC {
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        isBackClick = true
        view.endEditing(true)
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnSearchCloseClick(_ sender: UIButton) {
        self.txtSearchField.text = ""
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        footerViewLayout.constant = 0
        let providerFilterVCObj = ProviderFilterVC(nibName: "ProviderFilterVC", bundle: nil)
        self.navigationController?.pushViewController(providerFilterVCObj, animated: true)
    }
}


//MARK: -
extension PT_InboxVC : UITableViewDelegate ,UITableViewDataSource {
    // MARK: -  UITableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PT_InboxTableCell = tableView.dequeueReusableCell(withIdentifier: tblSliderCellIdentifier, for: indexPath) as! PT_InboxTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if self.arrPatineInbox.count > 0 {
           let shareInboxListObj = self.arrPatineInbox.object(at: indexPath.row)as!InboxListSObject
            cell.lblDate.text = shareInboxListObj.strNotificationDate
            cell.lblMessage.text =  shareInboxListObj.strDiscription
            

            if shareInboxListObj.strNotification_Type == "1"{
                cell.lblNotiTTFIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
                cell.lblNotiTTFIcon.textColor = Global.kAppColor.OffWhite
                cell.lblNotiTTFIcon.backgroundColor = Global.kAppColor.BlueDark
                cell.lblNotiTTFIcon.layer.cornerRadius = cell.lblNotiTTFIcon.frame.height / 2
                cell.lblNotiTTFIcon?.layer.masksToBounds = true
                cell.lblNotiTTFIcon.text = Global().getLocalizeStr(key: "keyIBXTTFRegister")

            }else if shareInboxListObj.strNotification_Type == "2"{
                cell.lblNotiTTFIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
                cell.lblNotiTTFIcon.backgroundColor = UIColor.clear
                cell.lblNotiTTFIcon.textColor = Global.kAppColor.GreenDark
                cell.lblNotiTTFIcon.text = Global().getLocalizeStr(key: "keyIBXTTFCreate")
            }else if shareInboxListObj.strNotification_Type == "3"{
                cell.lblNotiTTFIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
                cell.lblNotiTTFIcon.textColor = Global.kAppColor.Yellow
                cell.lblNotiTTFIcon.backgroundColor = UIColor.clear
                cell.lblNotiTTFIcon.text = Global().getLocalizeStr(key: "keyIBXTTFModify")
                
            }else if shareInboxListObj.strNotification_Type == "4"{
                cell.lblNotiTTFIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
                cell.lblNotiTTFIcon.textColor = Global.kAppColor.Red
                cell.lblNotiTTFIcon.backgroundColor = UIColor.clear
                cell.lblNotiTTFIcon.text = Global().getLocalizeStr(key: "keyIBXTTFModify")
                
            }else if shareInboxListObj.strNotification_Type == "5"{
                cell.lblNotiTTFIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
                cell.lblNotiTTFIcon.textColor = Global.kAppColor.BlueDark
                cell.lblNotiTTFIcon.backgroundColor = UIColor.clear
                cell.lblNotiTTFIcon.text = Global().getLocalizeStr(key: "keyIBXTTFAccept")
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPatineInbox.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // MARK: -  UITableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shareInboxListObj = self.arrPatineInbox.object(at: indexPath.row)as!InboxListSObject
        if shareInboxListObj.strNotification_Type == "1" {
            return
        }
        let pr_appointmentDetailObj = PR_AppointmentDetailVC(nibName: "PR_AppointmentDetailVC", bundle: nil)
        pr_appointmentDetailObj.strSelAppoId = shareInboxListObj.strAppointmentID
        self.navigationController?.pushViewController(pr_appointmentDetailObj, animated: true)
    }
    
}

// MARK: -
extension PT_InboxVC : UITextFieldDelegate {

    // MARK: -  UITextfield Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isViewDismiss = false
        self.inboxBlurView.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
            btnSearchClose.isHidden = true
        } else {
            btnSearchClose.isHidden = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isBackClick == false {
            Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.Page)
            let strTrim = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (strTrim?.characters.count)! > 0 {
                Global.singleton.saveToUserDefaults(value: strTrim!, forKey: Global.kSearchFilterParamKey.Keyword)
            } else {
                Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
            }
            Global.singleton.saveToUserDefaults(value: "1" , forKey: Global.kSearchFilterParamKey.isFromFavorite)
            Global.appDelegate.mySlideViewObj?.setGoToSearchMapViewControllerController()
        }
    }
}
