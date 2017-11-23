//
//  CountryDropDown.swift
//  Meopin
//
//  Created by Tops on 9/14/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit



class MultiDropDownClass: NSObject {
}

//=======================================================================================

@objc protocol CountryDropDowbDelegate {
    @objc optional func stopLoaderWithCityData()
    @objc optional func startLoaderUntilDataFromCountry(strCountryName:String)
}

class CountryDropDown: NSObject {
    static let sharedCountryDropDown = CountryDropDown()
    var delegate: CountryDropDowbDelegate?
    var dropMenuCountry: KPDropMenu = KPDropMenu()
    
    // MARK: -  Open Country Selection View
    func allocCountryListSelectView()  {
        dropMenuCountry.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuCountry = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:dropMenuCountry)
        dropMenuCountry.delegate = self
        dropMenuCountry.items = Global.appDelegate.arrCountryName
    }
    
    func addCountryDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuCountry.frame = frame
        inView.addSubview(dropMenuCountry)
    }
    func removeCountryDropMenu() {
        dropMenuCountry.removeFromSuperview()
    }
}

extension CountryDropDown: KPDropMenuDelegate {
    func didShow(_ dropMenu: KPDropMenu!) {
        dropDownCountryShow()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenu!, at atIndex: Int32) {
        selectCountryLanguGateMethodCall(dropMenuObj: dropMenu, selectedIndex: Int(atIndex))
    }
    
    // MARK: -  Dropdown Country Show & SelectedLanguage Methods
    func dropDownCountryShow() {
        dropMenuCountry.items = Global.appDelegate.arrCountryName
        dropMenuCountry.tblView.reloadData()
    }
    func selectCountryLanguGateMethodCall(dropMenuObj:KPDropMenu,selectedIndex:Int) {
        self.delegate?.startLoaderUntilDataFromCountry!(strCountryName: (dropMenuObj.items[Int(selectedIndex)] as? String ?? ""))
        DispatchQueue.global(qos: .background).async {
            Global.appDelegate.parseCountryToStateToCityList(getCountryId: selectedIndex)
            DispatchQueue.main.async {
                self.delegate?.stopLoaderWithCityData!()
            }
        }
    }
}

//=======================================================================================


@objc protocol CityDropDownDelegate {
    @objc optional func didSelectCity(strCityName:String)
}

class CityDropDown: NSObject {
    static let sharedCityDropDown = CityDropDown()
    var delegate: CityDropDownDelegate?
    var dropMenuCity: KPDropMenu = KPDropMenu()

    // MARK: -  Open Country Selection View
    func allocCityListSelectView()  {
        dropMenuCity.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuCity = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:dropMenuCity)
        dropMenuCity.delegate = self
        dropMenuCity.items = Global.appDelegate.arrCountryName
    }
    
    func addCityDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuCity.frame = frame
        inView.addSubview(dropMenuCity)
    }
    
    func removeCityDropMenu() {
        dropMenuCity.removeFromSuperview()
    }
}

extension CityDropDown: KPDropMenuDelegate {
    func didShow(_ dropMenu: KPDropMenu!) {
        dropDownCityShow()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenu!, at atIndex: Int32) {
        self.delegate?.didSelectCity!(strCityName: (dropMenu.items[Int(atIndex)] as? String ?? ""))
    }
    
    // MARK: -  Dropdown Country Show & SelectedLanguage Methods
    func dropDownCityShow() {
        dropMenuCity.items = Global.appDelegate.arrCityFromCountry
        dropMenuCity.tblView.reloadData()
    }
}

//=======================================================================================


// MARK: -  Dropdown Category's Methods
@objc protocol categoryDropMenuDelegate {
    @objc optional func didSelectCategory(selectedCategory: NSMutableArray)
    @objc optional func didCancelCategory()
}

class CategoryDropDown: NSObject {
    static let sharedCategoryDropDown = CategoryDropDown()
    var delegate: categoryDropMenuDelegate?
    var dropMenuCategory: KPDropMenuMulti = KPDropMenuMulti()
    
    // MARK: -  Open Category Selection View
    func allocCategoryListSelectView()  {
        dropMenuCategory.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuCategory = Global.appDelegate.GenericDropDownMenuMultiAllocation(genericDropDown: dropMenuCategory)
        dropMenuCategory.delegate = self
        dropMenuCategory.setupCategoriRecords()
        dropMenuCategory.items = Global.appDelegate.arrCategory
        
    }
    
