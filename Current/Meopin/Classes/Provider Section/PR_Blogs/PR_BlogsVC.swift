//
//  PR_BlogsVC.swift
//  Meopin
//
//  Created by Tops on 10/6/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import SVPullToRefresh
import Foundation
import IQKeyboardManagerSwift


class PR_BlogsVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var tblCategory: UITableView!
    @IBOutlet weak var searchPost: UIView!
    
    @IBOutlet weak var bottomSearchLayout: NSLayoutConstraint!
    @IBOutlet weak var actionSearchPopUp: UIView!
    @IBOutlet weak var footerVIew: UIView!
    
    @IBOutlet weak var LatestPostListView: UIView!
    @IBOutlet weak var viewLatestPost: UIView!
    @IBOutlet weak var btnLatestPost: UIButton!
    @IBOutlet weak var lblLatestPostIcon: UILabel!
    @IBOutlet weak var lblLatestPost: UILabel!
    
    @IBOutlet weak var categoryListView: UIView!
    @IBOutlet weak var viewCategories: UIView!
    @IBOutlet weak var btnCategories: UIButton!
    @IBOutlet weak var lblCategoriesTitle: UILabel!
    @IBOutlet weak var lblCategoriesIcon: UILabel!
    
    @IBOutlet weak var MostViewedListView: UIView!
    @IBOutlet weak var viewMostViewed: UIView!
    @IBOutlet weak var btnMostViewed: UIButton!
    @IBOutlet weak var lblMostViewedTitle: UILabel!
    @IBOutlet weak var lblMostViewedIcon: UILabel!
    
    @IBOutlet weak var searchPostListView: UIView!
    @IBOutlet weak var viewSearchPost: UIView!
    @IBOutlet weak var lblSearchPostTitle: UILabel!
    @IBOutlet weak var lblSearchPostIcon: UILabel!
    @IBOutlet weak var btnSearchPost: UIButton!
    @IBOutlet weak var searchBarLatestPost: UISearchBar!
    
    @IBOutlet weak var tblLatestPost: UITableView!
    @IBOutlet weak var tblMostViewed: UITableView!
    @IBOutlet weak var tblSearchPost: UITableView!
    @IBOutlet weak var latestPostView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    var isNavFromCategory: Bool = false
    var isNavFromSlideMenu: Bool = true

    
    var mySlideViewObj: MySlideViewController?
    var intPostPage : Int = 0
    
    var arrCategoryList : NSMutableArray = NSMutableArray()
    var arrLatestPostList : NSMutableArray = NSMutableArray()
    var arrMostViewedBlogList : NSMutableArray = NSMutableArray()
    
    var viewSpinner: UIView = UIView()
    var strSelectedCategoryId: String = ""
    var strSelectedCategoryName: String = ""
    var strMaxPageCount: Int = 0
    var strPageCount: Int = 1
    
    @IBOutlet weak var footerLayoutHeight: NSLayoutConstraint!
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().enable = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.hideKeyboardWhenTappedAround()

        tblCategory.estimatedRowHeight = 110.0
        tblCategory.rowHeight = UITableViewAutomaticDimension
        
        tblMostViewed.estimatedRowHeight = 125.0
        tblMostViewed.rowHeight = UITableViewAutomaticDimension
        
        tblLatestPost.estimatedRowHeight = 110.0
        tblLatestPost.rowHeight = UITableViewAutomaticDimension
        
        tblCategory.estimatedRowHeight = 110.0
        tblCategory.rowHeight = UITableViewAutomaticDimension
        
        tblCategory.register(UINib(nibName: "PR_CategoryList", bundle: nil), forCellReuseIdentifier: "PR_CategoryList")
        
        tblLatestPost.register(UINib(nibName: "PR_BlogMostViewedCell", bundle: nil), forCellReuseIdentifier: "PR_BlogMostViewedCell")
        tblLatestPost.register(UINib(nibName: "PR_BlogPostHeaderCell", bundle: nil), forCellReuseIdentifier: "PR_BlogPostHeaderCell")
        
        tblMostViewed.register(UINib(nibName: "PR_BlogMostViewedCell", bundle: nil), forCellReuseIdentifier: "PR_BlogMostViewedCell")
        tblMostViewed.register(UINib(nibName: "PR_BlogPostHeaderCell", bundle: nil), forCellReuseIdentifier: "PR_BlogPostHeaderCell")
        
        tblSearchPost.estimatedRowHeight = 110.0
        tblSearchPost.rowHeight = UITableViewAutomaticDimension
        
        tblSearchPost.register(UINib(nibName: "PR_BlogMostViewedCell", bundle: nil), forCellReuseIdentifier: "PR_BlogMostViewedCell")
        tblSearchPost.register(UINib(nibName: "PR_BlogPostHeaderCell", bundle: nil), forCellReuseIdentifier: "PR_BlogPostHeaderCell")
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        lblTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleHeader")
        self.addInfiniteScrollingLatestPost()

        // Logic for category selection button navigation
        if isNavFromCategory == true {
            self.HideAllViews()
            lblTitle.text = strSelectedCategoryName
            self.LatestPostListView.isHidden = false
            footerLayoutHeight.constant = 0
            btnCategories.isSelected = true
            viewCategories.backgroundColor = UIColor.white
            lblCategoriesIcon.textColor = Global.kAppColor.BlueDark
            lblCategoriesTitle.textColor = Global.kAppColor.BlueDark
            self.getLatestPostListWithCategorySelectionMethod(strCategoryId: self.strSelectedCategoryId, strPage: self.strPageCount)

        } else  {
            self.HideAllViews()
            self.LatestPostListView.isHidden = false
            footerLayoutHeight.constant = Global.singleton.getDeviceSpecificFontSize(50)
            btnLatestPost.isSelected = true
            viewLatestPost.backgroundColor = UIColor.white
            lblLatestPostIcon.textColor = Global.kAppColor.BlueDark
            lblLatestPost.textColor = Global.kAppColor.BlueDark
            self.getLatestPostListMethod(strCategoryId: "", strPage: 1)
        }
        
    }
    
      func addInfiniteScrollingLatestPost(){
        self.tblLatestPost.addInfiniteScrolling {
            self.tblLatestPost.reloadData()
            if self.arrLatestPostList.count == 1 {
                self.tblLatestPost.infiniteScrollingView.stopAnimating()
            }
            
            if self.arrLatestPostList.count > 1 {
                if self.strPageCount == self.strMaxPageCount {
                    self.tblLatestPost.infiniteScrollingView.stopAnimating()
                } else {
                    self.getLatestPostListMethod(strCategoryId: self.strSelectedCategoryId, strPage: self.strPageCount)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNavFromSlideMenu == true {
            self.btnSlideMenu.isHidden = false
            self.btnBack.isHidden = true
        } else {
            self.btnSlideMenu.isHidden = true
            self.btnBack.isHidden = false
        }
        self.setLanguageTitles()
        IQKeyboardManager.sharedManager().enable = false
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        IQKeyboardManager.sharedManager().enable = true
        super.viewWillDisappear(animated)
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        lblLatestPost.text = Global().getLocalizeStr(key: "KeyBlogTitleLatestPost")
        lblCategoriesTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleCategories")
        lblMostViewedTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleMostViewed")
        lblSearchPostTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleSearchPost")
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(16))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblLatestPost.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblCategoriesTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblMostViewedTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblSearchPostTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(8))
        
        lblCategoriesIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(16))
        lblLatestPostIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(16))
        lblMostViewedIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(16))
        lblSearchPostIcon.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(16))
    }
}


