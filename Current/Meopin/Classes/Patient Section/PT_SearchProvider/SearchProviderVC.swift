//
//  SearchProviderVC.swift
//  Meopin
//
//  Created by Tops on 9/12/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import MapKit

class SearchProviderVC: UIViewController {
    
    var mySlideViewObj: MySlideViewController?

    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSearchIcon: UILabel!
    @IBOutlet weak var lblMapListIcon: UILabel!
    @IBOutlet weak var lblSearchListIcon: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblReasonTitle: UILabel!
    @IBOutlet weak var lblMeopinLogo: UILabel!
    @IBOutlet var btnSearchWithMap: UIButton!
    @IBOutlet var btnSearchWithList: UIButton!
    @IBOutlet var btnNoNeedMore: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblMeopinLayoutTop: NSLayoutConstraint!
    @IBOutlet weak var txtSearchTopLayout: NSLayoutConstraint!
    @IBOutlet weak var btnMapLayoutTop: NSLayoutConstraint!
    @IBOutlet weak var btnNeedMoreLayoutTop: NSLayoutConstraint!

    // MARK: -  View Life Cycle Start Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.layer.cornerRadius = 2.0
        txtSearch.layer.borderWidth = 0.8
        txtSearch.layer.borderColor = Global.kAppColor.BlueDark.cgColor
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;

        let strIsFavorit = Global.singleton.retriveFromUserDefaults(key:Global.kSearchFilterParamKey.isFromFavorite )
        if strIsFavorit == "1" {
            let strTrim = txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (strTrim?.characters.count)! > 0 {
                Global.singleton.saveToUserDefaults(value: strTrim!, forKey: Global.kSearchFilterParamKey.Keyword)
            } else {
                Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
            }
            let searchListMapProviderVCObj = SearchListMapProviderVC(nibName: "SearchListMapProviderVC", bundle: nil)
            if Global.appDelegate.isMapList == true {
                searchListMapProviderVCObj.isMapOrList = true
                Global.singleton.saveToUserDefaults(value:"1", forKey: Global.kSearchFilterParamKey.ResultType)
            } else {
                Global.singleton.saveToUserDefaults(value:"0", forKey: Global.kSearchFilterParamKey.ResultType)
                searchListMapProviderVCObj.isMapOrList = false
            }
            self.navigationController?.pushViewController(searchListMapProviderVCObj, animated: false)
        }
        txtSearch.paddingRightLeftviewWithCustomValue(12.0, txtfield: txtSearch)
        self.deviceSpecify()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        
        txtSearch.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Keyword)
        
        if Global.appDelegate.isMapList == true {
            btnSearchWithList.backgroundColor = Global.kAppColor.LightGray
            btnSearchWithList.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            lblSearchListIcon.layer.cornerRadius = lblMapListIcon.frame.size.height / 2
            lblSearchListIcon.textColor = Global.kAppColor.GrayLight
            btnSearchWithMap.backgroundColor = Global.kAppColor.BlueDark
            btnSearchWithMap.setTitleColor(Global.kAppColor.OffWhite, for: .normal)
            lblMapListIcon.textColor = Global.kAppColor.OffWhite
            lblMapListIcon.layer.cornerRadius = lblSearchListIcon.frame.size.height / 2
        } else {
            btnSearchWithMap.backgroundColor = Global.kAppColor.LightGray
            btnSearchWithMap.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
            lblMapListIcon.layer.cornerRadius = lblMapListIcon.frame.size.height / 2
            lblMapListIcon.textColor = Global.kAppColor.GrayLight
            
            btnSearchWithList.backgroundColor = Global.kAppColor.BlueDark
            btnSearchWithList.setTitleColor(Global.kAppColor.OffWhite, for: .normal)
            lblSearchListIcon.textColor = Global.kAppColor.OffWhite
            lblSearchListIcon.layer.cornerRadius = lblSearchListIcon.frame.size.height / 2
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
        lblTitle.text = Global().getLocalizeStr(key: "keyPSearchTitle")
        lblReasonTitle.text = Global().getLocalizeStr(key: "keyPSearchReason")
        lblSpeciality.text = Global().getLocalizeStr(key: "keyPSearchSpeciality")
        btnSearchWithMap.setTitle(Global().getLocalizeStr(key: "keyPSearchViewMap"), for: .normal)
        txtSearch.placeholder = Global().getLocalizeStr(key: "keyPSearchPlaceHolder")
        lblMapListIcon.text = Global().getLocalizeStr(key: "KeyBtnSelectIcon")
        btnSearchWithList.setTitle (Global().getLocalizeStr(key: "keyPSearchViewListing"), for: .normal)
        btnNoNeedMore.setTitle (Global().getLocalizeStr(key: "keyPSearchNeedMore"), for: .normal)
        btnSearch.setTitle(Global().getLocalizeStr(key: "keyPSearch"), for: .normal)
        let isFromSlideMenu = Global.singleton.retriveFromUserDefaults(key:"isClickSlidMenu")
        if isFromSlideMenu == "1" {
            btnBack.setTitle(Global().getLocalizeStr(key: ""), for: .normal)
        } else  {
            btnBack.setTitle(Global().getLocalizeStr(key: ""), for: .normal)
        }
        
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        txtSearch.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))

        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblMeopinLogo.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(36))
        lblReasonTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblSpeciality.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnSearchWithMap.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnSearchWithList.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnNoNeedMore.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnSearch.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        txtSearch.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
    }
    
    func deviceSpecify()  {
        if Global.is_iPhone._4 {
            lblMeopinLayoutTop.constant = 20
            txtSearchTopLayout.constant = 15
            btnMapLayoutTop.constant = 25
            btnNeedMoreLayoutTop.constant = 15
            
        }else if Global.is_iPhone._6 {
            lblMeopinLayoutTop.constant = 55
            txtSearchTopLayout.constant = 30
            btnMapLayoutTop.constant = 55
            btnNeedMoreLayoutTop.constant = 34
            
        }
        else if Global.is_iPhone._6p {
            lblMeopinLayoutTop.constant = 55
            txtSearchTopLayout.constant = 38
            btnMapLayoutTop.constant = 60
            btnNeedMoreLayoutTop.constant = 40
        }
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}