    func addCategoryDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuCategory.frame = frame
        inView.addSubview(dropMenuCategory)
    }
    
    func removeCategoryDropMenu() {
        dropMenuCategory.removeFromSuperview()
    }
}
// MARK: -  Dropdown Category Delegate MEthod
extension CategoryDropDown: KPDropMenuMultiDelegate {
    func didShow(_ dropMenu: KPDropMenuMulti!) {
            dropMenu.setupCategoriRecords()
            dropDownCategoryShow()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenuMulti!, arrSelectedIndex selectedIndex: NSMutableArray!) {
        self.delegate?.didSelectCategory!(selectedCategory: selectedIndex)
    }
    
    // MARK: -  Dropdown Category Show & SelectedLanguage Methods
    func dropDownCategoryShow() {
        dropMenuCategory.setupCategoriRecords()
        dropMenuCategory.items = Global.appDelegate.arrCategory
        
        dropMenuCategory.strSelectionType = "Category"
        dropMenuCategory.tblView.reloadData()
    }
    
    func didCancelTapMethod() {
        self.delegate?.didCancelCategory!()

    }
}

//=======================================================================================


// MARK: -  Dropdown Category's Methods
@objc protocol SpecialityDropMenuDelegate {
    @objc optional func didSelectSpeciality(selectedSpeciality: NSMutableArray)
    @objc optional func didCancelSpeciality()

}

class SpecialityDropDown: NSObject {
    static let sharedSpecialityhDropDown = SpecialityDropDown()
    var delegate: SpecialityDropMenuDelegate?
    var dropMenuSpeciality: KPDropMenuMulti = KPDropMenuMulti()
    
    // MARK: -  Open Category Selection View
    func allocSpecialityListSelectView()  {
        dropMenuSpeciality.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuSpeciality = Global.appDelegate.GenericDropDownMenuMultiAllocation(genericDropDown:dropMenuSpeciality)
        dropMenuSpeciality.delegate = self
        dropMenuSpeciality.setupCategoriRecords()
        dropMenuSpeciality.items = Global.appDelegate.arrSpeciality

    }
    
    func addSpecialityDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuSpeciality.frame = frame
        inView.addSubview(dropMenuSpeciality)
    }
    
    func removeSpecialityDropMenu() {
        dropMenuSpeciality.removeFromSuperview()
    }
    func didCancelTapMethod() {
        self.delegate?.didCancelSpeciality!()
    }
}
// MARK: -  Dropdown Category Delegate MEthod
extension SpecialityDropDown: KPDropMenuMultiDelegate {
    func didShow(_ dropMenu: KPDropMenuMulti!) {
        dropDownSpecialityShow()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenuMulti!, arrSelectedIndex selectedIndex: NSMutableArray!) {
        self.delegate?.didSelectSpeciality!(selectedSpeciality: selectedIndex)
    }
    
    // MARK: -  Dropdown Category Show & SelectedLanguage Methods
    func dropDownSpecialityShow() {
        dropMenuSpeciality.items = Global.appDelegate.arrSpeciality
        
        dropMenuSpeciality.strSelectionType = "Speciality"
        dropMenuSpeciality.setupCategoriRecords()
        dropMenuSpeciality.tblView.reloadData()
    }
}

//=======================================================================================


// MARK: -  Dropdown Category's Methods
@objc protocol AppointmentDropMenuDelegate {
    @objc optional func didSelectAppointment(strAppointmentName:String)
}

class AppointmentDropDown: NSObject {
    static let sharedAppoinmentDropDown = AppointmentDropDown()
    var delegate: AppointmentDropMenuDelegate?
    var dropMenuAppointment: KPDropMenu = KPDropMenu()
    
    // MARK: -  Open Category Selection View
    func allocAppointmentListSelectView()  {
        dropMenuAppointment.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuAppointment = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:dropMenuAppointment)
        dropMenuAppointment.delegate = self
        let strIsAppointment = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.OnlineAppointment)

        if strIsAppointment == Global().getLocalizeStr(key: "keyYes") {
            dropMenuAppointment.intSelectedItems = 1
        } else  if strIsAppointment == Global().getLocalizeStr(key: "keyNo") {
            dropMenuAppointment.intSelectedItems = 0
        }
        
        dropMenuAppointment.items = [Global().getLocalizeStr(key: "keyNo"),Global().getLocalizeStr(key: "keyYes")]
    }
    
    func addAppointmentDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuAppointment.frame = frame
        inView.addSubview(dropMenuAppointment)
    }
    
    func removeAppointmentDropMenu() {
        dropMenuAppointment.removeFromSuperview()

    }
}


