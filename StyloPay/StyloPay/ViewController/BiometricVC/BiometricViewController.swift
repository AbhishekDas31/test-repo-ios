//
//  BiometricViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 12/11/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify
import LocalAuthentication

class BiometricViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> BiometricViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! BiometricViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var appNameTitleLabel: UILabel!
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var biometricImageView: UIImageView!
    @IBOutlet weak var biomtericButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    let theme = ThemeManager.currentTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        CustomUserDefaults.removeisKyc()
        self.configureTheme()
        if biometricType() == BiometricType.touch || biometricType() == BiometricType.face{
            //self.biometricImageView.image = theme.fingerPrintImage
            self.authenticationWithTouchID()
        } else {
            Constants.kAppDelegate?.setMainController()
            //self.biometricImageView.image = theme.fingerPrintImage
        }
        //self.authenticationWithTouchID()
    }
    
    func configureTheme(){
        self.navigationController?.navigationBar.isHidden = true
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        appNameTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        welcomeTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        logoutButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
        infoLabel.textColor = theme.bottomUnselectedTabButtonColor
        let email = CustomUserDefaults.getEmailID()
        self.welcomeTitleLabel.text = "Hi, \(email)"
        if biometricType() == BiometricType.touch {
            self.biometricImageView.image = theme.fingerPrintImage
        } else {
            self.biometricImageView.image = theme.fingerPrintImage
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        Global.showAlertWithTwoHandler(strMessage: "Do you want to logout?", strActionOne: "YES", strActionTwo: "NO", okBlock: {
            _ = Amplify.Auth.signOut() { result in
                switch result {
                case .success:
                    removeCredentials()
                    DispatchQueue.main.async {
                        Constants.kAppDelegate?.setControllers()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        Global.showAlert(withMessage: "\(error.errorDescription)", sender: self)
                    }
                }
            }
        }, cancelBlock: {})
    }
    
    @IBAction func biometricButtonPressed(_ sender: Any) {
        self.authenticationWithTouchID()
    }
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authorizationError: NSError?
        let reason = "Authentication is required to access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                if success {
                   AmplifyManager.getWalletAccessTokenFromLogin{ (isSuccess, error) in
                        debugPrint(isSuccess ?? false)
                    }
                    
//                    DispatchQueue.main.async() {
//                        Constants.kAppDelegate?.setMainController()
//                    }
                } else {
                    // Failed to authenticate
                    guard evaluateError != nil else {
                        return
                    }
                    print(evaluateError!)
                }
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            print(error)
            DispatchQueue.main.async {
                Global.showAlert(withMessage: "Kindly Enable Biometric Authentication", sender: self)
            }
//            DispatchQueue.main.async() {
//                Constants.kAppDelegate?.setMainController()
//            }
        }
    }
}

func biometricType() -> BiometricType {
    let authContext = LAContext()
    if #available(iOS 11, *) {
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        }
    } else {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
    }
}

enum BiometricType {
    case none
    case touch
    case face
}
