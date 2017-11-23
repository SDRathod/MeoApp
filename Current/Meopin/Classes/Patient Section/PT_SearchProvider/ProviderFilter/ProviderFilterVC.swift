//
//  ProviderSearchVC.swift
//  Meopin
//
//  Created by Tops on 9/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import GooglePlaces

protocol providerFilterDelegate {
    func filterApplyDelegateMethod()
}
class ProviderFilterVC: UIViewController {
    
    // MARK: -  IBOutlet Declarations
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnApplySearch: UIButton!

    @IBOutlet weak var tblProviderSearchFilter: UITableView!
    
    // MARK: -  Local Variable Declarations
    let param = NSMutableDictionary()
    var delegate: providerFilterDelegate?
    
    var arrPlaces = NSMutableArray ()
    weak var viewdate: ViewDurationPicker!
    var dateviewframe:CGRect!
    var isTimePicker: Bool = false
    var isReset : Bool = false
    var  strSelectedTime = String()
    var  strSelectedDate = String()
    var isMapOrList = Bool()
    
    var arrAppoimentList: NSArray = NSArray()
    var arrCollectionList : NSArray = NSArray()
    let categoryId = NSMutableArray()
    let specialityID = NSMutableArray()
    var countryCity = String()
    var rating = String()
    var gender = String()
    var hasProfilePicture = String()
    var resultType = String()
    var lat = String()
    var lng = String()
    var page = String()
    var sliderRedius = String()
    var strOnlineAppointment = String()
    var userMapObj = MKMapView()
    var txtCountry = String()
    
    
    let sectionArray:[[String]] = [[Global().getLocalizeStr(key: "KeyFilterLookingFor"), Global().getLocalizeStr(key: "KeyFilterSpeciality"), Global().getLocalizeStr(key: "KeyFilterCountryCity")], [Global().getLocalizeStr(key: "KeyFilterAppmtDate"), Global().getLocalizeStr(key: "KeyFilterOnlineAppmt")],[Global().getLocalizeStr(key: "KeyFilterLocationDist")] ,[Global().getLocalizeStr(key: "KeyFilterSpokenLan")], [Global().getLocalizeStr(key: "KeyFilterGlobleRating")] , [Global().getLocalizeStr(key: "KeyFilterGender"),Global().getLocalizeStr(key: "KeyFilterProfilePics")], [""]]

     let sectionPlaceHolder : [[String]] = [[Global().getLocalizeStr(key: "KeyFilterSelect"),Global().getLocalizeStr(key: "KeyFilterSelect"),Global().getLocalizeStr(key: "KeyFilterSelect")],[Global().getLocalizeStr(key: "KeyFilterNone"),Global().getLocalizeStr(key: "KeyFilterNo")],[""],[""],[""],[Global().getLocalizeStr(key: "KeyFilterBoth"),Global().getLocalizeStr(key: "KeyFilterNone")],[""]]
    
    // MARK: -  Collection & Table Identifier
    let tblCellidentifier = "ProviderFilterCell"
    let tblRatingCellIdentifier = "ProviderFilterRatingCell"
    let tblSliderCellIdentifier = "ProviderFilterSliderCell"
    let tblSpokenLangCellIdentifier = "ProviderSpokenLangCell"
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDatePicker()
        Global.appDelegate.navObj?.view.addSubview(viewdate)
        tblProviderSearchFilter.estimatedRowHeight = 70
        tblProviderSearchFilter.rowHeight = UITableViewAutomaticDimension
        tblProviderSearchFilter.register(UINib(nibName: "ProviderFilterCell", bundle: nil), forCellReuseIdentifier: tblCellidentifier)
        tblProviderSearchFilter.register(UINib(nibName: "ProviderFilterRatingCell", bundle: nil), forCellReuseIdentifier: tblRatingCellIdentifier)
        tblProviderSearchFilter.register(UINib(nibName: "ProviderFilterSliderCell", bundle: nil), forCellReuseIdentifier: tblSliderCellIdentifier)
        tblProviderSearchFilter.register(UINib(nibName: "ProviderSpokenLangCell", bundle: nil), forCellReuseIdentifier: tblSpokenLangCellIdentifier)
        
