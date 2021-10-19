//
//  VerifyAccountViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify

class VerifyAccountViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> VerifyAccountViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! VerifyAccountViewController
    }
    @IBOutlet var superView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var appNameTitleLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var continueButton: UIButton!
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
  
    
    var emailAddress = ""
    var password = ""
    var mobileNumber = ""
    var walletUserName = ""
    var isdCode = ""
    var isForgotPassword = false
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTheme()
        
    }
    
    func configureTheme(){
        superView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        appNameTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        mainImageView.image = theme.buttonsBackgroundImage
        continueButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
       
        let label = UILabel()
        if isForgotPassword{
        label.isHidden = true
        }
        else{
        label.frame = CGRect(x: 180, y: 582, width: 200, height: 20)
        label.textColor = UIColor.white
        let attributedString = NSMutableAttributedString.init(string: "Resend OTP")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                    NSRange.init(location: 0, length: attributedString.length));
                label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
               label.addGestureRecognizer(guestureRecognizer)
                view.addSubview(label)
                self.view = view
        }
        
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
    
    @objc func labelClicked(_ sender: Any) {
      
        AmplifyManager.resendCode(username: emailAddress, viewController: self)
        
       }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        let otp = "\(self.firstDigitTextField.text ?? "")\(self.secondDigitTextField.text ?? "")\(self.thirdDigitTextField.text ?? "")\(self.fourthDigitTextField.text ?? "")\( self.fifthDigitTextField.text ?? "")\(self.sixthDigitTextField.text ?? "")".trimmingCharacters(in: .whitespaces)
        if ValidationHandler.validateVerifyAccount(form: self, otp: otp){
            if isForgotPassword{
                
                let newPasswordVC = NewPasswordViewController.storyboardInstance()
                newPasswordVC.otp = otp
                newPasswordVC.emailAddress = emailAddress
                self.navigationController?.pushViewController(newPasswordVC, animated: true)
            }else{
                Alert.showProgressHud(onView: self.view)
                AmplifyManager.confirmSignUp(for: emailAddress, with: otp, walletusername: walletUserName, viewController: self, password: password, isdCode: self.isdCode, mobileNumber: self.mobileNumber)
            }
            
        }
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
}