// MARK: -  Dropdown Category Delegate MEthod
extension AppointmentDropDown: KPDropMenuDelegate {
    func didShow(_ dropMenu: KPDropMenu!) {
            dropDownAppointmentShow()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenu!, at atIndex: Int32) {
        self.delegate?.didSelectAppointment!(strAppointmentName: (dropMenu.items[Int(atIndex)] as? String ?? ""))
    }
    
    // MARK: -  Dropdown Category Show & SelectedLanguage Methods
    func dropDownAppointmentShow() {
        let strIsAppointment = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.OnlineAppointment)

        if strIsAppointment == Global().getLocalizeStr(key: "keyYes") {
            dropMenuAppointment.intSelectedItems = 1
        } else  if strIsAppointment == Global().getLocalizeStr(key: "keyNo") {
            dropMenuAppointment.intSelectedItems = 0
        }
        dropMenuAppointment.items = [Global().getLocalizeStr(key: "keyNo"),Global().getLocalizeStr(key: "keyYes")]

       // dropMenuAppointment.items = ["No","Yes"]
        dropMenuAppointment.tblView.reloadData()
    }
}

//=======================================================================================


// MARK: -  Dropdown Category's Methods
@objc protocol GenderDropMenuDelegate {
    @objc optional func didSelectGender(strGenderName:String)
}

class GenderDropDown: NSObject {
    static let sharedGenderDropDown = GenderDropDown()
    var delegate: GenderDropMenuDelegate?
    var dropMenuGender: KPDropMenu = KPDropMenu()
    
    // MARK: -  Open Category Selection View
    func allocGenderListSelectView()  {
        dropMenuGender.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuGender = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:dropMenuGender)
        dropMenuGender.delegate = self
        let strGenderType = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Gender)
        if strGenderType == "b" || strGenderType == "" {
            dropMenuGender.intSelectedItems = 0
        } else  if strGenderType == "m" {
            dropMenuGender.intSelectedItems = 1
        } else  {
            dropMenuGender.intSelectedItems = 2
        }
        dropMenuGender.items = [Global().getLocalizeStr(key: "KeyTextBoth"), Global().getLocalizeStr(key: "KeyTextMale"),Global().getLocalizeStr(key: "KeyTextFemale")]
        
        //dropMenuGender.items = ["Both","Male","Female"]
        
    }
    
    func addGenderDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuGender.frame = frame
        inView.addSubview(dropMenuGender)
    }
    
    func removeGenderDropMenu() {
        dropMenuGender.removeFromSuperview()
    }
}
// MARK: -  Dropdown Category Delegate MEthod
extension GenderDropDown: KPDropMenuDelegate {
    func didShow(_ dropMenu: KPDropMenu!) {
          dropDownGenderShow()
           
    }
    
    func didSelectItem(_ dropMenu: KPDropMenu!, at atIndex: Int32) {
        self.delegate?.didSelectGender!(strGenderName: (dropMenu.items[Int(atIndex)] as? String ?? ""))
    }
    
    // MARK: -  Dropdown Category Show & SelectedLanguage Methods
    func dropDownGenderShow() {
        let strGenderType = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Gender)
        if strGenderType == "b" || strGenderType == "" {
            dropMenuGender.intSelectedItems = 0
        } else  if strGenderType == "m" {
            dropMenuGender.intSelectedItems = 1
        } else  {
            dropMenuGender.intSelectedItems = 2
        }
        dropMenuGender.items = [Global().getLocalizeStr(key: "KeyTextBoth"), Global().getLocalizeStr(key: "KeyTextMale"),Global().getLocalizeStr(key: "KeyTextFemale")]

       // dropMenuGender.items = ["Both","Male","Female"]
        dropMenuGender.tblView.reloadData()
    }
}

//=======================================================================================

// MARK: -  Dropdown Profile Methods
@objc protocol ProfileDropMenuDelegate {
    @objc optional func didSelectProfile(strProfileName:String)
}

