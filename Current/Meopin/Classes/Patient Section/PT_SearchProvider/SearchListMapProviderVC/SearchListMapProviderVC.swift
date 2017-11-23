//
//  SearchProviderVC.swift
//  Meopin
//
//  Created by Tops on 9/12/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import MapKit
import IQKeyboardManagerSwift
import SDWebImage
import MessageUI
import SVPullToRefresh

let regionRadius: CLLocationDistance = 1000
class SearchListMapProviderVC: UIViewController {
    
    var mySlideViewObj: MySlideViewController?

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var mapProfileView: UIView!
    @IBOutlet weak var generalSearchView: UIView!
    @IBOutlet weak var generalSearchLable: UIView!
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblResultCount: UILabel!
    
    @IBOutlet var viewMapProvider: UIView!
    @IBOutlet var mapProviderObj: REVClusterMapView!
    
    @IBOutlet var viewListProvider: UIView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet var tblProviderList: UITableView!
    
    @IBOutlet weak var txtSearchFiled: UITextField!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var footerViewLayout: NSLayoutConstraint!
    
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var footerTextView: UIView!
    
    @IBOutlet weak var userMapProfile: UIView!
    @IBOutlet weak var userMapDetailView: UIView!
    @IBOutlet weak var btnResetMap: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblDocHospitalName: UILabel!
    @IBOutlet weak var lblRecomondedCount: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSpecialist: UILabel!
    @IBOutlet weak var lblNoRecordFound: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnUserDetail: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnCalenderProvider: UIButton!
    @IBOutlet weak var btnCallProvider: UIButton!
    @IBOutlet weak var btnMessageProvider: UIButton!
    @IBOutlet weak var btnEmailProvider: UIButton!
    @IBOutlet weak var btnLikeProvider: UIButton!
    
    var intTotalPage = 0
    var intPageCount = 0
    var param = NSMutableDictionary()
    var viewSpinner: UIView = UIView()
    var isBackgroundWSCall = false
    let tblCellidentifier = "SearchProviderTableCell"
    var isMapOrList = Bool()
    var mapChangedFromUserInteraction = false
    var arrResultObj =  NSMutableArray()
    var customAnotationView :MapCustomAnnotationView?
    var customProfileObj :MapCustomProfile?
    var getMapCenterLatLong : CLLocationCoordinate2D?
    //var mapViewReference = MKMapView()
    var locationAllLatLong = NSMutableDictionary()
    var intSelectPinTag = Int()
    let strIsFavorit : String = ""
    var floatCenterLat  : Double = 0.0
    var floatCenterLong : Double = 0.0
    
    var mapLocation: CLLocation?
    var isMapZoom = Bool()
    var count = 0
    var tapGesture = UITapGestureRecognizer()
    var isViewDismiss = false
    
    
    func ProviderListBlurGestureTapped(_ sender: UITapGestureRecognizer) {
        isViewDismiss = true
        txtSearchFiled.resignFirstResponder()
    }
    
