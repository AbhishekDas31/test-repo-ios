//
//  CardReplaceOverlayViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 07/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol CardReplaceDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func cardReplace(cardHashId: String, maskedCardNumber: String)
}

class CardReplaceOverlayViewController: UIViewController,UITextFieldDelegate {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> CardReplaceOverlayViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! CardReplaceOverlayViewController
    }

    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var modalView: UIView!
    
    let customerHashID = CustomUserDefaults.getCustomerHashId()
    let walletHashID = CustomUserDefaults.getwalletHashId()
    var maskedCardNumber = ""
    let theme = ThemeManager.currentTheme()
    var cardHashId = ""
    weak var delegate: CardReplaceDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirgureTextFields()
        okayButton.setBackgroundImage(theme.borderColorImage, for: .normal)
        modalView.layer.cornerRadius = 10.0
    }
    
    func confirgureTextFields(){
        monthTextField.delegate = self
        yearTextField.delegate = self
        monthTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        yearTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.utf16.count == 2 {
            switch textField {
            case monthTextField:
                yearTextField.becomeFirstResponder()
            case yearTextField:
                yearTextField.resignFirstResponder()
            default:
                break
            }
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okayButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        let month = self.monthTextField.text ?? ""
        let monthInt = Int(month) ?? 0
        let year = self.yearTextField.text ?? ""
        let expiryDate = "\(month)\(year)".trimmingCharacters(in: .whitespaces)
        print(expiryDate.length)
        if expiryDate.isEmpty {
            Global.showAlert(withMessage: "Expiry Date can't be blank", sender: self)
        } else if monthInt < 1 || monthInt > 12{
            Global.showAlert(withMessage: "Enter a valid month", sender: self)
        } else if expiryDate.length != 4{
            Global.showAlert(withMessage: "Enter a valid expiry date", sender: self)
        } else {
            self.replaceCard(cardExpiry: expiryDate)
        }
    }
}

extension CardReplaceOverlayViewController{
    
    func replaceCard(cardExpiry: String){
        Alert.showProgressHud(onView: self.view)
        let strUrl = "\(mainUrl)/api/v1/issueReplace/\(customerHashID)/\(walletHashID)/\(cardHashId)"
        let parameters = [ "cardFeeCurrencyCode": "SGD",
        "cardExpiry": "\(cardExpiry)"]
        WebServices.postRequest(urlString: strUrl, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject, stringResponse, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject {
                    if (response["errors"] != nil) {
                        if let message = response["message"] as? String {
                            Global.showAlert(withMessage: "\(message)", sender: self)
                        }
                    } else {
                        debugPrint("response:  \(response)")
                        if let cardHashId = response["cardHashId"] as? String{
                            self.cardHashId = cardHashId
                        }
                        if let maskedCardNumber = response["maskedCardNumber"] as? String{
                            self.maskedCardNumber = maskedCardNumber
                        }
                        if self.delegate != nil { self.delegate.cardReplace(cardHashId: self.cardHashId, maskedCardNumber: self.maskedCardNumber)}
                        self.dismiss(animated: true, completion: nil)
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