        tblProviderSearchFilter.rowHeight = UITableViewAutomaticDimension
        tblProviderSearchFilter.backgroundColor = UIColor.lightText
        self.deviceSpecificConstrain()
        self.setLanguageTitles()
    
        Global.singleton.saveToUserDefaults(value:"", forKey:Global.kSearchFilterParamKey.PatientID)

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        dateviewframe.size.width = UIScreen.main.bounds.size.width
        viewdate.frame = dateviewframe
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexpath: IndexPath = IndexPath(row: 0, section: 0)
        let frame = tblProviderSearchFilter.rectForRow(at: indexpath)
        Global.categortySingleton.delegate  = self
        Global.categortySingleton.addCategoryDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame.origin.y, width: Global.screenWidth - 20, height: frame.size.height - 10))
        
        
        let indexpath1: IndexPath = IndexPath(row: 1, section: 0)
        Global.spectialitySingleton.delegate  = self
        let frame1 = tblProviderSearchFilter.rectForRow(at: indexpath1)
        Global.spectialitySingleton.addSpecialityDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame1.origin.y, width: Global.screenWidth - 20, height: frame.size.height - 10))
        
        let indexpath2: IndexPath = IndexPath(row: 1, section: 1)
        Global.appointmentSingleton.delegate  = self
        let frame2 = tblProviderSearchFilter.rectForRow(at: indexpath2)
        Global.appointmentSingleton.addAppointmentDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame2.origin.y, width: Global.screenWidth - 20, height:  frame.size.height - 10))
        
        let indexpath3: IndexPath = IndexPath(row: 0, section: 5)
        Global.genderSingleton.delegate  = self
        let frame3 = tblProviderSearchFilter.rectForRow(at: indexpath3)

        let indexpath4: IndexPath = IndexPath(row: 1, section: 5)
        Global.profilSingleton.delegate  = self
        let frame4 = tblProviderSearchFilter.rectForRow(at: indexpath4)

        
        if (Global.is_iPhone._4) {
        } else if (Global.is_iPhone._4) {
            Global.genderSingleton.addGenderDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame3.origin.y , width: Global.screenWidth - 10, height: frame.size.height ))
            Global.profilSingleton.addProfileDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame4.origin.y, width: Global.screenWidth - 10, height:  frame.size.height))

        } else if (Global.is_iPhone._5) {
            Global.genderSingleton.addGenderDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame3.origin.y , width: Global.screenWidth - 10, height: frame.size.height ))
            Global.profilSingleton.addProfileDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame4.origin.y , width: Global.screenWidth - 10, height:  frame.size.height))

        } else if (Global.is_iPhone._6) {
            Global.genderSingleton.addGenderDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame3.origin.y + 20 , width: Global.screenWidth - 10, height: frame.size.height ))
            Global.profilSingleton.addProfileDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame4.origin.y + 20, width: Global.screenWidth - 10, height:  frame.size.height))
        } else if (Global.is_iPhone._6p) {
            Global.genderSingleton.addGenderDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame3.origin.y + 20 , width: Global.screenWidth - 10, height: frame.size.height ))
            Global.profilSingleton.addProfileDropDownList(inView: tblProviderSearchFilter, with: CGRect(x: 10, y: frame4.origin.y + 20, width: Global.screenWidth - 10, height:  frame.size.height))
        }
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: -  set LanguageTitle & setFont & Constrain Height As per deviceMethod
    func setLanguageTitles() {
        btnReset.setTitle(Global().getLocalizeStr(key: "keyPSReset"), for: .normal)
        btnReset.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))

        btnApplySearch.setTitle(Global().getLocalizeStr(key: "keyPSApply&Search"), for: .normal)
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
    }
    
    func setupDatePicker() {
        // DATE PICKER
        let arrNib = Bundle.main.loadNibNamed("ViewDurationPicker", owner: self, options: nil)
        viewdate = arrNib![0] as? ViewDurationPicker
        dateviewframe = viewdate.frame //UIScreen.mainScreen().bounds.size.height + 10
        dateviewframe.origin.y = UIScreen.main.bounds.size.height + 10
        viewdate.datePicker.datePickerMode = UIDatePickerMode.date
        viewdate.frame = dateviewframe
        viewdate.datePicker.minimumDate = Date()
        viewdate.datePicker.isHidden = false
        viewdate.btnDurationCancel.addTarget(self, action:#selector(btnDateCancelClick(sender:)), for: .touchUpInside)
        viewdate.btnDurationDone.addTarget(self, action:#selector(btnDateDoneClick(sender:)), for: .touchUpInside)
    }
    
    func deviceSpecificConstrain() {
        
        if (Global.is_iPhone._4) {
        } else if (Global.is_iPhone._4) {
        } else if (Global.is_iPhone._5) {
        } else if (Global.is_iPhone._6) {
        } else if (Global.is_iPhone._6p) {
        }
    }
    
    //MARK: DATE PICKER BUTTON METHODS
    @IBAction func btnDateCancelClick(sender:AnyObject) {
        HidePicker()
        if isTimePicker == true {
            Global.singleton.saveToUserDefaults(value: "False", forKey: Global.kSearchFilterParamKey.isCancelTime)
        }
        else {
            Global.singleton.saveToUserDefaults(value: "True", forKey: Global.kSearchFilterParamKey.isCancelTime)
            Global.singleton.saveToUserDefaults(value: "", forKey: Global.kSearchFilterParamKey.AppointmentTime)

        }
        self.isTimePicker = false
    }
    
    
    @IBAction func btnDateDoneClick(sender:AnyObject){
        HidePicker()
        let indexpath: IndexPath = IndexPath(row: 0, section: 1)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        
        if isTimePicker {
            strSelectedDate = Global().dateFormatterMMDDYYY().string(from: viewdate.datePicker.date)
            let strSelectedDatae =  Global().dateFormatterForCall().string(from: viewdate.datePicker.date)
            Global.singleton.saveToUserDefaults(value: strSelectedDatae, forKey: Global.kSearchFilterParamKey.AppointmentDate)
            
            
            cell.lblProviderType.text = strSelectedDate
            Global().delay(delay: 0.5, closure: {
                self.viewdate.datePicker.datePickerMode = UIDatePickerMode.time
                self.viewdate.ShowTitle(isShow: false, text:Global().getLocalizeStr(key: "KeySelectDate"))
                self.ShowPicker()
                self.isTimePicker = false
            })
        }
        else {
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            print(formatter.string(from: viewdate.datePicker.date))
            var strSelectedTime =  Global().TimeFormatter_24_H().string(from: viewdate.datePicker.date)
            Global.singleton.saveToUserDefaults(value: strSelectedTime, forKey: Global.kSearchFilterParamKey.AppointmentTime)
            strSelectedTime =  Global().TimeFormatter_12H().string(from: viewdate.datePicker.date)
            cell.lblProviderType.text = ("\(strSelectedDate) \(strSelectedTime)")
        }
    }
    
    //MARK: PICKER VIEW HIDE METHODS
    func HidePicker() -> Void {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.dateviewframe.origin.y = UIScreen.main.bounds.size.height + 10
            self.viewdate.frame = self.dateviewframe
        }, completion: { finished in
            
        })
    }
    
    func ShowPicker() -> Void {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.dateviewframe.origin.y = UIScreen.main.bounds.size.height - 200
            self.viewdate.frame = self.dateviewframe
        }, completion: { finished in
            
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        HidePicker()
    }
    
    func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        print(formatter.string(from: sender.date))
    }
}

