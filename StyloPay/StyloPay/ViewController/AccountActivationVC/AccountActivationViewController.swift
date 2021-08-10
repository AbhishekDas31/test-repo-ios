//
//  AccountActivationViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 16/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import LocalAuthentication


class AccountActivationViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> AccountActivationViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! AccountActivationViewController
    }
    @IBOutlet weak var accountVerificationTableView: UITableView!{
        didSet{
            accountVerificationTableView.delegate = self
            accountVerificationTableView.dataSource = self
        }
    }
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainViewBackgroundImageView: UIImageView!
   // @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenSubtitleLabel: UILabel!
    @IBOutlet weak var subheadingLabel: UILabel!
//    @IBOutlet weak var acceptLabel: UILabel!
//    @IBOutlet weak var tncLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var complianceStatus = CustomUserDefaults.getComplianceStatus()
    var mobileNumber = CustomUserDefaults.getMobileNumber()
    var walletUserName = CustomUserDefaults.getEmailID()
    var isdCode = CustomUserDefaults.getIsdCode()
    let theme = ThemeManager.currentTheme()
    var idRfiHashId = ""
    var selfieRfiHashId = ""
    var profileRfiHashId = ""
    var addressRfiHashID = ""
    var requestDataArray = [[String: Any]]()
    var subrequestDataArray = [[String: Any]]()
    var isPOI = false
    var isPOA = false
    var isSelfie = false
    var rfiDetailsArray = [RFIDetailsModel]()
    var profileDetails = PersonalnfoModel()
    var profileRFIData = [String: String]()
    var accountVerificationDataArray = [["title": "PROFILE DETAILS", "subtitle":"THIS HELPS US SERVE YOU BETTER.\nYOUR DATA IS ENCRYPTED AND\nCONFIDENTIAL WITH US", "isTrackVisible":true, "isDataUploaded":false, "screenType": ProofScreenType.PROFILE],["title": "ID PROOF", "subtitle":"PASSPORT OR ANY GOVERNMENT\nAPPROVED ID", "isTrackVisible":true, "isDataUploaded":false, "screenType": ProofScreenType.ID ],["title": "SELFIE WITH ID", "subtitle":"SMILE AND LET'S GIVE A NICE\nSELFIE WITH YOUR ID", "isTrackVisible":true, "isDataUploaded":false, "screenType": ProofScreenType.SELFIE],["title": "ADDRESS PROOF", "subtitle":"ANY GOVERNMENT UTILITY BILL\nSUCH AS TAX RECIEPT", "isTrackVisible":true, "isDataUploaded":false, "screenType": ProofScreenType.ADDRESS],["title": "ENABLE FINGER PRINT AUTHENTICATION", "subtitle":"THIS HELPS US SERVE YOU BETTER.\nYOUR DATA IS ENCRYPTED AND CONFIDENTIAL WITH US.", "isTrackVisible":false, "isDataUploaded":false, "screenType": ProofScreenType.AUTH]]
    var isTermsAndConditionsAccepted = false
    var proofsDataModelArray = [ProofsModel]()
    let nationalityArr = ["SG","AU","DE","HK","IN","ID","JP","MY","KR","TW","TH","GB","US","VN"]
    let countryNameArr = ["Singapore","Australia","Germany","HongKong","India","Indonesia","Japan","Malaysia","South Korea","Taiwan","Thailand","United Kingdom","United States of America","Vietnam"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
        configureTheme()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPrivacyPolicy))
//        self.tncLabel.addGestureRecognizer(tap)
//        self.tncLabel.isUserInteractionEnabled = true
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainViewBackgroundImageView.isHidden = theme.backgroundImageHidden
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        screenSubtitleLabel.textColor = theme.bottomSelectedTabButtonColor
        subheadingLabel.textColor = theme.bottomSelectedTabButtonColor
