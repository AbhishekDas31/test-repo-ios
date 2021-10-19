//
//  UpdateMailingAddressVC.swift
//  StyloPay
//
//  Created by Abhishek das on 22/09/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//
import UIKit
import Amplify
import Foundation

class UpdateMailingAddressVC: UIViewController, UITextFieldDelegate{


static func storyboardInstance() -> UpdateMailingAddressVC {
    return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! UpdateMailingAddressVC
}
    
    @IBOutlet  var mainView: UIView!
    
    @IBOutlet var dAdd:UITextField!
 
    @IBOutlet var Update: UIButton!
    @IBOutlet var deliveryAddress2: UITextField!
    @IBOutlet var deliveryCity: UITextField!
    @IBOutlet var deliveryLandmark: UITextField!
    @IBOutlet var deliveryState: UITextField!
    @IBOutlet var deliveryPinCode: UITextField!
    
    @IBOutlet var backButton: UIButton!
    let theme = ThemeManager.currentTheme()
    let color = #colorLiteral(red: 0.3607498705, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    var deliveryAdd1 = ""
    var deliveryAdd2 = ""
    var delCity = ""
    var delLndMark = ""
    var delSt = ""
    var delPinCde = ""
    var complianceStatus = ""
    let nationalityArr = ["SG","AU","DE","HK","IN","ID","JP","MY","KR","TW","TH","GB","US","VN"]
    let codeArr = ["SGD","AUD","EUR","HKD","INR","IDR","JPY","MYR","KRW","TWD","THB","GBP","USD","VND"]
    let countryCodeArr = ["65","61","49","852","91","62","81","60","82","886","66","44","1","84"]
    var profileDetails = PersonalnfoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
     
    }
    
    
    
    func configureTextField(data: PersonalnfoModel, isTextfieldEditable: Bool){
        deliveryAdd1 = "\(data.deliveryAddress1)"
        deliveryAdd2 = "\(data.deliveryAddress2)"
        delCity = "\(data.deliveryCity)"
        delLndMark = "\(data.deliveryLandmark)"
        delSt = "\(data.deliveryState)"
        delPinCde = "\(data.deliveryZipCode)"

  
        
    }
    
    
    
    func configureController(){
        let color = theme.bottomUnselectedTabButtonColor
        self.navigationController?.navigationBar.isHidden = true
        self.dAdd.keyboardType = .default
        self.dAdd.placeholder = "DELIVERY ADDRESS 1"
        dAdd.attributedPlaceholder = NSAttributedString(string: dAdd.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.dAdd.text = deliveryAdd1
        self.dAdd.isUserInteractionEnabled = true
        self.dAdd.isSecureTextEntry = false
        dAdd.tag = 1
        
        
    
        self.deliveryAddress2.keyboardType = .default
        self.deliveryAddress2.placeholder = "Delivery Address 2"
        self.deliveryAddress2.text = deliveryAdd2
        deliveryAddress2.attributedPlaceholder =  NSAttributedString(string: deliveryAddress2.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.deliveryAddress2.isUserInteractionEnabled = true
        self.deliveryAddress2.isSecureTextEntry = false
        deliveryAddress2.tag = 2

        
        self.deliveryCity.keyboardType = .default
        self.deliveryCity.placeholder = "Delivery City"
        self.deliveryCity.text = delCity
        deliveryCity.attributedPlaceholder =  NSAttributedString(string: deliveryCity.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.deliveryCity.isUserInteractionEnabled = true
        self.deliveryCity.isSecureTextEntry = false
        deliveryCity.tag = 3
        
        self.deliveryLandmark.keyboardType = .default
        self.deliveryLandmark.placeholder = "Delivery Landmark"
        self.deliveryLandmark.text = delLndMark
        deliveryLandmark.attributedPlaceholder =  NSAttributedString(string: deliveryLandmark.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.deliveryLandmark.isUserInteractionEnabled = true
        self.deliveryLandmark.isSecureTextEntry = false
        deliveryLandmark.tag = 4
        
        
        self.deliveryState.keyboardType = .default
        self.deliveryState.placeholder = "Delivery State"
        self.deliveryState.text = delSt
        deliveryState.attributedPlaceholder =  NSAttributedString(string: deliveryState.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.deliveryState.isUserInteractionEnabled = true
        self.deliveryState.isSecureTextEntry = false
        deliveryState.tag = 5
        
        
        
        self.deliveryPinCode.keyboardType = .numbersAndPunctuation
        self.deliveryPinCode.placeholder = "Delivery PIN CODE"
        self.deliveryPinCode.text = delPinCde
        deliveryPinCode.attributedPlaceholder =  NSAttributedString(string: deliveryPinCode.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.deliveryPinCode.isUserInteractionEnabled = true
        self.deliveryPinCode.isSecureTextEntry = false
        deliveryPinCode.tag = 6
        
        
        
          dAdd.delegate = self
          deliveryAddress2.delegate = self
          deliveryCity.delegate = self
          deliveryLandmark.delegate = self
          deliveryState.delegate = self
          deliveryPinCode.delegate = self
        
//        registerButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
//        signInButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
//    var  dAdd1 = ""
//    var dAdd2 = ""
//    var  dCity = ""
//    var dLndMark = ""
//    var dSt = ""
//    var dPinCde = ""
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.dAdd {
            deliveryAdd1 = textField.text!
            debugPrint(deliveryAdd1)
        } else if textField == self.deliveryAddress2 {
            deliveryAdd2 = textField.text!
        } else if textField == self.deliveryCity {
            delCity = textField.text!
        } else if textField == self.deliveryLandmark {
           delLndMark = textField.text!
        } else if textField == self.deliveryState {
            delSt = textField.text!
        }
        else if textField == self.deliveryPinCode {
            delPinCde = textField.text!
        }
    }
    
    
    
    @IBAction func bakButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        
        self.view.endEditing(true)
            Alert.showProgressHud(onView: self.view)
            _ = CustomUserDefaults.getComplianceStatus()
            let customerHashId = CustomUserDefaults.getCustomerHashId()
            let strUrl = "\(mainUrl)/api/v1/updateCustomer/\(customerHashId)"
            let password = KeychainService.loadPassword(service: service, account: account) ?? ""
            var walletUsername = ""
            if CustomUserDefaults.getEmailID().isEmpty {
                walletUsername = "\(self.profileDetails.email)"
            } else {
                walletUsername = CustomUserDefaults.getEmailID()
            }
        let parameters : [String : Any] = [ "agent_code": "\(agentCode)","sub_agent_code": "\(subAgentCode)","client_agent_subAgent_name" : "\(clientAgentSubagentName)" ,"username": "\(walletUsername)", "deliveryAddress1": "\(deliveryAdd1)", "deliveryAddress2": "\(deliveryAdd2)", "deliveryCity": "\(delCity)", "deliveryLandmark": "\(delLndMark)", "deliveryState": "\(delSt)", "deliveryZipCode": "\(delPinCde)"]
            
            WebServices.postRequest(urlString: strUrl, paramDict: parameters as [String : Any], isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey, completionHandler: { (responseObject , stringResponse, error) in
                Alert.hideProgressHud(onView: self.view)
                if error == nil {
                    if let response = responseObject {
                        if let error = response["error"] as? String{
                            if error == "invalid_token"{
                                self.getWalletAccessToken()
                            }
                        }else if let msg = response["message"] as? String{
                            if msg == "Customer Updated Successfully!"{
                            debugPrint(msg)
                               
                                Global.showAlert(withMessage: "Profile Updated Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler:{ (action) in
    //                                if self.delegate != nil { self.delegate.tabUpdateButton(isSuccess: true)}
//                                    let profileDetails = ProfileViewController.storyboardInstance()
//                                    profileDetails.getCustomerInfo()
                                    self.getCustomerInfo()
                                    
                                })
                            }else{
                                Global.showAlert(withMessage: "\(msg)",sender: self)
                            }

                        }
                    } else if let errorString = stringResponse {
                        Alert.hideProgressHud(onView: self.view)
                        Global.showAlert(withMessage: "\(errorString)", sender: self)
                    }
                }
                
//                else {
//                    let strError: String =  (error?.localizedDescription)!
//                    if strError == "Response could not be serialized, input data was nil or zero length." {
//                        Global.showAlert(withMessage: "Profile Updated Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
//                            //if self.delegate != nil { self.delegate.tabUpdateButton(isSuccess: true)}
//                        })
//                    } else{
//                        Global.showAlert(withMessage: "\(strError)",sender: self)
//                    }
//                }
            })
        }
    
    
    
    
    
    
   // func postUpdateMailingAddress()
    
    func getCustomerInfo(){
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let url = "\(mainUrl)/api/v1/getCustomer/\(customerHashId)"
        Alert.showProgressHud(onView: self.view)
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject as? [String : Any]{
                    debugPrint("response:  \(response)")
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            AmplifyManager.getWalletAccessToken{(isSuccess, error) in
                                debugPrint(isSuccess ?? false)
                            }
                        }
                    }else{
                        if let error =  responseObject?["message"] as? String {
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }
                    if let complianceStatus = response["complianceStatus"] as? String{
                        CustomUserDefaults.setComplianceStatus(data: complianceStatus)
                        self.complianceStatus = complianceStatus
                        let profiledata = PersonalnfoModel(response)
                        debugPrint(profiledata)
                        let profileDetails = ProfileDetailsViewController.storyboardInstance()
                        profileDetails.profileDetails = profiledata
                        for index in 0..<self.nationalityArr.count{
                            if self.nationalityArr[index] == "\(self.profileDetails.nationality)" {
                                self.profileDetails.code = "\(self.codeArr[index])"
                                self.profileDetails.countryCode = "\(self.countryCodeArr[index])"
                                
                            }
                            
                            
                        }
                        
                        
                        
                       
                        //profileDetails.getCustomerInfo()
                        profileDetails.index = 1
                        self.navigationController?.pushViewController(profileDetails, animated: true)
                        
//                        if self.isUpdate{
//
//                                let profileDetailsVC = ProfileDetailsViewController.storyboardInstance()
//                                profileDetailsVC.index = 1
//                                profileDetailsVC.profileDetails = self.profileDetails
//                                self.navigationController?.pushViewController(profileDetailsVC, animated: false)
//
//
//                        }
                    }
                    if CustomUserDefaults.getIsdCode() == ""{
                        if let isoCode = response["countryCode"] as? String
                        {
                            let index = isoCode2.indexes(of: isoCode)
                            if index.count == 1 {
                                self.awsUpdateSync(isdCode: "\(countryCodeList[index[0]])", mobileNumber: response["mobile"] as? String ?? "")
                                
                            }
                        }
                    }
                } else {
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            AmplifyManager.getWalletAccessToken{(isSuccess, error) in
                                debugPrint(isSuccess ?? false)
                            }
                        }
                    }else{
                        if let error =  responseObject?["message"] as? String {
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                debugPrint(strError)
            }
        }
    }

    func awsUpdateSync(isdCode:String,mobileNumber:String){
        Alert.showProgressHud(onView: self.view)
        Amplify.Auth.update(userAttributes: [AuthUserAttribute(.phoneNumber, value: "+\(isdCode)\(mobileNumber)"),AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:isd_code"), value: "+\(isdCode)"),], options: .none) { result in
            switch result {
            case .success:
                self.fetchUserAttributes()
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(error.errorDescription)", sender: self)
                }
            }
        }
    }

    func fetchUserAttributes() {
        _ = Amplify.Auth.fetchUserAttributes { result in
            switch result {
            case .success(let session):
                var dataDictionary: [String: Any] = [:]
                for items in session{
                    dataDictionary.updateValue(items.value, forKey: "\(items.key.rawValue)")
                }
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: self.view)
                    self.authoriseHandling(isdCode: dataDictionary["custom:isd_code"] as? String ?? "", mobileNumber: dataDictionary["phone_number"] as? String ?? "",phone_number_verified: dataDictionary["phone_number_verified"] as? String ?? "false")
                    //phone_number_verified

                }

            case .failure( _):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: self.view)
                }
            }
        }
    }

    func authoriseHandling(isdCode: String, mobileNumber: String , phone_number_verified:String)
    {
        let isdCodeLength = isdCode.length
        let isdCodeValue = String(isdCode.dropFirst())
        let phoneNumber = String(mobileNumber.dropFirst(isdCodeLength))
        CustomUserDefaults.setMobileNumber(data: phoneNumber)
        CustomUserDefaults.setPhoneNumberVerified(data:phone_number_verified != "false")
        CustomUserDefaults.setIsdCode(data: isdCodeValue)
    }

    
    
    
    
    
    
    
    
    
    
    
    func getWalletAccessToken(){
        AmplifyManager.getWalletAccessToken { (isSuccess,error) in
            if isSuccess ?? false{
                self.updateButtonPressed(self)
            }else{
                Global.showAlert(withMessage: "Something Went Wrong!\nPlease try again later", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                    Constants.kAppDelegate?.setMainController(animated: true)
                })
            }
        }
    }
    
}