extension ProviderFilterVC {
    // MARK: -  ALL Extention Method Start
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnResetClick(_ sender: UIButton) {
        
        let strCountryCity = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CityAndCountry)

        if strCountryCity == "" || (strCountryCity?.isEmpty)! || strCountryCity == Global().getLocalizeStr(key: "KeyFilterSelect") {
            Global.singleton.saveToUserDefaults(value: "", forKey:Global.kSearchFilterParamKey.ResetState)
        } else  {
            Global.singleton.saveToUserDefaults(value: "1", forKey:Global.kSearchFilterParamKey.ResetState)
        }
        if isMapOrList == true {
            searchFilterDataClass().saveDefaultValueforSearchFilterForMap()
        } else {
            searchFilterDataClass().saveDefaultValueforSearchFilter()
        }
        self.tblProviderSearchFilter.reloadData()
    }
    
    @IBAction func btnFilterAplyClick(_ sender: UIButton) {
        var isVCFound = false
        
        let strIsFavorit = Global.singleton.retriveFromUserDefaults(key:Global.kSearchFilterParamKey.isFromFavorite )
        if strIsFavorit == "1" {
            Global.appDelegate.mySlideViewObj?.setGoToSearchMapViewControllerController()

        } else {
            for viewcontrol in (self.navigationController?.viewControllers)! {
                if viewcontrol is SearchListMapProviderVC {
                    isVCFound = true
                    self.delegate?.filterApplyDelegateMethod()
                    self.navigationController?.popToViewController(viewcontrol, animated: true)
                }
            }
            
            if isVCFound == false {
                self.delegate?.filterApplyDelegateMethod()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: -  ALL Extention Method Start
extension ProviderFilterVC : UITableViewDelegate {
    // MARK: -  ALL UITableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                let autoCompleteController = GMSAutocompleteViewController()
                autoCompleteController.delegate = self
                autoCompleteController.autocompleteFilter?.country
                self.present(autoCompleteController, animated: true, completion: nil)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                viewdate.ShowTitle(isShow: false, text:Global().getLocalizeStr(key: "KeySelectDate"))
                viewdate.datePicker.datePickerMode = UIDatePickerMode.date
                ShowPicker()
                isTimePicker = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView ()
        headerView.backgroundColor = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 0.5)
        return headerView
    }
}

extension ProviderFilterVC : UITableViewDataSource {
    // MARK: -  ALL UITableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 6 {
            return ((Global.screenWidth) * 105) / 320
        }
        else if indexPath.section == 3 || indexPath.section == 2 {
            return ((Global.screenWidth) * 60) / 320
        }
        else if indexPath.section == 4 {
            return ((Global.screenWidth) * 70) / 320
        } else {
            return ((Global.screenWidth) * 40) / 320
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = sectionArray[indexPath.section]
        let strQuest = arr[indexPath.row]
        print(strQuest)
        
        let arrType = sectionPlaceHolder[indexPath.section]
        let strType = arrType[indexPath.row]
        print(strType)
        
        if indexPath.section == 2 {
            let cell:ProviderFilterSliderCell = tableView.dequeueReusableCell(withIdentifier: tblSliderCellIdentifier, for: indexPath) as! ProviderFilterSliderCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let strVlaueSlider = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Radius)
            cell.distanceSlider.value = (strVlaueSlider! as NSString).floatValue
            cell.lbldistanceVal.text = ("\(strVlaueSlider!) Km")
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 3 {
            let cell:ProviderSpokenLangCell = tableView.dequeueReusableCell(withIdentifier: tblSpokenLangCellIdentifier, for: indexPath) as! ProviderSpokenLangCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lblSpokenLang.text = strQuest
            cell.txtSpokenLang.text = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.SpokenLanguages)
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 4 {
            let cell:ProviderFilterRatingCell = tableView.dequeueReusableCell(withIdentifier: tblRatingCellIdentifier, for: indexPath) as! ProviderFilterRatingCell
            let RatingCount = Global.singleton.retriveFromUserDefaults(key:Global.kSearchFilterParamKey.Rating)
            if RatingCount == "" {
                cell.ratingView.rating = 0
            } else  {
                if let value = Float(RatingCount!) {
                    cell.ratingView.rating = Double(value)
                }else{
                    cell.ratingView.rating = 0
                }
            }
            if let value = Int(RatingCount!){
                cell.lblRatCoubt.text = ("\(value)/5")
            }else{
                cell.lblRatCoubt.text = ""
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.delegate = self
            return cell
            
        } else if indexPath.section == 6 {
            let cell:ProviderFilterCell = tableView.dequeueReusableCell(withIdentifier: tblCellidentifier, for: indexPath) as! ProviderFilterCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lblProviderQuest.isHidden = true
            cell.lblProviderType.isHidden = true
            cell.lblArrow.isHidden = true
            return cell
        }
        else {
            let cell:ProviderFilterCell = tableView.dequeueReusableCell(withIdentifier: tblCellidentifier, for: indexPath) as! ProviderFilterCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.delegate = self
            cell.lblProviderQuest.isHidden = false
            cell.lblProviderType.isHidden = false
            cell.lblProviderType.text = strType
            
            if indexPath.section  == 0 {
                if indexPath.row == 0 {
                    
                    let arrOfSelection = UserDefaults.standard.array(forKey: "MPCategory")
                    if (arrOfSelection?.count)! > 0 {
                        let categoryList = NSMutableArray()
                        for (index,element) in (arrOfSelection?.enumerated())! {
                            print("\(index) \(element)")
                            var getElementId = Int()
                            getElementId = element as? Int ?? 0
                            let strCategory = Global.appDelegate.arrCategory[getElementId]
                            categoryList.add(strCategory)
                        }
                        
                        let strCategoryList = categoryList.componentsJoined(by: ",")
                        cell.lblProviderType.text = strCategoryList
                    } else {
                        cell.lblProviderType.text = strType
                    }
                }
                if indexPath.row == 1 {
                    let arrOfSelection = UserDefaults.standard.array(forKey: "MPSpecialty")
                    if (arrOfSelection?.count)! > 0 {
                        let specialityList = NSMutableArray()
                        for (index,element) in (arrOfSelection?.enumerated())! {
                            print("\(index) \(element)")
                            var getElementId = Int()
                            getElementId = element as? Int ?? 0
                            let strCategory = Global.appDelegate.arrSpeciality[getElementId]
                            specialityList.add(strCategory)
                        }
                        
                        let strSpecialityLis = specialityList.componentsJoined(by: ",")
                        cell.lblProviderType.text = strSpecialityLis
                    } else {
                        cell.lblProviderType.text = strType
                    }
                }
                if indexPath.row == 2 {
                    let strCountryCity = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.CityAndCountry)
                    if strCountryCity == "" {
                        cell.lblProviderType.text = strType
                    } else {
                        cell.lblProviderType.text = strCountryCity
                    }
                }
            }
            
            if indexPath.section  == 1  {
                if indexPath.row == 0 {
                    let strAppointnentDate = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.AppointmentDate)
                    if strAppointnentDate == "" || (strAppointnentDate?.isEmpty)!{
                        cell.lblProviderType.text = strType
                    } else  {
                        var dateFormatter: DateFormatter
                        dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let selectedDate = dateFormatter.date(from: strAppointnentDate!)
                        let strSelectedDate =  Global().dateFormatterMMDDYYY().string(from: selectedDate!)
                        
                        var strSelectedTime = String()
                        let strAppointnentTime = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.AppointmentTime)
                        if strAppointnentTime == "" || (strAppointnentTime?.isEmpty)! {
                            strSelectedTime = ""
                        } else {
                            var dateFormatter: DateFormatter
                            dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            let selectedTime = dateFormatter.date(from: strAppointnentTime!)
                            strSelectedTime =  Global().TimeFormatter_12H().string(from: selectedTime!)
                        }
                        
                        cell.lblProviderType.text = ("\(strSelectedDate) \(strSelectedTime)")
                    }
                }
                if indexPath.row == 1 {
                    let strOnlineAppointment = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.OnlineAppointment)
                    if strOnlineAppointment == "0" {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "keyNo")
                    } else if strOnlineAppointment == "1" {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "keyYes")
                    } else  {
                        cell.lblProviderType.text = strType
                    }
                }
            }
            
            if indexPath.section  == 5 {
                if indexPath.row == 0 {
                    let strGenderType = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Gender)
                    if strGenderType == "b" || strGenderType == "" {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyTextBoth")
                    } else  if strGenderType == "m" {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyTextMale")
                    } else  {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyTextFemale")
                    }
                }
                else {
                    let strIsProfileSelect = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.IsProfilePicture)
                    
                    if strIsProfileSelect == "0" {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyFilterNone")
                    } else if strIsProfileSelect == "1" {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "keyNo")
                    } else if strIsProfileSelect == "2" {
                        cell.lblProviderType.text = Global().getLocalizeStr(key: "keyYes")
                    } else  {
                        cell.lblProviderType.text = strType
                    }
                }
            }
            cell.lblArrow.isHidden = false
            cell.lblProviderQuest.text = strQuest
            return cell
        }
    }
}

