//
//  AFAPIMaster.swift
//  chilax74-16
//
//  Created by Tops on 6/15/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit


class AFAPIMaster: AFAPICaller {
    static let sharedAPIMaster = AFAPIMaster()
    
    typealias AFAPIMasterSuccess = (_ returnData: Any) -> Void
    typealias AFAPIMasterFailure = () -> Void
    typealias DisplayProgress = (_ Progress:Any) -> Void
    
    // MARK: -  Check OAuth2 Token is expired or not
    func checkOAuth2TokenIsExpired(viewObj: UIView, boolIsOAuthCodeNeed: Bool, onSuccess: @escaping (AFAPIMasterSuccess)) {
        if (Global.kLoggedInUserData().IsLoggedIn == "1") {
            let doubleCurrentTimestamp: Double = Double(Global.singleton.getCurrentDateTimeStamp())!
            let doubleLoginTimestamp: Double = Double(Global.kLoggedInUserData().LastLoginTimestamp!)!
            let intTimestampDiffer: Int = Int(doubleCurrentTimestamp - doubleLoginTimestamp)
            
            if (intTimestampDiffer >= Int(Global.kLoggedInUserData().ExpiresIn!)!) {
                let param: NSMutableDictionary = NSMutableDictionary()
                param.setValue(Global.kLoggedInUserData().RefreshToken, forKey: "form[refreshToken]")
                
                AFAPIMaster.sharedAPIMaster.refreshOAuthTokenCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: viewObj, onSuccess: { (returnData: Any) in
                    let dictResponse: NSDictionary = returnData as! NSDictionary
                    if let dictData: NSDictionary = dictResponse.object(forKey: "userData") as? NSDictionary {
                        Global.singleton.saveToUserDefaults(value: "1", forKey: Global.kLoggedInUserKey.IsLoggedIn)
                        Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "accessToken") as? String ?? "", forKey: Global.kLoggedInUserKey.AccessToken);
                        Global.singleton.saveToUserDefaults(value: dictData.object(forKey: "refreshToken") as? String ?? "", forKey: Global.kLoggedInUserKey.RefreshToken);
                        Global.singleton.saveToUserDefaults(value: String(describing: (dictData.object(forKey: "expiresIn") as! NSNumber)) , forKey: Global.kLoggedInUserKey.ExpiresIn)
                        
                        Global.singleton.saveToUserDefaults(value: Global.singleton.getCurrentDateTimeStamp(), forKey: Global.kLoggedInUserKey.LastLoginTimestamp)
                        
                        onSuccess(returnData)
                    }
                })
            }
            else {
                onSuccess(NSDictionary())
            }
        }
        else {
            //call API for getting OAuth code
            if (boolIsOAuthCodeNeed == true) {
                let param: NSMutableDictionary = NSMutableDictionary()
                
                AFAPIMaster.sharedAPIMaster.getOAuthCodeCall_Completion(params: param, showLoader: true, enableInteraction: false, viewObj: viewObj, onSuccess: { (returnData: Any) in
                    onSuccess(returnData)
                })
            }
            else {
                onSuccess(NSDictionary())
            }
        }
    }
    
    // MARK: -  Get Application Current Version API
    func getAppCurrentVersionData_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict: Any, success: Bool) in
            if (success) {
                onSuccess(responseDict)
            }
        }, onFailure: { () in
        })
    }
    
    // MARK: -  Registration API
    func postRegistrationCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "patient/register", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
    }

    func postRegisterVarificationCodeCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "patient/register/verification", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            let nc = NotificationCenter.default
            nc.post(name: NSNotification.Name(rawValue: "ErroFailValidation"), object: nil)
        })
    }
    
    // MARK: -  Login Logout API
    func postLoginCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "user/login", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
    }
    
    func postLogoutUserCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/logout", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Forgot Password API
    func forgotPwdSendVerifCodeCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "user/forgot-password/send-verification", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
    }
    
    func forgotPwdCheckVerifCodeCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "user/forgot-password/verification", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
    }
    
    func forgotPwdChangePwdCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "user/forgot-password/change-password", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
    }
    
    // MARK: -  OAuth2 Refresh Token & Code API
    func refreshOAuthTokenCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "access_token", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
    }
    
    func getOAuthCodeCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPIUsingPOST(filePath: "", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
        })
    }
    
    // MARK: -  View Edit Patient Profile API Call
    func getPatientProfileDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingGET(filePath: "patient/show/\(Global.kLoggedInUserData().Id!)/\(Global.LanguageData().SelLanguage!)", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func sendPatientProfileVerificationCodeCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/profile-verification", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func postEditPatientProfileCall_Completion(params: NSMutableDictionary?, img: UIImage?, imgName: String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIWithImage(filePath: "patient/edit", params: params, image: img, imageParamName: imgName, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  View Edit Provider Profile Call API
    func getProviderProfileCall_Completion(params: NSMutableDictionary?, strUserId:String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingGET(filePath: String("provider/show/\(strUserId)/en"), params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func postEditProviderProfileCall_Completion(params: NSMutableDictionary?,userProfileImage:UIImage?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIWithImage(filePath: "provider/edit", params: params, image:userProfileImage , imageParamName: "form[profilePic]", enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{() in })
        }
    }
    
    func postEditProviderProfileVarificationCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/profile-verification", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Change Password API
    func postChangePasswordCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/change-password", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Provider Scheduling API
    func getProviderSchedulingDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/setting", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func setProviderTimeSlotDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/appointment-interval/set", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func addProviderLeaveDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/leave/add", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func editProviderLeaveDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/leave/edit", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func deleteProviderLeaveDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/leave/delete", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func addProviderSpecialRuleDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/special-rule/add", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func editProviderSpecialRuleDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/special-rule/edit", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func deleteProviderSpecialRuleDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/special-rule/delete", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func setProviderAvailabilityDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/availabilities/set", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Calendar & Agenda view API
    func getProviderAppointmentTimelineDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "provider/slots", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func getAgendaViewListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "list/appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func getReceivedRequestListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "list/appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Approve, Reject & Modify Appointment Request
    func acceptAppointmentRequestDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "approve/appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func rejectAppointmentRequestDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "cancel/appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Dashboard API Call
    func getProviderTodaysAppointmentListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "dash-today-provider-appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
                else {
                    onFailure()
                }
            }, onFailure: { () in
                onFailure()
            })
        }
    }
    
    func getProviderWaitingAppointmentListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "dash-waiting-provider-acceptance", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
                else {
                    onFailure()
                }
            }, onFailure: { () in
                onFailure()
            })
        }
    }
    
    func getPatientTodaysAppointmentListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "dash-today-patient-appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
                else {
                    onFailure()
                }
            }, onFailure: { () in
                onFailure()
            })
        }
    }
    
    func getPatientWaitingAppointmentListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "dash-waiting-patient-acceptance", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
                else {
                    onFailure()
                }
            }, onFailure: { () in
                onFailure()
            })
        }
    }
    
    // MARK: -  Review Section API Call
    func getReviewQuestionsListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "review/review-question-list", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func submitReviewDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "review/write-review", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func getPatientMyReviewsListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "reviews", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
                else {
                    onFailure()
                }
            }, onFailure: { () in
                onFailure()
            })
        }
    }
    
    func getProviderMyReviewsListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "reviews", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
                else {
                    onFailure()
                }
            }, onFailure: { () in
                onFailure()
            })
        }
    }
    
    func getReviewDetailDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "review/review-details", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Get Slide Menu counter
    func getPatientSlideMenuCounterDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/left-menu-count", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    func getProviderSlideMenuCounterDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/left-menu-count", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  Get CMS Pages List API Call
    func getCMSPageListDataCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingGET(filePath: "cms-page", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  View CategorySpeciality Call API
    func getCategorySpecialityCall_Completion(params: NSMutableDictionary?, strUserId:String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingGET(filePath: "category-speciality", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  View CategorySpeciality Call API
    func postSearchProviderFilterDetialCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        // self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
        AFAPICaller.shared.callAPIUsingPOSTforSearch(filePath: "search", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{() in
        
        })
    }
    
    func getProviderProfile_Completion(params: NSMutableDictionary?, strUserId:String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            var strGetParam = String()
            if (Global.kLoggedInUserData().IsLoggedIn == "1") {
                let strPatientId = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Id)
                strGetParam = String("provider/show/\(strUserId)/en/\(strPatientId!)")
            }else  {
                strGetParam = String("provider/show/\(strUserId)/en")
            }
            self.callAPIUsingGET(filePath: strGetParam , params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
                let nc = NotificationCenter.default
                nc.post(name: NSNotification.Name(rawValue: "ErroFailResponse"), object: nil)

            })
        }
    }
    
    
    // MARK: -  View Provider Patient Favorait Call API
    func sendPatientProviderFavoraiteCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/favorite-provider", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    
    // MARK: -  Patient Favorait Call API
   // "user/favorite-provider/add"
    
    func addProviderFavoraiteApi_Completion(strServiceName:String,params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: strServiceName, params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  View Provider Patient Favorait Call API
    func RemoveProviderFavoraiteApi_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "user/favorite-provider/remove", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  View ReasonList Call API
    func getReasonListCall_Completion(params: NSMutableDictionary?, strUserId:String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingGET(filePath: "appointment/reasons", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    
    // MARK: -  View Provider Patient Book AppointmentId Call API
    func PatientCreateAppointmentApi_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "book/appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    
    // MARK: -  View PatientProviderAppointmentDetial Call API
    func PatientProviderAppointmentDetialApi_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "view/appointment", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }
    
    // MARK: -  View Categories list of Blog Call API
    func getBlogCategoryListAPi_Complition(params: NSMutableDictionary?, strUserId:String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess),onFailure: @escaping (AFAPIMasterFailure)) {
        self.callAPIUsingGETForBlog(filePath: "categories", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
            else {
                onFailure()
            }
        }, onFailure:{ () in
            onFailure()
        })
    }
    
    // MARK: -  View MostViewedPost Call API
    func getBlogMostViewedPost_Complition(params: NSMutableDictionary?, struParameter:String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess),onFailure: @escaping (AFAPIMasterFailure)) {
        self.callAPIUsingGETForBlog(filePath:struParameter, params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
            else {
                onFailure()
            }
        }, onFailure:{ () in
            onFailure()
        })
    }
    
    // MARK: -  View MostViewedPost Call API
    func getCategoryDetailPost_Complition(params: NSMutableDictionary?, struParameter:String, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess),onFailure: @escaping (AFAPIMasterFailure)) {
        self.callAPIUsingGETForBlog(filePath:struParameter, params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            onFailure()

        })
    }
    
    
    // MARK: -  View  Patient Inbox Call API
    func patientInboxCall_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.checkOAuth2TokenIsExpired(viewObj: viewObj, boolIsOAuthCodeNeed: false) { (tokenData) in
            self.callAPIUsingPOST(filePath: "inbox-list", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
                if (success){
                    onSuccess(responseDict)
                }
            }, onFailure:{ () in
            })
        }
    }

    
  }
