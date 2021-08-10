//
//  ProfileDetailsViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 05/08/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify

protocol ProfileDetailsDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabUpdateButton(isSuccess: Bool)
}

class ProfileDetailsViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ProfileDetailsViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ProfileDetailsViewController
    }
    
    @IBOutlet weak var profileDetailsTableView: UITableView!{
        didSet{
            profileDetailsTableView.delegate = self
            profileDetailsTableView.dataSource = self
        }
    }
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var updateButtonView: UIView!
    @IBOutlet weak var updateViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var updateButton: UIButton!
    
    let theme = ThemeManager.currentTheme()
    var index = 0
    weak var delegate: ProfileDetailsDelegate!
    var profileDetails = PersonalnfoModel()
    var isCorrespondence = false
    var isMailing = false
    var isBilling = false
    let complianceStatus = CustomUserDefaults.getComplianceStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
        moreOptionsButton.isHidden = true
        configureTheme()
        configureTitle()
    }
    
    func configureTitle(){
        if index == 0{
            screenTitleLabel.text = "PERSONAL DETAILS"
            updateButtonView.isHidden = true
            updateViewConstraint.constant = 0.0
        }else if index == 1{
            screenTitleLabel.text = "ADDRESS DETAILS"
            if self.complianceStatus == ComplianceStatusType.ACTION_REQUIRED.rawValue || self.complianceStatus == ComplianceStatusType.IN_PROGRESS.rawValue {
                updateButtonView.isHidden = false
            } else {
                updateButtonView.isHidden = true
            }
            
            updateViewConstraint.constant = 60.0
        }
    }
    
    func configureCell() {
        profileDetailsTableView.estimatedRowHeight = 80
        profileDetailsTableView.separatorStyle = .none
        profileDetailsTableView.separatorInset = UIEdgeInsets.zero
        profileDetailsTableView.sectionFooterHeight = 56
        profileDetailsTableView.rowHeight = UITableView.automaticDimension
        profileDetailsTableView.register(UINib(nibName: "PersonalInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalInfoTableViewCell")
        profileDetailsTableView.register(UINib(nibName: "RemittanceAddressDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "RemittanceAddressDetailTableViewCell")
        profileDetailsTableView.register(UINib(nibName: "AddressDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressDetailsTableViewCell")
        profileDetailsTableView.register(UINib(nibName: "MobileNoCell", bundle: nil), forCellReuseIdentifier: "mobileNoCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        backgroundImageView.isHidden = theme.backgroundImageHidden
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        manageCardButton.setImage(theme.selectedManageCardImage, for: .normal)
        updateButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        backButton.setImage(theme.backImage,for: .normal)
        
        let transferImage = AssetsImages.transferUnselected?.withRenderingMode(.alwaysTemplate)
        transferMoneyButton.setImage(transferImage, for: .normal)
        transferMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let exchangeImage =  AssetsImages.exchangeUnselected?.withRenderingMode(.alwaysTemplate)
        exchangeMoneyButton.setImage(exchangeImage, for: .normal)
        exchangeMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor

        
        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        //self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func manageMyCardButtonPressed(_ sender: Any) {
        let manageCardVC = ManageMyCardViewController.storyboardInstance()
        self.navigationController?.pushViewController(manageCardVC, animated: false)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let sendingOptionsVC = ReciverEmailViewController.storyboardInstance()//SendingOptionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(sendingOptionsVC, animated: false)
    }
    
    
    @IBAction func exchangeButtonPressed(_ sender: Any) {
        let homeVC = HomeViewController.storyboardInstance()
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    @IBAction func recentTransactionButtonPressed(_ sender: Any) {
        let recentTransactionVC = RecentTransactionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(recentTransactionVC, animated: false)
    }
    @IBAction func moreOptionButtonPressed(_ sender: Any) {
        let moreOptionVC = MoreOptionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(moreOptionVC, animated: false)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateProfileUpdateScreen(form: self, data: self.profileDetails){
            self.postUpdateUserDetails()
        }
    }
    
}

extension ProfileDetailsViewController: UITableViewDelegate, UITableViewDataSource, ProfileAddressActionDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 1{
            return 3
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if index == 0{
            if indexPath.row == 0 {
                if let personlDetailsCell =  tableView.dequeueReusableCell(withIdentifier: "PersonalInfoTableViewCell", for: indexPath) as? PersonalInfoTableViewCell{
                    personlDetailsCell.configureTextFields(data: self.profileDetails, isTextfieldEditable: false, isProfile: true , isfromProfileView: true)
                    return personlDetailsCell
                }
            }
            else {

                if let mobileNoCell =  tableView.dequeueReusableCell(withIdentifier: "mobileNoCell", for: indexPath) as? MobileNoCell{

                    mobileNoCell.configureView(CustomUserDefaults.getPhoneNumberVerified())
                    mobileNoCell.delegate = self

                    return mobileNoCell
                }
            }

        }
            else if index == 1{
            if let addressDetailsCell =  tableView.dequeueReusableCell(withIdentifier: "AddressDetailsTableViewCell", for: indexPath) as? AddressDetailsTableViewCell{
                if self.complianceStatus == ComplianceStatusType.ACTION_REQUIRED.rawValue || self.complianceStatus == ComplianceStatusType.IN_PROGRESS.rawValue {
                    addressDetailsCell.configureMyProfileTextFields(row: indexPath.row, data: self.profileDetails, isTextfieldEditable: true)
                } else {
                    addressDetailsCell.configureMyProfileTextFields(row: indexPath.row, data: self.profileDetails, isTextfieldEditable: false)
                }
                
                addressDetailsCell.configureView(isCorrespondence: self.isCorrespondence, isMailing: self.isMailing, isBilling: self.isBilling, row: indexPath.row)
                addressDetailsCell.landmarkTextField.delegate = self
                addressDetailsCell.delegate = self
                addressDetailsCell.firstAddressLineTextField.delegate = self
                addressDetailsCell.secondAddressLineTextField.delegate = self
                addressDetailsCell.cityTextField.delegate = self
                addressDetailsCell.statesTextField.delegate = self
                addressDetailsCell.zipcodeTextField.delegate = self
                return addressDetailsCell
            }
        }
        return UITableViewCell()
    }
    
    func tabDropdownButton(cell: AddressDetailsTableViewCell) {
        guard let index = self.profileDetailsTableView.indexPath(for: cell) else { return }
        switch index.row {
        case 0:
            self.isCorrespondence = !self.isCorrespondence
            self.isBilling = false
            self.isMailing = false
            break
        case 1:
            self.isCorrespondence = false
            self.isBilling = !self.isBilling
            self.isMailing = false
            break
        case 2:
            self.isCorrespondence = false
            self.isBilling = false
            self.isMailing = !self.isMailing
            break
        default:
            break
        }
        self.profileDetailsTableView.reloadData()
        self.profileDetailsTableView.scrollToRow(at: index, at: .top, animated: false)
    }
}

extension ProfileDetailsViewController: UITextFieldDelegate {
    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_ALPHADIGITS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890- "
        if textField.tag == 9 || textField.tag == 10 || textField.tag == 15 || textField.tag == 16 || textField.tag == 21 || textField.tag == 22{
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }else if textField.text?.length ?? 0 > 19 {
                    return false
                }
            }
        } else if textField.tag == 7 || textField.tag == 8 || textField.tag == 13 || textField.tag == 14 || textField.tag == 19 || textField.tag == 20 || textField.tag == 11 || textField.tag == 17 || textField.tag == 23{
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }else if textField.text?.length ?? 0 > 39 {
                    return false
                }
            }
        } else if textField.tag == 12 || textField.tag == 18 || textField.tag == 24{
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                } else if textField.text?.length ?? 0 > 9 {
                    return false
                } else {
                    let cs = NSCharacterSet(charactersIn: ACCEPTABLE_ALPHADIGITS).inverted
                    let filtered = string.components(separatedBy: cs).joined(separator: "")
                    return (string == filtered)
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 7 {
            self.profileDetails.correspondenceAddress1 = textField.text!
        } else if textField.tag == 8 {
            self.profileDetails.correspondenceAddress2 = textField.text!
        } else if textField.tag == 9 {
            self.profileDetails.correspondenceState = textField.text!
        } else if textField.tag == 10 {
            self.profileDetails.correspondenceCity = textField.text!
        } else if textField.tag == 11 {
            self.profileDetails.correspondenceLandmark = textField.text!
        } else if textField.tag == 12 {
            self.profileDetails.correspondenceZipCode = textField.text!
        } else if textField.tag == 13 {
            self.profileDetails.deliveryAddress1 = textField.text!
        } else if textField.tag == 14 {
            self.profileDetails.deliveryAddress2 = textField.text!
        } else if textField.tag == 15 {
            self.profileDetails.deliveryState = textField.text!
        } else if textField.tag == 16 {
            self.profileDetails.deliveryCity = textField.text!
        } else if textField.tag == 17 {
            self.profileDetails.deliveryLandmark = textField.text!
        } else if textField.tag == 18 {
            self.profileDetails.deliveryZipCode = textField.text!
        } else if textField.tag == 19 {
            self.profileDetails.billingAddress1 = textField.text!
        } else if textField.tag == 20 {
            self.profileDetails.billingAddress2 = textField.text!
        } else if textField.tag == 21 {
            self.profileDetails.billingState = textField.text!
        } else if textField.tag == 22 {
            self.profileDetails.billingCity = textField.text!
        } else if textField.tag == 23 {
            self.profileDetails.billingLandmark = textField.text!
        } else if textField.tag == 24 {
            self.profileDetails.billingZipCode = textField.text!
        }
    }
}