//MARK: -
extension SearchProviderVC {
    
    // MARK: -  Button Click Methods
    @IBAction func btnBackClick(_ sender: Any) {
        let isFromSlideMenu = Global.singleton.retriveFromUserDefaults(key:"isClickSlidMenu")
        let strIsFavorit = Global.singleton.retriveFromUserDefaults(key:Global.kSearchFilterParamKey.isFromFavorite )
        
        if isFromSlideMenu == "1" || strIsFavorit == "1" {
            mySlideViewObj?.menuBarButtonItemPressed(sender)
        } else  {
            self.mySlideViewObj?.addDynamicDataSource()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "101"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSearchWithMapClick(_ sender: UIButton) {
        sender.backgroundColor = Global.kAppColor.BlueDark
        sender.setTitleColor(Global.kAppColor.OffWhite, for: .normal)
        lblMapListIcon.textColor = Global.kAppColor.OffWhite
        btnSearchWithList.backgroundColor = Global.kAppColor.LightGray
        btnSearchWithList.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        lblSearchListIcon.textColor = Global.kAppColor.GrayLight
        Global.singleton.saveToUserDefaults(value:"1", forKey: Global.kSearchFilterParamKey.ResultType)
        Global.appDelegate.isMapList = true
    }
    
    @IBAction func btnSearchWithListClick(_ sender: UIButton) {
        sender.backgroundColor = Global.kAppColor.BlueDark
        sender.setTitleColor(Global.kAppColor.OffWhite, for: .normal)
        lblSearchListIcon.textColor = Global.kAppColor.OffWhite
        btnSearchWithMap.backgroundColor = Global.kAppColor.LightGray
        btnSearchWithMap.setTitleColor(Global.kAppColor.GrayLight, for: .normal)
        lblMapListIcon.textColor = Global.kAppColor.GrayLight
        Global.singleton.saveToUserDefaults(value:"0", forKey: Global.kSearchFilterParamKey.ResultType)
        Global.appDelegate.isMapList = false

    }
    @IBAction func btnNoNeedMoreClick(_ sender: Any) {
        let ProviderFilterVCObj = ProviderFilterVC(nibName: "ProviderFilterVC", bundle: nil)
        self.navigationController?.pushViewController(ProviderFilterVCObj, animated: true)
    }
   
    
    @IBAction func btnSearchClick(_ sender: Any) {
        
        let strTrim = txtSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (strTrim?.characters.count)! > 0 {
            Global.singleton.saveToUserDefaults(value: strTrim!, forKey: Global.kSearchFilterParamKey.Keyword)
        } else {
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
        }
        let searchListMapProviderVCObj = SearchListMapProviderVC(nibName: "SearchListMapProviderVC", bundle: nil)
       if Global.appDelegate.isMapList == true {
            searchListMapProviderVCObj.isMapOrList = true
        Global.singleton.saveToUserDefaults(value:"1", forKey: Global.kSearchFilterParamKey.ResultType)
        } else {
        Global.singleton.saveToUserDefaults(value:"0", forKey: Global.kSearchFilterParamKey.ResultType)
            searchListMapProviderVCObj.isMapOrList = false
        }
        self.navigationController?.pushViewController(searchListMapProviderVCObj, animated: true)
    }
}

extension SearchProviderVC : UITextFieldDelegate {
    // MARK: -  UITextfield Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let strTrim = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (strTrim?.characters.count)! > 0 {
            Global.singleton.saveToUserDefaults(value: strTrim!, forKey: Global.kSearchFilterParamKey.Keyword)
        } else {
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
        }
    }
}