extension ProviderFilterVC : categoryDropMenuDelegate {
    func didSelectCategory(selectedCategory: NSMutableArray) {
        var arrListCategory : [String] = []
        categoryId.removeAllObjects()
        for (index,element) in selectedCategory.enumerated() {
            print("\(index) \(element)")
            print(Global.appDelegate.arrCategory[index])
            var getElementId = Int()
            getElementId = element as! Int
            let strCategory = Global.appDelegate.arrCategory[getElementId]
            let strCatId = Global.appDelegate.arrCategoryId[getElementId]
            arrListCategory.append(strCategory)
            categoryId.add(strCatId)
        }
        
        UserDefaults.standard.set(categoryId, forKey: "MPCategoryID")
        UserDefaults.standard.synchronize()
        let indexpath: IndexPath = IndexPath(row: 0, section: 0)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        let strCategoryList = arrListCategory.joined(separator: ",")
        
        if selectedCategory.count > 0 {
            cell.lblProviderType.text = strCategoryList
        }
        else {
            cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyFilterSelect")
        }
    }
    
    func didCancelCategory() {
        let indexpath: IndexPath = IndexPath(row: 0, section: 0)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        
        let arrOfSelection = UserDefaults.standard.array(forKey: "MPCategory")
        if (arrOfSelection?.count)! > 0 {
            let categoryList = NSMutableArray()
            for (index,element) in (arrOfSelection?.enumerated())! {
                print("\(index) \(element)")
                var getElementId = Int()
                getElementId = element as? Int ?? 0
                let strCategory = Global.appDelegate.arrCategory[getElementId]
                categoryList.add(strCategory)
            }
            
            let strCategoryList = categoryList.componentsJoined(by: ",")
            cell.lblProviderType.text = strCategoryList
        } else {
            cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyFilterSelect")
        }
    }
}

