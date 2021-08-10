//
//  UpdateCardPINViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 07/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class UpdateCardPINViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> UpdateCardPINViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! UpdateCardPINViewController
    }

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cardviewBackgroundImage: UIImageView!
    
    let theme = ThemeManager.currentTheme()
    
    @IBOutlet weak var firstOtpView: UIView!
    @IBOutlet weak var secondOtpView: UIView!
    @IBOutlet weak var thirdOtpView: UIView!
    @IBOutlet weak var fourthOtpView: UIView!
    @IBOutlet weak var fifthOtpView: UIView!
    @IBOutlet weak var sixthOtpView: UIView!
    @IBOutlet weak var firstDigitTextField: UITextField!
    @IBOutlet weak var secondDigitTextField: UITextField!
    @IBOutlet weak var thirdDigitTextField: UITextField!
    @IBOutlet weak var fourthDigitTextField: UITextField!
    @IBOutlet weak var fifthDigitTextField: UITextField!
    @IBOutlet weak var sixthDigitTextField: UITextField!
    
    var cardHashID = ""
    let customerHashID = CustomUserDefaults.getCustomerHashId()
    let walletHashID = CustomUserDefaults.getwalletHashId()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreOptionsButton.isHidden = true
        configureView()
        configureTheme()
    }
    
    func configureView(){
        self.navigationController?.navigationBar.isHidden = true
        firstOtpView.layer.borderWidth = 1.0
        firstOtpView.layer.cornerRadius = 5.0
        firstOtpView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        secondOtpView.layer.borderWidth = 1.0
        secondOtpView.layer.cornerRadius = 5.0
        secondOtpView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        thirdOtpView.layer.borderWidth = 1.0
        thirdOtpView.layer.cornerRadius = 5.0
        thirdOtpView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        fourthOtpView.layer.borderWidth = 1.0
        fourthOtpView.layer.cornerRadius = 5.0
        fourthOtpView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        fifthOtpView.layer.borderWidth = 1.0
        fifthOtpView.layer.cornerRadius = 5.0
        fifthOtpView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sixthOtpView.layer.borderWidth = 1.0
        sixthOtpView.layer.cornerRadius = 5.0
        sixthOtpView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        confirgureTextFields()
    }
    
    func configureTheme(){
        
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        cardviewBackgroundImage.image = theme.buttonsBackgroundImage
        updateButton.setBackgroundImage(theme.borderColorImage, for: .normal)
        updateButton.setTitleColor(theme.bottomUnselectedTabButtonColor, for: .normal)
        
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        backButton.setImage(theme.backImage,for: .normal)
        
        manageCardButton.setImage(theme.selectedManageCardImage, for: .normal)
        
        let transferImage = AssetsImages.transferUnselected?.withRenderingMode(.alwaysTemplate)
        transferMoneyButton.setImage(transferImage, for: .normal)
        transferMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let exchangeImage = AssetsImages.exchangeUnselected?.withRenderingMode(.alwaysTemplate)
        exchangeMoneyButton.setImage(exchangeImage, for: .normal)
        exchangeMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        
        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
    }
    
    
    func confirgureTextFields(){
        firstDigitTextField.delegate = self
        secondDigitTextField.delegate = self
        thirdDigitTextField.delegate = self
        fourthDigitTextField.delegate = self
        fifthDigitTextField.delegate = self
        sixthDigitTextField.delegate = self
        
        firstDigitTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        secondDigitTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        thirdDigitTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        fourthDigitTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        fifthDigitTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        sixthDigitTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField {
            case firstDigitTextField:
                secondDigitTextField.becomeFirstResponder()
            case secondDigitTextField:
                thirdDigitTextField.becomeFirstResponder()
            case thirdDigitTextField:
                fourthDigitTextField.becomeFirstResponder()
            case fourthDigitTextField:
                fifthDigitTextField.becomeFirstResponder()
            case fifthDigitTextField:
                sixthDigitTextField.becomeFirstResponder()
            case sixthDigitTextField:
                sixthDigitTextField.resignFirstResponder()
            default:
                break
            }
        } else {
            switch textField {
            case sixthDigitTextField:
                fifthDigitTextField.becomeFirstResponder()
            case fifthDigitTextField:
                fourthDigitTextField.becomeFirstResponder()
            case fourthDigitTextField:
                thirdDigitTextField.becomeFirstResponder()
            case thirdDigitTextField:
                secondDigitTextField.becomeFirstResponder()
            case secondDigitTextField:
                firstDigitTextField.becomeFirstResponder()
            case firstDigitTextField:
                firstDigitTextField.resignFirstResponder()
            default:
                break
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        let otp = "\(self.firstDigitTextField.text ?? "")\(self.secondDigitTextField.text ?? "")\(self.thirdDigitTextField.text ?? "")\(self.fourthDigitTextField.text ?? "")\( self.fifthDigitTextField.text ?? "")\(self.sixthDigitTextField.text ?? "")".trimmingCharacters(in: .whitespaces)
        print(otp.length)
        if !otp.isEmpty && otp.length == 6{
            let base64encoded = otp.toBase64()
            print(base64encoded)
            self.postUpdatePin(encodedOTP: base64encoded)
        }else{
            Global.showAlert(withMessage: "Please enter a valid 6 Digit PIN", sender: self, buttonTitle: "OK")
        }
        
    }
}

extension UpdateCardPINViewController{
    
    func postUpdatePin(encodedOTP: String){
        Alert.showProgressHud(onView: self.view)
        let strUrl = "\(mainUrl)/api/v1/pinUpdate/\(customerHashID)/\(walletHashID)/\(cardHashID)"
        let parameters = [ "pinBlock": "\(encodedOTP)" ]
        WebServices.postRequest(urlString: strUrl, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject , stringResponse, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject {
                    debugPrint("response:  \(response)")
                    if let status = response["status"] as? String{
                        let statusData = status.lowercased()
                        if statusData == "success"{
                            Global.showAlert(withMessage: "PIN Updated Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                self.navigationController?.popViewController(animated: false)
                            })
                        } else {
                            if let errors = response["errors"] as? String {
                                Global.showAlert(withMessage: "\(errors)", sender: self)
                            }
                        }
                    }
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
        
    }
}