    func myviewTapped(_ sender: UITapGestureRecognizer) {
        self.mapProfileView.isHidden = true
        txtSearchFiled.resignFirstResponder()
    }
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;

        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.ProviderListBlurGestureTapped(_:)))
        generalSearchView.addGestureRecognizer(tapGesture)
        generalSearchView.isUserInteractionEnabled = true
        
        generalSearchView.alpha = 1
        generalSearchLable.backgroundColor = UIColor.clear
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        mapProfileView.addGestureRecognizer(tapGesture)
        mapProfileView.isUserInteractionEnabled = true
        
        mapProfileView.alpha = 1
        mapProfileView.backgroundColor = UIColor.clear
        
        userMapProfile.layer.borderWidth = 1.4
        userMapProfile.layer.borderColor = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 0.5).cgColor
        userMapProfile.layer.cornerRadius = 5
        txtSearchFiled.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Keyword)
       /* Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat4)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong4)*/
        Global.singleton.saveToUserDefaults(value:String(0), forKey:Global.kSearchFilterParamKey.Page)
        
        btnCancel.layer.cornerRadius = btnCancel.frame.size.height / 2 - 10
        userMapDetailView.layer.cornerRadius = 15
        
        IQKeyboardManager.sharedManager().enable = false
        tblProviderList.register(UINib(nibName: "SearchProviderTableCell", bundle: nil), forCellReuseIdentifier: tblCellidentifier)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.setUpMapMethod()
        if Global.appDelegate.isLocationOn == false {
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.MapCenterLat)
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.MapCenterLong)
        }
        
        self.intPageCount = 0
        Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.Page)
        
        if isMapOrList == true {
            Global().delay(delay: 0.1, closure: {
                self.genericSearchApiCall_Method(intPage: 0, isLoader: true)
            })
        } else  {
            Global().delay(delay: 0.1, closure: {
                Global.singleton.saveToUserDefaults(value: String(0) , forKey: Global.kSearchFilterParamKey.Page)
                self.genericSearchApiCallForTableList_Method(intPage: self.intPageCount)
            })
        }
        
        mapProviderObj.showsUserLocation = true
        self.viewListProvider.isHidden = false
        self.viewMapProvider.isHidden = false
        
        if isMapOrList == true {
            self.viewListProvider.isHidden = true
        }
        else {
            self.viewMapProvider.isHidden = true
            self.tblProviderList.reloadData()
        }
        
        footerTextView.layer.masksToBounds = true
        footerTextView.layer.cornerRadius = 5
        txtSearchFiled.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParameterKey.Keyword)
        tblProviderList.estimatedRowHeight = 200
        tblProviderList.rowHeight = UITableViewAutomaticDimension
        self.addInfiniteScrolling()
    }
    
    
    func setUpMapMethod() {
        //map code
        
        mapLocation = Global.appDelegate.locationManager.location
        
        if (!CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied) {
            var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
            coordinateRegion.center = mapProviderObj.centerCoordinate
            coordinateRegion.span.latitudeDelta = 8
            coordinateRegion.span.longitudeDelta = 8
            
            Global.appDelegate.floatCurrentLat = Float(coordinateRegion.center.latitude)
            Global.appDelegate.floatCurrentLong = Float(coordinateRegion.center.longitude)
            
            self.mapLocation = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            
            Global.singleton.saveToUserDefaults(value: String(Global.appDelegate.floatCurrentLat), forKey: Global.kSearchFilterParamKey.Lat)
            Global.singleton.saveToUserDefaults(value: String(Global.appDelegate.floatCurrentLong), forKey: Global.kSearchFilterParamKey.Long)
            
            mapProviderObj.setRegion(coordinateRegion, animated: true)
        }
        else {
            Global().delay(delay: 0.2, closure: {
                
                var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
                
                //  Global.appDelegate.floatCurrentLat = 42.330887
                //Global.appDelegate.floatCurrentLong = -73.257377
                
                coordinateRegion.center.latitude = CLLocationDegrees(Global.appDelegate.floatCurrentLat)
                coordinateRegion.center.longitude = CLLocationDegrees(Global.appDelegate.floatCurrentLong)
                
                coordinateRegion.span.latitudeDelta = 8
                coordinateRegion.span.longitudeDelta = 8
                
                self.mapProviderObj.setRegion(coordinateRegion, animated: true)
                self.mapLocation = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            })
        }
        
        if (mapLocation != nil) {
            mapProviderObj.centerCoordinate = CLLocationCoordinate2DMake((mapLocation?.coordinate.latitude)!, (mapLocation?.coordinate.longitude)!)
        }
        
        mapProviderObj.showsUserLocation = true
        self.viewListProvider.isHidden = false
        self.viewMapProvider.isHidden = false
        
        if isMapOrList == true {
            self.viewListProvider.isHidden = true
        }
        else {
            self.viewMapProvider.isHidden = true
            self.tblProviderList.reloadData()
        }
        
        mapProviderObj.showsUserLocation = true
        self.viewListProvider.isHidden = false
        self.viewMapProvider.isHidden = false
        
        if isMapOrList == true {
            self.viewListProvider.isHidden = true
        }
        else {
            self.viewMapProvider.isHidden = true
            self.tblProviderList.reloadData()
        }
        
    }
    
    func addInfiniteScrolling(){
        self.tblProviderList.addInfiniteScrolling {
            self.tblProviderList.reloadData()
            if self.arrResultObj.count == 1 {
                self.tblProviderList.infiniteScrollingView.stopAnimating()
            }
            
            if self.arrResultObj.count > 1 {
                if self.intPageCount == self.intTotalPage {
                    self.tblProviderList.showsPullToRefresh  = false
                    self.tblProviderList.showsInfiniteScrolling = false
                    self.tblProviderList.infiniteScrollingView.stopAnimating()
                } else {
                    self.genericSearchApiCallForTableList_Method(intPage: self.intPageCount)
                }
            }
        }
    }
    
    func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            footerViewLayout.constant = keyboardFrame.height
            generalSearchLable.backgroundColor = UIColor.black
            generalSearchView.alpha = 0.6
            generalSearchView.isHidden = false
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let _ = (infoKey as AnyObject).cgRectValue {
            footerViewLayout.constant = 0
            generalSearchLable.backgroundColor = UIColor.clear
            generalSearchView.alpha = 1
            generalSearchView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSearchFiled.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Keyword)
        mapProviderObj.showsUserLocation = true;
        self.navigationController?.isNavigationBarHidden = true;
        self.mapProfileView.isHidden = true
        self.setLanguageTitles()
        
        if isMapOrList == true {
            Global().delay(delay: 0.1, closure: {
                self.genericSearchApiCall_Method(intPage: 0, isLoader: true)
            })
        } else  {
            Global().delay(delay: 0.1, closure: {
                Global.singleton.saveToUserDefaults(value: String(0) , forKey: Global.kSearchFilterParamKey.Page)
                self.genericSearchApiCallForTableList_Method(intPage: self.intPageCount)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapProviderObj.showsUserLocation = true
        self.lblRating.layer.cornerRadius = self.lblRating.height / 2
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        txtSearchFiled.placeholder = Global().getLocalizeStr(key: "KeyTextSearch")
        lblTitle.text = Global().getLocalizeStr(key: "keySearchResult")
        let strIsFavorit = Global.singleton.retriveFromUserDefaults(key:Global.kSearchFilterParamKey.isFromFavorite )
        if strIsFavorit == "1" {
            btnBack.setTitle(Global().getLocalizeStr(key: ""), for: .normal)
        } else {
            btnBack.setTitle(Global().getLocalizeStr(key: ""), for: .normal)
        }
        
        if isMapOrList == true {
            btnList.setTitle(Global().getLocalizeStr(key: "keyListIcon"), for: .normal)
        }
        else {
            btnList.setTitle(Global().getLocalizeStr(key: "keyMapIcon"), for: .normal)
        }
    }
    
    func setDeviceSpecificFonts() {
        txtSearchFiled.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(16))
        btnList.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(18))
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnFilter.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(18))
        lblAddress.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblDistance.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(7))
        lblDocHospitalName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblSpecialist.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
    }
    
    // MARK: -  REVCluster Setup Method
    func setupRevClusterMethod() {
        
        var pins = [Any]()
        for (index,element) in arrResultObj.enumerated() {
            var diction = NSDictionary()
            diction = element as! NSDictionary
            
            let lat:CLLocationDegrees = CLLocationDegrees(diction.object(forKey: "lat") as? String ?? "")!
            let long:CLLocationDegrees = CLLocationDegrees(diction.object(forKey: "lng") as? String ?? "")!
            let newCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long);
            let pin = REVClusterPin()
            pin.dictObj = diction as! [AnyHashable : Any]
            pin.coordinate = newCoord
            pin.title = ""
            pin.intPinId = Int32(index)
            pins.append(pin)
        }
        
        mapProviderObj.removeAnnotations(pins as! [MKAnnotation])
        mapProviderObj.addAnnotations(pins as! [MKAnnotation])
        AFAPICaller().hideRemoveLoaderFromView(removableView: self.viewSpinner, mainView: self.view)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapProviderObj.setRegion(coordinateRegion, animated: true)
    }
    
    func clearAllDataLatitudeLongitute() {
        
        let strFilterCountry = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CityAndCountry)
        if strFilterCountry == "" || (strFilterCountry?.isEmpty)! || strFilterCountry?.characters.count == 0 {
            Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Lat)
            Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Long)
        } else  {
            
        }
        
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.MapCenterLat)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.MapCenterLong)
        
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat4)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong4)
    }
    
    func clearAllDataLatitudeLongituteList() {
        
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat1)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong2)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong3)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLat4)
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.CurrLong4)
    }
}