extension ProviderFilterVC: SpecialityDropMenuDelegate {
    func didSelectSpeciality(selectedSpeciality: NSMutableArray) {
        var arrListSpeciality : [String] = []
        specialityID.removeAllObjects()
        
        for (index,element) in selectedSpeciality.enumerated() {
            print("\(index) \(element)")
            var getElementId = Int()
            getElementId = element as! Int
            let strSpeciality = Global.appDelegate.arrSpeciality[getElementId]
            let strSpecialityID = Global.appDelegate.arrSpecialityId[getElementId]
            arrListSpeciality.append(strSpeciality)
            specialityID.add(strSpecialityID)
        }
        
        UserDefaults.standard.set(specialityID, forKey: "MPSpecialtyID")
        UserDefaults.standard.synchronize()
        
        let indexpath: IndexPath = IndexPath(row: 1, section: 0)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        let strSpecialityList = arrListSpeciality.joined(separator: ",")
        if selectedSpeciality.count > 0 {
            cell.lblProviderType.text = strSpecialityList
        } else {
            cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyFilterSelect")
        }
    }
    
    func didCancelSpeciality() {
        let indexpath: IndexPath = IndexPath(row: 1, section: 0)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        
        let arrOfSelection = UserDefaults.standard.array(forKey: "MPSpecialty")
        //let arrOfSelection = UserDefaults.standard.array(forKey: "MPTempSpecialtyID")

        if (arrOfSelection?.count)! > 0 {
            let specialityList = NSMutableArray()
            for (index,element) in (arrOfSelection?.enumerated())! {
                print("\(index) \(element)")
                var getElementId = Int()
                getElementId = element as? Int ?? 0
                let strCategory = Global.appDelegate.arrSpeciality[getElementId]
                specialityList.add(strCategory)
            }
            
            let strSpecialityLis = specialityList.componentsJoined(by: ",")
            cell.lblProviderType.text = strSpecialityLis
        } else {
            cell.lblProviderType.text = Global().getLocalizeStr(key: "KeyFilterSelect")
        }
    }
}