//        acceptLabel.textColor = theme.bottomUnselectedTabButtonColor
//        tncLabel.textColor = theme.bottomSelectedTabButtonColor
        doneButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        skipButton.setBackgroundImage(theme.borderColorImage, for: .normal)
        skipButton.setTitleColor(theme.bottomUnselectedTabButtonColor, for: .normal)
        //checkBoxButton.setBackgroundImage(theme.uncheckBoxColorImage, for: .normal)
        self.accountVerificationDataArray[4]["isDataUploaded"] = CustomUserDefaults.getisAuth()
        let profileUploaded = self.accountVerificationDataArray[0]["isDataUploaded"] as? Bool ?? false
        let idUploaded = self.accountVerificationDataArray[1]["isDataUploaded"] as? Bool ?? false
        let selfieIDUploaded = self.accountVerificationDataArray[2]["isDataUploaded"] as? Bool ?? false
        let addressUploaded = self.accountVerificationDataArray[3]["isDataUploaded"] as? Bool ?? false
        let authntication = self.accountVerificationDataArray[4]["isDataUploaded"] as? Bool ?? false
        if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue {
            if profileUploaded && idUploaded && selfieIDUploaded && addressUploaded && authntication {
               // self.doneButton.isEnabled = true
            } else {
                //self.doneButton.isEnabled = false
            }
        } else {
            if idUploaded && selfieIDUploaded && addressUploaded && authntication{
              //  self.doneButton.isEnabled = true
            } else {
              //  self.doneButton.isEnabled = false
            }
        }
    }
    
    func configureCell() {
        accountVerificationTableView.estimatedRowHeight = 60
        accountVerificationTableView.separatorStyle = .none
        accountVerificationTableView.separatorInset = UIEdgeInsets.zero
        accountVerificationTableView.sectionFooterHeight = 56
        accountVerificationTableView.rowHeight = UITableView.automaticDimension
        accountVerificationTableView.register(UINib(nibName: "AccountActivationTableViewCell", bundle: nil),forCellReuseIdentifier: "AccountActivationTableViewCell")
        accountVerificationTableView.register(UINib(nibName: "SIngleLabelCell", bundle: nil),forCellReuseIdentifier: "SIngleLabelCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func tapPrivacyPolicy(gesture: UITapGestureRecognizer) {
        let webViewVC = WebPageViewController.storyboardInstance()
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    @IBAction func checkBoxButtonPressed(_ sender: Any) {
        if isTermsAndConditionsAccepted{
            isTermsAndConditionsAccepted = false
           // checkBoxButton.setBackgroundImage(theme.uncheckBoxColorImage, for: .normal)
        }else{
            isTermsAndConditionsAccepted = true
           // checkBoxButton.setBackgroundImage(theme.checkBoxColorImage, for: .normal)
        }
    }
    
    @IBAction func doneUpdatingButtonPressed(_ sender: Any) {
        if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue{
            self.configureRFIData()
        }else{
            self.configureData()
        }
        let profileUploaded = self.accountVerificationDataArray[0]["isDataUploaded"] as? Bool ?? false
        let idUploaded = self.accountVerificationDataArray[1]["isDataUploaded"] as? Bool ?? false
        let selfieIDUploaded = self.accountVerificationDataArray[2]["isDataUploaded"] as? Bool ?? false
        let addressUploaded = self.accountVerificationDataArray[3]["isDataUploaded"] as? Bool ?? false
        let authentication = CustomUserDefaults.getisAuth()
        if profileUploaded && idUploaded && selfieIDUploaded && addressUploaded && authentication{
            self.uploadWalletKYCDocuments()
        }else{
            Global.showAlert(withMessage: "Please upload all the required Documents.", sender: self)
        }
    }
    
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        Constants.kAppDelegate?.setMainController()
    }
}