//MARK: -
extension SearchListMapProviderVC {
    
    // MARK: -  Button Click Methods
    @IBAction func btnResetMapClick(_ sender: UIButton) {
        self.intPageCount = 0
        Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.Page)
        Global().delay(delay: 0.1, closure: {
            //  self.mapProviderObj.isUserInteractionEnabled = false
            self.genericSearchApiCall_Method(intPage: 0, isLoader: true)
        })
        self.btnResetMap.isHidden = true
    }
    
    @IBAction func btnCalenderClick(_ sender: UIButton) {
        
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
            let pt_CreateAppointmentSlotObj = PT_CreateAppointmentSlotVC(nibName: "PT_CreateAppointmentSlotVC", bundle: nil)
            pt_CreateAppointmentSlotObj.strSelProviderId = dictionary.value(forKey: "id") as? String ?? ""
            pt_CreateAppointmentSlotObj.dictSelProviderData = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
            self.navigationController?.pushViewController(pt_CreateAppointmentSlotObj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    @IBAction func btnLikeClick(_ sender: UIButton) {
    }
    @IBAction func btnMessageClick(_ sender: UIButton) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
            
            let pt_writeReviewStep1Obj = PT_WriteReviewStep1VC(nibName: "PT_WriteReviewStep1VC", bundle: nil)
            pt_writeReviewStep1Obj.strSelProviderId = dictionary.value(forKey: "id") as? String ?? ""
            pt_writeReviewStep1Obj.dictSelProviderData = dictionary
            self.navigationController?.pushViewController(pt_writeReviewStep1Obj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    @IBAction func btnCallClick(_ sender: UIButton) {
        let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        var strPhoneNo = dictionary.value(forKey: "phoneNumber") as? String ?? ""
        strPhoneNo = strPhoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        if strPhoneNo.isEmpty || strPhoneNo == "" {
            Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoMobileNoAlert"))
            return
        }
        if let phoneCallURL = URL(string: "tel://\(strPhoneNo)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: { (finish) in
                    })
                } else {
                    UIApplication.shared.openURL(phoneCallURL)
                }
            }
        }
    }
    
    @IBAction func btnEmailClick(_ sender: UIButton) {
        let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        let strEmail = dictionary.value(forKey: "email") as? String ?? ""
        
        if strEmail.isEmpty || strEmail == "" {
            Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoEmailAlert"))
            
            return
        }
        else {
            let mailComposeViewController = configuredMailComposeViewController(strRecipients: strEmail)
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
            else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        self.mapProfileView.isHidden = true
    }
    
    
    func btnCallPhoneClick(sender:UIButton) {
        
        let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        
        var strPhoneNo = dictionary.value(forKey: "phoneNumber") as? String ?? ""
        strPhoneNo = strPhoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        if strPhoneNo.isEmpty || strPhoneNo == "" {
            Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoMobileNoAlert"))
            return
        }
        
        if let phoneCallURL = URL(string: "tel://\(strPhoneNo)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: { (finish) in
                    })
                } else {
                    UIApplication.shared.openURL(phoneCallURL)
                }
            }
        }
    }
    
    func btnCelanderClick(sender:UIButton) {
        let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let pt_CreateAppointmentSlotObj = PT_CreateAppointmentSlotVC(nibName: "PT_CreateAppointmentSlotVC", bundle: nil)
            pt_CreateAppointmentSlotObj.strSelProviderId = dictionary.value(forKey: "id") as? String ?? ""
            pt_CreateAppointmentSlotObj.dictSelProviderData = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
            self.navigationController?.pushViewController(pt_CreateAppointmentSlotObj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    func btnReviewClick(sender:UIButton) {
        
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
            
            let pt_writeReviewStep1Obj = PT_WriteReviewStep1VC(nibName: "PT_WriteReviewStep1VC", bundle: nil)
            pt_writeReviewStep1Obj.strSelProviderId = dictionary.value(forKey: "id") as? String ?? ""
            pt_writeReviewStep1Obj.dictSelProviderData = dictionary
            self.navigationController?.pushViewController(pt_writeReviewStep1Obj, animated: true)
        }
        else {
            let loginObj = LoginVC(nibName: "LoginVC", bundle: nil)
            loginObj.boolFromProvider = true
            self.navigationController?.pushViewController(loginObj, animated: true)
        }
    }
    
    func btnMailClick(sender:UIButton) {
        
        let dictionary = arrResultObj.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        let strEmail = dictionary.value(forKey: "email") as? String ?? ""
        
        if strEmail.isEmpty || strEmail == "" {
            
            Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoEmailAlert"))
            return
        }
        else {
            let mailComposeViewController = configuredMailComposeViewController(strRecipients: strEmail)
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
            else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    func showSendMailErrorAlert() {
        Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyDeviceEmailNotSupportAlert"))
    }
    
    func btnLikeClick(sender:UIButton) {
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        footerViewLayout.constant = 0
        generalSearchView.isHidden = true
        generalSearchLable.backgroundColor = UIColor.clear
        generalSearchView.alpha = 1
        let providerFilterVCObj = ProviderFilterVC(nibName: "ProviderFilterVC", bundle: nil)
        if isMapOrList == true {
            providerFilterVCObj.isMapOrList = true
        } else  {
            providerFilterVCObj.isMapOrList = false
        }
        providerFilterVCObj.delegate = self
        //providerFilterVCObj.userMapObj = mapViewReference
        self.navigationController?.pushViewController(providerFilterVCObj, animated: true)
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.txtSearchFiled.text = ""
        Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
    }
    
    @IBAction func btnListClick(_ sender: UIButton) {
        intPageCount = 0
        footerViewLayout.constant = 0
        generalSearchView.alpha = 1
        generalSearchView.isHidden = true
        generalSearchLable.backgroundColor = UIColor.clear
        self.tblProviderList.reloadData()
        
        Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.Page)
        
        if isMapOrList == true {
            isBackgroundWSCall = true
            btnList.setTitle(Global().getLocalizeStr(key: "keyMapIcon"), for: .normal)
            Global.singleton.saveToUserDefaults(value:"0", forKey:Global.kSearchFilterParamKey.ResultType)
            viewMapProvider.isHidden = true
            viewListProvider.isHidden = false
            isMapOrList = false
            
            let strLat = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Lat)
            let strLong = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Long)
            
            Global.singleton.saveToUserDefaults(value: String(strLat!), forKey: Global.kSearchFilterParamKey.Lat)
            Global.singleton.saveToUserDefaults(value: String(strLong!), forKey: Global.kSearchFilterParamKey.Long)
            
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.MapCenterLong)
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.MapCenterLat)
            genericSearchApiCallForTableList_Method(intPage: 0)
        }
        else {
            isBackgroundWSCall = false
            isMapZoom = true
            Global.singleton.saveToUserDefaults(value:"1", forKey:Global.kSearchFilterParamKey.ResultType)
            
            btnList.setTitle(Global().getLocalizeStr(key: "keyListIcon"), for: .normal)
            viewMapProvider.isHidden = false
            viewListProvider.isHidden = true
            isMapOrList = true
            genericSearchApiCall_Method(intPage: 0, isLoader: true)
        }
    }
    
    @IBAction func btnUserDetailClick(_ sender: Any) {
        let diction = arrResultObj.object(at: intSelectPinTag) as? NSDictionary ?? NSDictionary()
        let searchProviderDetialVCObj = SearchProviderDetialVC(nibName: "SearchProviderDetialVC", bundle: nil)
        searchProviderDetialVCObj.strProviderId = String(diction.value(forKey: "id") as? String ?? "")
        searchProviderDetialVCObj.responseDict = diction

        if Global.appDelegate.isLocationOn == false {
            searchProviderDetialVCObj.distanceKM = ""
        } else {
            let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            let myLocation = CLLocation(latitude:Double(diction.value(forKey: "lat") as? String ?? "0")! , longitude: Double(diction.value(forKey: "lng") as? String ?? "0")!)
            let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
            searchProviderDetialVCObj.distanceKM = ("\(strDistance) km")
        }
        
        self.navigationController?.pushViewController(searchProviderDetialVCObj, animated: true)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        
        let strIsFavorit = Global.singleton.retriveFromUserDefaults(key:Global.kSearchFilterParamKey.isFromFavorite )
        if strIsFavorit == "1" {
            view.endEditing(true)
            mySlideViewObj?.menuBarButtonItemPressed(sender)
        } else  {
            view.endEditing(true)
            isBackgroundWSCall = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    // MARK: -  Put All Pin in Center Map Method
    func centerMapForAllPin() {
        var region: MKCoordinateRegion = MKCoordinateRegion()
        
        var maxLat: CLLocationDegrees = -90
        var maxLon: CLLocationDegrees = -180
        var minLat: CLLocationDegrees = 90
        var minLon: CLLocationDegrees = 180
        
        for i in 0 ..< arrResultObj.count {
            let dictPinData: NSDictionary = arrResultObj.object(at: i) as! NSDictionary
            
            let currentlocation:CLLocation = CLLocation(latitude: Double(dictPinData.object(forKey: "lat") as? String ?? "0")!, longitude: Double(dictPinData.object(forKey: "lng") as? String ?? "0")!)
            
            if (currentlocation.coordinate.latitude > maxLat) {
                maxLat = currentlocation.coordinate.latitude
            }
            if (currentlocation.coordinate.latitude < minLat) {
                minLat = currentlocation.coordinate.latitude
            }
            if (currentlocation.coordinate.longitude > maxLon) {
                maxLon = currentlocation.coordinate.longitude
            }
            if (currentlocation.coordinate.longitude < minLon) {
                minLon = currentlocation.coordinate.longitude
            }
        }
        region.center.latitude     = (maxLat + minLat) / 2
        region.center.longitude    = (maxLon + minLon) / 2
        region.span.latitudeDelta  = maxLat - minLat + 8
        region.span.longitudeDelta = maxLon - minLon + 8
        
        mapProviderObj.setRegion(region, animated: true)
    }
    
    func genericSearchApiCall_Method(intPage : Int, isLoader: Bool) {
        
        if Global.appDelegate.isLocationOn == false {
            self.clearAllDataLatitudeLongitute()
        }
        
        let dictParameter = searchFilterDataClass().getSearchFilterDictKeyAndValue()
        if isBackgroundWSCall == false {
            print(dictParameter)
            AFAPIMaster.sharedAPIMaster.postSearchProviderFilterDetialCall_Completion(params: dictParameter, showLoader: isLoader, enableInteraction: false, viewObj: self.mapProviderObj, onSuccess: { (returnData: Any) in
                let dictResponse: NSDictionary = returnData as! NSDictionary
                
                let allAnnotations = self.mapProviderObj.annotations
                self.mapProviderObj.removeOverlays(self.mapProviderObj.overlays)
                self.mapProviderObj.removeAnnotations(allAnnotations)
                
                
                for vc in (self.mapProviderObj?.subviews)! {
                    if (vc is MKAnnotation) {
                        vc.removeFromSuperview()
                    }
                    if vc is REVClusterAnnotationView {
                        vc.removeFromSuperview()
                    }
                }
                
                var pins = [Any]()
                for (index,element) in self.arrResultObj.enumerated() {
                    var diction = NSDictionary()
                    diction = element as! NSDictionary
                    
                    let lat:CLLocationDegrees = CLLocationDegrees(diction.object(forKey: "lat") as? String ?? "0")!
                    let long:CLLocationDegrees = CLLocationDegrees(diction.object(forKey: "lng") as? String ?? "0")!
                    let newCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long);
                    let pin = REVClusterPin()
                    pin.dictObj = diction as! [AnyHashable : Any]
                    pin.coordinate = newCoord
                    pin.title = ""
                    pin.intPinId = Int32(index)
                    pins.append(pin)
                }
                
                self.mapProviderObj.removeAnnotations(pins as! [MKAnnotation])
                
                self.arrResultObj.removeAllObjects()
                
                if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                    print(dictData)
                    let arrResult: NSArray = (dictData.object(forKey: "result") as? NSArray)!
                    if arrResult.count > 0 {
                        
                        let checkReset = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.ResetState)
                        if checkReset == "1" {
                            Global.singleton.saveToUserDefaults(value: "0", forKey:Global.kSearchFilterParamKey.ResetState)
                        }
                        
                        self.intPageCount = Int(dictData.object(forKey: "page") as? String ?? "")!
                        self.intTotalPage = Int(dictData.object(forKey: "maxPages") as? String ?? "")!
                        if  self.intPageCount == 0 {
                            if self.isMapOrList == true {
                                self.viewMapProvider.isHidden = false
                                self.viewListProvider.isHidden = true
                            }
                            else {
                                self.viewMapProvider.isHidden = true
                                self.viewListProvider.isHidden = false
                            }
                            let allAnnotations = self.mapProviderObj.annotations
                            self.mapProviderObj.removeAnnotations(allAnnotations)
                            self.arrResultObj.removeAllObjects()
                            
                            self.arrResultObj.addObjects(from: arrResult as! [Any])
                            self.setupRevClusterMethod()
                            self.centerMapForAllPin()
                        }
                    }
                    else {
                        let allAnnotations = self.mapProviderObj.annotations
                        self.mapProviderObj.removeAnnotations(allAnnotations)
                        self.arrResultObj.removeAllObjects()
                        
                        Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoRecord"))
                        
                    }
                } else {
                    // self.mapProviderObj.isUserInteractionEnabled = true
                }
            })
        }
    }
    
    
    func genericSearchApiCallForTableList_Method(intPage : Int) {
        self.clearAllDataLatitudeLongituteList()
        if Global.appDelegate.isLocationOn == false {
            let strFilterCountry = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CityAndCountry)
            if strFilterCountry == "" || (strFilterCountry?.isEmpty)! || strFilterCountry?.characters.count == 0 {
                Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Lat)
                Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.Long)
            } else  {
                
            }
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.MapCenterLat)
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.MapCenterLong)
            
        } else {
            
            let strLat = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Lat)
            let strLong = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Long)
            
            Global.singleton.saveToUserDefaults(value: String(strLat!), forKey: Global.kSearchFilterParamKey.Lat)
            Global.singleton.saveToUserDefaults(value: String(strLong!), forKey: Global.kSearchFilterParamKey.Long)
        }
        
        let dictParameter = searchFilterDataClass().getSearchFilterDictKeyAndValue()
        print(dictParameter)
        AFAPIMaster.sharedAPIMaster.postSearchProviderFilterDetialCall_Completion(params: dictParameter, showLoader: true, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                let arrResult: NSArray = (dictData.object(forKey: "result") as? NSArray)!
                self.intPageCount = Int(dictData.object(forKey: "page") as? String ?? "")!
                print(dictData)
                
                let checkReset = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.ResetState)
                if checkReset == "1" {
                    Global.singleton.saveToUserDefaults(value: "0", forKey:Global.kSearchFilterParamKey.ResetState)
                }
                
                if arrResult.count > 0 {
                    
                    self.intPageCount = Int(dictData.object(forKey: "page") as? String ?? "")!
                    self.intTotalPage = Int(dictData.object(forKey: "maxPages") as? String ?? "")!
                    if self.isMapOrList == true {
                        self.viewMapProvider.isHidden = false
                        self.viewListProvider.isHidden = true
                    }
                    else {
                        self.viewMapProvider.isHidden = true
                        self.viewListProvider.isHidden = false
                    }
                    if self.intPageCount == 0 {
                        self.arrResultObj.removeAllObjects()
                        self.arrResultObj.addObjects(from: arrResult as! [Any])
                        self.tblProviderList.reloadData()
                        self.tblProviderList.infiniteScrollingView.stopAnimating()
                        self.setupRevClusterMethod()
                        //set center map
                        if (self.isMapOrList == true) {
                            if let strIsVisibleArea: String = dictData.object(forKey: "isResultVisibleArea") as? String {
                                if (strIsVisibleArea == "1") {
                                    self.centerMapForAllPin()
                                }
                            }
                        }
                        self.intPageCount = self.intPageCount + 1
                        Global.singleton.saveToUserDefaults(value: String(self.intPageCount) , forKey: Global.kSearchFilterParamKey.Page)
                    }
                    else if self.intPageCount <= self.intTotalPage {
                        self.intPageCount = self.intPageCount + 1
                        Global.singleton.saveToUserDefaults(value: String(self.intPageCount) , forKey: Global.kSearchFilterParamKey.Page)
                        
                        self.arrResultObj.addObjects(from: arrResult as! [Any])
                        self.tblProviderList.reloadData()
                        self.tblProviderList.infiniteScrollingView.stopAnimating()
                    }
                    else {
                        self.tblProviderList.reloadData()
                        self.tblProviderList.infiniteScrollingView.stopAnimating()
                        let allAnnotations = self.mapProviderObj.annotations
                        self.mapProviderObj.removeAnnotations(allAnnotations)
                        self.setupRevClusterMethod()
                        if (self.isMapOrList == true) {
                            if let strIsVisibleArea: String = dictData.object(forKey: "isResultVisibleArea") as? String {
                                if (strIsVisibleArea == "1") {
                                    self.centerMapForAllPin()
                                }
                            }
                        }
                    }
                    
                } else  {
                    Global.singleton.showWarningAlert(withMsg:Global().getLocalizeStr(key: "keyNoRecord"))
                    
                    self.arrResultObj.removeAllObjects()
                    let allAnnotations = self.mapProviderObj.annotations
                    self.mapProviderObj.removeAnnotations(allAnnotations)
                    self.tblProviderList.reloadData()
                }
            }
        })
    }
}

