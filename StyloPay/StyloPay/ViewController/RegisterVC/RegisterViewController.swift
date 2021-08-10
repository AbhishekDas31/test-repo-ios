//
//  RegisterViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify

class RegisterViewController: UIViewController, UITextFieldDelegate {
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> RegisterViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! RegisterViewController
    }

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryIsdcodeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameSeperatorView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailSeperatorView: UIView!
    @IBOutlet weak var mobileNumberSeperatorView: UIView!
    @IBOutlet weak var passwordSeperateView: UIView!
    @IBOutlet weak var confirmPasswordSeperateView: UIView!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    
    var emailaddress = ""
    var username = ""
    var mobileNumber = ""
    var isdCode = ""
    var password = ""
    var confirmPassword = ""
    let nationalityArr = ["SG","AU","DE","HK","IN","ID","JP","MY","KR","TW","TH","GB","US","VN"]
    let countryCodeArr = ["65","61","49","852","91","62","81","60","82","886","66","44","1","84"]
    let countryNameArr = ["Singapore","Australia","Germany","HongKong","India","Indonesia","Japan","Malaysia","South Korea","Taiwan","Thailand","United Kingdom","United States of America","Vietnam"]
    let countryFlagArr = ["singapore","australia","europe","hong-kong","india","indonesia","japan","malaysia","SKflag","taiwan","thailand","uk","usa","vietnam"]
    let codeArr = ["SGD","AUD","EUR","HKD","INR","IDR","JPY","MYR","KRW","TWD","THB","GBP","USD","VND"]
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        configureTheme()
    }
    
    // MARK: - Methods or Functions
    //Method to configure Controller Labels
    func configureController(){
        let color = theme.bottomUnselectedTabButtonColor
        self.navigationController?.navigationBar.isHidden = true
        self.usernameTextField.keyboardType = .default
        self.usernameTextField.placeholder = "USERNAME"
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.usernameTextField.isSecureTextEntry = false
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.placeholder = "EMAIL"
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.emailTextField.isSecureTextEntry = false
        
        self.mobileNumberTextField.keyboardType = .phonePad
        self.mobileNumberTextField.placeholder = "MOBILE NUMBER"
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: mobileNumberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.mobileNumberTextField.isSecureTextEntry = false
        
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.placeholder = "PASSWORD"
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.confirmPasswordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.placeholder = "CONFIRM PASSWORD"
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: confirmPasswordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        emailTextField.delegate = self
        usernameTextField.delegate = self
        mobileNumberTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        registerButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        signInButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
    }
    
    func configureTheme(){
        countryIsdcodeLabel.textColor = theme.bottomUnselectedTabButtonColor
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        alreadyAccountLabel.textColor = theme.bottomUnselectedTabButtonColor
        emailTextField.textColor = theme.bottomUnselectedTabButtonColor
        usernameTextField.textColor = theme.bottomUnselectedTabButtonColor
        mobileNumberTextField.textColor = theme.bottomUnselectedTabButtonColor
        passwordTextField.textColor = theme.bottomUnselectedTabButtonColor
        confirmPasswordTextField.textColor = theme.bottomUnselectedTabButtonColor
        emailSeperatorView.backgroundColor = theme.bottomUnselectedTabButtonColor
        usernameSeperatorView.backgroundColor = theme.bottomUnselectedTabButtonColor
        mobileNumberSeperatorView.backgroundColor = theme.bottomUnselectedTabButtonColor
        passwordSeperateView.backgroundColor = theme.bottomUnselectedTabButtonColor
        confirmPasswordSeperateView.backgroundColor = theme.bottomUnselectedTabButtonColor
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateRegisterationForm(form: self, email: self.emailaddress, password: password, confirmPassword: confirmPassword, mobileNumber: mobileNumber, username: self.emailaddress, isdcode: isdCode) {
            Alert.showProgressHud(onView: self.view)
//            let isdcode = isdCode.trimmingCharacters(in: .whitespaces)
            AmplifyManager.register(username: emailaddress, walletusername: self.emailaddress, password: password, email: emailaddress, isdCode: isdCode, mobileNumber: mobileNumber, viewController: self)
            //AmplifyManager.register(username: emailaddress, password: password, email: emailaddress, viewController: self)
        }
    }
    
    @IBAction func countrySelectorButtonPressed(_ sender: Any) {
        let countryCodeVC = CountryPopUpViewController.storyboardInstance()
        countryCodeVC.modalPresentationStyle = .overCurrentContext
        countryCodeVC.countryNameArray = countryList//self.countryNameArr
       // countryCodeVC.countryFlagArray = countryFlags//self.countryFlagArr
        countryCodeVC.delegate = self
        self.navigationController?.present(countryCodeVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.usernameTextField {
            username = textField.text!
        } else if textField == self.emailTextField {
            emailaddress = textField.text!
        } else if textField == self.mobileNumberTextField {
            mobileNumber = textField.text!
        } else if textField == self.passwordTextField {
            password = textField.text!
        } else if textField == self.confirmPasswordTextField {
            confirmPassword = textField.text!
        }
    }
}

extension RegisterViewController: CountryCodeDelegate {
    func tabCountryCode(country: String, row: Int) {
        let imageName = "\(countryFlags[row])"
        let countryCode = "\(countryCodeList[row])"
        self.countryFlagImageView.image = UIImage(named: imageName)
        self.countryIsdcodeLabel.text = "+ \(countryCode)"
        self.isdCode = "\(countryCode)"
    }
}
