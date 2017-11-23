//
//  PT_HelpDeskVC.swift
//  Meopin
//
//  Created by Tops on 10/6/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PT_HelpDeskVC: UIViewController {
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var webObj: UIWebView!
    
    var spinner: UIView!
    
    var boolIsFromSlideMenu: Bool = true
    
    var mySlideViewObj: MySlideViewController?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webObj.scalesPageToFit = true;
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        
        self.getHelpDeskURLCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        
        if (boolIsFromSlideMenu) {
            btnSlideMenu.isHidden = false
            btnBack.isHidden = true
        }
        else {
            btnSlideMenu.isHidden = true
            btnBack.isHidden = false
        }
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keySlHelpDesk")
    }
    
    func setDeviceSpecificFonts() {
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PT_HelpDeskVC {
    // MARK: -  API Call
    func getHelpDeskURLCall() {
        AFAPIMaster.sharedAPIMaster.getCMSPageListDataCall_Completion(params: nil, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if let arrData: NSArray = dictResponse.object(forKey: "userData") as? NSArray {
                for i in 0 ..< arrData.count {
                    if let dictData: NSDictionary = arrData.object(at: i) as? NSDictionary {
                        if let resultData: NSDictionary = dictData.object(forKey: "result") as? NSDictionary {
                            if (resultData.object(forKey: "id") as? String ?? "" == "1") {
                                let strHelpDeskURL: String = resultData.object(forKey: "url") as? String ?? ""
                                self.webObj.loadRequest(URLRequest(url: URL.init(string: strHelpDeskURL)!))
                            }
                        }
                    }
                }
            }
        })
    }
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - 
extension PT_HelpDeskVC: UIWebViewDelegate {
    // MARK: -  UIWebView Delegate Methods
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        spinner = AFAPIMaster.sharedAPIMaster.addShowLoaderInView(viewObj: self.view, boolShow: true, enableInteraction: true)
        return true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        AFAPIMaster.sharedAPIMaster.hideRemoveLoaderFromView(removableView: spinner, mainView: self.view)
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        AFAPIMaster.sharedAPIMaster.hideRemoveLoaderFromView(removableView: spinner, mainView: self.view)
    }
}