// MARK: -
extension SearchListMapProviderVC : UITableViewDelegate {
    // MARK: -  UITableview  Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isBackgroundWSCall = true
        let dictionary = arrResultObj.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        
        let searchProviderDetialVCObj = SearchProviderDetialVC(nibName: "SearchProviderDetialVC", bundle: nil)
        searchProviderDetialVCObj.responseDict = dictionary
        searchProviderDetialVCObj.strProviderId = String(dictionary.value(forKey: "id") as? String ?? "")
        
        if Global.appDelegate.isLocationOn == false {
            searchProviderDetialVCObj.distanceKM = ""
        } else {
            let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
            let myLocation = CLLocation(latitude:Double(dictionary.value(forKey: "lat") as? String ?? "0")! , longitude: Double(dictionary.value(forKey: "lng") as? String ?? "0")!)
            let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
            searchProviderDetialVCObj.distanceKM = ("\(strDistance) km")
        }
        self.navigationController?.pushViewController(searchProviderDetialVCObj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        // return ((Global.screenWidth) * 150) / 320
    }
}

// MARK: -
extension SearchListMapProviderVC : UITableViewDataSource {
    // MARK: -  UITableview  Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResultObj.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SearchProviderTableCell = tableView.dequeueReusableCell(withIdentifier: tblCellidentifier , for: indexPath) as! SearchProviderTableCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if arrResultObj.count > 0 {
            let dictionary = arrResultObj.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            let arrSpeciality = dictionary.value(forKey: "specialty") as? NSArray ?? NSArray()
            let strSpeciality = arrSpeciality .componentsJoined(by: "|")
            cell.lblAddress.text = dictionary.value(forKey: "address") as? String ?? ""
            cell.lblSpecialits.text = strSpeciality
            cell.lblRatingCount.text = dictionary.value(forKey: "hospitalRating") as? String ?? "0.0"
        
