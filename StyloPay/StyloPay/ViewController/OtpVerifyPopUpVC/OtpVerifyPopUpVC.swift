//
//  OtpVerifyPopUpVC.swift
//  StyloPay
//
//  Created by Abhishek das on 08/09/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify
protocol OtpDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    //func addonCardDetailsUpdate(firstName: String, middleName: String, lastname: String, emailId: String, mobileNumber:String, code: String)
}
class OtpVerifyPopUpVC: UIViewController , UITextFieldDelegate {
    
    static func storyboardInstance() -> OtpVerifyPopUpVC {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! OtpVerifyPopUpVC
    }

    @IBOutlet var mainView: UIView!
    
    @IBOutlet var button: UIButton!
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    var otp = ""
    var emailAddress = ""
    var password = ""
    var mobileNumber = ""
    var walletUserName = ""
    var isdCode = ""
    var isForgotPassword = false
    weak var delegate: OtpDelegate!
    let theme = ThemeManager.currentTheme()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialView()
    }
    
    func setUpInitialView() {
        mainView.layer.cornerRadius = 10.0
        otpTextField.delegate = self
        
        self.submitButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        let color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        self.otpTextField.keyboardType = .numberPad
        self.otpTextField.placeholder = "ENTER OTP"
        otpTextField.attributedPlaceholder = NSAttributedString(string: otpTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    @IBAction func dismissViewPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.otpTextField {
            otp = textField.text!
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateOtpPopUpScreen(from: self, otp: otp){
            
            Alert.showProgressHud(onView: self.view)
            AmplifyManager.confirmOtpVerification(for: emailAddress, with: otp, walletusername: walletUserName, viewController: self, password: password, isdCode: self.isdCode, mobileNumber: self.mobileNumber)
            
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Self.otpWillDismissNotification, object: nil)
        }
        
        
        
        
    }
    
    
    static let otpWillDismissNotification = Notification.Name(rawValue: "otpWillDismissNotification")
}



