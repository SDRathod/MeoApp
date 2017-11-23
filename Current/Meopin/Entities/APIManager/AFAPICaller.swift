//
//  AFAPICaller.swift
//  chilax
//   test
//  Created by Tops on 6/15/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import SpinKit
import AFNetworking

class AFAPICaller: NSObject {
    
    typealias AFAPICallerSuccess = (_ responseData: Any, _ success: Bool) -> Void
    typealias AFAPICallerFailure = () -> Void
    typealias DisplayProgress = (_ Progress:Any) -> Void
    
    var manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
    
    
    static let shared = AFAPICaller()
    
    // MARK: -  Add loader in view
    func addShowLoaderInView(viewObj: UIView, boolShow: Bool, enableInteraction: Bool) -> UIView? {
        let viewSpinnerBg = UIView(frame: CGRect(x: (Global.screenWidth - 54.0) / 2.0, y: (Global.screenHeight - 54.0) / 2.0, width: 54.0, height: 54.0))
        viewSpinnerBg.backgroundColor = Global().RGB(r: 240, g: 240, b: 240, a: 0.4)
        viewSpinnerBg.layer.masksToBounds = true
        viewSpinnerBg.layer.cornerRadius = 5.0
        viewObj.addSubview(viewSpinnerBg)
        
        if boolShow {
            viewSpinnerBg.isHidden = false
        }
        else {
            viewSpinnerBg.isHidden = true
        }
        
        if !enableInteraction {
            viewObj.isUserInteractionEnabled = false
        }
        
        //add spinner in view
        let rtSpinKitspinner: RTSpinKitView = RTSpinKitView(style: RTSpinKitViewStyle.styleFadingCircleAlt, color: UIColor.white)
        rtSpinKitspinner.center = CGPoint(x: (viewSpinnerBg.frame.size.width - 8.0) / 2.0, y: (viewSpinnerBg.frame.size.height - 8.0) / 2.0)
        rtSpinKitspinner.color = Global.kAppColor.BlueDark
        rtSpinKitspinner.startAnimating()
        viewSpinnerBg.addSubview(rtSpinKitspinner)
        
        return viewSpinnerBg
    }
    
    
    // MARK: -  Hide and remove loader from view
    func hideRemoveLoaderFromView(removableView: UIView, mainView: UIView) {
        removableView.isHidden = true
        removableView.removeFromSuperview()
        mainView.isUserInteractionEnabled = true
    }
    
    // MARK: -  Call web service with GET method
    func callAPIUsingGET(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        params?.setValue(Global.LanguageData().SelLanguage!, forKey: "form[language]")
        
        let strPath = Global.baseURLPath + filePath;
        print(strPath)
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.requestSerializer.setValue(Global.kLoggedInUserData().AccessToken, forHTTPHeaderField: "accessToken")
        afManager.get(strPath, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "status") as! String == "1") { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                } else {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (responseObject == nil) {
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
            else {
                if let dictResponse: NSDictionary = responseObject as? NSDictionary {
                    if ((dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 400 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 405 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 500) {
                        if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                        }
                        onFailure()
                    }
                    else if (showLoader) {
                        Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                        onFailure()
                    }
                }
                else if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
                self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            }
        }
    }
    
    
    func callAPIUsingPOSTforSearch(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        params?.setValue(Global.LanguageData().SelLanguage!, forKey: "form[language]")
        
        let strPath = Global.baseURLPath + filePath;
        print(strPath)
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        //let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        //manager.session.invalidateAndCancel()
        manager.requestSerializer.setValue(Global.kLoggedInUserData().AccessToken, forHTTPHeaderField: "accessToken")
        
        manager.post(strPath, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "status") as! String == "1") { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                } else {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (responseObject == nil) {
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
            else {
                if let dictResponse: NSDictionary = responseObject as? NSDictionary {
                    if Global.appDelegate.isVarificationFail == true {
                        onFailure()
                        if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                        }
                    }
                    else  {
                        if ((dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 400 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 405 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 500) {
                            if (showLoader) {
                                Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                            } else {
                                self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                            }
                            onFailure()
                        }
                        else if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                            onFailure()
                        } else {
                            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                        }
                    }
                }
                else if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
        }
    }
    
    
    // MARK: -  Call web service with POST method
    func callAPIUsingPOST(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        params?.setValue(Global.LanguageData().SelLanguage!, forKey: "form[language]")
        
        let strPath = Global.baseURLPath + filePath
        print(strPath)
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.requestSerializer.setValue(Global.kLoggedInUserData().AccessToken, forHTTPHeaderField: "accessToken")
        print(params)
        afManager.post(strPath, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "status") as! String == "1") { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                } else {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (responseObject == nil) {
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
            else {
                if let dictResponse: NSDictionary = responseObject as? NSDictionary {
                    if Global.appDelegate.isVarificationFail == true {
                        onFailure()
                        if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                        }
                    }
                    else  {
                        if ((dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 400 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 405 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 500) {
                            if (showLoader) {
                                Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                            } else {
                                self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                            }
                            onFailure()
                        }
                        else if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                            onFailure()
                        } else {
                            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                        }
                    }
                }
                else if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
        }
    }
    
