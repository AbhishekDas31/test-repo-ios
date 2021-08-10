//
//  AssignedCardDetailsViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 08/01/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol AssignedCardDetilsDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func assignedCardDetailsUpdate(accountNumber: String, lastDigits: String)
}

class AssignedCardDetailsViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> AssignedCardDetailsViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! AssignedCardDetailsViewController
    }

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var lastDigitsTextfield: UITextField!
    @IBOutlet weak var addCardButton: UIButton!
    
    
    let theme = ThemeManager.currentTheme()
    weak var delegate: AssignedCardDetilsDelegate!
    var accountNumber = ""
    var lastDigits = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialView()
    }
    
    func setUpInitialView() {
        mainView.layer.cornerRadius = 10.0
        accountNumberTextField.delegate = self
        lastDigitsTextfield.delegate = self
        self.addCardButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        let color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.accountNumberTextField.keyboardType = .numberPad
        self.accountNumberTextField.placeholder = "ACCOUNT NUMBER*"
        accountNumberTextField.attributedPlaceholder = NSAttributedString(string: accountNumberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.lastDigitsTextfield.keyboardType = .numberPad
        self.lastDigitsTextfield.placeholder = "CARD LAST 4-DIGITS*"
        lastDigitsTextfield.attributedPlaceholder = NSAttributedString(string: lastDigitsTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    
    @IBAction func addCardButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateAsignedDetaildPopupScreen(form: self, accountNumber: self.accountNumber, lastDigits: self.lastDigits) {
            if self.delegate != nil {
                self.delegate.assignedCardDetailsUpdate(accountNumber: self.accountNumber, lastDigits: self.lastDigits)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func dismissViewPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AssignedCardDetailsViewController: UITextFieldDelegate {
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_DIGITS = "1234567890"
        if textField == accountNumberTextField {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                } else if textField.text?.length ?? 0 > 19 {
                    return false
                } else if (string == " ") {
                    return false
                } else {
                    let cs = NSCharacterSet(charactersIn: ACCEPTABLE_DIGITS).inverted
                    let filtered = string.components(separatedBy: cs).joined(separator: "")
                    return (string == filtered)
                }
            }
       }else if textField == lastDigitsTextfield {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                } else if textField.text?.length ?? 0 > 3 {
                    return false
                } else if (string == " ") {
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
        if textField == accountNumberTextField {
            self.accountNumber = textField.text!
        } else if textField == lastDigitsTextfield {
            self.lastDigits = textField.text!
        }
    }
}
