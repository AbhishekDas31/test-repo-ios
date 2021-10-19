//
//  HomeViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 15/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify

class HomeViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> HomeViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! HomeViewController
    }
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var exchangeImageView: UIImageView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
   // @IBOutlet weak var walletBalance : UILabel!
    
    @IBOutlet var dropDownBtn: UIButton!
    @IBOutlet var Wallet: UILabel!
    @IBOutlet weak var fromCurrencyImageView: UIImageView!
    @IBOutlet weak var fromCountryImageView: UIImageView!
    @IBOutlet weak var toCountryImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var toCurrencyImageView: UIImageView!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var headerLbl:UILabel!
    
    @IBOutlet var fxLabel: UILabel!
    let theme = ThemeManager.currentTheme()
    let emailAddress = CustomUserDefaults.getEmailID()
    var password = ""
    var fromCurrencyCode = "SGD"
    var fromCountryimage = ""
    var fromcurrencyamount = ""
    var toCurrencyCode = "INR"
    var toCountryimage = ""
    var tocurrencyamount = ""
    var walletBalanceArray = [WalletBalanceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feeLabel.text = "Fx :"
        self.Wallet.text = "Wallet Balance:"
        self.fxLabel.text = "Fees :"
        moreOptionsButton.isHidden = true
        configureView()
        getWalletBalance()
        if let password = KeychainService.loadPassword(service: service, account: account){
            self.password = password
        }
        if !fromcurrencyamount.isEmpty {
            self.fromTextField.text = "\(fromcurrencyamount)"
            if let intAmount = Double(fromcurrencyamount){
                self.getExchangeRate(amount: intAmount.truncate(places: 2))
            }
        }
    }
    
    func configureView(){
        self.navigationController?.navigationBar.isHidden = true
        self.exchangeView.layer.cornerRadius = 10.0
        self.fromView.layer.cornerRadius = 5.0
        self.toView.layer.cornerRadius = 5.0
        self.fromView.layer.borderWidth = 1.0
        self.fromView.layer.borderColor = UIColor.white.cgColor
        self.toView.layer.borderWidth = 1.0
        self.toView.layer.borderColor = UIColor.white.cgColor
        let color = UIColor.white
        self.fromTextField.placeholder = "AMOUNT"
        self.toTextField.placeholder = "AMOUNT"
        self.fromTextField.keyboardType = .decimalPad
        self.toTextField.keyboardType = .decimalPad
        fromTextField.attributedPlaceholder = NSAttributedString(string: fromTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        fromTextField.delegate = self
       // toTextField.delegate = self
        fromTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
       // fromTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingDidEnd)

        toTextField.attributedPlaceholder = NSAttributedString(string: toTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        configureTheme()
        
    }
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        
        let grayWhiteColor = theme.bottomUnselectedTabButtonColor
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = grayWhiteColor
        let sideMenuImage = AssetsImages.sideMenuIcon?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(sideMenuImage, for: .normal)
        menuButton.imageView?.tintColor = grayWhiteColor
        headerLbl.textColor = grayWhiteColor
        
        exchangeImageView.image = theme.buttonsBackgroundImage
        sendButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        
        let manageCardImage = AssetsImages.manageCardIconImage?.withRenderingMode(.alwaysTemplate)
        manageCardButton.setImage(manageCardImage, for: .normal)
        manageCardButton.imageView?.tintColor = grayWhiteColor
        
        let transferImage = AssetsImages.transferUnselected?.withRenderingMode(.alwaysTemplate)
        transferMoneyButton.setImage(transferImage, for: .normal)
        transferMoneyButton.imageView?.tintColor = grayWhiteColor
        
        exchangeMoneyButton.setImage(theme.selectedExchangeImage, for: .normal)
        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = grayWhiteColor
        
        
        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = grayWhiteColor
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector:
        #selector(self.reload(_:)), object: textField)
            perform(#selector(self.reload(_:)), with: textField, afterDelay: 0.75)

    }

    @objc func reload(_ textField: UITextField) {
        if let text = textField.text{
            if !text.isEmpty{
                if let intAmount = Double(text){
                    self.fromcurrencyamount = text
                    self.getExchangeRate(amount: intAmount.truncate(places: 2))
                }
            }
        }


    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
//        let vc = SuccessScreenViewController.storyboardInstance()
//        vc.isFromExchange = true
//        self.navigationController?.pushViewController(vc, animated: true)
       
        if !tocurrencyamount.isEmpty && !fromcurrencyamount.isEmpty{
            if let amount = Double(fromcurrencyamount){
                self.postCurrencyExchange(amount: amount.truncate(places: 2))
            }else{
                Global.showAlert(withMessage: "ENTER A VALID AMOUNT", sender: self)
            }
        }else{
            Global.showAlert(withMessage: "ENTER A VALID AMOUNT", sender: self)
        }
    }
    
    @IBAction func currencyFromButtonPressed(_ sender: Any) {
        let currencyCodeVC = CurrencyCodePopUpViewController.storyboardInstance()
        currencyCodeVC.isExchange = true
        currencyCodeVC.isToCurrency = false
        currencyCodeVC.isFromCurrency = true
        currencyCodeVC.delegate = self
        currencyCodeVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(currencyCodeVC, animated: true, completion: nil)
    }
    
    @IBAction func currencyToButtonPressed(_ sender: Any) {
        let currencyCodeVC = CurrencyCodePopUpViewController.storyboardInstance()
        currencyCodeVC.isExchange = true
        currencyCodeVC.isToCurrency = true
        currencyCodeVC.isFromCurrency = false
        currencyCodeVC.delegate = self
        currencyCodeVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(currencyCodeVC, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let sendingOptionsVC = ReciverEmailViewController.storyboardInstance()//SendingOptionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(sendingOptionsVC, animated: false)
    }
    @IBAction func manageMyCardButtonPressed(_ sender: Any) {
        let manageCardVC = ManageMyCardViewController.storyboardInstance()
        self.navigationController?.pushViewController(manageCardVC, animated: false)
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

extension HomeViewController: CurrencyCodeDelegate{
    
    

    
    func tabCountryCode(country: String, currencyCode: String, countryFlag: String, currencyIcon:String,currencySymbol: String, isTo: Bool, isFrom: Bool, isFiltered: Bool) {
//        print("country : \(country) , currencyCode: \(currencyCode) , isTo : \(isTo) , isFrom : \(isFrom)")
        self.toTextField.text = ""
        self.fromTextField.text = ""
        self.feeLabel.text="Fx :"
        self.fxLabel.text="Fees :"
        if isFrom{
            if currencyCode == toCurrencyCode{
                Global.showAlert(withMessage: "Source and Destination cannot be same ", sender: self)
            }else{
                fromCountryImageView.image = UIImage(named: countryFlag)
                fromCurrencyImageView.image = UIImage(named: currencyIcon)
                fromCurrencyCode = "\(currencyCode)"
                for i in 0..<self.walletBalanceArray.count{
                    if self.walletBalanceArray[i].curSymbol == currencyCode{
                        self.Wallet.text = "Wallet Balance: \(currencySymbol) \(self.walletBalanceArray[i].balance)"
                    }
                }
            }
        }
        else if isTo{
            if fromCurrencyCode == currencyCode{
                Global.showAlert(withMessage: "Source and Destination cannot be same ", sender: self)
            }else{
                toCurrencyCode = "\(currencyCode)"
                toCountryImageView.image = UIImage(named: countryFlag)
                toCurrencyImageView.image = UIImage(named: currencyIcon)
        
       
            }
        }
    }
}




extension HomeViewController{
    
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
    func getExchangeRate(amount : Double){
        self.view.endEditing(true)

        let url =  "\(mainUrl)/api/v1/exchangeRate?sourceCurrencyCode=\(toCurrencyCode)&sourceAmount=&destinationCurrencyCode=\(fromCurrencyCode)&destinationAmount=\(amount)"
      // let url = "\(mainUrl)/api/v1/exchangeRate?sourceAmount=\(amount)&destinationCurrencyCode=\(toCurrencyCode)&sourceCurrencyCode=\(fromCurrencyCode)"
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if let error =  response["error"] as? String {
                        if error == "invalid_token"{
                            Global.showAlert(withMessage: "Something Went Wrong. Please Try again later", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                self.getWalletAccessToken()
                            })
                        }
                    }
                    else {
                        if let exchangeRate = response["exchangeRate"] , let markupAmount = response["markupAmount"] as? Double{
                            self.feeLabel.text = "Fx :  \(exchangeRate)"
                            self.fxLabel.text = "Fees :  \(markupAmount)"
                        }
                        if let destinationAmount = response["sourceAmount"] as? Double{
                            self.toTextField.text = "\(destinationAmount)"
                            self.tocurrencyamount = "\(destinationAmount)"
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
                self.Wallet.text = "Wallet Balance: \(symbol) \(walletBalanceData.balance)"
                let image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                //let sgddollarImage = AssetsImages.sdollarSymbol?.withRenderingMode(.alwaysTemplate)
                fromCurrencyImageView.image = image
                //currencyChang.setImage(image, for: .normal)
                //dropDownBtn.imageView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                fromCurrencyImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                break
            }
        }
    }
    
    func postCurrencyExchange(amount: Double){
        self.view.endEditing(true)
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/transferBalance/\(customerHashId)/\(walletHashId)"
        let parameters : [String : Any] = ["amount": amount,
        "destinationCurrency": "\(toCurrencyCode)",
        "sourceCurrency": "\(fromCurrencyCode)"]
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject , error, stringResponse)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let _ = responseObject{
//                    if let quotedId = response["quoteId"] as? String{
//                        if !quotedId.isEmpty{
//                            Global.showAlert(withMessage: "Exchange Done Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                self.toTextField.text = ""
                                self.fromTextField.text = ""
                                self.feeLabel.text = "Fx :"
                    self.Wallet.text = "Wallet Balance:"
                    self.fxLabel.text = "Fees :"
                                self.fromcurrencyamount = ""
                                self.tocurrencyamount = ""
                                let vc = SuccessScreenViewController.storyboardInstance()
                                vc.isFromExchange = true
                                self.navigationController?.pushViewController(vc, animated: true)
                           // })
//                        }
//                    }
                }  else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                }
            }else{
                debugPrint(error ?? "Something went wrong!")
            }
        }

    }

    func getWalletAccessToken(){
        AmplifyManager.getWalletAccessToken{(isSuccess, error) in
            if isSuccess ?? false{
                self.getWalletBalance()
            }
            if error != nil{
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
}

extension HomeViewController:UITextFieldDelegate {
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
        
    

