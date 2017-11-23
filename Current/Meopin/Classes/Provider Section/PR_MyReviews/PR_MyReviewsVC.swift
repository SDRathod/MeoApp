//
//  PR_MyReviews.swift
//  Meopin
//
//  Created by Tops on 10/6/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PR_MyReviewsVC: STableViewController {
    @IBOutlet var btnSlideMenu: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var tblReviewList: UITableView!
    @IBOutlet var lblNoDataMsg: UILabel!
    
    var arrReviewList: [ReviewListSObject] = [ReviewListSObject]()
    
    var boolIsFromSlideMenu: Bool = true
    var intCurrentPage: Int = 0
    var mySlideViewObj: MySlideViewController?
    
    // MARK: -  View Life Cycle Start Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySlideViewObj = self.navigationController?.parent as? MySlideViewController;
        
        self.tableView.frame = CGRect(x: tblReviewList.frame.origin.x, y: tblReviewList.frame.origin.y, width: Global.screenWidth, height: tblReviewList.frame.size.height)
        
        var nib: [AnyObject] = Bundle.main.loadNibNamed("DemoTableHeaderView", owner: self, options: nil)! as [AnyObject]
        let headerView: DemoTableHeaderView = (nib[0] as! DemoTableHeaderView)
        self.headerView = headerView
        
        nib = Bundle.main.loadNibNamed("DemoTableFooterView", owner: self, options: nil)! as [AnyObject]
        let footerView: DemoTableFooterView = (nib[0] as! DemoTableFooterView)
        self.footerView = footerView
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.canLoadMore = true
        self.pullToRefreshEnabled = true
        
        self.tableView.register(UINib(nibName: "PT_MyReviewsCell", bundle: nil), forCellReuseIdentifier: "PT_MyReviewsCell")
        
        tblReviewList.isHidden = true
        lblNoDataMsg.isHidden = true
        self.view.bringSubview(toFront: lblNoDataMsg)
        
        self.getPatientMyReviewListCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.setLanguageTitles()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLanguageTitles), name: NSNotification.Name(rawValue: "105"), object: nil)
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if (boolIsFromSlideMenu) {
            btnSlideMenu.isHidden = false
            btnBack.isHidden = true
        }
        else {
            btnSlideMenu.isHidden = true
            btnBack.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = tblReviewList.frame
    }
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        lblTitle.text = Global().getLocalizeStr(key: "keyMRTitle")
        lblNoDataMsg.text = Global().getLocalizeStr(key: "keyMRNoReviewMsg1")
        
        self.tableView.reloadData()
    }
    
    func setDeviceSpecificFonts() {
        btnSlideMenu.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        btnBack.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(17))
        lblNoDataMsg.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    // MARK: -  View Life Cycle End Method
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "105"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