extension ProviderFilterVC : AppointmentDropMenuDelegate {
    func didSelectAppointment(strAppointmentName: String) {
        let indexpath: IndexPath = IndexPath(row: 1, section: 1)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        
        if strAppointmentName == Global().getLocalizeStr(key: "keyYes") {
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kSearchFilterParamKey.OnlineAppointment)
        } else  {
            Global.singleton.saveToUserDefaults(value: "0", forKey: Global.kSearchFilterParamKey.OnlineAppointment)
        }
        cell.lblProviderType.text = strAppointmentName
    }
}

extension ProviderFilterVC : GenderDropMenuDelegate {
    func didSelectGender(strGenderName: String) {
        let indexpath: IndexPath = IndexPath(row: 0, section: 5)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        if strGenderName == Global().getLocalizeStr(key: "KeyTextMale") {
            gender = "m"
        } else if strGenderName == Global().getLocalizeStr(key: "KeyTextFemale") {
            gender = "f"
        } else {
            gender = ""
        }
        Global.singleton.saveToUserDefaults(value: gender, forKey: Global.kSearchFilterParamKey.Gender)
        cell.lblProviderType.text = strGenderName
    }
}

extension ProviderFilterVC : ProfileDropMenuDelegate {
    func didSelectProfile(strProfileName: String) {
        let indexpath: IndexPath = IndexPath(row: 1, section: 5)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        if strProfileName == Global().getLocalizeStr(key: "keyYes") {
            Global.singleton.saveToUserDefaults(value: "2", forKey: Global.kSearchFilterParamKey.IsProfilePicture)
        } else if strProfileName == Global().getLocalizeStr(key: "keyNo")  {
            Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kSearchFilterParamKey.IsProfilePicture)
        } else  {
            Global.singleton.saveToUserDefaults(value: "0", forKey: Global.kSearchFilterParamKey.IsProfilePicture)
        }
        cell.lblProviderType.text = strProfileName
    }
}

