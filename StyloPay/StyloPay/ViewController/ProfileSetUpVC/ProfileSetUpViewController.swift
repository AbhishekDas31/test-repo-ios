//
//  ProfileSetUpViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 16/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import DropDown

protocol UpdateProfileDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabOnOptionButton(isProfileUpdate: Bool)
    func tabOnRFIUpdateButton(data: [String:String])
}

class ProfileSetUpViewController: UIViewController {
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ProfileSetUpViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ProfileSetUpViewController
    }

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileTableView: UITableView!{
        didSet{
            profileTableView.delegate = self
            profileTableView.dataSource = self
        }
    }
    
    var complianceStatus = ""
    var mobileNumber = ""
    var walletUsername = ""
    var isdCode = ""
    var isAccepted = false
    var country = ""
    let theme = ThemeManager.currentTheme()
    let centeredDropDown = DropDown()
    let genderDropDown = DropDown()
    let nationalityDropDown = DropDown()
    let countryCodeDropDown = DropDown()
    let codeDropDown = DropDown()
    weak var delegate: UpdateProfileDelegate!
    var isUKAddress = false
    var isSameMailingAddress = false
    var isRFIRequest = false
    var personalInfo = PersonalnfoModel()
    var emailAddress = CustomUserDefaults.getEmailID()
    var password = ""//CustomUserDefaults.getPassword()
    var rfiData = RFIDetailsModel()
    let genderArr = ["MALE", "FEMALE", "OTHER"]
    let nationalityArr = ["SG","AU","DE","HK","IN","ID","JP","MY","KR","TW","TH","GB","US","VN"]
    let countryCodeArr = ["65","61","49","852","91","62","81","60","82","886","66","44","1","84"]
    let countryNameArr = ["Singapore","Australia","Germany","HongKong","India","Indonesia","Japan","Malaysia","South Korea","Taiwan","Thailand","United Kingdom","United States of America","Vietnam"]
    let countryFlagArr = ["singapore","australia","europe","hong-kong","india","indonesia","japan","malaysia","SKflag","taiwan","thailand","uk","usa","vietnam"]
    let codeArr = ["SGD","AUD","EUR","HKD","INR","IDR","JPY","MYR","KRW","TWD","THB","GBP","USD","VND"]
    
    lazy var dropDowns: [DropDown] = {
           return [
               self.centeredDropDown
           ]
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadButton.setTitle("CONTINUE", for: .normal)
        intialSetUp()
        if let password = KeychainService.loadPassword(service: service, account: account){
            self.password = password
        }
    }
    
    func intialSetUp() {
        self.personalInfo.mobileNumber = self.mobileNumber
        self.personalInfo.countryCode = self.isdCode.replacingOccurrences(of: "+", with: "")
        if !self.personalInfo.nationality.isEmpty {
            for index in 0..<nationalityArr.count {
                if nationalityArr[index] == self.personalInfo.nationality {
                    self.personalInfo.billingCountry = "\(self.countryNameArr[index])"
                    self.personalInfo.deliveryCountry = "\(self.countryNameArr[index])"
                    break
                }
            }
        }
        genderDropDown.dataSource = genderArr
        nationalityDropDown.dataSource = countryNameArr
        countryCodeDropDown.dataSource = countryCodeArr
        codeDropDown.dataSource = codeArr
        configureCell()
        configureTheme()
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        backButton.setImage(theme.backImage,for: .normal)
        uploadButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
    }
    
    func configureCell() {
        profileTableView.estimatedRowHeight = 60
        profileTableView.separatorStyle = .none
        profileTableView.separatorInset = UIEdgeInsets.zero
        profileTableView.sectionFooterHeight = 56
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.register(UINib(nibName: "PersonalInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalInfoTableViewCell")
        profileTableView.register(UINib(nibName: "AddressDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressDetailsTableViewCell")
        profileTableView.register(UINib(nibName: "SwitchButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchButtonTableViewCell")
        profileTableView.register(UINib(nibName: "RemittanceAddressDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "RemittanceAddressDetailTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func updateButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateProfileSetupScreen(form: self, data: personalInfo){
            if self.isAccepted {
                if isRFIRequest {
                    self.configureRFIProfileData()
                } else {
                    self.postWalletUserDetails()
                }
            } else {
                Global.showAlert(withMessage: "Please Accept Terms & Conditions", sender: self)
            }
            
        }
    }
    
    func configureRFIProfileData() {
        
        var rfiUpdateData = [String: String] ()
        if self.rfiData.rfiDescription == "firstName" {
            rfiUpdateData = ["rfiHashId": "\(rfiData.rfiHashId)", "\(self.rfiData.rfiDescription)":"\(self.personalInfo.firstName)"]
        } else if self.rfiData.rfiDescription == "lastName" {
            rfiUpdateData = ["rfiHashId": "\(rfiData.rfiHashId)", "\(self.rfiData.rfiDescription)":"\(self.personalInfo.lastName)"]
        } else if self.rfiData.rfiDescription == "middleName" {
            rfiUpdateData = ["rfiHashId": "\(rfiData.rfiHashId)", "\(self.rfiData.rfiDescription)":"\(self.personalInfo.middleName)"]
        } else if self.rfiData.rfiDescription == "preferredName" {
            rfiUpdateData = ["rfiHashId": "\(rfiData.rfiHashId)", "\(self.rfiData.rfiDescription)":"\(self.personalInfo.preferredName)"]
        } else if self.rfiData.rfiDescription == "dateOfBirth" {
            rfiUpdateData = ["rfiHashId": "\(rfiData.rfiHashId)", "\(self.rfiData.rfiDescription)":"\(self.personalInfo.dateOfBirth)"]
        } else if self.rfiData.rfiDescription == "mobileNumber" {
            rfiUpdateData = ["rfiHashId": "\(rfiData.rfiHashId)", "\(self.rfiData.rfiDescription)":"\(self.personalInfo.mobileNumber)"]
        } else if self.rfiData.rfiDescription.isEmpty || self.rfiData.rfiDescription == "all" {
            rfiUpdateData = ["rfiHashId": "\(rfiData.rfiHashId)", "deliveryAddress1": "\(self.personalInfo.deliveryAddress1)", "deliveryAddress2": "\(self.personalInfo.deliveryAddress2)", "deliveryCity": "\(self.personalInfo.deliveryCity)", "deliveryState": "\(self.personalInfo.deliveryState)", "deliveryZipCode": "\(self.personalInfo.deliveryZipCode)", "country": "\(self.personalInfo.nationality)", "billingAddress1": "\(self.personalInfo.deliveryAddress1)", "billingAddress2": "\(self.personalInfo.deliveryAddress2)", "billingCity": "\(self.personalInfo.deliveryCity)", "billingState": "\(self.personalInfo.deliveryState)", "billingZipCode": "\(self.personalInfo.deliveryZipCode)"]
        }
        if delegate != nil { delegate.tabOnRFIUpdateButton(data: rfiUpdateData)}
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProfileSetUpViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            if let profileInfoCell =  tableView.dequeueReusableCell(withIdentifier: "PersonalInfoTableViewCell", for: indexPath) as? PersonalInfoTableViewCell{
                if isRFIRequest {
                    profileInfoCell.configureRfiTextFields(remark: self.rfiData.remarks, data: self.personalInfo, description: self.rfiData.rfiDescription, isProfile: true)
                } else {
                    profileInfoCell.configureTextFields(data: personalInfo, isTextfieldEditable: true, isProfile: false)
                }
                profileInfoCell.firstNameTextField.delegate = self
                profileInfoCell.middleNameTextField.delegate = self
                profileInfoCell.lastNameTextField.delegate = self
                profileInfoCell.genderTextField.delegate = self
                profileInfoCell.birthDateTextField.delegate = self
                profileInfoCell.mobileNumberTextField.delegate = self
                if isRFIRequest {
                    if self.rfiData.rfiDescription == "dateOfBirth" {
                        profileInfoCell.dateOfBirthButton.addTarget(self, action: #selector(dateTap), for: .touchUpInside)
                    } else if self.rfiData.rfiDescription == "mobileNumber" {
                        profileInfoCell.countryCodeButton.addTarget(self, action: #selector(countryCodeTap), for: .touchUpInside)
                    }
                } else {
                    profileInfoCell.dateOfBirthButton.addTarget(self, action: #selector(dateTap), for: .touchUpInside)
                    profileInfoCell.countryCodeButton.addTarget(self, action: #selector(countryCodeTap), for: .touchUpInside)
                }
                
                return profileInfoCell
            }
        } else if indexPath.row == 1 {
            if let addressDetailsCell =  tableView.dequeueReusableCell(withIdentifier: "AddressDetailsTableViewCell", for: indexPath) as? AddressDetailsTableViewCell{
                if isRFIRequest {
                    if self.rfiData.rfiDescription.isEmpty || self.rfiData.rfiDescription == "address"{
                        self.rfiData.rfiDescription = "all"
                    }
                    addressDetailsCell.configureRFITextFields(row: indexPath.row, data: self.personalInfo, description: self.rfiData.rfiDescription, remark: self.rfiData.remarks)
                } else {
                    addressDetailsCell.configureTextFields(row: indexPath.row, data: personalInfo, isTextfieldEditable: true)
                }
                
                addressDetailsCell.landmarkTextField.delegate = self
                addressDetailsCell.firstAddressLineTextField.delegate = self
                addressDetailsCell.secondAddressLineTextField.delegate = self
                addressDetailsCell.cityTextField.delegate = self
                addressDetailsCell.statesTextField.delegate = self
                addressDetailsCell.zipcodeTextField.delegate = self
                if !self.isRFIRequest {
                    addressDetailsCell.countryButton.addTarget(self, action: #selector(nationalityTap), for: .touchUpInside)
                }
                return addressDetailsCell
            }
        } else {
            if let switchButtonCell =  tableView.dequeueReusableCell(withIdentifier: "SwitchButtonTableViewCell", for: indexPath) as? SwitchButtonTableViewCell{
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapPrivacyPolicy))
                switchButtonCell.tncLabel.addGestureRecognizer(tap)
                switchButtonCell.tncLabel.isUserInteractionEnabled = true
                switchButtonCell.delegate = self
                return switchButtonCell
            }
        }
        return UITableViewCell()
    }
    
    @objc func tapPrivacyPolicy(gesture: UITapGestureRecognizer) {
        let webViewVC = WebPageViewController.storyboardInstance()
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
}

extension ProfileSetUpViewController: UITextFieldDelegate{
    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
        let maxLength = 20
        let ACCEPTABLE_ALPHADIGITS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890- "
        let ACCEPTABLE_DIGITS = "1234567890"
        if textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4 {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

            // check characters
            guard newText.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return false }

            // check length
            guard newText.count <= maxLength else { return false }

            return true
        }else if textField.tag == 6 {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                } else if textField.text?.length ?? 0 > 19 {
                    return false
                } else {
                    let cs = NSCharacterSet(charactersIn: ACCEPTABLE_DIGITS).inverted
                    let filtered = string.components(separatedBy: cs).joined(separator: "")
                    return (string == filtered)
                }
            }
        } else if textField.tag == 8 || textField.tag == 9{
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }else if textField.text?.length ?? 0 > 19 {
                    return false
                }
            }
        } else if textField.tag == 10 || textField.tag == 11{
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }else if textField.text?.length ?? 0 > 39 {
                    return false
                }
            }
        } else if textField.tag == 12 {
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
        if textField.tag == 1 {
            self.personalInfo.firstName = textField.text!
        } else if textField.tag == 2 {
            self.personalInfo.middleName = textField.text!
        } else if textField.tag == 3 {
            self.personalInfo.lastName = textField.text!
        } else if textField.tag == 4 {
            self.personalInfo.preferredName = textField.text!
        } else if textField.tag == 5 {
            self.personalInfo.dateOfBirth = textField.text!
        }else if textField.tag == 6 {
            self.personalInfo.mobileNumber = textField.text!
        } else if textField.tag == 7 {
            //self.personalInfo.country = textField.text!
        } else if textField.tag == 8 {
            self.personalInfo.billingCity = textField.text!
            self.personalInfo.deliveryCity = textField.text!
        } else if textField.tag == 9 {
            self.personalInfo.billingState = textField.text!
            self.personalInfo.deliveryState = textField.text!
        } else if textField.tag == 10 {
            self.personalInfo.billingAddress1 = textField.text!
            self.personalInfo.deliveryAddress1 = textField.text!
        } else if textField.tag == 11 {
            self.personalInfo.billingAddress2 = textField.text!
            self.personalInfo.deliveryAddress2 = textField.text!
        } else if textField.tag == 12 {
            self.personalInfo.billingZipCode = textField.text!
            self.personalInfo.deliveryZipCode = textField.text!
        }
    }
    
    // MARK: - Nationality Button Action
    @objc func nationalityTap(_ sender: UIButton ){
        let countryCodeVC = CountryPopUpViewController.storyboardInstance()
        countryCodeVC.modalPresentationStyle = .overCurrentContext
//        countryCodeVC.countryNameArray = self.countryNameArr
//        countryCodeVC.countryFlagArray = self.countryFlagArr
        countryCodeVC.countryNameArray = countryList//self.countryNameArr
       // countryCodeVC.countryFlagArray = countryFlags//self.countryFlagArr
        countryCodeVC.delegate = self
        self.navigationController?.present(countryCodeVC, animated: true, completion: nil)
    }
    
    // MARK: - Country Code Button Action
    @objc func countryCodeTap(_ sender: UIButton ) {
        
        let indexPathh = IndexPath(row: 0, section: 0)
        if let cell: PersonalInfoTableViewCell = profileTableView.cellForRow(at: indexPathh) as? PersonalInfoTableViewCell {
            countryCodeDropDown.anchorView = cell.countryCodeButton
            countryCodeDropDown.direction = .bottom
            // Action triggered on selection
            countryCodeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                cell.countryCodeLabel.text = "+ \(self.countryCodeArr[index])"
                self.personalInfo.countryCode = "\(self.countryCodeArr[index])"
            }
            countryCodeDropDown.show()
        }
    }
    // MARK: - Code Button Action
    @objc func codeTap(_ sender: UIButton ) {
        let indexPathh = IndexPath(row: 1, section: 0)
        if let cell:RemittanceAddressDetailTableViewCell = profileTableView.cellForRow(at: indexPathh) as? RemittanceAddressDetailTableViewCell {
            codeDropDown.anchorView = cell.codeDropdownButton
            codeDropDown.direction = .bottom
            // Action triggered on selection
            codeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                cell.codeTextField.text = "\(self.codeArr[index])"
                self.personalInfo.code = "\(self.codeArr[index])"
            }
            codeDropDown.show()
        }
    }
    
    // MARK: - Date of Birth Button Action
    @objc func dateTap(_ sender: UIButton ){
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateTime: Date?
        if !personalInfo.dateOfBirth.isEmpty {
            currentDateTime = dateFormatter.date(from: personalInfo.dateOfBirth)
        } else {
            currentDateTime = Date()
        }
        let datePicker = ActionSheetDatePicker(title: "Select Date of Birth", datePickerMode: UIDatePicker.Mode.date, selectedDate: currentDateTime, doneBlock: { picker, value, index in
            let dateInFormat = dateFormatter.string(from: value as! Date)
            self.personalInfo.dateOfBirth = "\(dateInFormat)"
            if let cell = self.profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PersonalInfoTableViewCell{
                cell.birthDateTextField.text = "\(dateInFormat)"
            }
            let remittanceDate = dateInFormat.toDateString(inputDateFormat: "yyyy-MM-dd", ouputDateFormat: "dd/MM/yyy")
            self.personalInfo.remittanceDOB = "\(remittanceDate)"
            return
        }, cancel: { _ in return }, origin: self.view)
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        var cDate = Date()
        if personalInfo.dateOfBirth.isEmpty{
            cDate = currentDateTime!
        }
        let maxDate: Date = calendar.date(byAdding: components, to: cDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: cDate)!
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate
        if #available(iOS 14.0, *) {
            datePicker?.datePickerStyle = .automatic
        }
        //datePicker?. = .compact
        if #available(iOS 13.0, *) {
            datePicker?.toolbarButtonsColor = .label
            datePicker?.pickerBackgroundColor = .systemGray6
            datePicker?.toolbarBackgroundColor = .systemGray3
        }else {
           datePicker?.toolbarButtonsColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        datePicker?.show()
    }
}