            var strFullName = String()
            
            let categoryName = dictionary.object(forKey: "category") as? String ?? ""
            if categoryName == "Hospital" {
                let strHospitalName = dictionary.value(forKey: "hospitalName") as? String ?? ""
                cell.lblProviderName.text = strHospitalName
            } else {
                let strSalutation = dictionary.value(forKey: "salutation") as? String ?? ""
                if (strSalutation.characters.count > 0) {
                    strFullName = "\(strSalutation) "
                }
                
                let strFirstname = dictionary.value(forKey: "firstName") as? String ?? ""
                if (strFirstname.characters.count > 0) {
                    strFullName = "\(strFullName)\(strFirstname) "
                }
                let strLastname = dictionary.value(forKey: "lastName") as? String ?? ""
                if (strLastname.characters.count > 0) {
                    strFullName = "\(strFullName)\(strLastname)"
                }
                cell.lblProviderName.text = strFullName
            }

            if let strProfilePic =  dictionary.object(forKey: "profilePictureUrl") as? String {
                if (strProfilePic.isEmpty || strProfilePic == "") {
                    cell.imgUserProfile.sd_setImage(with: URL.init(string: dictionary.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                }
                else {
                    cell.imgUserProfile.sd_setImage(with: URL.init(string: strProfilePic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                }
            }
            else {
                cell.imgUserProfile.sd_setImage(with: URL.init(string: dictionary.object(forKey: "hospitalImg") as? String ?? ""), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            }
        
            cell.btnCalender.tag = indexPath.row
            cell.btnCall.tag     = indexPath.row
            cell.btnMessage.tag  = indexPath.row
            cell.btnEmail.tag    = indexPath.row
            
            cell.btnCall.addTarget(self, action: #selector(btnCallPhoneClick(sender:)), for: .touchUpInside)
            cell.btnCalender.addTarget(self, action: #selector(btnCelanderClick(sender:)), for: .touchUpInside)
            cell.btnEmail.addTarget(self, action: #selector(btnMailClick(sender:)), for: .touchUpInside)
            cell.btnMessage.addTarget(self, action: #selector(btnReviewClick(sender:)), for: .touchUpInside)
            cell.lblRecomondation.text = dictionary.value(forKey: "recommendationCount") as? String ?? "0"
            
            if Global.appDelegate.isLocationOn == false {
                cell.lblDistance.text = ""
            } else {
                let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
                let myLocation = CLLocation(latitude:Double(dictionary.value(forKey: "lat") as? String ?? "0")! , longitude: Double(dictionary.value(forKey: "lng") as? String ?? "0")!)
                let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                cell.lblDistance.text = ("\(strDistance) km")
            }
            
        }
        return cell
    }
    
    func distanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> String {
        let  distanceInMeters = source.distance(from: destination)
        let distanceInMiles = distanceInMeters/1000
        return String(format:"%.2f",distanceInMiles)
    }
}

// MARK: -
extension SearchListMapProviderVC: MKMapViewDelegate {
    // MARK: -  MKMapViewDelegate Delegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation .isMember(of: MKUserLocation.self) {
            let userLocationView = mapView .view(for: annotation)
            userLocationView?.canShowCallout = false
            userLocationView?.isEnabled = false
            print("Current Location Click")
            return nil
        }
        
        let annotation = annotation
        var index = 0
        var is_Useranno = false
        for anno in self.mapProviderObj.annotations {
            if anno is MKUserLocation {
                is_Useranno = true
                break
            }
        }
        index = (self.mapProviderObj.annotations as NSArray).index(of: annotation)
        if is_Useranno {
            index = index - 1
        }
        
        let pin = annotation as? REVClusterPin
        var annView: MKAnnotationView?
        annView?.image = nil
        
        if (pin?.nodeCount())! > 0 {
            annView = (mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? REVClusterAnnotationView)
            if annView == nil {
                annView = (REVClusterAnnotationView(annotation: annotation, reuseIdentifier: "cluster"))
            }
            annView?.canShowCallout = false
            if arrResultObj.count > index {
                pin?.title = ""
                
                (annView as? REVClusterAnnotationView)?.setClusterText("")
                annView?.tag = index
                annView?.canShowCallout = false
                
                annView?.image = UIImage(named: "mapPin")
                
                
                let pinNodeCount = UILabel(frame: CGRect(x:(annView?.frame.width)! / 2 - 13 , y: (annView?.frame.height)! / 2 - 12, width: 28, height: (annView?.frame.height)! / 2 - 5))
                pinNodeCount.textColor = Global.kAppColor.BlueDark
                pinNodeCount.font = UIFont(name: Global.kFont.SourceSemiBold, size: 12)
                pinNodeCount.textAlignment = .center
                pinNodeCount.backgroundColor = UIColor.white
                let strPinCount = Int32((pin?.nodeCount())!)
                pinNodeCount.text = String(strPinCount)
                annView?.addSubview(pinNodeCount)
            } else  {
                annView?.image = UIImage(named: "")
                for vc in (annView?.subviews)! {
                    if vc is UILabel {
                        vc.removeFromSuperview()
                    }
                }
            }
        }
        else {
            annView = (mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? REVClusterAnnotationView)
            if !(annView != nil) {
                annView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            }
            var customUserProfileView :MapCustomProfile?
            annView?.canShowCallout = true
            if arrResultObj.count > index && arrResultObj.count > 0 {
                if index < 0 {
                    index = 0
                }
                
                let diction = arrResultObj.object(at: index ) as? NSDictionary ?? NSDictionary()
                annView?.image = UIImage(named: "mapPin")
                annView?.canShowCallout = false
                annView?.calloutOffset = CGPoint(x: -6.0, y: 0.0)
                annView?.tag = index
                customUserProfileView = Bundle.main.loadNibNamed("MapCustomProfile", owner: self, options: nil)?[0] as? MapCustomProfile
                var strImageProfileCheck: String = String()
                let strImageProfile = diction.value(forKey: "profilePictureUrl") as? String ?? ""
                
                if !strImageProfile.isEmpty || strImageProfile != ""  {
                    strImageProfileCheck = strImageProfile
                } else  {
                    strImageProfileCheck = diction.value(forKey: "icon") as? String ?? ""
                }
                customUserProfileView?.cornerReduce()
                customUserProfileView?.profileImage.sd_setImage(with: URL(string: strImageProfileCheck), completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                    if (image != nil) {                        DispatchQueue.main.async {
                            SDWebImageManager.shared().cachedImageExists(for: URL(string: strImageProfileCheck), completion: { (finished) in
                                if finished {
                                    customUserProfileView?.profileImage.image = image!
                                }
                            })
                        }
                    }
                    else  {
                        customUserProfileView?.profileImage.image = UIImage(named: "ProfileView")
                    }
                })
                annView?.addSubview(customUserProfileView!)
            }
        }
        return annView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            if (view.annotation?.isKind(of: MKUserLocation.self))! {
                view.canShowCallout = false
                view.isEnabled = false
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation {
            return
        }
        if !(view is REVClusterAnnotationView) {
            if let pin = view.annotation as? REVClusterPin {
                intSelectPinTag = Int(pin.intPinId)
                btnCalenderProvider.tag = intSelectPinTag
                btnCallProvider.tag = intSelectPinTag
                btnLikeProvider.tag = intSelectPinTag
                btnMessageProvider.tag = intSelectPinTag
                self.mapProfileView.isHidden = false
                let diction = arrResultObj.object(at: Int(pin.intPinId)) as? NSDictionary ?? NSDictionary()
                self.mapProfileView.isHidden = false
            
                if let strUrl = URL(string:diction.value(forKey: "profilePictureUrl") as? String ?? ""){
                    self.imgProfile.sd_setImage(with: strUrl, completed: { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                        if (image != nil) {
                            self.imgProfile.image = image!
                        }
                        else  {
                            self.imgProfile.image = UIImage(named: "ProfileView")
                        }
                    })
                }else{
                    self.imgProfile.image = UIImage(named: "ProfileView")
                }
                
                
                var strFullName = String()
                let categoryName = diction.object(forKey: "category") as? String ?? ""
                if categoryName == "Hospital" {
                    let strHospitalName = diction.value(forKey: "hospitalName") as? String ?? ""
                    self.lblDocHospitalName.text = strHospitalName
                } else {
                    let strSalutation = diction.value(forKey: "salutation") as? String ?? ""
                    if (strSalutation.characters.count > 0) {
                        strFullName = "\(strSalutation) "
                    }
                    
                    let strFirstname = diction.value(forKey: "firstName") as? String ?? ""
                    if (strFirstname.characters.count > 0) {
                        strFullName = "\(strFullName)\(strFirstname) "
                    }
                    let strLastname = diction.value(forKey: "lastName") as? String ?? ""
                    if (strLastname.characters.count > 0) {
                        strFullName = "\(strFullName)\(strLastname)"
                    }
                    self.lblDocHospitalName.text = strFullName
                }
            
                
                let arrSpeciality = diction.value(forKey: "specialty") as? NSArray ?? NSArray()
                let strSpeciality = arrSpeciality .componentsJoined(by: "|")
                lblAddress.text = diction.value(forKey: "address") as? String ?? ""
                lblSpecialist.text = strSpeciality
                lblRecomondedCount.text = diction.value(forKey: "recommendationCount") as? String ?? "0"
                lblRating.text = diction.value(forKey: "hospitalRating") as? String ?? "0.0"
                if Global.appDelegate.isLocationOn == false {
                    lblDistance.text = ("")
                }
                else {
                    let sourceLocaiton = CLLocation(latitude: CLLocationDegrees(Global.appDelegate.floatCurrentLat), longitude: CLLocationDegrees(Global.appDelegate.floatCurrentLong))
                    let myLocation = CLLocation(latitude:Double(diction.value(forKey: "lat") as? String ?? "0")! , longitude: Double(diction.value(forKey: "lng") as? String ?? "0")!)
                    let strDistance = self.distanceBetweenTwoLocations(source: sourceLocaiton, destination: myLocation)
                    lblDistance.text = ("\(strDistance) km")
                }
            }
        }
        else {
            let centerCoordinate: CLLocationCoordinate2D? = (view.annotation as? REVClusterPin)?.coordinate
            let newSpan: MKCoordinateSpan = MKCoordinateSpanMake(mapView.region.span.latitudeDelta / 8.0, mapView.region.span.longitudeDelta / 8.0)
            mapView.setRegion(MKCoordinateRegionMake(centerCoordinate!, newSpan), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if arrResultObj.count == 0 {
            var pins = [Any]()
            for  i in 0..<mapProviderObj.annotations.count {
                print(i)
                let pin = REVClusterPin()
                pins.append(pin)
            }
            self.mapProviderObj.removeAnnotations(pins as! [REVClusterPin])
            mapView.removeAnnotations(pins as! [REVClusterPin])
            print("PinCount: == \(mapProviderObj.annotations.count)")
        }
        let strIsFirstTime = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.IsFirstTimeLogIn)
        
        if strIsFirstTime == "" {
            if Global.appDelegate.isLocationOn == true {
            } else {
                self.clearAllDataLatitudeLongitute()
            }
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kLoggedInUserKey.IsFirstTimeLogIn)
        } else  {
            if isMapOrList == true {
                getMapCenterLatLong = mapView.centerCoordinate
                // mapViewReference = mapView
                let getSouthEdgePoint = mapProviderObj.southEdgePoints()
                let getNorthEdgePoint = mapProviderObj.northEdgePoints()
                
                Global.singleton.saveToUserDefaults(value:String(mapProviderObj.centerCoordinate.latitude), forKey:Global.kSearchFilterParamKey.Lat)
                Global.singleton.saveToUserDefaults(value:String(mapProviderObj.centerCoordinate.longitude), forKey:Global.kSearchFilterParamKey.Long)
                
                Global.singleton.saveToUserDefaults(value:String(mapProviderObj.centerCoordinate.latitude), forKey:Global.kSearchFilterParamKey.MapCenterLat)
                Global.singleton.saveToUserDefaults(value:String(mapProviderObj.centerCoordinate.longitude), forKey:Global.kSearchFilterParamKey.MapCenterLong)
                
                let location1 = CLLocation(latitude: floatCenterLat, longitude: floatCenterLong)
                let location2 = CLLocation(latitude: mapProviderObj.centerCoordinate.latitude, longitude: mapProviderObj.centerCoordinate.longitude)
                let distanceInMeters = location1.distance(from: location2)
                let distanceInMiles = distanceInMeters / 1000
                
                if distanceInMiles > 1 {
                    Global.singleton.saveToUserDefaults(value:String(getNorthEdgePoint.northWest.latitude), forKey:Global.kSearchFilterParamKey.CurrLat1)
                    Global.singleton.saveToUserDefaults(value:String(getNorthEdgePoint.northWest.longitude), forKey:Global.kSearchFilterParamKey.CurrLong1)
                    Global.singleton.saveToUserDefaults(value:String(getNorthEdgePoint.northEast.latitude), forKey:Global.kSearchFilterParamKey.CurrLat2)
                    Global.singleton.saveToUserDefaults(value:String(getNorthEdgePoint.northEast.longitude), forKey:Global.kSearchFilterParamKey.CurrLong2)
                    Global.singleton.saveToUserDefaults(value:String(getSouthEdgePoint.southWest.latitude), forKey:Global.kSearchFilterParamKey.CurrLat3)
                    Global.singleton.saveToUserDefaults(value:String(getSouthEdgePoint.southWest.longitude), forKey:Global.kSearchFilterParamKey.CurrLong3)
                    Global.singleton.saveToUserDefaults(value:String(getSouthEdgePoint.southEast.latitude), forKey:Global.kSearchFilterParamKey.CurrLat4)
                    Global.singleton.saveToUserDefaults(value:String(getSouthEdgePoint.southEast.longitude), forKey:Global.kSearchFilterParamKey.CurrLong4)
                    self.btnResetMap.isHidden = false
                    //  self.btnResetMap.addTarget(self, action: #selector(btnSearchResultClick), for: .touchUpInside)
                    
                }
            }
        }
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        self.btnResetMap.isHidden = true
    }
    func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapProviderObj.subviews[0]
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
}

// MARK: -
extension SearchListMapProviderVC : MFMailComposeViewControllerDelegate {
    // MARK: -  MFMailComposeViewControllerDelegate Delegate Methods
    func configuredMailComposeViewController(strRecipients:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([strRecipients])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: -
extension SearchListMapProviderVC : UITextFieldDelegate {
    // MARK: -  UITextfield Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
            btnClose.isHidden = true
        } else {
            btnClose.isHidden = false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isViewDismiss = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.intPageCount = 0
        Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.Page)
        let strTrim = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (strTrim?.characters.count)! > 0 {
            Global.singleton.saveToUserDefaults(value: strTrim!, forKey: Global.kSearchFilterParamKey.Keyword)
            if isViewDismiss == false {
                if self.isMapOrList == true {
                    self.genericSearchApiCall_Method(intPage: 0, isLoader: true)
                }else  {
                    self.genericSearchApiCallForTableList_Method(intPage: 0)
                }
            }
            
        } else {
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.Keyword)
            if isViewDismiss == false {
                if self.isMapOrList == true {
                    self.genericSearchApiCall_Method(intPage: 0, isLoader: true)
                }else  {
                    self.genericSearchApiCallForTableList_Method(intPage: 0)
                }
            }
        }
        if isViewDismiss == true {
            isViewDismiss = false
        }
    }
    
    
}

// MARK: -
extension SearchListMapProviderVC: providerFilterDelegate {
    // MARK: -  Provider Filter Delegate Methods
    func filterApplyDelegateMethod() {
        self.intPageCount = 0
        Global.singleton.saveToUserDefaults(value: "0" , forKey: Global.kSearchFilterParamKey.Page)
        if self.isMapOrList == true {
            self.genericSearchApiCall_Method(intPage: 0, isLoader: true)
        } else  {
            self.genericSearchApiCallForTableList_Method(intPage: 0)
        }
    }
}

typealias NorthEdges = (northEast: CLLocationCoordinate2D, northWest: CLLocationCoordinate2D)
typealias SouthEdges = (southEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D)

extension MKMapView {
    func northEdgePoints() -> NorthEdges {
        let northEastePoint = CGPoint(x: self.bounds.maxX, y: self.bounds.origin.y)
        let northWestPoint = CGPoint(x: self.bounds.minX, y: self.bounds.origin.y)
        let northEastCoord = self.convert(northEastePoint, toCoordinateFrom: self)
        let northWestCoord = self.convert(northWestPoint, toCoordinateFrom: self)
        return (northEast: northEastCoord, northWest: northWestCoord)
    }
    
    func southEdgePoints() -> SouthEdges {
        let southWestPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        let southEastPoint = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
        let southWestCoord = self.convert(southWestPoint, toCoordinateFrom: self)
        let southEastCoord = self.convert(southEastPoint, toCoordinateFrom: self)
        return (southEast: southEastCoord, southWest: southWestCoord)
    }
}


