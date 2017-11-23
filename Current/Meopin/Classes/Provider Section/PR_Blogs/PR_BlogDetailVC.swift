//
//  PR_BlogDetailVC.swift
//  Meopin
//
//  Created by Tops on 11/17/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PR_BlogDetailVC: UIViewController {
    
    @IBOutlet weak var detailWebView: UIWebView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!

    var viewSpinner: UIView = UIView()
    var strWebDetailUrl = String()
    var strWebDetailCategoryName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLanguageText()
        self.detailWebView.delegate = self
        self.detailWebView.loadRequest(NSURLRequest(url: NSURL(string: strWebDetailUrl)! as URL) as URLRequest)

    }

    func setLanguageText(){
        lblTitle.text = Global().getLocalizeStr(key: "KeyBlogDetailTitleHeader")
        self.setDeviceSpecificFont()
    }
    
    func setDeviceSpecificFont() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(16))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Button Back
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension PR_BlogDetailVC:UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.viewSpinner = AFAPICaller().addShowLoaderInView(viewObj: self.view , boolShow: true, enableInteraction: false)!
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        AFAPICaller().hideRemoveLoaderFromView(removableView: self.viewSpinner, mainView: self.view)
        self.detailWebView.isHidden = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        AFAPICaller().hideRemoveLoaderFromView(removableView: self.viewSpinner, mainView: self.view)
    }
    
}
