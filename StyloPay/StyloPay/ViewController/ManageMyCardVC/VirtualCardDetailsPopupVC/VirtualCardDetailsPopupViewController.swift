//
//  VirtualCardDetailsPopupViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 08/01/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol AddOnCardDetilsDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func addonCardDetailsUpdate(firstName: String, middleName: String, lastname: String, emailId: String, mobileNumber:String, code: String)
}

class VirtualCardDetailsPopupViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> VirtualCardDetailsPopupViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! VirtualCardDetailsPopupViewController
    }

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var fNameTextfield: UITextField!
    @IBOutlet weak var mNameTextfield: UITextField!
    @IBOutlet weak var lNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var mobileNumberTextfield: UITextField!
    @IBOutlet weak var addCardButton: UIButton!
    
    var firstName = ""
    var middleName = ""
    var lastname = ""
    var emailId = ""
    var mobileNumber = ""
    var code = ""
    var nationality = ""
    let nationalityArr = ["SG","AU","DE","HK","IN","ID","JP","MY","KR","TW","TH","GB","US","VN"]
    let countryCodeArr = ["65","61","49","852","91","62","81","60","82","886","66","44","1","84"]
    weak var delegate: AddOnCardDetilsDelegate!
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialView()
    }
    
    func setUpInitialView() {
        mainView.layer.cornerRadius = 10.0
        fNameTextfield.delegate = self
        lNameTextfield.delegate = self
        mNameTextfield.delegate = self
        emailTextfield.delegate = self
        mobileNumberTextfield.delegate = self
        self.codeHandling()
        self.addCardButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        let color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        self.fNameTextfield.keyboardType = .default
        self.fNameTextfield.placeholder = "FIRSTNAME*"
        fNameTextfield.attributedPlaceholder = NSAttributedString(string: fNameTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.lNameTextfield.keyboardType = .default
        self.lNameTextfield.placeholder = "LASTNAME*"
        lNameTextfield.attributedPlaceholder = NSAttributedString(string: lNameTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.mNameTextfield.keyboardType = .default
        self.mNameTextfield.placeholder = "MIDDLENAME"
        mNameTextfield.attributedPlaceholder = NSAttributedString(string: mNameTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.emailTextfield.keyboardType = .emailAddress
        self.emailTextfield.placeholder = "EMAIL"
        emailTextfield.attributedPlaceholder = NSAttributedString(string: emailTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.mobileNumberTextfield.keyboardType = .numberPad
        self.mobileNumberTextfield.placeholder = "MOBILE NUMBER*"
        mobileNumberTextfield.attributedPlaceholder = NSAttributedString(string: mobileNumberTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func codeHandling() {
        for index in 0..<self.nationalityArr.count {
            if nationalityArr[index] == self.nationality {
                self.code = self.countryCodeArr[index]
                self.countryCodeLabel.text = "+ \(self.code)"
                break
            }
        }
    }
    
    @IBAction func addCardButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateAddonDetaildPopupScreen(form: self, firstName: self.firstName, lastName: self.lastname, emailId: self.emailId, mobileNumber: self.mobileNumber) {
            if self.delegate != nil {
                self.delegate.addonCardDetailsUpdate(firstName: self.firstName, middleName: self.middleName, lastname: self.lastname, emailId: self.emailId, mobileNumber: self.mobileNumber, code: self.code)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissViewPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension VirtualCardDetailsPopupViewController: UITextFieldDelegate {
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let ACCEPTABLE_DIGITS = "1234567890"
        if textField == fNameTextfield || textField == lNameTextfield || textField == mNameTextfield {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                } else if textField.text?.length ?? 0 > 19 {
                    return false
                } else {
                    let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                    let filtered = string.components(separatedBy: cs).joined(separator: "")
                    return (string == filtered)
                }
            }
        }else if textField == mobileNumberTextfield {
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
        } else if textField == emailTextfield {
            if (string == " ") {
                return false
            }
            return true
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fNameTextfield {
            self.firstName = textField.text!
        } else if textField == mNameTextfield {
            self.middleName = textField.text!
        } else if textField == lNameTextfield{
            self.lastname = textField.text!
        } else if textField == emailTextfield {
            self.emailId = textField.text!
        } else if textField == mobileNumberTextfield {
            self.mobileNumber = textField.text!
        }
    }
}
