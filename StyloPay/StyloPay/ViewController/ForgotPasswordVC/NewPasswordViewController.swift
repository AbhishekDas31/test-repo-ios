//
//  NewPasswordViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 01/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class NewPasswordViewController: UIViewController, UITextFieldDelegate {

    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> NewPasswordViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! NewPasswordViewController
    }
    
    var newPassword = ""
    var confirmPassword = ""
    var otp = ""
    var emailAddress = ""
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var firstLineSeperatorView: UIView!
    @IBOutlet weak var secondLineSeperatorView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        newPasswordTextField.placeholder = "NEW PASSWORD"
        let color = theme.bottomUnselectedTabButtonColor
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: newPasswordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.delegate = self
        
        confirmPasswordTextField.placeholder = "CONFIRM PASSWORD"
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: confirmPasswordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.delegate = self
        configureTheme()
    }
    
    func configureTheme(){
        mainview.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        newPasswordTextField.textColor = theme.bottomUnselectedTabButtonColor
        confirmPasswordTextField.textColor = theme.bottomUnselectedTabButtonColor
        firstLineSeperatorView.backgroundColor = theme.bottomUnselectedTabButtonColor
        secondLineSeperatorView.backgroundColor = theme.bottomUnselectedTabButtonColor
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        submitButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
    }
    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.newPasswordTextField {
            newPassword = textField.text!
        } else if textField == self.confirmPasswordTextField {
            confirmPassword = textField.text!
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        if ValidationHandler.validateResetPasswordScreen(form: self, password: newPassword, confirmPassword: confirmPassword){
            Alert.showProgressHud(onView: self.view)
            AmplifyManager.confirmResetPassword(username: emailAddress, newPassword: newPassword, confirmationCode: otp, viewController: self)
        }
    }

}