//MARK: -
extension PR_BlogsVC {
    
    // MARK: -  Button Click Methods
    @IBAction func btnSlideMenuClick(_ sender: Any) {
        self.view.endEditing(true)
        mySlideViewObj?.menuBarButtonItemPressed(sender)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLatestPostClick(_ sender: UIButton) {
        // New Key For Blog Titile
        self.lblTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleHeader")
        self.ClearAllSelectedFooterButton()
        self.HideAllViews()
        LatestPostListView.isHidden = false
        if btnLatestPost.isSelected == true {
        } else {
            btnLatestPost.isSelected = true
            self.getLatestPostListMethod(strCategoryId: "", strPage: 1)
        }
        viewLatestPost.backgroundColor = UIColor.white
        lblLatestPostIcon.textColor = Global.kAppColor.BlueDark
        lblLatestPost.textColor = Global.kAppColor.BlueDark
    }
    
    @IBAction func btnCategoryClick(_ sender: UIButton) {

        self.lblTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleCategoriesTitle")
        self.ClearAllSelectedFooterButton()
        self.HideAllViews()
        categoryListView.isHidden = false
        if btnCategories.isSelected == true {
        } else {
            self.getCategoryListMethod()
        }
        viewCategories.backgroundColor = UIColor.white
        lblCategoriesIcon.textColor = Global.kAppColor.BlueDark
        lblCategoriesTitle.textColor = Global.kAppColor.BlueDark
    }
    
    @IBAction func btnMostViewedPostClick(_ sender: UIButton) {
        self.lblTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleMostViewedTitle")
        self.ClearAllSelectedFooterButton()
        self.HideAllViews()

        if arrMostViewedBlogList.count > 0 {
            MostViewedListView.isHidden = false
        } else {
            MostViewedListView.isHidden = true
        }
        
        if btnMostViewed.isSelected == true {
        } else {
            btnMostViewed.isSelected = true
            self.arrMostViewedBlogList.removeAllObjects()
            self.tblMostViewed.reloadData()
            self.getCommonWebServiceForBlogList(strUrlString:"most_viewed?type=week",isSearchPost:false)
        }
        
        viewMostViewed.backgroundColor = UIColor.white
        lblMostViewedIcon.textColor = Global.kAppColor.BlueDark
        lblMostViewedTitle.textColor = Global.kAppColor.BlueDark
    }
    
    @IBAction func btnSearchPostClick(_ sender: UIButton) {
        self.lblTitle.text = Global().getLocalizeStr(key: "KeyBlogTitleSearchPostTitle")
        self.ClearAllSelectedFooterButton()
        self.HideAllViews()
        
        viewSearchPost.backgroundColor = UIColor.white
        lblSearchPostIcon.textColor = Global.kAppColor.BlueDark
        lblSearchPostTitle.textColor = Global.kAppColor.BlueDark
        
        if arrMostViewedBlogList.count > 0 {
            self.searchPostListView.isHidden = false
        } else {
            self.searchPostListView.isHidden = true
        }
        
        if btnSearchPost.isSelected == true {
            
        } else {
            btnSearchPost.isSelected = true
            self.arrMostViewedBlogList.removeAllObjects()
            self.tblSearchPost.reloadData()
            self.getCommonWebServiceForBlogList(strUrlString:"search_post?keyword=",isSearchPost:true)
        }
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func ClearAllSelectedFooterButton() {
        
        viewLatestPost.backgroundColor = Global.kAppColor.BlueDark
        lblLatestPostIcon.textColor = UIColor.white
        lblLatestPost.textColor = UIColor.white
        
        viewCategories.backgroundColor = Global.kAppColor.BlueDark
        lblCategoriesIcon.textColor = UIColor.white
        lblCategoriesTitle.textColor = UIColor.white
        
        viewMostViewed.backgroundColor = Global.kAppColor.BlueDark
        lblMostViewedIcon.textColor = UIColor.white
        lblMostViewedTitle.textColor = UIColor.white
        
        viewSearchPost.backgroundColor = Global.kAppColor.BlueDark
        lblSearchPostIcon.textColor = UIColor.white
        lblSearchPostTitle.textColor = UIColor.white
        
        btnMostViewed.isSelected = false
        btnLatestPost.isSelected = false
        btnCategories.isSelected = false
        btnSearchPost.isSelected = false
    }
    
    // MARK: -  Get CategoryList API Call Methods
    func getCategoryListMethod() {
        AFAPIMaster.sharedAPIMaster.getBlogCategoryListAPi_Complition(params: nil, strUserId: "", showLoader: true, enableInteraction: true, viewObj:(self.view)! , onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let arrList = dictResponse.value(forKey: "data") as? NSArray {
                if arrList.count > 0 {
                    self.arrCategoryList.removeAllObjects()
                    for element in arrList {
                        var diction = NSDictionary()
                        diction = element as! NSDictionary
                        
                        let shareCategoryBlogObj: sharedBlogCategory = sharedBlogCategory()
                        shareCategoryBlogObj.strCategoryId = String(diction.value(forKey: "id") as? Int64 ?? 0)
                        shareCategoryBlogObj.strDiscription = diction.value(forKey: "description") as? String ?? ""
                        shareCategoryBlogObj.strCategoryImage = diction.value(forKey: "image") as? String ?? ""
                        shareCategoryBlogObj.strCategoryLink = diction.value(forKey: "link") as? String ?? ""
                        shareCategoryBlogObj.strCategoryName = diction.value(forKey: "name") as? String ?? ""
                        shareCategoryBlogObj.strCategorySlug = diction.value(forKey: "slug") as? String ?? ""
                        self.arrCategoryList.add(shareCategoryBlogObj)
                    }
                    self.tblCategory.reloadData()
                }
                else {
                    print(arrList)
                }
            }
            else {
            }
        }, onFailure: { () in
            
        })

    }
    
    
    // MARK: -  Get  Latest Post API Call Methods
    func getLatestPostListWithCategorySelectionMethod(strCategoryId:String,strPage:Int) {
        let strParameter = "articles?per_page=10&page=\(strPage)&cat=\(strCategoryId)"
        AFAPIMaster.sharedAPIMaster.getCategoryDetailPost_Complition(params: nil, struParameter: strParameter, showLoader: true, enableInteraction: false, viewObj:(self.view)! , onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            self.strMaxPageCount = (dictResponse.value(forKey: "max_num_page") as? Int ?? 0)
            if let arrList = dictResponse.value(forKey: "data") as? NSArray {
                if arrList.count > 0 {
                    if strCategoryId == "" {
                        if strPage == 1 {
                            self.strPageCount = self.strPageCount + 1
                            self.arrLatestPostList.removeAllObjects()
                        } else {
                            if self.strPageCount == self.strMaxPageCount {
                            } else {
                                self.strPageCount = self.strPageCount + 1
                            }
                        }
                    } else {
                        self.arrLatestPostList.removeAllObjects()
                    }
                    
                    for element in arrList {
                        var diction = NSDictionary()
                        diction = element as! NSDictionary
                        
                        let sharedMostViewedPostObj: sharedMostViewedBlogPost = sharedMostViewedBlogPost()
                        sharedMostViewedPostObj.strId = String(diction.value(forKey: "id") as? Int64 ?? 0)
                        sharedMostViewedPostObj.strPerLink = diction.value(forKey: "perlink") as? String ?? ""
                        sharedMostViewedPostObj.strTitle = diction.value(forKey: "title") as? String ?? ""
                        sharedMostViewedPostObj.strContent = diction.value(forKey: "content")as? String ?? ""
                        if let dictionMedia = diction.value(forKey: "featured_media") as? NSDictionary  {
                            sharedMostViewedPostObj.strFullImage = dictionMedia.value(forKey: "full_url") as? String ?? ""
                            sharedMostViewedPostObj.strMediaId = dictionMedia.value(forKey: "id") as? String ?? ""
                            sharedMostViewedPostObj.strThumbImage = dictionMedia.value(forKey: "thumb_url") as? String ?? ""
                        }
                        
                        if let arrCategory = diction.value(forKey: "categories") as? NSArray {
                            if arrCategory.count > 0 {
                                let dictCategory = arrCategory.object(at: 0) as? NSDictionary ?? NSDictionary()
                                sharedMostViewedPostObj.strCategoryName = dictCategory.value(forKey: "name") as? String ?? ""
                            }
                        }
                        
                        sharedMostViewedPostObj.strAuthorName = diction.value(forKey: "author") as? String ?? ""
                        sharedMostViewedPostObj.strTotalPostCount = diction.value(forKey: "count") as? String ?? "0"
                        sharedMostViewedPostObj.strDate = diction.value(forKey: "date") as? String ?? ""
                        
                        let strViewCount = diction.value(forKey: "views")as? String ?? ""
                        if strViewCount == "" {
                            sharedMostViewedPostObj.strViewPost = ("\("0") Views")
                        } else {
                            sharedMostViewedPostObj.strViewPost = ("\(diction.value(forKey: "views") as? String ?? "0") Views")
                        }
                        
                        
                        if let dictComment = diction.value(forKey: "comment_count") as? NSDictionary {
                            sharedMostViewedPostObj.strTotalPostCount = ("\(dictComment.value(forKey: "total_comments") as? String ?? "0") Comments")
                            let strViewCount = diction.value(forKey: "total_comments")as? String ?? ""
                            if strViewCount == "" {
                                sharedMostViewedPostObj.strViewPost = ("\("0") Comments")
                            } else {
                                sharedMostViewedPostObj.strViewPost = ("\(diction.value(forKey: "views") as? String ?? "0") Comments")
                            }
                        }
                        
                        self.arrLatestPostList.add(sharedMostViewedPostObj)
                    }
                    self.tblLatestPost.infiniteScrollingView.stopAnimating()
                    self.LatestPostListView.isHidden = false
                    self.tblLatestPost.reloadData()
                }
                print(arrList)
            }
            print(dictResponse)
        }, onFailure: { () in
            self.tblLatestPost.infiniteScrollingView.stopAnimating()
        })
    }