    // MARK: -  Call web service with one image
    func callAPIWithImage(filePath: String, params: NSMutableDictionary?, image: UIImage?, imageParamName: String, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        params?.setValue(Global.LanguageData().SelLanguage!, forKey: "form[language]")
        
        let strPath = Global.baseURLPath + filePath;
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.requestSerializer.setValue(Global.kLoggedInUserData().AccessToken, forHTTPHeaderField: "accessToken")
        
        afManager.post(strPath, parameters: params, constructingBodyWith: { (Data) in
            if (image != nil) {
                let imageData: Data = UIImagePNGRepresentation(image!)!
                Data.appendPart(withFileData: imageData, name: imageParamName, fileName: "photo.png", mimeType: "image/png")
            }
        }, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "status") as! String == "1") { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                } else {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (responseObject == nil) {
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                } else {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                }
            }
            else {
                if let dictResponse: NSDictionary = responseObject as? NSDictionary {
                    if ((dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 400 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 405 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 500) {
                        if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                        }
                        onFailure()
                    }
                    else if (showLoader) {
                        Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                        onFailure()
                    }
                }
                else if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
        }
    }
    
    // MARK: -  Call web service with multi image
    func callAPIWithMultiImage(filePath: String, params: NSMutableDictionary?, images: [UIImage], imageParamNames: [String], enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        params?.setValue(Global.LanguageData().SelLanguage!, forKey: "form[language]")
        
        let strPath = Global.baseURLPath + filePath;
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.requestSerializer.setValue(Global.kLoggedInUserData().AccessToken, forHTTPHeaderField: "accessToken")
        
        afManager.post(strPath, parameters: params, constructingBodyWith: { (Data) in
            var i: Int = 0
            for image in images {
                let imageData: Data = UIImagePNGRepresentation(image)!
                Data.appendPart(withFileData: imageData, name: imageParamNames[i], fileName: "photo.png", mimeType: "image/png")
                i = i+1;
            }
        }, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "status") as! String == "1") { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (responseObject == nil) {
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
            else {
                if let dictResponse: NSDictionary = responseObject as? NSDictionary {
                    if ((dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 400 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 405 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 500) {
                        if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                        }
                        onFailure()
                    }
                    else if (showLoader) {
                        Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                        onFailure()
                    }
                }
                else if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
        }
    }
    
    // MARK: -  Call web service with DELETE method
    func callAPIUsingDELETE(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        params?.setValue(Global.LanguageData().SelLanguage!, forKey: "form[language]")
        
        let strPath = Global.baseURLPath + filePath;
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.requestSerializer.setValue(Global.kLoggedInUserData().AccessToken, forHTTPHeaderField: "accessToken")
        
        afManager.delete(strPath, parameters: params, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "status") as! String == "1") { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (responseObject == nil) {
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
            else {
                if let dictResponse: NSDictionary = responseObject as? NSDictionary {
                    if ((dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 400 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 405 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 500) {
                        if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                        }
                        onFailure()
                    }
                    else if (showLoader) {
                        Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                        onFailure()
                    }
                }
                else if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
        }
    }
    
    
    // Webservice List
    
    
    // MARK: -  Call web service with GET method
    func callAPIUsingGETForBlog(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        
        let strPath = Global.BlogBaseURLPath + filePath;
        print(strPath)
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.get(strPath, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "flag") as! Bool == true) { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                } else {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
                }
                onSuccess(dictResponse, false)
            }

        }) { (task: URLSessionDataTask?, error: Error, responseObject: Any?) in
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (responseObject == nil) {
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
            }
            else {
                if let dictResponse: NSDictionary = responseObject as? NSDictionary {
                    if ((dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 400 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 405 || (dictResponse.object(forKey: "code") as? NSNumber ?? 0) == 500) {
                        if (showLoader) {
                            Global.singleton.showWarningAlert(withMsg: (dictResponse.object(forKey: "message") as? String ?? Global().getLocalizeStr(key: "keyInternetMsg")))
                        }
                        onFailure()
                    }
                    else if (showLoader) {
                        Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                        onFailure()
                    }
                }
                else if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: Global().getLocalizeStr(key: "keyInternetMsg"))
                    onFailure()
                }
                self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            }
        }
    }
}
