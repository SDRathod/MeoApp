//
//  RegisterSuccessFailVC.swift
//  Meopin
//
//  Created by Tops on 9/1/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class RegisterSuccessFailVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgSuccessFailStatus: UIImageView!
    
    @IBOutlet weak var lblFailurMessage: UILabel!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var lblSuccessFirst: UILabel!
    @IBOutlet weak var lblSuccessMiddle: UILabel!
    @IBOutlet weak var lblSuccessLast: UILabel!
    @IBOutlet weak var btnSearchProvider: UIButton!
    @IBOutlet weak var btnGoMeophinBlog: UIButton!
    @IBOutlet weak var btnHome: UIButton!

    @IBOutlet weak var successLayoutTop: NSLayoutConstraint!

    @IBOutlet weak var failerView: UIView!
    @IBOutlet weak var lblFailReason: UILabel!
    @IBOutlet weak var btnSearchActivation: UIButton!
    
    @IBOutlet var lblTTFStatusIcon: UILabel!
    var statusSuccessFail = Bool()

    @IBOutlet weak var failViewLayoutTop: NSLayoutConstraint!
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        if statusSuccessFail == true {
            self.successView.isHidden = false
            self.failerView.isHidden = true
            Global.appDelegate.isSuccess = false
        } else  {
            self.failerView.isHidden = false
            self.successView.isHidden = true
            Global.appDelegate.isSuccess = true
        }
        designLayoutSetup()
        self.setLanguageTitles()
    }
    
    func designLayoutSetup()  {
        if (Global.is_iPhone._4) {
            if Global.appDelegate.isSuccess {
                
            }else  {
                
            }
            
        }
        else if (Global.is_iPhone._5) {
            if Global.appDelegate.isSuccess {
                successLayoutTop.constant = 26
                //searchProvicerLayoutBottom.constant = 60
            }else  {
                
            }
        }
        else if (Global.is_iPhone._6) {
            if Global.appDelegate.isSuccess {
                successLayoutTop.constant = 35
               // searchProvicerLayoutBottom.constant = 66
            }else  {
                failViewLayoutTop.constant = 35
            }
        }
        else if (Global.is_iPhone._6p) {
            if Global.appDelegate.isSuccess {
                successLayoutTop.constant = 40
                //searchProvicerLayoutBottom.constant = 76
            }else  {
                failViewLayoutTop.constant = 35
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        //Failer View Set Language
        
        lblFailurMessage.text = Global().getLocalizeStr(key:  "keyRegisterFailScreenMsg")
        lblFailReason.text = Global().getLocalizeStr(key:  "keyRegisterFailMsg")
        btnSearchActivation.setTitle(Global().getLocalizeStr(key:  "keyRegisterFailMsgCode"), for: .normal)
        if statusSuccessFail == true {
            lblTTFStatusIcon.text = ""
            lblHeaderTitle.text = Global().getLocalizeStr(key:  "keyRegisterSuccessStatus")
        } else  {
            lblTTFStatusIcon.text = ""
            lblHeaderTitle.text = Global().getLocalizeStr(key:  "keyRegisterFailStatus")
        }
        //Success View Set Language
        lblSuccessFirst.text = Global().getLocalizeStr(key:  "keyRegisterSuccessMsgFirst")
        lblSuccessMiddle.text = Global().getLocalizeStr(key:  "keyRegisterSuccessMsgMiddle")
        lblSuccessLast.text = Global().getLocalizeStr(key:  "keyRegisterSuccessMsgLast")
        
        btnSearchProvider.setTitle(Global().getLocalizeStr(key:  "keyRegisterSuccessSearchProvider"), for: .normal)
        
        btnGoMeophinBlog.setTitle(Global().getLocalizeStr(key:  "keyRegisterSuccessMeopinBlog"), for: .normal)
        
        //Footer View Set Language
        btnHome.setTitle(Global().getLocalizeStr(key:  "keyHomeButton"), for: .normal)
    }
    
    func setDeviceSpecificFonts() {
        
        //Header View Set Font
        lblHeaderTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        //Failer View Set Language
        lblFailReason.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
        lblFailurMessage.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))

        btnSearchActivation.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        lblTTFStatusIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(60))

        
        //Success View Set Language

        lblSuccessFirst.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblSuccessMiddle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblSuccessLast.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        
        btnSearchProvider.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))
        btnGoMeophinBlog.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(14))

        
        //Footer View Set Font
        btnHome.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12.5))
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RegisterSuccessFailVC {
    // MARK: -  Button Click Methods
    @IBAction func btnSearchProviderClick(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnBackClick(_ sender: Any) {
        if statusSuccessFail == true {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSearchActivationClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGoMeopinBlogClick(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