extension ProfileDetailsViewController {
    func postUpdateUserDetails() {
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
        var parameters : [String : Any] = [ "agent_code": "\(agentCode)","sub_agent_code": "\(subAgentCode)","client_agent_subAgent_name" : "\(clientAgentSubagentName)" ,"username": "\(walletUsername)","firstName": "\(self.profileDetails.firstName)","lastName": "\(self.profileDetails.lastName)","preferredName": "\(self.profileDetails.preferredName)","dateOfBirth": "\(self.profileDetails.dateOfBirth)","nationality": "\(self.profileDetails.nationality)","countryCode": "\(self.profileDetails.nationality)","country": "\(self.profileDetails.nationality)","email": "\(self.profileDetails.email)","mobile": "\(self.profileDetails.mobileNumber)", "deliveryAddress1": "\(self.profileDetails.deliveryAddress1)", "deliveryAddress2": "\(self.profileDetails.deliveryAddress2)", "deliveryCity": "\(self.profileDetails.deliveryCity)", "deliveryLandmark": "\(self.profileDetails.deliveryLandmark)", "deliveryState": "\(self.profileDetails.deliveryState)", "deliveryZipCode": "\(self.profileDetails.deliveryZipCode)", "billingAddress1": "\(self.profileDetails.billingAddress1)", "billingAddress2": "\(self.profileDetails.billingAddress2)", "billingCity": "\(self.profileDetails.billingCity)", "billingLandmark": "\(self.profileDetails.billingLandmark)", "billingState": "\(self.profileDetails.billingState)", "billingZipCode": "\(self.profileDetails.billingZipCode)", "correspondenceAddress1": "\(self.profileDetails.correspondenceAddress1)", "correspondenceAddress2": "\(self.profileDetails.correspondenceAddress2)", "correspondenceCity": "\(self.profileDetails.correspondenceCity)", "correspondenceLandmark": "\(self.profileDetails.correspondenceLandmark)", "correspondenceState": "\(self.profileDetails.correspondenceState)", "correspondenceZipCode": "\(self.profileDetails.correspondenceZipCode)", "address_line_1": "\(self.profileDetails.billingAddress1)", "address_line_2": "\(self.profileDetails.billingAddress2)", "preferred_currency": "\(self.profileDetails.code)", "password": "\(password)", "city": "\(self.profileDetails.billingCity)", "phone_type": "M", "country_isd_code": "\(self.profileDetails.countryCode)"]
        if !self.profileDetails.middleName.isEmpty {
            parameters.updateValue("\(self.profileDetails.middleName)", forKey: "middleName")
        }
        WebServices.postRequest(urlString: strUrl, paramDict: parameters as [String : Any], isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey, completionHandler: { (responseObject , stringResponse, error) in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject {
                    if let error = response["error"] as? String{
                        if error == "invalid_token"{
                            self.getWalletAccessToken()
                        }
                    }else{
                        print("\(response)")
                    }
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                } else {
                    if responseObject?["message"] != nil {
                        Global.showAlert(withMessage: "\(responseObject?["message"] ?? "Something Went Wrong")", sender: self)
                    }
                }
            } else {
                let strError: String =  (error?.localizedDescription)!
                if strError == "Response could not be serialized, input data was nil or zero length." {
                    Global.showAlert(withMessage: "Profile Updated Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                        if self.delegate != nil { self.delegate.tabUpdateButton(isSuccess: true)}
                    })
                } else{
                    Global.showAlert(withMessage: "\(strError)",sender: self)
                }
            }
        })
    }
    
    func getWalletAccessToken(){
        AmplifyManager.getWalletAccessToken { (isSuccess,error) in
            if isSuccess ?? false{
                self.postUpdateUserDetails()
            }else{
                Global.showAlert(withMessage: "Something Went Wrong!\nPlease try again later", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                    Constants.kAppDelegate?.setMainController(animated: true)
                })
            }
        }
    }
}

extension ProfileDetailsViewController:OpenAccountactivation,ActivateCardDetilsDelegate{
    func openAccountActivation() {

        // verify phone no
        Alert.showProgressHud(onView: self.view)
        Amplify.Auth.resendConfirmationCode(for: .phoneNumber) { result in
            switch result {
            case .success(let deliveryDetails):
                DispatchQueue.main.async {
                Alert.hideProgressHud(onView: self.view)
                    // open Otp PopUP
                    let activateCardVC = ActivateCardViewController.storyboardInstance()
                    activateCardVC.modalPresentationStyle = .overCurrentContext
                    activateCardVC.isOtp = true
                    activateCardVC.delegate = self
                    self.navigationController?.present(activateCardVC, animated: true, completion: nil)
                print("Resend code send to - \(deliveryDetails)")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                Alert.hideProgressHud(onView: self.view)
                Global.showAlert(withMessage: "\(error)",sender: self)
                }
            }
        }
    }

    func activateCardDetailsUpdate(lastDigits: String, cardHashId: String) {
        self.profileDetailsTableView.reloadData()
    }
}