// MARK: -  ALL Provider Filter Delegate Method
extension ProviderFilterVC : FilterCellDelegate {
    func fiilterDropDownClickDelegate(cell: ProviderFilterCell) {
    }
}

extension ProviderFilterVC : ProviderSpokenLangDelegate {
    func providerSpokenLanguageDropDownClickDelegate(strText: String, cell: ProviderSpokenLangCell) {
        Global.singleton.saveToUserDefaults(value: strText, forKey: Global.kSearchFilterParamKey.SpokenLanguages)
        cell.txtSpokenLang.text = strText
    }
}

// MARK: -  ALL Provider Rating Delegate Method
extension ProviderFilterVC : ProviderFilterRatingCellDelegate {
    func didEndTouchingRatingCallMethod(strRatings: String, cell: ProviderFilterRatingCell) {
    }
    
    func didEndTouchingRatingCallMethod(strRatings: String) {
    }
}

// MARK: -  ALL Provider Slider Delegate Method
extension ProviderFilterVC : ProviderSliderDelegate {
    func locationSliderValueSelection(strDistance: String) {
        sliderRedius = strDistance
        Global.singleton.saveToUserDefaults(value: strDistance, forKey: Global.kSearchFilterParamKey.Radius)
    }
}

extension ProviderFilterVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        print("Place name: \(place.name)")
        print("Place Latitute: \(place.coordinate.latitude)")
        print("Place Longitute: \(place.coordinate.longitude)")
        print("Place address: \(place.formattedAddress!)")
        
        Global.singleton.saveToUserDefaults(value: String(place.coordinate.latitude), forKey: Global.kSearchFilterParamKey.Lat)
        Global.singleton.saveToUserDefaults(value: String(place.coordinate.longitude), forKey: Global.kSearchFilterParamKey.Long)
        Global.singleton.saveToUserDefaults(value: String(place.coordinate.latitude), forKey: Global.kSearchFilterParamKey.MapCenterLat)

        Global.singleton.saveToUserDefaults(value: String(place.coordinate.longitude), forKey: Global.kSearchFilterParamKey.MapCenterLong)
        Global.singleton.saveToUserDefaults(value: place.formattedAddress!, forKey: Global.kSearchFilterParamKey.CityAndCountry)
        
        countryCity = place.formattedAddress!
        let indexpath: IndexPath = IndexPath(row: 2, section: 0)
        let cell = tblProviderSearchFilter.cellForRow(at: indexpath) as! ProviderFilterCell
        cell.lblProviderType.text = place.formattedAddress!
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


