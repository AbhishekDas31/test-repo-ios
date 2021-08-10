//
//  TransferViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController,UITextFieldDelegate {
    
    // MARK: - StoryBoard Instance
       static func storyboardInstance() -> TransferViewController {
           return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! TransferViewController
       }

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dropDownBtn:UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var cardviewBackgroundImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var receiverImageView: UIImageView!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var currencyChangeButton: UIButton!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    
    
    let theme = ThemeManager.currentTheme()
    var walletBalanceArray = [WalletBalanceModel]()
    let emailAddress = CustomUserDefaults.getEmailID()
    var password = ""//CustomUserDefaults.getPassword()
    var wallebalance = ""
    var selectedCurrency = "SGD"
    var name = ""
    var destinationWalletHashid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let password = KeychainService.loadPassword(service: service, account: account){
            self.password = password
            print(self.password)
        }
        self.configureView()
        self.getWalletBalance()
    }
    
    func configureView(){
        self.receiverName.text = "\(name)"
        amountTextfield.attributedPlaceholder = NSAttributedString(string: amountTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        amountTextfield.keyboardType = .decimalPad
        self.amountTextfield.delegate = self
        self.receiverImageView.layer.cornerRadius = 30.0
        self.senderImageView.layer.cornerRadius = 30.0
        self.amountView.layer.borderWidth = 1.0
        self.amountView.layer.borderColor = UIColor.white.cgColor
        self.amountView.layer.cornerRadius = 5.0
        cardView.layer.cornerRadius = 8.0
        configureTheme()
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        cardviewBackgroundImage.image = theme.buttonsBackgroundImage
        proceedButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        receiverName.textColor = theme.bottomUnselectedTabButtonColor
        let addImage = AssetsImages.addImage?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(addImage, for: .normal)
        addButton.imageView?.tintColor = UIColor.white
        receiverImageView.image = theme.defaultProfileImage
        senderImageView.image = theme.defaultProfileImage
        rightArrowImageView.image = theme.rightArrowImage
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        backButton.setImage(theme.backImage,for: .normal)

        let downImage = AssetsImages.dropdownRedImage?.withRenderingMode(.alwaysTemplate)
        dropDownBtn.setImage(downImage, for: .normal)
        dropDownBtn.imageView?.tintColor = UIColor.white
       // dropDownBtn.setImage(theme.dropDownColorImage,for: .normal)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addButton(_ sender:UIButton)
    {
        let loadAmountVC = LoadMoneyViewController.storyboardInstance()
        self.navigationController?.pushViewController(loadAmountVC, animated: true)
    }
    
    @IBAction func currencyChangeButtonPressed(_ sender: Any) {
        let currencyCodeVC = CurrencyCodePopUpViewController.storyboardInstance()
        currencyCodeVC.delegate = self
        currencyCodeVC.walletBalanceArray = self.walletBalanceArray
        currencyCodeVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(currencyCodeVC, animated: true, completion: nil)
    }
    
    @IBAction func proceedButtonPressed(_ sender: Any) {

        self.transeFerMoney()


    }

    func transferAlert() {

        Global.showAlertWithTwoHandler(strMessage: "Transferring funds to \(name) Press OK To Confirm", strActionOne: "OK", strActionTwo: "CANCEL", sender: self, okBlock: {
            self.verifyOtp()

        }, cancelBlock: {
            return
        })
    }

    func transeFerMoney()
    {
        if let transferamount = Double(self.amountTextfield.text ?? ""){
            self.transferAlert()

            }
        else {
            Global.showAlert(withMessage: "Please Enter Amount to be transfered", sender: self)
        }
    }
}

extension TransferViewController: CurrencyCodeDelegate{
    
    func tabCountryCode(country: String, currencyCode: String, countryFlag: String, currencyIcon: String,currencySymbol: String, isTo: Bool, isFrom: Bool, isFiltered: Bool) {
        var isExist = false
        let imageIcon = UIImage(named: currencyIcon)
        self.selectedCurrency = currencyCode
        self.currencyImageView.image = imageIcon
        self.currencyChangeButton.setImage(UIImage(named: currencyIcon), for: .normal)
        for i in 0..<self.walletBalanceArray.count{
            if self.walletBalanceArray[i].curSymbol == currencyCode{
                self.walletBalanceLabel.text = "\(currencySymbol) \(self.walletBalanceArray[i].balance)"
                isExist = true
                return
            }else{
                isExist = false
            }
        }
        if !isExist{
            self.walletBalanceLabel.text = "0.00"
        }
    }
}

extension TransferViewController{
    func getWalletBalance(){
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/getWalletBalance/\(customerHashId)/\(walletHashId)"
        Alert.showProgressHud(onView: self.view)
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
               if let response = responseObject{
                    if let error =  response["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken()
                           // Global.showAlert(withMessage: "Something Went Wrong. Please Try again after later", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
//                                AmplifyManager.getWalletAccessToken { (isSuccess) in
//                                    debugPrint(isSuccess ?? false)
//                                }
                                
                            //})
                        }
                    }
               }else{
                self.walletBalanceArray.removeAll()
                if let walletBalanceresponse = responseArray{
                    for data in walletBalanceresponse{
                        let walletBalanceData = WalletBalanceModel(data)
                        self.walletBalanceArray.append(walletBalanceData)
                        if walletBalanceData.defaultValue{
                            self.setupDefaultIcon(walletBalanceData: walletBalanceData)
                        }
                    }
                }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }


    
    func setupDefaultIcon(walletBalanceData: WalletBalanceModel){
        
        for i in 0..<currencyData.count{
            let icon = currencyData[i]["currencyIcon"] as? String ?? ""
            let symbol = currencyData[i]["currencySymbol"] as? String ?? ""
            //
            let code = currencyData[i]["currencyCode"] as? String ?? ""
            if walletBalanceData.curSymbol == code{
                self.walletBalanceLabel.text = "\(symbol) \(walletBalanceData.balance)"
                let image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                //let sgddollarImage = AssetsImages.sdollarSymbol?.withRenderingMode(.alwaysTemplate)
                currencyImageView.image = image
                currencyChangeButton.setImage(image, for: .normal)
                currencyChangeButton.imageView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                currencyImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                break
            }
        }
    }
    func getWalletAccessToken(){
        
        AmplifyManager.getWalletAccessToken { (isSuccess,error) in
            
            if isSuccess ?? false{
                self.getWalletBalance()
            }else{
                if error == "Bad credentials"{
                    DispatchQueue.main.async {
                        Global.showAlertWithTwoHandler(strMessage: "Please complete your profile", strActionOne: "OK", strActionTwo: "Skip", okBlock: {
                            CustomUserDefaults.setisAuth(data: false)
                            let vc = AccountActivationViewController.storyboardInstance()
                            self.navigationController?.pushViewController(vc, animated: false)
                        }, cancelBlock: {})
                    }
                }
            }
        }
    }
    
    func postP2PTransfer(amount: Double, destinationWalletHashID: String) {
        self.view.endEditing(true)
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/p2pTransfer/\(customerHashId)/\(walletHashId)"
        let parameters : [String : Any] = ["destinationWalletHashId":"\(destinationWalletHashID)","amount":amount, "currencyCode": "\(self.selectedCurrency)" ]
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject, stringResponse, error)   in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
               // debugPrint(responseObject)
                if let response = responseObject{
                    if let status = response["status"] as? String{
                        if status == "Approved"{
                            if let retrievalReferenceNumber = response["retrievalReferenceNumber"] as? String{
                                print(retrievalReferenceNumber)
                                let vc = SuccessScreenViewController.storyboardInstance()
                                self.navigationController?.pushViewController(vc, animated: true)
//                                Global.showAlert(withMessage: "Money Transferred", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
//
//                                })
                                
                            }
                        }
                        else {
                            Global.showAlert(withMessage: "\(response["message"] as? String ?? "")", sender: self)

                        }
                    }
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                }
            } else {
                //Alert.hideProgressHud(onView: self.view)
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }

    func verifyOtp() {
        self.view.endEditing(true)

        let parameters : [String : Any] = ["api_key":nexmo_api_key,"api_secret":nexmo_secret_key, "number": "+\(CustomUserDefaults.getIsdCode())\(CustomUserDefaults.getMobileNumber())" ,"pin_expiry":"300","brand":brand]
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequestnexom(urlString: nexmo_verify_url, paramDict: parameters, isWalletUser: false, isAuth: false, xAPIKey: ""){ (responseObject, stringResponse, error)   in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
               // debugPrint(responseObject)
                if let response = responseObject{
                    if let status = response["status"] as? String{
                        if status == "0" || status == "10"{

                                let activateCardVC = ActivateCardViewController.storyboardInstance()
                                activateCardVC.modalPresentationStyle = .overCurrentContext
                                //activateCardVC.isOtp = true
                                activateCardVC.isComingFromP2p = true
                                activateCardVC.delegate = self
                                activateCardVC.requestId = response["request_id"] as? String ?? ""
                                self.navigationController?.present(activateCardVC, animated: true, completion: nil)

                            }
                        else {
                            Global.showAlert(withMessage: "\(response["error_text"] as? String ?? "")", sender: self)

                        }
                    }
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                }
            } else {
                //Alert.hideProgressHud(onView: self.view)
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
}
extension TransferViewController {
    //"^(?![0.]+$)[0-9]{0,10}(?:\\.[0-9]{0,2})?$"
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


      // Take number of digits present after the decimal point.
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^[0-9]{0,7}(?:\\.[0-9]{0,2})?$"
        var _: Error? = nil
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
        } catch {
        }
        let numberOfMatches = regex?.numberOfMatches(in: newString, options: [], range: NSRange(location: 0, length: newString.count)) ?? 0
        return numberOfMatches != 0
    }

}

extension TransferViewController:ActivateCardDetilsDelegate {

    func transferMoney(flas:Bool, message:String){

        if flas {
        if let transferamount = Double(self.amountTextfield.text ?? ""){
            self.postP2PTransfer(amount: transferamount, destinationWalletHashID: self.destinationWalletHashid)
        }
        }
        else {
            Global.showAlert(withMessage: message, sender: self)
        }

    }
}