extension AccountActivationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountVerificationDataArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != accountVerificationDataArray.count
        {
            if let accountVerificationCell =  tableView.dequeueReusableCell(withIdentifier: "AccountActivationTableViewCell", for: indexPath) as? AccountActivationTableViewCell{
                let data = self.accountVerificationDataArray[indexPath.row]
                accountVerificationCell.configureRow(data: data, row :indexPath.row)
                return accountVerificationCell
            }
            return UITableViewCell()
        }
        else {
            if let cell =  tableView.dequeueReusableCell(withIdentifier: "SIngleLabelCell", for: indexPath) as? SIngleLabelCell{

                return cell
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != accountVerificationDataArray.count
        {
        let status = CustomUserDefaults.getComplianceStatus()
        if status == ComplianceStatusType.RFI_REQUESTED.rawValue {
            if indexPath.row == 0 {
                for items in self.rfiDetailsArray {
                    if items.type != "document"{
                        let profileSetUpVC = ProfileSetUpViewController.storyboardInstance()
                        profileSetUpVC.delegate = self
                        profileSetUpVC.personalInfo = self.profileDetails
                        profileSetUpVC.rfiData = items
                        profileSetUpVC.walletUsername = self.walletUserName
                        profileSetUpVC.mobileNumber = self.mobileNumber
                        profileSetUpVC.isdCode = self.isdCode
                        profileSetUpVC.isRFIRequest =  true
                        if let dataUploaded = self.accountVerificationDataArray[indexPath.row]["isDataUploaded"] as? Bool{
                            if !dataUploaded {
                                self.navigationController?.pushViewController(profileSetUpVC, animated: true)
                            }
                        }
                        break
                    }
                }
            } else {
                for items in self.rfiDetailsArray {
                    let documenttype = items.documentType.lowercased()
                    let discription = items.rfiDescription.lowercased()
                    if items.type == "document" {
                        if indexPath.row == 1 {
                            if documenttype == "poi" && discription != "selfiewithid"{
                                let proofVC = ProofViewController.storyboardInstance()
                                proofVC.screenTitle = "ID PROOF"
                                proofVC.screenType = self.accountVerificationDataArray[indexPath.row]["screenType"] as? String ?? ""
                                proofVC.screenID = indexPath.row
                                proofVC.delegate = self
                                proofVC.rfiData = items
                                proofVC.isRFI = true
                                proofVC.screenType = ProofScreenType.ID.rawValue
                                if !self.proofsDataModelArray.isEmpty{
                                    proofVC.proofsDataModelObj = self.proofsDataModelArray[0]
                                }
                                if let dataUploaded = self.accountVerificationDataArray[indexPath.row]["isDataUploaded"] as? Bool{
                                    if !dataUploaded {
                                        self.navigationController?.pushViewController(proofVC, animated: true)
                                    }
                                }
                                break
                            }
                        } else if indexPath.row == 2 {
                            if  documenttype == "poi" && discription == "selfiewithid" {
                                let proofVC = ProofViewController.storyboardInstance()
                                proofVC.screenTitle = "SELFIE WITH ID"
                                proofVC.screenType = self.accountVerificationDataArray[indexPath.row]["screenType"] as? String ?? ""
                                proofVC.screenID = indexPath.row
                                proofVC.delegate = self
                                proofVC.rfiData = items
                                proofVC.isRFI = true
                                proofVC.screenType = ProofScreenType.SELFIE.rawValue
                                if !self.proofsDataModelArray.isEmpty{
                                    proofVC.proofsDataModelObj = self.proofsDataModelArray[0]
                                }
                                if let dataUploaded = self.accountVerificationDataArray[indexPath.row]["isDataUploaded"] as? Bool{
                                    if !dataUploaded {
                                        self.navigationController?.pushViewController(proofVC, animated: true)
                                    }
                                }
                                break
                            }
                        } else if indexPath.row == 3 {
                            if documenttype == "poa" {
                                let proofVC = AddressProofViewController.storyboardInstance()
                                proofVC.screenType = self.accountVerificationDataArray[indexPath.row]["screenType"] as? String ?? ""
                                proofVC.screenID = indexPath.row
                                proofVC.screenType = ProofScreenType.ADDRESS.rawValue
                                let firstname = CustomUserDefaults.getFirstname()
                                let lastname = CustomUserDefaults.getLastname()
                                proofVC.proofsDataModelObj.identificationDocHolderName = "\(firstname) \(lastname)"
                                proofVC.rfiData = items
                                proofVC.isRfi = true
                                proofVC.proofsDataModelObjArray = self.proofsDataModelArray
                                proofVC.delegate = self
                                if let dataUploaded = self.accountVerificationDataArray[indexPath.row]["isDataUploaded"] as? Bool{
                                    if !dataUploaded {
                                        self.navigationController?.pushViewController(proofVC, animated: true)
                                    }
                                }
                                break
                            }
                        }
                        else if indexPath.row == 4 {
                           if !CustomUserDefaults.getisAuth(){
                                    self.authenticationWithTouchID()
                                    // finege

                            }
                        }
                    }
                }
            }
        } else {
            if indexPath.row == 0{
                if let isDataUploaded = self.accountVerificationDataArray[indexPath.row]["isDataUploaded"] as? Bool{
                    if !isDataUploaded{
                        let profileSetUpVC = ProfileSetUpViewController.storyboardInstance()
                        profileSetUpVC.delegate = self
                        profileSetUpVC.mobileNumber = self.mobileNumber
                        profileSetUpVC.isdCode = self.isdCode
                        profileSetUpVC.walletUsername = self.walletUserName
                        profileSetUpVC.isRFIRequest = false
                        self.navigationController?.pushViewController(profileSetUpVC, animated: true)
                    }
                    
                }
                
            }
            else if indexPath.row == 4 {
                //finger
                if  !CustomUserDefaults.getisAuth(){

                    self.authenticationWithTouchID()
                    // fineger
                }
        }
            else if indexPath.row == 3{
                if let isDataUploaded = self.accountVerificationDataArray[indexPath.row-1]["isDataUploaded"] as? Bool,let isCurrentDataUploaded = self.accountVerificationDataArray[indexPath.row]["isDataUploaded"] as? Bool{
                    if isDataUploaded && !isCurrentDataUploaded && status != "sCT"{
                        let proofVC = AddressProofViewController.storyboardInstance()
                        proofVC.screenType = self.accountVerificationDataArray[indexPath.row]["screenType"] as? String ?? ""
                        proofVC.screenID = indexPath.row
                        proofVC.screenType = ProofScreenType.ADDRESS.rawValue
                        print(self.proofsDataModelArray.count)
                        let firstname = CustomUserDefaults.getFirstname()
                        let lastname = CustomUserDefaults.getLastname()
                        if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue {
                            proofVC.proofsDataModelObj.identificationDocHolderName = "\(firstname) \(lastname)"
                        }else{
                            proofVC.proofsDataModelObj.identificationDocHolderName = self.proofsDataModelArray[indexPath.row - 2].identificationDocHolderName
                            proofVC.proofsDataModelObj.identificationDocIssuanceCountry = self.proofsDataModelArray[indexPath.row - 2].identificationDocIssuanceCountry
                        }
                        proofVC.proofsDataModelObjArray = self.proofsDataModelArray
                        proofVC.delegate = self
                        self.navigationController?.pushViewController(proofVC, animated: true)
                    } else if !isDataUploaded && !isCurrentDataUploaded && status != "REJECT" && status != "ERROR" {
                        let title = self.accountVerificationDataArray[indexPath.row-1]["title"] as? String ?? ""
                        Global.showAlert(withMessage: "Please add \(title) first", sender: self)
                    }
                } else {
                    let title = self.accountVerificationDataArray[indexPath.row-1]["title"] as? String ?? ""
                    Global.showAlert(withMessage: "Please add \(title) first", sender: self)
                }
            }else{
                if let isDataUploaded = self.accountVerificationDataArray[indexPath.row-1]["isDataUploaded"] as? Bool,let isCurrentDataUploaded = self.accountVerificationDataArray[indexPath.row]["isDataUploaded"] as? Bool{
                    if isDataUploaded && !isCurrentDataUploaded && status != "REJECT" && status != "ERROR"{
                        let proofVC = ProofViewController.storyboardInstance()
                        proofVC.screenTitle = "ID PROOF"
                        proofVC.screenType = self.accountVerificationDataArray[indexPath.row]["screenType"] as? String ?? ""
                        proofVC.screenID = indexPath.row
                        proofVC.delegate = self
                        if indexPath.row == 1{
                            proofVC.screenTitle = "ID PROOF"
                            proofVC.screenType = ProofScreenType.ID.rawValue
                            if !self.proofsDataModelArray.isEmpty{
                                proofVC.proofsDataModelObj = self.proofsDataModelArray[0]
                            }
                            
                        }else{
                            proofVC.screenTitle = "SELFIE WITH ID"
                            proofVC.screenType = ProofScreenType.SELFIE.rawValue
                            proofVC.proofsDataModelObj = self.proofsDataModelArray[0]
                        }
                        self.navigationController?.pushViewController(proofVC, animated: true)
                    }else if !isDataUploaded && !isCurrentDataUploaded && status != "REJECT" && status != "ERROR"{
                        let title = self.accountVerificationDataArray[indexPath.row-1]["title"] as? String ?? ""
                        Global.showAlert(withMessage: "Please add \(title) first", sender: self)
                    }
                }
            }
        }
    }
    }
}
extension AccountActivationViewController: UpdateProfileDelegate, UpdateProofDelegate {
    func tabOnRFIUpdateButton(data: [String : String]) {
        if !data.isEmpty {
            self.profileRFIData = data
            self.accountVerificationDataArray[0]["isDataUploaded"] = true
            let idUploaded = self.accountVerificationDataArray[1]["isDataUploaded"] as? Bool ?? false
            let selfieIDUploaded = self.accountVerificationDataArray[2]["isDataUploaded"] as? Bool ?? false
            let addressUploaded = self.accountVerificationDataArray[3]["isDataUploaded"] as? Bool ?? false
            let authentication = CustomUserDefaults.getisAuth()
            if idUploaded && selfieIDUploaded && addressUploaded && authentication {
             //   self.doneButton.isEnabled = true
            } else {
               // self.doneButton.isEnabled = false
            }
            self.accountVerificationTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    func tabOnUpdateButton(isUpdated: Bool, row: Int, screenType: String, data: ProofsModel) {
        let selctedScreenType = screenType
        if self.proofsDataModelArray.isEmpty {
            self.proofsDataModelArray.append(data)
        } else {
            var isExist = false
            for i in 0..<self.proofsDataModelArray.count{
                if self.proofsDataModelArray[i].screenType == selctedScreenType{
                    self.proofsDataModelArray.remove(at: i)
                    self.proofsDataModelArray.append(data)
                    isExist = true
                    break
                }else {
                    isExist = false
                }
            }
            if !isExist{
                self.proofsDataModelArray.append(data)
            }
        }
        self.accountVerificationDataArray[row]["isDataUploaded"] = isUpdated
        let idUploaded = self.accountVerificationDataArray[1]["isDataUploaded"] as? Bool ?? false
        let selfieIDUploaded = self.accountVerificationDataArray[2]["isDataUploaded"] as? Bool ?? false
        let addressUploaded = self.accountVerificationDataArray[3]["isDataUploaded"] as? Bool ?? false
        let authentication = CustomUserDefaults.getisAuth()
        if idUploaded && selfieIDUploaded && addressUploaded && authentication{
            let status = CustomUserDefaults.getComplianceStatus()
            var isProfileRFI = false
            if status == ComplianceStatusType.RFI_REQUESTED.rawValue{
                for items in self.rfiDetailsArray{
                    if items.type == "data" {
                        isProfileRFI = true
                        break
                    } else {
                        isProfileRFI = false
                    }
                }
                if isProfileRFI {
                   // self.doneButton.isEnabled = !self.profileRFIData.isEmpty
                } else {
                   // self.doneButton.isEnabled = true
                }
            } else {
               // self.doneButton.isEnabled = true
            }
        } else {
            //self.doneButton.isEnabled = false
        }
        self.accountVerificationTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    
    func tabOnOptionButton(isProfileUpdate: Bool) {
        self.accountVerificationDataArray[0]["isDataUploaded"] = isProfileUpdate
        self.accountVerificationTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

extension AccountActivationViewController{
    func configureData(){
        self.requestDataArray.removeAll()
        for index in 0..<self.proofsDataModelArray.count{
            self.subrequestDataArray.removeAll()
            for subIndex in 0..<self.proofsDataModelArray[index].identificationFileDocumentArray.count{
                let subrequestObject = [
                    "fileName": "\(self.proofsDataModelArray[index].identificationFileDocumentArray[subIndex].fileName)",
                    "fileType": "\(self.proofsDataModelArray[index].identificationFileDocumentArray[subIndex].fileType)",
                    "document": "\(self.proofsDataModelArray[index].identificationFileDocumentArray[subIndex].document)"] as [String : Any]
                self.subrequestDataArray.append(subrequestObject)
            }
            let countryName = CustomUserDefaults.getCountry()
            if countryName.isEmpty {
                self.proofsDataModelArray[index].identificationIssuingCountry = "Singapore"
            } else {
                self.proofsDataModelArray[index].identificationIssuingCountry = countryName
            }
            
            let requestObject = [
                "identificationType": "\(self.proofsDataModelArray[index].identificationType)",
                "identificationValue": "\(self.proofsDataModelArray[index].identificationValue)",
                "identificationIssuingAuthority": "\(self.proofsDataModelArray[index].identificationIssuingAuthority)",
                "identificationIssuingDate": "\(self.proofsDataModelArray[index].identificationIssuingDate)",
                "identificationDocExpiry": "\(self.proofsDataModelArray[index].identificationDocExpiry)",
                "identificationDocHolderName": "\(self.proofsDataModelArray[index].identificationDocHolderName)",
                "identificationDocIssuanceCountry": "\(self.proofsDataModelArray[index].identificationIssuingCountry)",
                "identificationDocument": self.subrequestDataArray
                ] as [String: Any]
            self.requestDataArray.append(requestObject)
        }
    }
    
    func configureRFIData(){
        self.requestDataArray.removeAll()
        var rfihasdId = ""
        for index in 0..<self.proofsDataModelArray.count{
            if self.proofsDataModelArray[index].screenType == ProofScreenType.ID.rawValue{
                rfihasdId = self.idRfiHashId
            }else if self.proofsDataModelArray[index].screenType == ProofScreenType.ADDRESS.rawValue{
                rfihasdId = self.addressRfiHashID
            } else {
                rfihasdId = self.selfieRfiHashId
            }
            
            self.subrequestDataArray.removeAll()
            
            for subIndex in 0..<self.proofsDataModelArray[index].identificationFileDocumentArray.count{
                let subrequestObject =
                    [
                        "fileName": "\(self.proofsDataModelArray[index].identificationFileDocumentArray[subIndex].fileName)",
                        "fileType": "\(self.proofsDataModelArray[index].identificationFileDocumentArray[subIndex].fileType)",
                        "document": "\(self.proofsDataModelArray[index].identificationFileDocumentArray[subIndex].document)"] as [String : Any]
                self.subrequestDataArray.append(subrequestObject)
            }
            let countryName = CustomUserDefaults.getCountry()
            self.proofsDataModelArray[index].identificationIssuingCountry = countryName
            let requestObject = [
                "identificationType": "\(self.proofsDataModelArray[index].identificationType)",
                "identificationDocReferenceNumber" : "\(self.proofsDataModelArray[index].identificationValue)",
                "identificationValue": "\(self.proofsDataModelArray[index].identificationValue)",
                "identificationIssuingAuthority": "\(self.proofsDataModelArray[index].identificationIssuingAuthority)",
                "identificationIssuingDate": "\(self.proofsDataModelArray[index].identificationIssuingDate)",
                "identificationDocExpiry": "\(self.proofsDataModelArray[index].identificationDocExpiry)",
                "identificationDocHolderName": "\(self.proofsDataModelArray[index].identificationDocHolderName)",
                "identificationDocIssuanceCountry": "\(self.proofsDataModelArray[index].identificationIssuingCountry)",
                "identificationDocument": self.subrequestDataArray
                ] as [String: Any]
            let rfiRequest = ["rfiHashId" : "\(rfihasdId)","identificationDoc" : requestObject] as [String: Any]
            self.requestDataArray.append(rfiRequest)
        }
        var isProfileRfi = false
        for items in self.rfiDetailsArray{
            if items.type == "data"{
                isProfileRfi = true
                break
            } else {
                isProfileRfi = false
            }
        }
        if isProfileRfi{
            self.requestDataArray.append(self.profileRFIData)
        }
    }
    
    func uploadWalletKYCDocuments(){
        Alert.showProgressHud(onView: self.view)
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        var url = ""
        var parameters = [String:Any]()
        if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue{
            url = "\(mainUrl)/api/v1/uploadRfiDocument/\(customerHashId)"
            parameters = [ "rfiResponseRequest":  self.requestDataArray ]
        }else{
            url = "\(mainUrl)/api/v1/uploadDocument/\(customerHashId)"
            parameters = [ "identificationDoc":  self.requestDataArray ]
        }
        debugPrint(parameters,url)
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey, completionHandler: { (responseObject , stringResponse, error) in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject {
                    debugPrint("response uploadWalletKYCDocuments:  \(response)")
                    if let status = response["status"] as? String {
                        if status != "BAD_REQUEST"{
                            if status == "INTERNAL_SERVER_ERROR"{
                                if let message = response["message"] as? String {
                                    Global.showAlert(withMessage: "\(message)", sender: self)
                                }
                            }else{
                                CustomUserDefaults.setComplianceStatus(data: status)
                                self.showalertMessage()
                            }
                            
                            //self.uploadRemittanceIDProofDocuments()
                        }else if status == "BAD_REQUEST"{
                            if let message = response["message"] as? String {
                                self.getAllCardsCustomerInfo()
                                //self.uploadRemittanceIDProofDocuments()
                            }
                            
                            //self.uploadRemittanceIDProofDocuments()
                        }else{
//                            Alert.hideProgressHud(onView: self.view)
                            Global.showAlert(withMessage: "Something Went Wrong", sender: self)
                        }
                        
                    }else if let message = response["message"] as? String {
                        print(message)
                        //self.uploadRemittanceIDProofDocuments()
                    }else if let message = response["error"] as? String {
                        if message == "invalid_token"{
                            //Global.showAlert(withMessage: "Something Went Wrong", sender: self)
                            AmplifyManager.getWalletAccessToken{ (isSuccess, error) in
                                debugPrint(isSuccess ?? false)
                                if isSuccess ?? false{
                                    self.uploadWalletKYCDocuments()
                                }else{
                                    Global.showAlert(withMessage: "Something Went Wrong", sender: self)
                                }
                            }
                            //AmplifyManager.getWalletAccessToken(emailAddress: cu, password: <#T##String#>, viewController: <#T##UIViewController#>)
                        }
                        //self.uploadRemittanceIDProofDocuments()
                    }
                    
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                } else {
                    if responseObject?["message"] != nil {
//                        Alert.hideProgressHud(onView: self.view)
                        Global.showAlert(withMessage: "\(responseObject?["message"] ?? "Something Went Wrong")", sender: self)
                    }
                }
            } else {
                Alert.hideProgressHud(onView: self.view)
                let strError: String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        })
    }
    
    func getAllCardsCustomerInfo(){
            let customerHashId = CustomUserDefaults.getCustomerHashId()
            let url = "\(mainUrl)/api/v1/getCustomer/\(customerHashId)"
            WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
                Alert.hideProgressHud(onView: self.view)
                if error == nil {
                    if let response = responseObject as? [String : Any]{
                        debugPrint("response:  \(response)")
                        if let complianceStatus = response["complianceStatus"] as? String{
                            CustomUserDefaults.setComplianceStatus(data: complianceStatus)
                            self.complianceStatus = complianceStatus
                            DispatchQueue.main.async {
                                if complianceStatus == "REJECT"  || complianceStatus == "ERROR"{
                                    Global.showAlert(withMessage: "KYC has been Rejected.\nKindly Reinitiate by filling up Profile Details", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                        self.accountVerificationDataArray[0]["isDataUploaded"] = false
                                        self.accountVerificationDataArray[1]["isDataUploaded"] = false
                                        self.accountVerificationDataArray[2]["isDataUploaded"] = false
                                        self.accountVerificationDataArray[3]["isDataUploaded"] = false
                                        self.accountVerificationDataArray[4]["isDataUploaded"] = false
                                        CustomUserDefaults.setisAuth(data: false)
                                        self.accountVerificationTableView.reloadData()
                                    })
                                }
                            }
                        }else if let error =  responseObject?["error"] as? String {
                            if error == "invalid_token"{
                                AmplifyManager.getWalletAccessToken{ (isSuccess, error) in
                                    debugPrint(isSuccess ?? false)
                                }
                            }
                        }else{
                            if let error =  responseObject?["message"] as? String {
                                Global.showAlert(withMessage: "\(error)", sender: self)
                            }
                        }
                    } else {
                        if let error =  responseObject?["error"] as? String {
                            if error == "invalid_token"{
                                AmplifyManager.getWalletAccessToken{ (isSuccess, error) in
                                    debugPrint(isSuccess ?? false)
                                }
                                //self.getWalletAccessToken(emailAddress: self.emailAddress, password: self.password, isFetchToken: false)
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
    
//    func uploadRemittanceIDProofDocuments(){
//        let customerId = CustomUserDefaults.getCustomerId()
//        let urlString = "\(liveBaseUrl)/RAAS/api/v1/clients/\(clientID)/customers/\(customerId)/documents"
//        let parameters : [String: Any] = [ "type": "INDIVIDUAL_POI","code": "NRIC_PR","isBackDocument":  false,"dateOfExpiry":  "\(self.proofsDataModelArray[0].identificationDocExpiry)", "identityNumber": "\(self.proofsDataModelArray[0].identificationValue)"]
//        WebServices.uploadImageWithParameterAndImageName(strImageKey: "image",urlString: urlString, xAPIKey: remittanceXApiKey, isAuth: true, isWalletUser: false, image: self.proofsDataModelArray[0].identificationFileDocumentArray[0].uploadImage, paramDict: parameters,completionHandler: { responseObject , error in
//            if error == nil {
//                if let response = responseObject {
//                    debugPrint("response uploadRemittanceIDProofDocuments:  \(response)")
//                    if let documentId = response["documentId"] as? String{
//                        CustomUserDefaults.setIDDocId(data: documentId)
//                        self.uploadRemittanceSelfieIDProofDocuments()
//                    }else{
//                        if let message = response["code"] as? String{
//                            print(message)
//                            Alert.hideProgressHud(onView: self.view)
//                            self.showalertMessage()
//                        }
//                    }
//                } else {
//                    if responseObject?["message"] != nil {
//                        Alert.hideProgressHud(onView: self.view)
//                        self.showalertMessage()
//                    }
//                }
//            } else {
//                Alert.hideProgressHud(onView: self.view)
//               self.showalertMessage()
//                let strError : String =  (error?.localizedDescription)!
//                //Global.showAlert(withMessage: "\(strError)", sender: self)
//            }
//        })
//    }
//    
//    func uploadRemittanceSelfieIDProofDocuments(){
//            let customerId = CustomUserDefaults.getCustomerId()
//            let urlString = "\(liveBaseUrl)/RAAS/api/v1/clients/\(clientID)/customers/\(customerId)/documents"
//            //let url = URL(string: urlString)!
//            //51045025-4864-4953-8a2e-2994e247af34
//            let parameters : [String: Any] = [ "type": "INDIVIDUAL_PERSONAL_IMAGE","code": "INDIVIDUAL_SELFIE_WITH_ID","isBackDocument":  false,"dateOfExpiry": "\(self.proofsDataModelArray[1].identificationDocExpiry)", "identityNumber": "\(self.proofsDataModelArray[1].identificationValue)"]
//        WebServices.uploadImageWithParameterAndImageName(strImageKey: "image",urlString: urlString, xAPIKey: remittanceXApiKey, isAuth: true, isWalletUser: false, image: self.proofsDataModelArray[1].identificationFileDocumentArray[0].uploadImage, paramDict: parameters,completionHandler: { responseObject , error in
//            Alert.hideProgressHud(onView: self.view)
//                if error == nil {
//                    if let response = responseObject {
//                        debugPrint("response uploadRemittanceSelfieIDProofDocuments:  \(response)")
//                        if let documentId = response["documentId"] as? String{
//                            CustomUserDefaults.setSelfieDocId(data: documentId)
//                           
//                        }else{
//                            if let message = response["code"] as? String{
//                                print(message)
//                            }
//                        }
//                    } else {
//                        if responseObject?["message"] != nil {
//                            //Global.showAlert(withMessage: "\(responseObject?["message"] ?? "Something Went Wrong")", sender: self)
//                            //Constants.kAppDelegate?.setMainController()
//                        }
//                    }
//                } else {
//                    //Constants.kAppDelegate?.setMainController()
//                    let strError : String =  (error?.localizedDescription)!
//                    //Global.showAlert(withMessage: "\(strError)", sender: self)
//                }
//            self.showalertMessage()
//            })
//    //        WebServices.
//        }
    
    
    func showalertMessage(){
        Global.showAlert(withMessage: "Documents Uploaded Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
            Constants.kAppDelegate?.setMainController()
        })
    }

     func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authorizationError: NSError?
        let reason = "Authentication is required to access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                    CustomUserDefaults.setisAuth(data: true)
                    self.accountVerificationDataArray[4]["isDataUploaded"] = true
                    self.accountVerificationTableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
                    }


                } else {
                    // Failed to authenticate
                    guard evaluateError != nil else {
                        return
                    }
                    DispatchQueue.main.async() {
                       // Constants.kAppDelegate?.setControllers()
                    }
                    print(evaluateError?.localizedDescription)
                }
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            print(error)
            DispatchQueue.main.async {
                Global.showAlert(withMessage: "Kindly Enable Biometric Authentication", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                   // Constants.kAppDelegate?.setControllers()
                })

                //Global.showAlert(withMessage: "Kindly Enable Biometric Authentication")
            }
        }
    }
}
