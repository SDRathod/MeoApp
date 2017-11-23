//
//  ScrollLanguage.swift
//  Meopin
//
//  Created by Tops on 11/3/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

@objc protocol ScrollLanguageDelegate {
    @objc optional func didSelectLanguage(scrollObj: ScrollLanguage)
}

class ScrollLanguage: UIView {
    var scrollObj: UIScrollView?
    
    var btnEnglish: UIButton?
    var btnFrench: UIButton?
    var btnDutch: UIButton?
    var btnGerman: UIButton?
    
    var langTextColor: UIColor?
    var langSelTextColor: UIColor?
    
    var boolIsForSlideMenu: Bool = false
    
    var floatFontSize: CGFloat = 13.0
    
    var delegate: ScrollLanguageDelegate?
    
    // MARK: -  Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -  Add Scroll
    func addScrollForLanguage() {
        scrollObj = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollObj?.backgroundColor = .clear
        scrollObj?.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
        scrollObj?.contentOffset = .zero
        self.addSubview(scrollObj!)
        
        if (boolIsForSlideMenu == true) {
            floatFontSize = 9.0
        }
        
        self.addLanguageButtons()
    }
    
    // MARK: -  Add Language buttons & seperators
    func addLanguageButtons() {
        let intBtnCount: Int = 4
        let floatPadding: CGFloat = 3
        let floatWidth: CGFloat = (self.width - ((CGFloat(intBtnCount) * 2) * floatPadding)) / CGFloat(intBtnCount)
        
        //add buttons
        btnEnglish = UIButton(type: .custom)
        btnEnglish?.frame = CGRect(x: floatPadding, y: 0, width: floatWidth, height: self.height)
        btnEnglish?.setTitleColor(langTextColor, for: .normal)
        btnEnglish?.setTitle(Global().getLocalizeStr(key: "keyLangen"), for: .normal)
        btnEnglish?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        btnDutch?.titleLabel?.adjustsFontSizeToFitWidth = true
        btnEnglish?.tag = 0
        btnEnglish?.addTarget(self, action: #selector(btnLanguageClick(sender:)), for: .touchUpInside)
        scrollObj?.addSubview(btnEnglish!)
        
        btnFrench = UIButton(type: .custom)
        btnFrench?.frame = CGRect(x: ((floatPadding * 3) + floatWidth), y: 0, width: floatWidth, height: self.height)
        btnFrench?.setTitleColor(langTextColor, for: .normal)
        btnFrench?.setTitle(Global().getLocalizeStr(key: "keyLangfr"), for: .normal)
        btnFrench?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        btnDutch?.titleLabel?.adjustsFontSizeToFitWidth = true
        btnFrench?.tag = 1
        btnFrench?.addTarget(self, action: #selector(btnLanguageClick(sender:)), for: .touchUpInside)
        scrollObj?.addSubview(btnFrench!)
        
        btnDutch = UIButton(type: .custom)
        btnDutch?.frame = CGRect(x: ((floatPadding * 5) + (floatWidth * 2)), y: 0, width: floatWidth, height: self.height)
        btnDutch?.setTitleColor(langTextColor, for: .normal)
        btnDutch?.setTitle(Global().getLocalizeStr(key: "keyLangnl"), for: .normal)
        btnDutch?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        btnDutch?.titleLabel?.adjustsFontSizeToFitWidth = true
        btnDutch?.tag = 2
        btnDutch?.addTarget(self, action: #selector(btnLanguageClick(sender:)), for: .touchUpInside)
        scrollObj?.addSubview(btnDutch!)
        
        btnGerman = UIButton(type: .custom)
        btnGerman?.frame = CGRect(x: ((floatPadding * 7) + (floatWidth * 3)), y: 0, width: floatWidth, height: self.height)
        btnGerman?.setTitleColor(langTextColor, for: .normal)
        btnGerman?.setTitle(Global().getLocalizeStr(key: "keyLangde"), for: .normal)
        btnGerman?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        btnDutch?.titleLabel?.adjustsFontSizeToFitWidth = true
        btnGerman?.tag = 3
        btnGerman?.addTarget(self, action: #selector(btnLanguageClick(sender:)), for: .touchUpInside)
        scrollObj?.addSubview(btnGerman!)
        
        //add seperators
        for i in 0 ..< intBtnCount-1 {
            let lblSep: UILabel = UILabel(frame: CGRect(x: ((self.width / CGFloat(intBtnCount)) * CGFloat(i)), y: self.height / 4, width: 1, height: self.height / 2))
            lblSep.text = ""
            lblSep.tag = 100 + i + 1
            lblSep.backgroundColor = langTextColor
            scrollObj?.addSubview(lblSep)
        }
        self.languageSelectionChanged(boolNeedDelegate: true)
    }
    
    // MARK: -  Frame changed
    func viewFrameChanged(newFrame: CGRect) {
        self.frame = newFrame
        scrollObj?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        let intBtnCount: Int = 4
        let floatPadding: CGFloat = 3
        let floatWidth: CGFloat = (self.width - ((CGFloat(intBtnCount) * 2) * floatPadding)) / CGFloat(intBtnCount)
        
        btnEnglish?.frame = CGRect(x: floatPadding, y: 0, width: floatWidth, height: self.height)
        btnFrench?.frame = CGRect(x: ((floatPadding * 3) + floatWidth), y: 0, width: floatWidth, height: self.height)
        btnDutch?.frame = CGRect(x: ((floatPadding * 5) + (floatWidth * 2)), y: 0, width: floatWidth, height: self.height)
        btnGerman?.frame = CGRect(x: ((floatPadding * 7) + (floatWidth * 3)), y: 0, width: floatWidth, height: self.height)
        
        for viewTemp in (scrollObj?.subviews)! {
            if (viewTemp.tag > 100) {
                viewTemp.frame = CGRect(x: ((self.width / CGFloat(intBtnCount)) * CGFloat(viewTemp.tag - 100) - 1), y: self.height / 4, width: 1, height: self.height / 2)
                viewTemp.backgroundColor = langTextColor
            }
        }
        self.languageSelectionChanged(boolNeedDelegate: false)
    }
    
    // MARK: -  Button Click Methods
    func btnLanguageClick(sender: UIButton) {
        Global.singleton.intSelLanguageIndexFromScroll = sender.tag
        self.languageSelectionChanged(boolNeedDelegate: true)
    }
    
    // MARK: -  Changed Language selection Method
    func languageSelectionChanged(boolNeedDelegate: Bool) {
        var strSelLangCode: String = ""
        
        btnEnglish?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        btnFrench?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        btnDutch?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        btnGerman?.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
        
        btnEnglish?.setTitleColor(langTextColor, for: .normal)
        btnFrench?.setTitleColor(langTextColor, for: .normal)
        btnDutch?.setTitleColor(langTextColor, for: .normal)
        btnGerman?.setTitleColor(langTextColor, for: .normal)
        
        if (Global.singleton.intSelLanguageIndexFromScroll == 0) {
            btnEnglish?.setTitleColor(langSelTextColor, for: .normal)
            btnEnglish?.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
            strSelLangCode = Global.LanguageData.English
        }
        else if (Global.singleton.intSelLanguageIndexFromScroll == 1) {
            btnFrench?.setTitleColor(langSelTextColor, for: .normal)
            btnFrench?.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
            strSelLangCode = Global.LanguageData.French
        }
        else if (Global.singleton.intSelLanguageIndexFromScroll == 2) {
            btnDutch?.setTitleColor(langSelTextColor, for: .normal)
            btnDutch?.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
            strSelLangCode = Global.LanguageData.Dutch
        }
        else if (Global.singleton.intSelLanguageIndexFromScroll == 3) {
            btnGerman?.setTitleColor(langSelTextColor, for: .normal)
            btnGerman?.titleLabel?.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(floatFontSize))
            strSelLangCode = Global.LanguageData.German
        }
        
        Global.singleton.saveToUserDefaults(value: strSelLangCode, forKey: Global.LanguageData.SelLanguageKey)
        print(Global.LanguageData().SelLanguage)
        
        if (boolNeedDelegate) {
            LocalizeHelper.sharedLocalSystem().setLanguage(Global.LanguageData().SelLanguage)
            Global().delay(delay: 0.01) {
                self.delegate?.didSelectLanguage!(scrollObj: self)
            }
        }
        self.btnEnglish?.setTitle(Global().getLocalizeStr(key: "keyLangen"), for: .normal)
        self.btnFrench?.setTitle(Global().getLocalizeStr(key: "keyLangfr"), for: .normal)
        self.btnDutch?.setTitle(Global().getLocalizeStr(key: "keyLangnl"), for: .normal)
        self.btnGerman?.setTitle(Global().getLocalizeStr(key: "keyLangde"), for: .normal)
    }
}
