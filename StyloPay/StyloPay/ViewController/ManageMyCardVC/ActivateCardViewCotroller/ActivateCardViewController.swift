//
//  ActivateCardViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 12/01/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify

@objc protocol ActivateCardDetilsDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    @objc optional func activateCardDetailsUpdate(lastDigits: String, cardHashId: String)
    @objc optional func transferMoney(flas:Bool, message:String)
}

class ActivateCardViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ActivateCardViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ActivateCardViewController
    }
    
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var otpVerfy: UIButton!

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lastDigitsTextFields: UITextField!
    @IBOutlet weak var activateCard: UIButton!
    
    let theme = ThemeManager.currentTheme()
    weak var delegate: ActivateCardDetilsDelegate!
    var proxyNumber = ""
    var cardHashId = ""
    var lastDigits = ""
    var isOtp = false
    var isComingFromP2p = false
    var requestId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialView()
    }
    
    func setUpInitialView() {
        if (!isOtp && !isComingFromP2p)
        {
        otpView.isHidden = true
        mainView.layer.cornerRadius = 10.0
        lastDigitsTextFields.delegate = self
        self.activateCard.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        let color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.lastDigitsTextFields.keyboardType = .numberPad
        self.lastDigitsTextFields.placeholder = "Enter Here*"
        lastDigitsTextFields.attributedPlaceholder = NSAttributedString(string: lastDigitsTextFields.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        }
        else if isOtp || isComingFromP2p {
            self.mainView.isHidden = true
            otpField.delegate = self
            self.otpVerfy.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
            let color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.otpField.keyboardType = .numberPad
            self.otpField.placeholder = "OTP"
            otpField.attributedPlaceholder = NSAttributedString(string: otpField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        }
    }
    
    
    @IBAction func activateCardButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if self.lastDigits.isEmpty {
            Global.showAlert(withMessage: "Enter the Last 4-Digits")
        } else {
            let proxyNumberLastCharacters = String(self.proxyNumber.suffix(4))
            if proxyNumberLastCharacters == self.lastDigits {
                if self.delegate != nil {
                    self.delegate.activateCardDetailsUpdate!(lastDigits: self.lastDigits, cardHashId: self.cardHashId)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                Global.showAlert(withMessage: "Wrong last 4 digits")
            }
        }
        
    }


    @IBAction func otpVerifAction(_ sender: UIButton) {

        if self.lastDigits.isEmpty {
            Global.showAlert(withMessage: "Please enter the otp!")
        }
        else {
            Alert.showProgressHud(onView: self.view)
            if isOtp { self.confirmAttribute() }
            else if isComingFromP2p {self.checkOtp(lastDigits)}
        }
    }

    func confirmAttribute() {
        Amplify.Auth.confirm(userAttribute: .phoneNumber, confirmationCode: lastDigits) { result in
            switch result {
            case .success:
                self.fetchUserAttributes()
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(error.errorDescription )",sender: self)
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
        self.delegate?.activateCardDetailsUpdate!(lastDigits: "", cardHashId: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true, completion: nil)
        }

    }

    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ActivateCardViewController: UITextFieldDelegate {
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_DIGITS = "1234567890"
        if textField == lastDigitsTextFields || textField == otpField {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }
                else if textField.text?.length ?? 0 > (isOtp ? 5 : 3) {
                    return false
                }
                else if (string == " ") {
                    return false
                }else {
                    let cs = NSCharacterSet(charactersIn: ACCEPTABLE_DIGITS).inverted
                    let filtered = string.components(separatedBy: cs).joined(separator: "")
                    return (string == filtered)
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.lastDigits = textField.text!
    }
}

extension ActivateCardViewController {

    func checkOtp(_ code:String){

        let url = "\(nexmo_check_url)api_key=\(nexmo_api_key)&api_secret=\(nexmo_secret_key)&request_id=\(requestId)&code=\(code)"

        WebServices.getRequest(urlString: url, isAuth: false, isWalletUser: false, xAPIKey: "") { (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if let status =  response["status"] as? String {
                        if status == "0"{
                            self.dissmissView(flas: true, message: "")

                        }
                        else {
                            self.dissmissView(flas: false, message: response["error_text"] as? String ?? "")
                        }
                    }
                    else {
                        self.dissmissView(flas: false, message: response["error_text"] as? String ?? "")
                    }

                }
                else{
                    self.dissmissView(flas: false, message: "Something went wrong!")
                }
            }
            else {
                let strError : String =  (error?.localizedDescription)!
                self.dissmissView(flas: false, message: strError)
            }
        }
    }

    func dissmissView(flas: Bool, message: String)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.dismiss(animated: true, completion: {
                self.delegate?.transferMoney?(flas: flas, message: message)
            })
        }

    }
}
