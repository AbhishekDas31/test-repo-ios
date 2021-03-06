//
//  ForgotPasswordViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 01/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ForgotPasswordViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ForgotPasswordViewController
    }
    
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var appNameTitleLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var lineSeperatorView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet var labelMsg: UILabel!
    var emailAddress = ""
    
    let theme = ThemeManager.currentTheme()
    var otpObservation : NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        otpObservation = NotificationCenter.default.addObserver(forName: OtpVerifyPopUpVC.otpWillDismissNotification, object: nil, queue: .main) { _ in
            self.labelMsg.isHidden=false
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        configureTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureTheme(){
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "EMAIL"
        let color = theme.bottomUnselectedTabButtonColor
        emailTextField.textColor = color
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.backButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
        self.emailTextField.isSecureTextEntry = false
        emailTextField.delegate = self
        mainview.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        appNameTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        lineSeperatorView.backgroundColor = theme.bottomUnselectedTabButtonColor
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        submitButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        labelMsg.isHidden=true
    }
    
    @IBAction func backToSignIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitEmailAddressPressed(_ sender: Any) {
        self.view.endEditing(true)
        if ValidationHandler.validateForgotPasswordScreen(form: self, email: self.emailAddress){
            Alert.showProgressHud(onView: self.view)
            AmplifyManager.resetPassword(username: emailAddress, viewController: self)
        }
    }
    
    
    

    
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTextField {
            emailAddress = textField.text!
        }
    }
    
    
}

//extension ForgotPasswordViewController: OtpDelegate {
//    func messageDisplay(status: String) {
//        if status == "done"{
//            
//            labelMsg.isHidden=false
//            
//        }
//        
////            let imageName = "\(countryFlags[row])"
////            let countryCode = "\(countryCodeList[row])"
////            self.countryFlagImageView.image = UIImage(named: imageName)
////            self.countryIsdcodeLabel.text = "+ \(countryCode)"
////            self.isdCode = "\(countryCode)"
//    }
//}