extension ProfileSetUpViewController: ProfileSwitchActionDelegate,PermanentAddressActionDelegate, CountryCodeDelegate{
    func tabcheckBoxButton(cell: RemittanceAddressDetailTableViewCell) {
        print("RemittanceAddressDetailTableViewCell")
    }
    
    func tabCountryCode(country: String, row: Int) {
        let indexPathh = IndexPath(row: 1, section: 0)
        if let cell:AddressDetailsTableViewCell = profileTableView.cellForRow(at: indexPathh) as? AddressDetailsTableViewCell{
            cell.firstAddressLineTextField.text = "\(country)"
            CustomUserDefaults.setCountry(data: "\(country)")
            self.personalInfo.nationality = "\(isoCode2[row])"
            self.personalInfo.country = "\(isoCode2[row])"
            self.country = "\(isoCode2[row])"
            
            self.personalInfo.code = "\(isoCode3[row])"
        }
    }
    
    func tabCheckButton(cell: SwitchButtonTableViewCell) {
        if self.isAccepted {
            self.isAccepted = false
            cell.checkBoxButton.setBackgroundImage(theme.uncheckBoxColorImage, for: .normal)
        } else {
            self.isAccepted = true
            cell.checkBoxButton.setBackgroundImage(theme.checkBoxColorImage, for: .normal)
        }
    }
}