class ProfileDropDown: NSObject {
    static let sharedProfileDropDown = ProfileDropDown()
    var delegate: ProfileDropMenuDelegate?
    var dropMenuProfile: KPDropMenu = KPDropMenu()
    
    // MARK: -  Open Category Selection View
    func allocProfileListSelectView()  {
        dropMenuProfile.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuProfile = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:dropMenuProfile)
        dropMenuProfile.delegate = self

        let strIsProfileSelect = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.IsProfilePicture)
        
        if strIsProfileSelect == Global().getLocalizeStr(key: "keyYes") {
            dropMenuProfile.intSelectedItems = 2
        } else  if strIsProfileSelect == Global().getLocalizeStr(key: "keyNo") {
            dropMenuProfile.intSelectedItems = 1
        } else {
            dropMenuProfile.intSelectedItems = 0
        }
        
        dropMenuProfile.items = [Global().getLocalizeStr(key: "KeyFilterNone"),Global().getLocalizeStr(key: "keyNo"),Global().getLocalizeStr(key: "keyYes")]
        
    //    dropMenuProfile.items = ["None","No","Yes"]

    }
    
    func addProfileDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuProfile.frame = frame
        inView.addSubview(dropMenuProfile)
    }
    
    func removeProfileDropMenu() {
        dropMenuProfile.removeFromSuperview()

    }
}

// MARK: -  Dropdown Category Delegate MEthod
extension ProfileDropDown: KPDropMenuDelegate {
    
    func didShow(_ dropMenu: KPDropMenu!) {
        dropDownProfileShow()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenu!, at atIndex: Int32) {
        self.delegate?.didSelectProfile!(strProfileName: (dropMenu.items[Int(atIndex)] as? String ?? ""))
    }
    
    // MARK: -  Dropdown Category Show & SelectedLanguage Methods
    func dropDownProfileShow() {
        let strIsProfileSelect = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.IsProfilePicture)
        
        if strIsProfileSelect == "2" {
            dropMenuProfile.intSelectedItems = 2
        } else  if strIsProfileSelect == "1" {
            dropMenuProfile.intSelectedItems = 1
        } else {
            dropMenuProfile.intSelectedItems = 0
        }
        dropMenuProfile.items = [Global().getLocalizeStr(key: "KeyFilterNone"),Global().getLocalizeStr(key: "keyNo"),Global().getLocalizeStr(key: "keyYes")]
       // dropMenuProfile.items = ["None","No","Yes"]
        dropMenuProfile.tblView.reloadData()
    }
}

//=======================================================================================


// MARK: -  Dropdown Category's Methods
@objc protocol ReasonListDropMenuDelegate {
    @objc optional func didSelectReasonList(strAppointmentName:String,intIndexPath:Int32)
}

class ReasonListDropDown: NSObject {
    static let sharedReasonListDropDown = ReasonListDropDown()
    var delegate: ReasonListDropMenuDelegate?
    var dropMenuReasonList: KPDropMenu = KPDropMenu()
    
    // MARK: -  Open Category Selection View
    func allocReasonListSelectView()  {
        dropMenuReasonList.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        dropMenuReasonList = Global.appDelegate.GenericDropDownMenuAllocation(genericDropDown:dropMenuReasonList)
        dropMenuReasonList.delegate = self
        dropMenuReasonList.items = Global.appDelegate.arrReasonName
    }
    
    func addReasonListDropDownList(inView: UIView, with frame: CGRect) {
        dropMenuReasonList.frame = frame
        inView.addSubview(dropMenuReasonList)
    }
    
    func removeAppointmentDropMenu() {
        dropMenuReasonList.removeFromSuperview()
    }
}


// MARK: -  Dropdown Category Delegate MEthod
extension ReasonListDropDown: KPDropMenuDelegate {
    func didShow(_ dropMenu: KPDropMenu!) {
        dropDownReasonListShow()
    }
    
    func didSelectItem(_ dropMenu: KPDropMenu!, at atIndex: Int32) {
        self.delegate?.didSelectReasonList!(strAppointmentName: (dropMenu.items[Int(atIndex)] as? String ?? ""), intIndexPath: atIndex)
    }
    
    // MARK: -  Dropdown Category Show & SelectedLanguage Methods
    func dropDownReasonListShow() {
        dropMenuReasonList.items = Global.appDelegate.arrReasonName
        dropMenuReasonList.tblView.reloadData()
    }
}