//MARK: -
extension PR_MyReviewsVC {
    // MARK: -  API Call Methods
    func getPatientMyReviewListCall() {
        let intPageIndex: Int = intCurrentPage
        let param: NSMutableDictionary = NSMutableDictionary()
        param.setValue(Global.kLoggedInUserData().Id!, forKey: "form[providerId]")
        param.setValue("\(intCurrentPage)", forKey: "form[page]")
        
        var boolLoader: Bool = false
        if (self.arrReviewList.count <= 0) {
            boolLoader = true
            self.lblNoDataMsg.isHidden = true
        }
        
        let intTempArrayCount = self.arrReviewList.count
        AFAPIMaster.sharedAPIMaster.getProviderMyReviewsListDataCall_Completion(params: param, showLoader: boolLoader, enableInteraction: false, viewObj: self.view, onSuccess: { (returnData: Any) in
            let dictResponse: NSDictionary = returnData as! NSDictionary
            
            if (intPageIndex == 0) {
                self.arrReviewList.removeAll()
            }
            if let arrData: NSArray = dictResponse.object(forKey: "userData") as? NSArray {
                if let dictData: NSDictionary = arrData.object(at: 0) as? NSDictionary {
                    if let arrResultData: NSArray = dictData.object(forKey: "result") as? NSArray {
                        for i in 0 ..< arrResultData.count {
                            if let dictReview: NSDictionary = arrResultData.object(at: i) as? NSDictionary {
                                let shareObj: ReviewListSObject = ReviewListSObject()
                                
                                shareObj.strReviewId = dictReview.object(forKey: "reviewId") as? String ?? ""
                                shareObj.strPatientId = dictReview.object(forKey: "userId") as? String ?? ""
                                shareObj.strReviewTime = dictReview.object(forKey: "addedTimeBefore") as? String ?? ""
                                shareObj.strRevieDesc = dictReview.object(forKey: "reviewText") as? String ?? ""
                                shareObj.strGlobalRating = dictReview.object(forKey: "myScore") as? String ?? ""
                                
                                shareObj.strProfilePic = dictReview.object(forKey: "profilePictureUrl") as? String ?? ""
                                shareObj.strSalutation = dictReview.object(forKey: "salutation") as? String ?? ""
                                shareObj.strFirstName = dictReview.object(forKey: "firstName") as? String ?? ""
                                shareObj.strLastName = dictReview.object(forKey: "lastName") as? String ?? ""
                                
                                if let dictProvider: NSDictionary = dictReview.object(forKey: "provider") as? NSDictionary {
                                    shareObj.strProviderId = dictProvider.object(forKey: "userId") as? String ?? ""
                                }
                                if let arrRatingData: NSArray = dictReview.object(forKey: "grade") as? NSArray {
                                    for j in 0 ..< arrRatingData.count {
                                        if let dictRating: NSDictionary = arrRatingData.object(at: j) as? NSDictionary {
                                            if (j == 0) {
                                                shareObj.strReviewRatingTitle1 = dictRating.object(forKey: "name") as? String ?? ""
                                                shareObj.strReviewRatingRating1 = dictRating.object(forKey: "grade") as? String ?? ""
                                            }
                                            else if (j == 1) {
                                                shareObj.strReviewRatingTitle2 = dictRating.object(forKey: "name") as? String ?? ""
                                                shareObj.strReviewRatingRating2 = dictRating.object(forKey: "grade") as? String ?? ""
                                            }
                                            else if (j == 2) {
                                                shareObj.strReviewRatingTitle3 = dictRating.object(forKey: "name") as? String ?? ""
                                                shareObj.strReviewRatingRating3 = dictRating.object(forKey: "grade") as? String ?? ""
                                            }
                                        }
                                    }
                                }
                                
                                self.arrReviewList.append(shareObj)
                            }
                        }
                    }
                }
            }
            if (self.arrReviewList.count > intTempArrayCount || intPageIndex == 0) {
                self.tableView.reloadData()
            }
            
            self.loadMoreCompleted()
            self.refreshCompleted()
            if (self.arrReviewList.count == 0) {
                self.lblNoDataMsg.isHidden = false
            }
            else {
                self.lblNoDataMsg.isHidden = true
            }
        }, onFailure: { () in
            self.loadMoreCompleted()
            self.refreshCompleted()
            
            if (self.arrReviewList.count == 0) {
                self.lblNoDataMsg.isHidden = false
            }
            else {
                self.lblNoDataMsg.isHidden = true
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

// MARK: -
extension PR_MyReviewsVC {
    // MARK: -  UITableView DataSource & Delegate Methods
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReviewList.count
    }
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PT_MyReviewsCell = tableView.dequeueReusableCell(withIdentifier: "PT_MyReviewsCell", for: indexPath) as! PT_MyReviewsCell
        cell.setLanguageTitles()
        
        let shareObj: ReviewListSObject = self.arrReviewList[indexPath.row]
        
        cell.imgProfilePic.image = #imageLiteral(resourceName: "ProfileView")
        if (shareObj.strProfilePic != "") {
            cell.imgProfilePic.sd_setImage(with: URL.init(string: shareObj.strProfilePic), placeholderImage: #imageLiteral(resourceName: "ProfileView"))
        }
        
        var strFullName: String = ""
        if (shareObj.strFirstName.characters.count > 0) {
            strFullName = "\(strFullName)\(shareObj.strFirstName) "
        }
        strFullName = "\(strFullName)\(shareObj.strLastName)"
        cell.lblUserName.text = strFullName
        
        cell.lblReviewTime.text = shareObj.strReviewTime
        cell.lblReviewDesc.text = shareObj.strRevieDesc
        cell.lblReviewRating.text = "\(Global().getLocalizeStr(key: "keyMRGlobalRating")) \(shareObj.strGlobalRating)"
        cell.lblReviewAllRating.text = "\(shareObj.strReviewRatingTitle1) \(shareObj.strReviewRatingRating1)  | \(shareObj.strReviewRatingTitle2) \(shareObj.strReviewRatingRating2)  | \(shareObj.strReviewRatingTitle3) \(shareObj.strReviewRatingRating3)"
        
        cell.sizeToFit()
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shareObj = arrReviewList[indexPath.row]
        
        let pt_reviewDetailObj = PT_ReviewDetailVC(nibName: "PT_ReviewDetailVC", bundle: nil)
        pt_reviewDetailObj.strSelReviewId = shareObj.strReviewId
        self.navigationController?.pushViewController(pt_reviewDetailObj, animated: true)
    }
}

// MARK: -
extension PR_MyReviewsVC {
    // MARK: -  STableViewController Methods
    override func pinHeaderView() {
        super.pinHeaderView()
        let hv: DemoTableHeaderView = (self.headerView as! DemoTableHeaderView)
        hv.activityIndicator.startAnimating()
        hv.title.text = Global().getLocalizeStr(key: "keyPRTLoading")
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        hv.arrowImage.isHidden = true
        CATransaction.commit()
        self.perform(#selector(self.addItemsOnTop), with: nil, afterDelay: 0.0)
    }
    
    override func unpinHeaderView() {
        super.unpinHeaderView()
        (self.headerView as! DemoTableHeaderView).activityIndicator.stopAnimating()
    }
    
    override func headerViewDidScroll(_ willRefreshOnRelease: Bool, scrollView: UIScrollView) {
        let hv: DemoTableHeaderView = (self.headerView as! DemoTableHeaderView)
        if willRefreshOnRelease {
            hv.title.text = Global().getLocalizeStr(key: "keyPRTReleaseRefresh")
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.18)
            hv.arrowImage.transform = CATransform3DMakeRotation((.pi/180.0)*180.0, 0.0, 0.0, 1.0)
            CATransaction.commit()
        }
        else {
            hv.title.text = Global().getLocalizeStr(key: "keyPRTDownRefresh")
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.18)
            hv.arrowImage.transform = CATransform3DIdentity
            CATransaction.commit()
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            hv.arrowImage.isHidden = false
            hv.arrowImage.transform = CATransform3DIdentity
            CATransaction.commit()
        }
    }
    
    override func refresh() -> Bool {
        if !super.refresh() {
            return false
        }
        return true
    }
    
    override func willBeginLoadingMore() {
        super.willBeginLoadingMore()
        let fv: DemoTableFooterView = (self.footerView as! DemoTableFooterView)
        fv.activityIndicator.startAnimating()
        self.perform(#selector(self.addItemsOnBottom), with: nil, afterDelay: 0.0)
    }
    
    override func loadMoreCompleted() {
        super.loadMoreCompleted()
        
        let fv: DemoTableFooterView = (self.footerView as! DemoTableFooterView)
        fv.activityIndicator.stopAnimating()
        if !self.canLoadMore {
            fv.infoLabel.isHidden = false
        }
    }
    
    func loadMoreCompletedNoRecords() {
        super.loadMoreCompleted()
        
        let fv: DemoTableFooterView = (self.footerView as! DemoTableFooterView)
        fv.activityIndicator.stopAnimating()
        
        fv.infoLabel.isHidden = false
        fv.infoLabel.alpha = 0.0
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            fv.infoLabel.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
            Global().delay(delay: 2, closure: {
                fv.infoLabel.alpha = 1.0
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                    fv.infoLabel.alpha = 0.0
                }, completion: {(finished: Bool) -> Void in
                    fv.infoLabel.isHidden = true
                })
            })
        })
    }
    
    override func loadMore() -> Bool {
        if !super.loadMore() {
            return false
        }
        return true
    }
    
    func addItemsOnTop() {
        intCurrentPage = 0
        self.getPatientMyReviewListCall()
    }
    
    func addItemsOnBottom() {
        intCurrentPage = intCurrentPage + 1
        self.getPatientMyReviewListCall()
        self.canLoadMore = true
    }
}