extension ProfileSetUpViewController {
    func postWalletUserDetails() {
        Alert.showProgressHud(onView: self.view)
        var strUrl = ""
        var isAuth = false
        let complianceStatus = CustomUserDefaults.getComplianceStatus()
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        if complianceStatus == "REJECT" || complianceStatus == "ERROR"{
            strUrl = "\(mainUrl)/api/v1/reInitiateKyc"
        }else{
            strUrl = "\(mainUrl)/api/v1/addCustomer"
        }
        
        if self.walletUsername.isEmpty{
            self.walletUsername = "\(emailAddress)"
        }
        //in username will be same as walletusername//
        var parameters : [String : Any] = [ "agent_code": "\(agentCode)","sub_agent_code": "\(subAgentCode)","client_agent_subAgent_name" : "\(clientAgentSubagentName)" ,"username": "\(self.walletUsername)", "firstName": "\(personalInfo.firstName)","lastName": "\(personalInfo.lastName)", "preferredName": "\(personalInfo.preferredName)", "dateOfBirth": "\(personalInfo.dateOfBirth)", "nationality": "\(personalInfo.nationality)", "countryCode": "\(personalInfo.nationality)", "country": "\(personalInfo.nationality)","email": "\(emailAddress)","mobile": "\(personalInfo.mobileNumber)", "deliveryAddress1": "\(personalInfo.deliveryAddress1)", "deliveryAddress2": "\(personalInfo.deliveryAddress2)", "deliveryCity": "\(personalInfo.deliveryCity)", "deliveryLandmark": "\(personalInfo.deliveryLandmark)", "deliveryState": "\(personalInfo.deliveryState)", "deliveryZipCode": "\(personalInfo.deliveryZipCode)", "billingAddress1": "\(personalInfo.billingAddress1)", "billingAddress2": "\(personalInfo.billingAddress2)", "billingCity": "\(personalInfo.billingCity)", "billingLandmark": "\(personalInfo.billingLandmark)", "billingState": "\(personalInfo.billingState)", "billingZipCode": "\(personalInfo.billingZipCode)", "correspondenceAddress1": "\(personalInfo.billingAddress1)", "correspondenceAddress2": "\(personalInfo.billingAddress2)", "correspondenceCity": "\(personalInfo.billingCity)", "correspondenceLandmark": "\(personalInfo.billingLandmark)", "correspondenceState": "\(personalInfo.billingState)", "correspondenceZipCode": "\(personalInfo.billingZipCode)", "address_line_1": "\(personalInfo.billingAddress1)", "address_line_2": "\(personalInfo.billingAddress2)", "preferred_currency": "SGD", "password": "\(password)", "city": "\(personalInfo.billingCity)", "phone_type": "M", "country_isd_code": "\(self.personalInfo.countryCode)"]
        //\(self.personalInfo.code)
        if !personalInfo.middleName.isEmpty {
            parameters.updateValue("\(personalInfo.middleName)", forKey: "middleName")
        }
        if complianceStatus == "REJECT" || complianceStatus == "ERROR"{
            parameters.updateValue(customerHashId, forKey: "customerHashId")
            isAuth = true
        }
        WebServices.postRequest(urlString: strUrl, paramDict: parameters as [String : Any], isWalletUser: true, isAuth: isAuth, xAPIKey: liveWalletXAPIKey, completionHandler: { (responseObject , stringResponse, error)  in
            if error == nil {
                if let response = responseObject {
                    if let errorMessage = response["message"] as? String {
                        Alert.hideProgressHud(onView: self.view)
                        Global.showAlert(withMessage: errorMessage)
                    } else {
                        if let error = response["error"] as? String{
                            if error == "invalid_token"{
                                self.getWalletAccessToken(isInvalid: true)
                            }
                        }else{
                            CustomUserDefaults.setFirstname(data: self.personalInfo.firstName)
                            CustomUserDefaults.setLastname(data: self.personalInfo.lastName)
                            CustomUserDefaults.setMiddlename(data: self.personalInfo.middleName)
                            
                            if let walletHashId = response["walletHashId"] as? String {
                                CustomUserDefaults.setwalletHashId(data: walletHashId)
                            }
                            
                            if let customerHashId = response["customerHashId"] as? String {
                                CustomUserDefaults.setCustomerHashId(data: customerHashId)
                            }
                            
                            self.getWalletAccessToken(isInvalid: false)
                        }
                    }
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                }  else {
                    Alert.hideProgressHud(onView: self.view)
                    if responseObject?["message"] != nil {
                        Global.showAlert(withMessage: "\(responseObject?["message"] ?? "Something Went Wrong")", sender: self)
                    }
                }
            } else {
                Alert.hideProgressHud(onView: self.view)
                let strError: String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)",sender: self)
            }
            //                self.postApiCreateRaasUser()
        })
    }
    
    func postAcceptTermsandConditions(customerHashId: String) {
        let strUrl = "\(mainUrl)/api/v1/acceptTermsAndCondition/\(customerHashId)"
        let parameters : [String : Any] = [ "accept":true, "name":"GENERALTNC", "versionId":"1.0"]
        
        WebServices.postRequest(urlString: strUrl, paramDict: parameters as [String : Any], isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey, completionHandler: { (responseObject , error, stringResponse)  in
            self.getAllCardsCustomerInfo()
        })
    }
    
    
    func getWalletAccessToken(isInvalid: Bool){
        AmplifyManager.getWalletAccessToken { (isSuccess,error) in
            if isSuccess ?? false{
                if isInvalid{
                    self.postWalletUserDetails()
                }else{
                    let customerHashId = CustomUserDefaults.getCustomerHashId()
                    self.postAcceptTermsandConditions(customerHashId: customerHashId)
                    
                }
            }else{
                if error == "Bad credentials"{
                    DispatchQueue.main.async {
                        Global.showAlert(withMessage: "Something Went Wrong", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                            debugPrint("Error Occurred")
                        })
                    }
                }
            }
        }
    }
    
    func getAllCardsCustomerInfo(){
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let url = "\(mainUrl)/api/v1/getCustomer/\(customerHashId)"
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject as? [String : Any]{
                    if let complianceStatus = response["complianceStatus"] as? String{
                        CustomUserDefaults.setComplianceStatus(data: complianceStatus)
                        self.complianceStatus = complianceStatus
                        DispatchQueue.main.async {
                            if complianceStatus == "REJECT" || complianceStatus == "ERROR"{
                                if self.delegate != nil { self.delegate.tabOnOptionButton(isProfileUpdate: false) }
                            }else{
                                if self.delegate != nil { self.delegate.tabOnOptionButton(isProfileUpdate: true) }
                            }
                            Global.showAlert(withMessage: "Profile Uploaded Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }else if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(isInvalid: false)
                        }
                    }else{
                        if let error =  responseObject?["message"] as? String {
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }
                } else {
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(isInvalid: false)
                        }
                    }else{
                        if let error =  responseObject?["message"] as? String {
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                //Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
}

extension ProfileSetUpViewController{
    
    func postApiCreateRaasUser(){
        let url = "\(liveBaseUrl)/RAAS/api/v1/clients/\(clientID)/customers"
        let parameters : [String: Any] = [ "email":"\(emailAddress)","countryCode": "\(personalInfo.nationality)",
            "accountType": "INDIVIDUAL","isTermConditionsAccepted": true,"authType":"BASIC"]
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: false, isAuth: false, xAPIKey: remittanceXApiKey, completionHandler: { (responseObject , stringResponse, error) in
            if error == nil {
                if let response = responseObject {
                    debugPrint("response postApiCreateRaasUser:  \(response)")
                    if let status = response["status"] as? String{
                        if status == "error"{
                            if let errorMessage = response["msg"] as? String{
                                Global.showAlert(withMessage: errorMessage)
                            }
                        }
                        self.postWalletUserDetails()
                    }else{
                       
                        if let accessToken = response["accessToken"] as? String{
                            CustomUserDefaults.setAccessToken(data: accessToken)
                        }
                        if let refreshToken = response["refreshToken"] as? String{
                            CustomUserDefaults.setRefreshToken(data: refreshToken)
                        }
                        if let customerId = response["customerId"] as? String{
                            CustomUserDefaults.setCustomerId(data: customerId)
                            self.postRaasUserProfile(customerID: customerId)
                        }
                    }
                    
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                } else {
                    if responseObject?["message"] != nil {
                        Global.showAlert(withMessage: "\(responseObject?["message"] ?? "Something Went Wrong")", sender: self)
                    }
                    self.postWalletUserDetails()
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
                self.postWalletUserDetails()
            }
        })
    }
    
    func postRaasUserProfile(customerID: String){
        
        let url = "\(liveBaseUrl)/RAAS/api/v1/clients/\(clientID)/customers/\(customerID)/details"
        let countryCode = Int(personalInfo.countryCode.trimmingCharacters(in: CharacterSet(charactersIn: "+"))) ?? 65
        let parameters : [String: Any] = [
            "firstName": "\(personalInfo.firstName)",
            "middleName": "\(personalInfo.middleName)",
            "lastName": "\(personalInfo.lastName)",
            "dateOfBirth": "\(personalInfo.remittanceDOB)",
            "intendedUseOfAccount": "25dc2051-990f-46a7-a49d-3f4c0f981c33",
            "nationality": "\(personalInfo.nationality)",
            "isPep": false,
            "netWorthValue": "56de9079-dfa5-4030-9f10-aed147638db6",
            "industryType": "960fb1d7-4661-44ec-9abe-8b684802c379",
            "mobileCountryCode": countryCode,
            "mobileNumber": "\(personalInfo.mobileNumber)",
            "postcode": "\(personalInfo.zipcode)",
            "streetName": "\(personalInfo.streetName)",
            "buildingName": "\(personalInfo.buildingName)",
            "unitNumber": "\(personalInfo.unitNumber)",
            "blockNumber": "\(personalInfo.blockNumber)",
            "floorNumber": "\(personalInfo.floorNumber)",
            "isPermanentSgResident": false
        ]
        
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: false, isAuth: true, xAPIKey: remittanceXApiKey, completionHandler: { (responseObject , stringResponse, error) in
            if error == nil {
                if let response = responseObject {
                    debugPrint("response postRaasUserProfile:  \(response)")
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                } else {
                    if responseObject?["message"] != nil {
                        debugPrint("strError:  \(responseObject?["message"] ?? "Something Went Wrong")")
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                debugPrint("strError:  \(strError)")
                //Global.showAlert(withMessage: "\(strError)", sender: self)
            }
            self.postWalletUserDetails()
        })
    }
}
