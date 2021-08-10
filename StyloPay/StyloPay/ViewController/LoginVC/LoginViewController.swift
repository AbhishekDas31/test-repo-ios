//
//  LoginViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify

class LoginViewController: UIViewController , UITextFieldDelegate{

    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> LoginViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! LoginViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var screenNameTitleLabel: UILabel!
    @IBOutlet weak var signupSubtitleLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailSeperatorView: UIView!
    @IBOutlet weak var passwordSeperateView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var emailAddress = ""
    var password = ""
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        configureTheme()
    }
    
    
    // MARK: - Methods or Functions
    //Method to configure Controller Labels
    func configureController(){
        self.navigationController?.navigationBar.isHidden = true
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.placeholder = "EMAIL"
        let color = theme.bottomUnselectedTabButtonColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.emailTextField.isSecureTextEntry = false
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.placeholder = "PASSWORD"
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func configureTheme(){
        emailTextField.textColor = theme.bottomUnselectedTabButtonColor
        passwordTextField.textColor = theme.bottomUnselectedTabButtonColor
        emailSeperatorView.backgroundColor = theme.bottomUnselectedTabButtonColor
        passwordSeperateView.backgroundColor = theme.bottomUnselectedTabButtonColor
        forgotPasswordButton.setTitleColor(theme.bottomUnselectedTabButtonColor, for: .normal)
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        screenNameTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        signupSubtitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        signUpButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
        signInButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let registerVC = RegisterViewController.storyboardInstance()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateSigninScreen(form: self, email: emailAddress, password: password){
            Alert.showProgressHud(onView: self.view)
            AmplifyManager.signIn(username: emailAddress, password: password, viewController: self, isNew: false, isAuthVerification: false)
        }
    }
    
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        let forgotPasswordVC = ForgotPasswordViewController.storyboardInstance()
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
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
        if textField == self.emailTextField {
            emailAddress = textField.text!
        } else if textField == self.passwordTextField {
            password = textField.text!
        }
    }
}