    // MARK: -  Get  Latest Post API Call Methods
    func getLatestPostListMethod(strCategoryId:String,strPage:Int) {
        let strParameter  = "articles?per_page=10&page=\(strPage)"

        AFAPIMaster.sharedAPIMaster.getCategoryDetailPost_Complition(params: nil, struParameter: strParameter, showLoader: true, enableInteraction: false, viewObj:(self.view)! , onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            self.strMaxPageCount = (dictResponse.value(forKey: "max_num_page") as? Int ?? 0)
            if let arrList = dictResponse.value(forKey: "data") as? NSArray {
                print(arrList.count)
                print(arrList)
                if arrList.count > 0 {
                    if strPage == 1 {
                        self.strPageCount = self.strPageCount + 1
                        self.arrLatestPostList.removeAllObjects()
                    } else {
                        if self.strPageCount == self.strMaxPageCount {
                        } else {
                            self.strPageCount = self.strPageCount + 1
                        }
                    }
                    
                    for element in arrList {
                        var diction = NSDictionary()
                        diction = element as! NSDictionary
                        
                        let sharedMostViewedPostObj: sharedMostViewedBlogPost = sharedMostViewedBlogPost()
                        sharedMostViewedPostObj.strId = String(diction.value(forKey: "id") as? Int64 ?? 0)
                        sharedMostViewedPostObj.strPerLink = diction.value(forKey: "perlink") as? String ?? ""
                        sharedMostViewedPostObj.strTitle = diction.value(forKey: "title") as? String ?? ""
                        sharedMostViewedPostObj.strContent = diction.value(forKey: "content")as? String ?? ""
                        if let dictionMedia = diction.value(forKey: "featured_media") as? NSDictionary  {
                            sharedMostViewedPostObj.strFullImage = dictionMedia.value(forKey: "full_url") as? String ?? ""
                            sharedMostViewedPostObj.strMediaId = dictionMedia.value(forKey: "id") as? String ?? ""
                            sharedMostViewedPostObj.strThumbImage = dictionMedia.value(forKey: "thumb_url") as? String ?? ""
                        }
                        
                        if let arrCategory = diction.value(forKey: "categories") as? NSArray {
                            if arrCategory.count > 0 {
                                let dictCategory = arrCategory.object(at: 0) as? NSDictionary ?? NSDictionary()
                                sharedMostViewedPostObj.strCategoryName = dictCategory.value(forKey: "name") as? String ?? ""
                            }
                        }
                        
                        sharedMostViewedPostObj.strAuthorName = diction.value(forKey: "author") as? String ?? ""
                        sharedMostViewedPostObj.strTotalPostCount = diction.value(forKey: "count") as? String ?? "0"
                        sharedMostViewedPostObj.strDate = diction.value(forKey: "date") as? String ?? ""
                        
                        let strViewCount = diction.value(forKey: "views")as? String ?? ""
                        if strViewCount == "" {
                            sharedMostViewedPostObj.strViewPost = ("\("0") Views")
                        } else {
                            sharedMostViewedPostObj.strViewPost = ("\(diction.value(forKey: "views") as? String ?? "0") Views")
                        }
                        
                    
                        if let dictComment = diction.value(forKey: "comment_count") as? NSDictionary {
                            sharedMostViewedPostObj.strTotalPostCount = ("\(dictComment.value(forKey: "total_comments") as? String ?? "0") Comments")
                            let strViewCount = diction.value(forKey: "total_comments")as? String ?? ""
                            if strViewCount == "" {
                                sharedMostViewedPostObj.strViewPost = ("\("0") Comments")
                            } else {
                                sharedMostViewedPostObj.strViewPost = ("\(diction.value(forKey: "views") as? String ?? "0") Comments")
                            }
                        }
                    
                        self.arrLatestPostList.add(sharedMostViewedPostObj)
                    }
                    self.tblLatestPost.reloadData()
                    self.tblLatestPost.infiniteScrollingView.stopAnimating()
                }
            }
            print(dictResponse)
        }, onFailure: { () in
            self.tblLatestPost.infiniteScrollingView.stopAnimating()
        })
    }
    

    // MARK: -  Get  Latest Post API Call Methods
    func getCommonWebServiceForBlogList(strUrlString:String, isSearchPost:Bool) {
        AFAPIMaster.sharedAPIMaster.getBlogMostViewedPost_Complition(params: nil, struParameter:strUrlString, showLoader: true, enableInteraction: false, viewObj:(self.view)! , onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            if let arrList = dictResponse.value(forKey: "data") as? NSArray {
                if arrList.count > 0 {
                    self.arrMostViewedBlogList.removeAllObjects()
                    for element in arrList {
                        var diction = NSDictionary()
                        diction = element as! NSDictionary
                        
                        let sharedMostViewedPostObj: sharedMostViewedBlogPost = sharedMostViewedBlogPost()
                        sharedMostViewedPostObj.strId = String(diction.value(forKey: "id") as? Int64 ?? 0)
                        sharedMostViewedPostObj.strPerLink = diction.value(forKey: "perlink") as? String ?? ""
                        sharedMostViewedPostObj.strTitle = diction.value(forKey: "title") as? String ?? ""
                        sharedMostViewedPostObj.strContent = diction.value(forKey: "content")as? String ?? ""
                        
                        if isSearchPost == true {
                            if let dictionMedia = diction.value(forKey: "featured_media") as? NSDictionary  {
                                sharedMostViewedPostObj.strFullImage = dictionMedia.value(forKey: "full_url") as? String ?? ""
                                sharedMostViewedPostObj.strMediaId = dictionMedia.value(forKey: "id") as? String ?? ""
                                sharedMostViewedPostObj.strThumbImage = dictionMedia.value(forKey: "thumb_url") as? String ?? ""
                            }
                        } else {
                            if let dictionMedia = diction.value(forKey: "featured_media") as? NSDictionary  {
                                sharedMostViewedPostObj.strFullImage = dictionMedia.value(forKey: "full") as? String ?? ""
                                sharedMostViewedPostObj.strMediaId = dictionMedia.value(forKey: "id") as? String ?? ""
                                sharedMostViewedPostObj.strThumbImage = dictionMedia.value(forKey: "thumb") as? String ?? ""
                            }
                        }
                        
                        if let arrCategory = diction.value(forKey: "categories") as? NSArray {
                            if arrCategory.count > 0 {
                                let dictCategory = arrCategory.object(at: 0) as? NSDictionary ?? NSDictionary()
                                sharedMostViewedPostObj.strCategoryName = dictCategory.value(forKey: "name") as? String ?? ""
                            }
                        }
                        
                        sharedMostViewedPostObj.strAuthorName = diction.value(forKey: "author") as? String ?? ""
                        sharedMostViewedPostObj.strTotalPostCount = diction.value(forKey: "count") as? String ?? "0"
                        sharedMostViewedPostObj.strDate = diction.value(forKey: "date") as? String ?? ""
                        
                        let strViewCount = diction.value(forKey: "views")as? String ?? ""
                        if strViewCount == "" {
                            sharedMostViewedPostObj.strViewPost = ("\("0") Views")
                        } else {
                            sharedMostViewedPostObj.strViewPost = ("\(diction.value(forKey: "views") as? String ?? "0") Views")
                        }
                        
                        
                        if let dictComment = diction.value(forKey: "comment_count") as? NSDictionary {
                            sharedMostViewedPostObj.strTotalPostCount = ("\(dictComment.value(forKey: "total_comments") as? String ?? "0") Comments")
                            let strViewCount = diction.value(forKey: "total_comments")as? String ?? ""
                            if strViewCount == "" {
                                sharedMostViewedPostObj.strViewPost = ("\("0") Comments")
                            } else {
                                sharedMostViewedPostObj.strViewPost = ("\(diction.value(forKey: "views") as? String ?? "0") Comments")
                            }
                        }
                        self.arrMostViewedBlogList.add(sharedMostViewedPostObj)
                    }
                    
                    if isSearchPost == true {
                        self.tblSearchPost.reloadData()
                        self.searchPostListView.isHidden = false
                    } else {
                        self.tblMostViewed.reloadData()
                        self.MostViewedListView.isHidden = false
                    }
                }
                
                if isSearchPost == true {
                    self.tblSearchPost.reloadData()
                    self.searchPostListView.isHidden = false
                } else {
                    self.tblMostViewed.reloadData()
                    self.MostViewedListView.isHidden = false
                }
                print(arrList)
            }
            if isSearchPost == true {
                self.tblSearchPost.reloadData()
                self.searchPostListView.isHidden = false
            } else {
                self.tblMostViewed.reloadData()
                self.MostViewedListView.isHidden = false
            }
            print(dictResponse)
        }, onFailure: { () in

            if isSearchPost == true {
                self.searchPostListView.isHidden = false
            } else {
                self.MostViewedListView.isHidden = false
            }
        })
    }
    
    func HideAllViews() {
        self.searchPostListView.isHidden = true
        self.categoryListView.isHidden = true
        self.MostViewedListView.isHidden = true
        self.latestPostView.isHidden = true
    }
}


