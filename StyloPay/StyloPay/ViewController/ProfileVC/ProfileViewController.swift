//
//  ProfileViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 04/08/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//ProfileOptionsTableViewCell

import UIKit
import Amplify

class ProfileViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ProfileViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ProfileViewController
    }

    @IBOutlet weak var profileOptionsTableView: UITableView!{
        didSet{
            profileOptionsTableView.delegate = self
            profileOptionsTableView.dataSource = self
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
    
    let theme = ThemeManager.currentTheme()
    var profileDetails = PersonalnfoModel()
    var complianceStatus = ""
    let nationalityArr = ["SG","AU","DE","HK","IN","ID","JP","MY","KR","TW","TH","GB","US","VN"]
    let codeArr = ["SGD","AUD","EUR","HKD","INR","IDR","JPY","MYR","KRW","TWD","THB","GBP","USD","VND"]
    let countryCodeArr = ["65","61","49","852","91","62","81","60","82","886","66","44","1","84"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTheme()
        moreOptionsButton.isHidden = true
        configureCell()
        getCustomerInfo()
    }
    
    func configureCell() {
        profileOptionsTableView.estimatedRowHeight = 80
        profileOptionsTableView.separatorStyle = .none
        profileOptionsTableView.separatorInset = UIEdgeInsets.zero
        profileOptionsTableView.sectionFooterHeight = 56
        profileOptionsTableView.rowHeight = UITableView.automaticDimension
        profileOptionsTableView.register(UINib(nibName: "ProfileOptionsTableViewCell", bundle: nil),forCellReuseIdentifier: "ProfileOptionsTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        backgroundImageView.isHidden = theme.backgroundImageHidden
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        
        manageCardButton.setImage(theme.selectedManageCardImage, for: .normal)
        let sideMenuImage = AssetsImages.sideMenuIcon?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(sideMenuImage, for: .normal)
        backButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        //backButton.setImage(theme.backImage,for: .normal)
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
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        //self.navigationController?.popViewController(animated: false)
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
}

extension ProfileViewController: ProfileDetailsDelegate{
    func tabUpdateButton(isSuccess: Bool) {
        if isSuccess{
            self.getCustomerInfo()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let profileCell =  tableView.dequeueReusableCell(withIdentifier: "ProfileOptionsTableViewCell", for: indexPath) as? ProfileOptionsTableViewCell{
            profileCell.configureCell(row: indexPath.row)
            return profileCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1{
            let profileDetailsVC = ProfileDetailsViewController.storyboardInstance()
            profileDetailsVC.index = indexPath.row
            profileDetailsVC.profileDetails = self.profileDetails
            self.navigationController?.pushViewController(profileDetailsVC, animated: false)
        }
        else if indexPath.row == 2{
            if complianceStatus == ComplianceStatusType.IN_PROGRESS.rawValue{
                CustomUserDefaults.setisAuth(data: false)
                Global.showAlertWithTwoHandler(strMessage: "Please complete your profile", strActionOne: "OK", strActionTwo: "Skip", okBlock: {
                    let accountActivation = AccountActivationViewController.storyboardInstance()
                    accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = true
                    self.navigationController?.pushViewController(accountActivation, animated: true)
                }, cancelBlock: {})
            }else if complianceStatus == ComplianceStatusType.ACTION_REQUIRED.rawValue || complianceStatus == ComplianceStatusType.RFI_RESPONDED.rawValue{
                Global.showAlert(withMessage: "Your KYC is being processed and pending approval.", sender: self)
            }else if complianceStatus == ComplianceStatusType.COMPLETED.rawValue{
                Global.showAlert(withMessage: "Your KYC is approved", sender: self)
            }else if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue{
                self.rfiStatusHandle()
            }
            else if complianceStatus == ComplianceStatusType.REJECT.rawValue ||  complianceStatus == ComplianceStatusType.ERROR.rawValue {
                CustomUserDefaults.setisAuth(data: false)
                Global.showAlert(withMessage: "KYC has been Rejected.\nKindly Reinitiate by filling up Profile Details", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                    let accountActivation = AccountActivationViewController.storyboardInstance()
                    accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = false
                    self.navigationController?.pushViewController(accountActivation, animated: true)
                })
            }
        }
    }
    
    func rfiStatusHandle(){
        var messageArray = [String]()
        var sequencedArray = [String]()
        var messageString = ""
        messageArray.removeAll()
        let accountActivation = AccountActivationViewController.storyboardInstance()
        accountActivation.rfiDetailsArray = self.profileDetails.rfiDetailsArray
        accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = true
        accountActivation.accountVerificationDataArray[1]["isDataUploaded"] = true
        accountActivation.accountVerificationDataArray[2]["isDataUploaded"] = true
        accountActivation.accountVerificationDataArray[3]["isDataUploaded"] = true
        accountActivation.profileDetails = self.profileDetails
        for items in profileDetails.rfiDetailsArray {
            if items.type == "document" {
                let documenttype = items.documentType.lowercased()
                let discription = items.rfiDescription.lowercased()
                if documenttype == "poi" && discription == "selfiewithid"{
                    accountActivation.selfieRfiHashId = items.rfiHashId
                    accountActivation.isPOI = true
                    accountActivation.accountVerificationDataArray[2]["isDataUploaded"] = false
                }
                else if documenttype == "poi" && discription != "selfiewithid"{
                    accountActivation.accountVerificationDataArray[1]["isDataUploaded"] = false
                    accountActivation.idRfiHashId = items.rfiHashId
                    accountActivation.isPOI = true
                }


                else if documenttype == "poa"{
                    accountActivation.addressRfiHashID = items.rfiHashId
                    accountActivation.isPOA = true
                    accountActivation.accountVerificationDataArray[3]["isDataUploaded"] = false
                }
//                else if documenttype == "selfiewithid"{
//                    accountActivation.selfieRfiHashId = items.rfiHashId
//                    accountActivation.isPOI = true
//                    accountActivation.accountVerificationDataArray[2]["isDataUploaded"] = false
//                }
                messageArray.append("\(items.remarks)")
            } else {
                accountActivation.profileRfiHashId = items.rfiHashId
                accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = false
                messageArray.append("\(items.remarks)")
            }
        }
        sequencedArray.removeAll()
        for index in 0..<messageArray.count{
            sequencedArray.append("\(index+1). \(messageArray[index])")
        }
        messageString = sequencedArray.joined(separator: "\n")
        
        Global.showAlert(withMessage: "\(messageString)", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
            CustomUserDefaults.setisAuth(data: true)
            self.navigationController?.pushViewController(accountActivation, animated: true)
        })
    }
}

extension ProfileViewController{
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
                        self.profileDetails = profiledata
                        for index in 0..<self.nationalityArr.count{
                            if self.nationalityArr[index] == "\(self.profileDetails.nationality)" {
                                self.profileDetails.code = "\(self.codeArr[index])"
                                self.profileDetails.countryCode = "\(self.countryCodeArr[index])"
                            }
                        }
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

}
