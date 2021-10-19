//
//  AppDelegate.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 09/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import Amplify
import AmplifyPlugins
import MFSideMenu
import LocalAuthentication

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var nav:UINavigationController?
    var sideMenu : MFSideMenuContainerViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use the Firebase library to configure APIs.
        IQKeyboardManager.shared.enable = true
        let currentTheme = ThemeManager.currentTheme()
        ThemeManager.applyTheme(theme: currentTheme)
       // FirebaseApp.configure()
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
        } catch {
            debugPrint("Failed to initialize Amplify with \(error)")
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        if window != nil {
            setControllers()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // MARK: - Method to set controllers.
    func setControllers() {
        //If user has already tapped Skip/Register Now/ Sign In Button on the Onboarding Screen or when the user has logged out whenever the app is opened the next time, then, Login Screen is Set. Else if user hasn't tapped Get Started the On Boarding screen is set.
        //If logged in, Biometric Authentication is enabled.
        if CustomUserDefaults.getisBoardingScreenSkipped() {
            //If user is logged in the main contollers
            if CustomUserDefaults.getisLoggedIn() {
                if KeychainService.loadPassword(service: service, account: account) != nil {
                    let biometricVC = BiometricViewController.storyboardInstance()
                    nav = UINavigationController(rootViewController: biometricVC)
                    window?.rootViewController = nav
                    window?.makeKeyAndVisible()
                    //self.authenticationWithTouchID()
                } else {
                    let loginVC = LoginViewController.storyboardInstance()
                    nav = UINavigationController(rootViewController: loginVC)
                    window?.rootViewController = nav
                    window?.makeKeyAndVisible()
                }

            } else {
                let loginVC = LoginViewController.storyboardInstance()
                nav = UINavigationController(rootViewController: loginVC)
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
            }
            
        } else {
            let onBoardingVC = OnboardingViewController.storyboardInstance()
            nav = UINavigationController(rootViewController: onBoardingVC)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - Method to set main controllers after user has logged in or when app is opened via shared link.
    func setMainController(animated: Bool = true) {
        let manageCardVC = ManageMyCardViewController.storyboardInstance()
        self.nav = UINavigationController(rootViewController: manageCardVC)
        let leftVC:UIViewController = SideMenuViewController.storyboardInstance()
        let navS = UINavigationController(rootViewController: leftVC)
        let sideMenuLeft: MFSideMenuContainerViewController = MFSideMenuContainerViewController.container(withCenter: self.nav, leftMenuViewController: navS, rightMenuViewController: nil)
        sideMenuLeft.panMode = MFSideMenuPanMode(rawValue: MFSideMenuPanModeNone.rawValue)
        self.sideMenu = sideMenuLeft
        window?.rootViewController = self.sideMenu
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authorizationError: NSError?
        let reason = "Authentication required to access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                if success {
                   AmplifyManager.getWalletAccessToken{ (isSuccess, error) in
                        debugPrint(isSuccess ?? false)
                    }
                    
                    DispatchQueue.main.async() {
                        self.setMainController()
                    }
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
        }
    }
}