//MARK: -
extension PR_BlogsVC: UITableViewDelegate,UITableViewDataSource {
    // MARK: -  UITableview Delegate Click Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblLatestPost {
            if indexPath.row == 0 {
                let cell: PR_BlogPostHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PR_BlogPostHeaderCell", for: indexPath) as! PR_BlogPostHeaderCell
                cell.selectionStyle = .none
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrLatestPostList[indexPath.row ] as! sharedMostViewedBlogPost
                let strCatName = "  \(shareMostViewesObj.strCategoryName)  "
                cell.btnCategoryName.setTitle(strCatName, for: .normal)
                cell.lblDate.text = shareMostViewesObj.strDate
                let strAuthorName = ("\(shareMostViewesObj.strAuthorName)")
                let strAuthor = Global().getLocalizeStr(key: "KeyAuthor")
                let strMixText = (" \(strAuthor) \(strAuthorName)")
                let range = (strMixText as NSString).range(of: strAuthorName)
                let attributedString = NSMutableAttributedString(string:strMixText)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.kAppColor.BlueDark , range: range)
                cell.lblAuthorName.attributedText = attributedString
                cell.lblCommentCount.text = shareMostViewesObj.strTotalPostCount
                cell.lblPostView.text = shareMostViewesObj.strViewPost
                cell.imgProfile.sd_setImage(with: URL.init(string: shareMostViewesObj.strFullImage), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                
                var strValue: String = ""
                strValue = shareMostViewesObj.strContent
                
                if (strValue.characters.count > 150) {
                    let index = strValue.index(strValue.startIndex, offsetBy: 150)
                    strValue = strValue.substring(to: index)  // Hello
                    print(strValue)
                    cell.lblDiscription.text = strValue.html2String

                } else {
                    cell.lblDiscription.text = strValue.html2String
                }
    
                return cell
            } else {
                let cell: PR_BlogMostViewedCell = tableView.dequeueReusableCell(withIdentifier: "PR_BlogMostViewedCell", for: indexPath) as! PR_BlogMostViewedCell
                cell.selectionStyle = .none
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrLatestPostList[indexPath.row ] as! sharedMostViewedBlogPost
                let strCatName = "  \(shareMostViewesObj.strCategoryName)  "
                cell.btnCategoryName.setTitle(strCatName, for: .normal)
                
                cell.lblDate.text = shareMostViewesObj.strDate
                let strAuthorName = ("\(shareMostViewesObj.strAuthorName)")
                let strAuthor = Global().getLocalizeStr(key: "KeyAuthor")
                let strMixText = (" \(strAuthor) \(strAuthorName)")
                let range = (strMixText as NSString).range(of: strAuthorName)
                let attributedString = NSMutableAttributedString(string:strMixText)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.kAppColor.BlueDark , range: range)
                cell.lblAuthorName.attributedText = attributedString
                cell.lblCommentCount.text = shareMostViewesObj.strTotalPostCount
                cell.lblPostView.text = shareMostViewesObj.strViewPost
                cell.imgProfile.sd_setImage(with: URL.init(string: shareMostViewesObj.strFullImage), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                var strValue: String = ""
                strValue = shareMostViewesObj.strContent
               
    
                if (strValue.characters.count > 150) {
                    let index = strValue.index(strValue.startIndex, offsetBy: 150)
                    strValue = strValue.substring(to: index)  // Hello
                    print(strValue)
                    cell.lblDiscription.text = strValue.html2String
                    
                } else {
                    cell.lblDiscription.text = strValue.html2String
                }
                return cell
            }
            
        }  else if tableView == tblSearchPost {
            if indexPath.row == 0 {
                let cell: PR_BlogPostHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PR_BlogPostHeaderCell", for: indexPath) as! PR_BlogPostHeaderCell
                cell.selectionStyle = .none
                
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrMostViewedBlogList[indexPath.row] as! sharedMostViewedBlogPost
                
                let strCatName = "  \(shareMostViewesObj.strCategoryName)  "
                cell.btnCategoryName.setTitle(strCatName, for: .normal)
                
                cell.lblDate.text = shareMostViewesObj.strDate
                let strAuthorName = ("\(shareMostViewesObj.strAuthorName)")
                let strAuthor = Global().getLocalizeStr(key: "KeyAuthor")
                let strMixText = (" \(strAuthor) \(strAuthorName)")
                let range = (strMixText as NSString).range(of: strAuthorName)
                let attributedString = NSMutableAttributedString(string:strMixText)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.kAppColor.BlueDark , range: range)
                cell.lblAuthorName.attributedText = attributedString
                cell.lblCommentCount.text = shareMostViewesObj.strTotalPostCount
                cell.lblPostView.text = shareMostViewesObj.strViewPost
                cell.imgProfile.sd_setImage(with: URL.init(string: shareMostViewesObj.strFullImage), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                var strValue: String = ""
                strValue = shareMostViewesObj.strContent
                
                if (strValue.characters.count > 150) {
                    let index = strValue.index(strValue.startIndex, offsetBy: 150)
                    strValue = strValue.substring(to: index)  // Hello
                    print(strValue)
                    cell.lblDiscription.text = strValue.html2String
                    
                } else {
                    cell.lblDiscription.text = strValue.html2String
                }
                return cell
            } else {
                let cell: PR_BlogMostViewedCell = tableView.dequeueReusableCell(withIdentifier: "PR_BlogMostViewedCell", for: indexPath) as! PR_BlogMostViewedCell
                cell.selectionStyle = .none
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrMostViewedBlogList[indexPath.row ] as! sharedMostViewedBlogPost
                let strCatName = "  \(shareMostViewesObj.strCategoryName)  "
                cell.btnCategoryName.setTitle(strCatName, for: .normal)
                
                cell.lblDate.text = shareMostViewesObj.strDate
                let strAuthorName = ("\(shareMostViewesObj.strAuthorName)")
                let strAuthor = Global().getLocalizeStr(key: "KeyAuthor")
                let strMixText = (" \(strAuthor) \(strAuthorName)")
                let range = (strMixText as NSString).range(of: strAuthorName)
                let attributedString = NSMutableAttributedString(string:strMixText)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.kAppColor.BlueDark , range: range)
                cell.lblAuthorName.attributedText = attributedString
                cell.lblCommentCount.text = shareMostViewesObj.strTotalPostCount
                cell.lblPostView.text = shareMostViewesObj.strViewPost
                cell.imgProfile.sd_setImage(with: URL.init(string: shareMostViewesObj.strFullImage), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                
                var strValue: String = ""
                strValue = shareMostViewesObj.strContent
                
                if (strValue.characters.count > 150) {
                    let index = strValue.index(strValue.startIndex, offsetBy: 150)
                    strValue = strValue.substring(to: index)  // Hello
                    print(strValue)
                    cell.lblDiscription.text = strValue.html2String
                    
                } else {
                    cell.lblDiscription.text = strValue.html2String
                }
                return cell
            }

        } else if tableView == tblMostViewed {
            
            if indexPath.row == 0 {
                let cell: PR_BlogPostHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PR_BlogPostHeaderCell", for: indexPath) as! PR_BlogPostHeaderCell
                cell.selectionStyle = .none
                
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrMostViewedBlogList[indexPath.row] as! sharedMostViewedBlogPost
                
                let strCatName = "  \(shareMostViewesObj.strCategoryName)  "
                cell.btnCategoryName.setTitle(strCatName, for: .normal)
                
                cell.lblDate.text = shareMostViewesObj.strDate
                let strAuthorName = ("\(shareMostViewesObj.strAuthorName)")
                let strAuthor = Global().getLocalizeStr(key: "KeyAuthor")
                let strMixText = (" \(strAuthor) \(strAuthorName)")
                let range = (strMixText as NSString).range(of: strAuthorName)
                let attributedString = NSMutableAttributedString(string:strMixText)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.kAppColor.BlueDark , range: range)
                cell.lblAuthorName.attributedText = attributedString
                cell.lblCommentCount.text = shareMostViewesObj.strTotalPostCount
                cell.lblPostView.text = shareMostViewesObj.strViewPost
                cell.imgProfile.sd_setImage(with: URL.init(string: shareMostViewesObj.strFullImage), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                var strValue: String = ""
                strValue = shareMostViewesObj.strContent
                
                if (strValue.characters.count > 150) {
                    let index = strValue.index(strValue.startIndex, offsetBy: 150)
                    strValue = strValue.substring(to: index)  // Hello
                    print(strValue)
                    cell.lblDiscription.text = strValue.html2String
                    
                } else {
                    cell.lblDiscription.text = strValue.html2String
                }
                return cell
            } else {
                let cell: PR_BlogMostViewedCell = tableView.dequeueReusableCell(withIdentifier: "PR_BlogMostViewedCell", for: indexPath) as! PR_BlogMostViewedCell
                cell.selectionStyle = .none
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrMostViewedBlogList[indexPath.row ] as! sharedMostViewedBlogPost
                let strCatName = "  \(shareMostViewesObj.strCategoryName)  "
                cell.btnCategoryName.setTitle(strCatName, for: .normal)
                
                cell.lblDate.text = shareMostViewesObj.strDate
                let strAuthorName = ("\(shareMostViewesObj.strAuthorName)")
                let strAuthor = Global().getLocalizeStr(key: "KeyAuthor")
                let strMixText = (" \(strAuthor) \(strAuthorName)")
                let range = (strMixText as NSString).range(of: strAuthorName)
                let attributedString = NSMutableAttributedString(string:strMixText)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: Global.kAppColor.BlueDark , range: range)
                cell.lblAuthorName.attributedText = attributedString
                cell.lblCommentCount.text = shareMostViewesObj.strTotalPostCount
                cell.lblPostView.text = shareMostViewesObj.strViewPost
                cell.imgProfile.sd_setImage(with: URL.init(string: shareMostViewesObj.strFullImage), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
                
                var strValue: String = ""
                strValue = shareMostViewesObj.strContent
                if (strValue.characters.count > 150) {
                    let index = strValue.index(strValue.startIndex, offsetBy: 150)
                    strValue = strValue.substring(to: index)  // Hello
                    print(strValue)
                    cell.lblDiscription.text = strValue.html2String
                    
                } else {
                    cell.lblDiscription.text = strValue.html2String
                }
                return cell
            }
            
        } else  {
            let cell: PR_CategoryList = tableView.dequeueReusableCell(withIdentifier: "PR_CategoryList", for: indexPath) as! PR_CategoryList
            cell.selectionStyle = .none
            if indexPath.row % 2 == 0 {
                cell.contentView.backgroundColor = Global.kAppColor.OffWhite
            } else {
                cell.contentView.backgroundColor = UIColor.white
            }
            
            let shareObj: sharedBlogCategory = self.arrCategoryList[indexPath.row] as! sharedBlogCategory
            cell.lblCategoryName.text = shareObj.strCategoryName
            cell.imgCategory.sd_setImage(with: URL.init(string: shareObj.strCategoryImage), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblCategory {
            return self.arrCategoryList.count
        } else if tableView == tblSearchPost {
            if arrMostViewedBlogList.count > 1 {
                self.searchPostListView.isHidden = false
                return arrMostViewedBlogList.count
            } else {
                return 0
            }
        } else if tableView == tblLatestPost {
            if self.arrLatestPostList.count > 1 {
                self.latestPostView.isHidden = false
                return self.arrLatestPostList.count
            } else {
                return 0
            }
        } else {
            if arrMostViewedBlogList.count > 1 {
                self.MostViewedListView.isHidden = false
                return arrMostViewedBlogList.count
            } else {
                return 0
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblCategory {
            return ((Global.screenWidth) * 55) / 320
        } else {
            if indexPath.row == 0 {
                return ((Global.screenWidth) * 265) / 320
            }
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: -  UITableview Delegate Click Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        bottomSearchLayout.constant = 0
        if tableView == tblCategory {
            
            let shareObj: sharedBlogCategory = self.arrCategoryList[indexPath.row] as! sharedBlogCategory
            let PR_BlogsVCObj = PR_BlogsVC(nibName: "PR_BlogsVC", bundle: nil)
            PR_BlogsVCObj.isNavFromCategory = true
            PR_BlogsVCObj.isNavFromSlideMenu = false
            PR_BlogsVCObj.strSelectedCategoryId = shareObj.strCategoryId
            PR_BlogsVCObj.strSelectedCategoryName = shareObj.strCategoryName
            self.navigationController?.pushViewController(PR_BlogsVCObj, animated: true)
            self.LatestPostListView.isHidden = true
        } else {
            let PR_BlogDetailVCObj = PR_BlogDetailVC(nibName: "PR_BlogDetailVC", bundle: nil)
            if tableView == tblSearchPost || tableView == tblMostViewed  {
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrMostViewedBlogList[indexPath.row] as! sharedMostViewedBlogPost
                PR_BlogDetailVCObj.strWebDetailUrl = shareMostViewesObj.strPerLink
                PR_BlogDetailVCObj.strWebDetailCategoryName = shareMostViewesObj.strCategoryName
            } else {
                let shareMostViewesObj: sharedMostViewedBlogPost = self.arrLatestPostList[indexPath.row] as! sharedMostViewedBlogPost
                PR_BlogDetailVCObj.strWebDetailUrl = shareMostViewesObj.strPerLink
                PR_BlogDetailVCObj.strWebDetailCategoryName = shareMostViewesObj.strCategoryName
            }
            self.navigationController?.pushViewController(PR_BlogDetailVCObj, animated: true)
        }
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension PR_BlogsVC:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let strKeyworkSaerch = searchBar.text!
        let escapedString = strKeyworkSaerch.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        self.getCommonWebServiceForBlogList(strUrlString:"search_post?keyword=\(escapedString!)",isSearchPost:true)
        self.view.endEditing(true)
        bottomSearchLayout.constant = 0
    }
}

// MARK: -
extension PR_BlogsVC {
    // MARK: -  Keyboard Hide Show Methods
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomSearchLayout.constant = keyboardSize.height - footerVIew.frame.height
        }
    }
}


