//
//  AmplifyManager.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 14/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify
import Alamofire
import LocalAuthentication


class AmplifyManager: NSObject {
    
    
    
    
    class func mailVerify(email : String , viewController: UIViewController , completionHandler: @escaping (_ responseValue: Dictionary<String,Any>?, _ isError: String?) -> ()){
        let strtUrl = "\(baseUrl)/api/v1/AuthServices/adminUpdateUserAttributes"
        var semaphore = DispatchSemaphore (value: 0)
        let parameters = "{\n    \n\t\"email\": \"\(email)\",\n   \"clientId\": \"37384mi68cfm440mc377b7tpii\",\n\t\"userPoolId\": \"eu-west-1_JAFQFM1IJ\",\n\t\n    \"customAttributes\": {\n         \n        \"email_verified\":\"true\"\n    }\n}"
        
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: strtUrl )!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            
            do {
                
                if let responseJson = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                {
                    debugPrint("User Attribute Response++++++++++",responseJson)
                   completionHandler(responseJson , "")
                  
                    
                    let metaData = responseJson["sdkHttpMetadata"] as? Dictionary<String,Any>
                    debugPrint("MetaData+++++++++",metaData)
                    let statusCode = metaData?["httpStatusCode"] as? Int
                    debugPrint("status+++++++++",statusCode as Any)
                    
                    if statusCode == 200{
                        AmplifyManager.resetPassword(username: email, viewController: viewController)
                    }
                    
                }

          }
            catch _ as NSError {
                        
                    }
    }
       // task.resume()
    
    }
    
    
    
    
    
    class func mobileCheck(username: String, walletusername: String, password: String, email: String, isdCode: String, mobileNumber: String, viewController: UIViewController,completionHandler: @escaping (_ responseValue: Dictionary<String,Any>?, _ isError: String?) -> ()){
        let strtUrl = "\(baseUrl)/api/v1/AuthServices/listUsers"

        var semaphore = DispatchSemaphore (value: 0)
        let parameters = "{\r\n    \"userPoolId\": \"eu-west-1_JAFQFM1IJ\",\r\n    \"phoneNumber\": \"+\(isdCode)\(mobileNumber)\",\r\n    \"email\": \"\",\r\n    \"paginationToken\":\"\"\r\n    \r\n}"
        
        let postData = parameters.data(using: .utf8)
        debugPrint("walletParam++++++++++++++++++++++++++",parameters,strtUrl)
        //let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: strtUrl)!,timeoutInterval: Double.infinity)


        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {

            debugPrint(String(describing: error))
            semaphore.signal()
            return
        }
            do {
                            if let response = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                            {
                                completionHandler(response , "")
                             

                            }

                      }
                catch _ as NSError {
                            
                        }

                    }
                    task.resume()
       // semaphore.wait()
                }

    
    class func register(username: String, walletusername: String, password: String, email: String, isdCode: String, mobileNumber: String, viewController: UIViewController) {
        //  let userAttributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.phoneNumber, value: "+\(isdCode)\(mobileNumber)"), AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:isd_code"), value: "+\(isdCode)"), AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:walletusername"), value: "\(email)"), AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:application_name"), value: "\(Constants.kAppDisplayName)")]
        let userAttributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.phoneNumber, value: "+\(isdCode)\(mobileNumber)"), AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:isd_code"), value: "+\(isdCode)"), AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:application_name"), value: "\(Constants.kAppDisplayName)"), AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:agent_code"), value: "\(Constants.agentValue)"), AuthUserAttribute(AuthUserAttributeKey(rawValue: "custom:subagent_code"), value: "\(Constants.subAgentValue)")]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        
        _ = Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case .confirmUser(_, _) = signUpResult.nextStep {
                    DispatchQueue.main.async {
                        Alert.hideProgressHud(onView: viewController.view)
                        let verifyAccountVC = VerifyAccountViewController.storyboardInstance()
                        verifyAccountVC.emailAddress = email
                        verifyAccountVC.mobileNumber = mobileNumber
                        verifyAccountVC.walletUserName = walletusername
                        verifyAccountVC.isdCode = isdCode
                        verifyAccountVC.password = password
                        viewController.navigationController?.pushViewController(verifyAccountVC, animated: true)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: viewController.view)
                    Global.showAlert(withMessage: "\(error.errorDescription)", sender: viewController)
                }
            }
        }
    }
    
    
    class func confirmOtpVerification(for username: String, with confirmationCode: String, walletusername: String, viewController: UIViewController, password: String, isdCode: String, mobileNumber: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(_):
                
            
                    let verifyAccountVC = OtpVerifyPopUpVC.storyboardInstance()
                  
                    verifyAccountVC.dismiss(animated: true, completion: nil)
                    
                NotificationCenter.default.post(name: OtpVerifyPopUpVC.otpWillDismissNotification, object: nil)
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: viewController.view)
                    Global.showAlert(withMessage: "\(error.errorDescription)", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                        Constants.kAppDelegate?.setControllers()
                    })
                }
            }
        }
    }
    
    
    
    
    class func confirmSignUp(for username: String, with confirmationCode: String, walletusername: String, viewController: UIViewController, password: String, isdCode: String, mobileNumber: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    //Alert.hideProgressHud(onView: viewController.view)
                    Global.showAlert(withMessage: "Registered Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                        CustomUserDefaults.isLoggedIn(data: true)
                        CustomUserDefaults.setEmailID(data: username)
                        CustomUserDefaults.setMobileNumber(data: mobileNumber)
                        // CustomUserDefaults.setWalletUsername(data: walletusername)
                        CustomUserDefaults.setIsdCode(data: isdCode)
                        KeychainService.savePassword(service: service, account: account, data: password)
                        Alert.hideProgressHud(onView: viewController.view)
                        AmplifyManager.getWalletAccessToken{(isSuccess, error) in
                            debugPrint(isSuccess ?? false)
                        }
                        let accountActivationVC = AccountActivationViewController.storyboardInstance()
                        CustomUserDefaults.setisAuth(data: false)
                        viewController.navigationController?.pushViewController(accountActivationVC, animated: true)
                    })
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: viewController.view)
                    Global.showAlert(withMessage: "\(error.errorDescription)", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                        Constants.kAppDelegate?.setControllers()
                    })
                }
            }
        }
    }
    
    
    class func signIn(username: String, password: String, viewController: UIViewController, isNew: Bool, isAuthVerification:Bool) {
        _ = Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(let successresponse):
                DispatchQueue.main.async {
                    debugPrint("\(successresponse.nextStep)")
                    switch successresponse.nextStep {
                    case .done:
                        CustomUserDefaults.isLoggedIn(data: true)
                        CustomUserDefaults.setEmailID(data: username)
                        KeychainService.savePassword(service: service, account: account, data: password)
                        
                        if isNew{
                            Alert.hideProgressHud(onView: viewController.view)
                            let accountActivationVC = AccountActivationViewController.storyboardInstance()
                            CustomUserDefaults.setisAuth(data: false)
                            viewController.navigationController?.pushViewController(accountActivationVC, animated: true)
                        }else{
                            AmplifyManager.fetchUserAttributes(viewcontroller: viewController)
                        }
                        break
                    case .confirmSignUp(_):
                        
                       // AmplifyManager.resendCode(email: "adas31@yopmail.com")
                        
                      Alert.hideProgressHud(onView: viewController.view)
                        DispatchQueue.main.async {
                            Global.showAlert(withMessage: "Account Not verified.\n Kindly verify first to proceed", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                AmplifyManager.resendCode(username : username, viewController: viewController)

                                let verifyAccountVC = VerifyAccountViewController.storyboardInstance()


                                //AmplifyManager.resendCode()
                                verifyAccountVC.emailAddress = username
                                verifyAccountVC.password = password
                                viewController.navigationController?.pushViewController(verifyAccountVC, animated: true)
                            })
                        }
                        break
                    case .confirmSignInWithSMSMFACode(_, _):
                        break
                    case .confirmSignInWithCustomChallenge(_):
                        break
                    case .confirmSignInWithNewPassword(_):
                        break
                    case .resetPassword(_):
                        break
                    }//close async
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: viewController.view)
                    Global.showAlert(withMessage: "\(error.errorDescription)", setTwoButton: false, setFirstButtonTitle: error.errorDescription == "There is already a user which is signed in. Please log out the user before calling showSignIn." ? "LOGOUT":"OK", setSecondButtonTitle: "", handler: { (action) in
                        if error.errorDescription == "There is already a user which is signed in. Please log out the user before calling showSignIn."
                        {
                            AmplifyManager.logOutfromUninstall(viewController)
                        }
                        else {
                            if isAuthVerification {
                                CustomUserDefaults.isLoggedIn(data: false)
                                removeCredentials()
                                Constants.kAppDelegate?.setControllers()
                            }
                        }
                    })
                }
                
            }
        }
    }

    class func logOutfromUninstall(_ viewController: UIViewController)
    {
        _ = Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                removeCredentials()
                DispatchQueue.main.async {
                    Constants.kAppDelegate?.setControllers()
                }
            case .failure(let error):
                debugPrint("\(error.errorDescription)")
                DispatchQueue.main.async {
                    Global.showAlert(withMessage: "\(error.errorDescription)", sender: viewController)
                }
            }
        }
    }

    
    class func nonAuthorisedUserHandling(viewcontroller:UIViewController) {
        Global.showAlert(withMessage: "Wrong Program! Please contact your Admin", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
            _ = Amplify.Auth.signOut() { result in
                switch result {
                case .success:
                    removeCredentials()
                    DispatchQueue.main.async {
                        Constants.kAppDelegate?.setControllers()
                    }
                case .failure(let error):
                    debugPrint("\(error.errorDescription)")
                }
            }
        })
    }
    
    class func authorisedUserHandling(isdCode: String, mobileNumber: String , phone_number_verified:String) {
        Global.showAlert(withMessage: "Logged In Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
            CustomUserDefaults.isLoggedIn(data: true)
            //CustomUserDefaults.setWalletUsername(data: walletUsername)
            let isdCodeLength = isdCode.length
            let isdCodeValue = String(isdCode.dropFirst())
            let phoneNumber = String(mobileNumber.dropFirst(isdCodeLength))
            CustomUserDefaults.setMobileNumber(data: phoneNumber)
            CustomUserDefaults.setPhoneNumberVerified(data:phone_number_verified != "false")
            CustomUserDefaults.setIsdCode(data: isdCodeValue)
            AmplifyManager.authenticationWithTouchID()
        })
    }
    
    class func fetchUserAttributes(viewcontroller: UIViewController) {
        //Amplify.Auth.resendConfirmationCode(for: AuthUserAttributeKey.phoneNumber, listener: <#T##((AmplifyOperation<AuthAttributeResendConfirmationCodeRequest, AuthCodeDeliveryDetails, AuthError>.OperationResult) -> Void)?##((AmplifyOperation<AuthAttributeResendConfirmationCodeRequest, AuthCodeDeliveryDetails, AuthError>.OperationResult) -> Void)?##(AmplifyOperation<AuthAttributeResendConfirmationCodeRequest, AuthCodeDeliveryDetails, AuthError>.OperationResult) -> Void#>);

    //    Amplify.Auth.update(userAttributes: [AuthUserAttributeKey.custom("custom:isd_code"),""], options: <#T##AuthUpdateUserAttributesRequest.Options?#>) aws update while sync

        // otp verification
      //  Amplify.Auth.confirm(userAttribute: AuthUserAttributeKey.phoneNumber, confirmationCode: //"otp", listener: <#T##((AmplifyOperation<AuthConfirmUserAttributeRequest, Void, AuthError>.OperationResult) -> Void)?##((AmplifyOperation<AuthConfirmUserAttributeRequest, Void, AuthError>.OperationResult) -> Void)?##(AmplifyOperation<AuthConfirmUserAttributeRequest, Void, AuthError>.OperationResult) -> Void#>) >>>>>>>>> Fetch attrivute

        _ = Amplify.Auth.fetchUserAttributes { result in
            switch result {
            case .success(let session):
                var dataDictionary: [String: Any] = [:]
                for items in session{
                    dataDictionary.updateValue(items.value, forKey: "\(items.key.rawValue)")
                }
//                DispatchQueue.main.async {
//                    Alert.hideProgressHud(onView: viewcontroller.view)
//                    AmplifyManager.authorisedUserHandling(isdCode: dataDictionary["custom:isd_code"] as? String ?? "", mobileNumber: dataDictionary["phone_number"] as? String ?? "",phone_number_verified: dataDictionary["phone_number_verified"] as? String ?? "false")
//                    //phone_number_verified
//
//                }
                if let agentCode = dataDictionary["custom:agent_code"] as? String ,
                                   let subAgentCode = dataDictionary["custom:subagent_code"] as? String {
                                    if (agentCode == Constants.agentValue && subAgentCode == Constants.subAgentValue )  || (agentCode == "000" && subAgentCode == "0") || (agentCode == "" && subAgentCode == "") {

                                        DispatchQueue.main.async {
                                            Alert.hideProgressHud(onView: viewcontroller.view)
                                            AmplifyManager.authorisedUserHandling(isdCode: dataDictionary["custom:isd_code"] as? String ?? "", mobileNumber: dataDictionary["phone_number"] as? String ?? "", phone_number_verified: "false")

                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            Alert.hideProgressHud(onView: viewcontroller.view)
                                            AmplifyManager.nonAuthorisedUserHandling(viewcontroller: viewcontroller)
                                        }
                                    }
                                }
                else {
                    DispatchQueue.main.sync {
                        Alert.hideProgressHud(onView: viewcontroller.view)
                        AmplifyManager.authorisedUserHandling(isdCode: dataDictionary["custom:isd_code"] as? String ?? "", mobileNumber: dataDictionary["phone_number"] as? String ?? "", phone_number_verified: "false")
                    }
                }
            case .failure( _):
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: viewcontroller.view)
                }
            }
        }
    }
    
    
    class func resendCode1resend(username : String , viewController: UIViewController) {
        
        _ = Amplify.Auth.resendSignUpCode(for: username) { result in
            switch result {
            case .success(let deliveryDetails):
                DispatchQueue.main.async() {
                print("Resend code send to - \(deliveryDetails)")
                Global.showAlert(withMessage: "Email not verfied! Click on 'OK' to verify Email", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                    
                    let otpVC = OtpVerifyPopUpVC.storyboardInstance()
                    otpVC.modalPresentationStyle = .overCurrentContext
                   
                    otpVC.isForgotPassword = true
                    otpVC.emailAddress = username
                    viewController.navigationController?.present(otpVC, animated: true)
                    
                    
                })
                }
                
            case .failure(let error):
                
               
                debugPrint("Resend code failed with error \(error.errorDescription)")
                
                if error.errorDescription == "User is already confirmed."{
                    
                    debugPrint("HelloWorld")
                    
                    AmplifyManager.mailVerify(email: username , viewController: viewController, completionHandler: { (stringResponse, error) in
                        
                        debugPrint("stringResponse+++++++++++++++++++++",stringResponse)
                        })
                    
                   
                }
                    
                else{
                    
                    debugPrint("ByeWorld")
                }
                    
                }
                    }
            
       }
    //generic
    class func resendCode(username : String , viewController: UIViewController) {
        
        _ = Amplify.Auth.resendSignUpCode(for: username) { result in
            switch result {
            case .success(let deliveryDetails):
                DispatchQueue.main.async() {
                Global.showAlert(withMessage: "OTP sent in Emil", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                
                print("Resend code send to - \(deliveryDetails)")
                
                })
                }
            case .failure(let error):
                
               
                debugPrint("Resend code failed with error \(error.errorDescription)")
                
              
                    
                }
                    }
            
       }
    
    
    class func authenticationWithTouchID() {
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
                    

                } else {
                    // Failed to authenticate
                    guard evaluateError != nil else {
                        return
                    }
                    DispatchQueue.main.async() {
                        Constants.kAppDelegate?.setControllers()
                    }
                    print(evaluateError?.localizedDescription)
                }
            }
        } else {
            guard let error = authorizationError else {
                return
            }
            print(error)
            DispatchQueue.main.async {
                Global.showAlert(withMessage: "Kindly Enable Biometric Authentication", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                    Constants.kAppDelegate?.setControllers()
                })

                //Global.showAlert(withMessage: "Kindly Enable Biometric Authentication")
            }
        }
    }
    
    
    class func resetPassword(username: String, viewController: UIViewController) {
        
        _ = Amplify.Auth.resetPassword(for: username) { result in
            
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                
                
                
                case .confirmResetPasswordWithCode( _, _):
                    DispatchQueue.main.async {
                        Alert.hideProgressHud(onView: viewController.view)
                        let verifyAccountVC = VerifyAccountViewController.storyboardInstance()
                        verifyAccountVC.isForgotPassword = true
                        verifyAccountVC.emailAddress = username
                        viewController.navigationController?.pushViewController(verifyAccountVC, animated: true)
                    }
                case .done:
                    print("Reset completed")
                }
            } catch {
                DispatchQueue.main.async {
                    Alert.hideProgressHud(onView: viewController.view)
                    if error is AuthError{
                        
                        AmplifyManager.resendCode1resend(username : username, viewController: viewController)
                       
                    }
                    //Global.showAlert(withMessage: "\(error)", sender: viewController)
                }
            }
        }
    }
    
    class func confirmResetPassword(username: String, newPassword: String, confirmationCode: String, viewController: UIViewController) {
        _ = Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.changePassword(username: username, password: newPassword, viewcontroller: viewController)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        Alert.hideProgressHud(onView: viewController.view)
                        Global.showAlert(withMessage: "\(error)", sender: viewController)
                    }
                }
        }
    }
    
    class func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    
    class func changePassword(username: String, password: String, viewcontroller: UIViewController){
        let strUrl = "\(liveBaseUrl)/changePassword"
        let parameters : [String : Any] = ["username":"\(username)", "password":"\(password)"]
        WebServices.postRequest(urlString: strUrl, paramDict: parameters, isWalletUser: true, isAuth: false, xAPIKey: "\(liveWalletXAPIKey)", completionHandler: { (responseObject , stringResponse, error) in
            Alert.hideProgressHud(onView: viewcontroller.view)
            if error == nil {
                if let response = responseObject {
                    debugPrint("response:  \(response)")
                    if let status = response["status"] as? String{
                        if status == "success"{
                            Global.showAlert(withMessage: "Passwword Changed Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                let loginVC = LoginViewController.storyboardInstance()
                                viewcontroller.navigationController?.pushViewController(loginVC, animated: true)
                            })
                        }
                    }
                }  else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: viewcontroller.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: viewcontroller)
                } else {
                    if responseObject?["message"] != nil {
                        Global.showAlert(withMessage: "\(responseObject?["message"] ?? "Something Went Wrong")", sender: viewcontroller)
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                debugPrint("Check 1: ",error?.localizedDescription as Any)
                Global.showAlert(withMessage: "\(strError)", sender: viewcontroller)
            }
        })
    }
    
    // MARK: - Get API to fetch OAuth Token .
    /**
     Pass the parameter to the server for login purpose
     - parameter
     - username: Country Code  from labelCode
     - password: User password from self.txtfieldMobile
     - grant_type: access type
     */
    
    class func getWalletAccessToken(completionHandler: @escaping (_ isSuccess: Bool?, _ isError: String?) -> ()){
        let strUrl = "\(liveBaseUrl)/oauth/token"
        let user = "swagger-client"
        let spassword = "swagger-secret"
        let emailID = CustomUserDefaults.getEmailID()
        let password = KeychainService.loadPassword(service: service, account: account) ?? ""
        let credentialData = "\(user):\(spassword)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var parameters = ""
        if CustomUserDefaults.getWalletRefreshToken() == ""
        {
            parameters = "username=\(emailID)&password=\(password)&grant_type=password"
        }
        else {
            parameters = "username=\(emailID)&password=\(password)&grant_type=refresh_token&refresh_token=\(CustomUserDefaults.getWalletRefreshToken())"

        }
        debugPrint("walletParam++++++++++++++++++++++++++",parameters,strUrl,emailID,password,credentialData,base64Credentials)
       // let p = parameters.da
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: strUrl)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(liveWalletXAPIKey, forHTTPHeaderField: "x-api-key")
        
        request.addValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                debugPrint(String(describing: error))
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                {
                    debugPrint("token+++++++++++++++++++++",json)
                    if let error = json["error_description"] as? String{
                        debugPrint("NoDataFetch")
                        completionHandler(false, error)
                    }else{
                        if let accessToken = json["access_token"] as? String{
                            CustomUserDefaults.setWalletAccessToken(data: accessToken)
                        }
                        if let refreshToken = json["refresh_token"] as? String{
                            CustomUserDefaults.setWalletRefreshToken(data: refreshToken)
                        }
                        completionHandler(true, nil)
                    }
                } else {
                    completionHandler(false, nil)
                }
            } catch _ as NSError {
                completionHandler(false, nil)
            }
            
        }
        task.resume()
    }

    class func getWalletAccessTokenFromLogin(completionHandler: @escaping (_ isSuccess: Bool?, _ isError: String?) -> ()){
        let strUrl = "\(liveBaseUrl)/oauth/token"
        let user = "swagger-client"
        let spassword = "swagger-secret"
        let emailID = CustomUserDefaults.getEmailID()
        let password = KeychainService.loadPassword(service: service, account: account) ?? ""
        let credentialData = "\(user):\(spassword)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        var parameters = ""
        if CustomUserDefaults.getWalletRefreshToken() == ""
        {
            parameters = "username=\(emailID)&password=\(password)&grant_type=password"
        }
        else {
            parameters = "username=\(emailID)&password=\(password)&grant_type=refresh_token&refresh_token=\(CustomUserDefaults.getWalletRefreshToken())"
            
        }
        debugPrint("walletParam++++++++++++++++++++++++++",parameters,strUrl,emailID,password,credentialData,base64Credentials)
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: strUrl)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(liveWalletXAPIKey, forHTTPHeaderField: "x-api-key")
        
        request.addValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                
                DispatchQueue.main.async() {
                    Constants.kAppDelegate?.setMainController()
                }
                debugPrint(String(describing: error))
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                {
                    debugPrint("token+++++++++++++++++++++",json)
                    if let error = json["error_description"] as? String{
                        debugPrint("NoDataFetch")
                        DispatchQueue.main.async() {
                            Constants.kAppDelegate?.setMainController()
                        }
                        completionHandler(false, error)
                    }else{
                        if let accessToken = json["access_token"] as? String{
                            CustomUserDefaults.setWalletAccessToken(data: accessToken)
                        }
                        if let refreshToken = json["refresh_token"] as? String{
                            CustomUserDefaults.setWalletRefreshToken(data: refreshToken)
                        }
                        DispatchQueue.main.async() {
                            Constants.kAppDelegate?.setMainController()
                        }
                        completionHandler(true, nil)
                    }
                } else {
                    DispatchQueue.main.async() {
                        Constants.kAppDelegate?.setMainController()
                    }
                    completionHandler(false, nil)
                }
            } catch _ as NSError {
                DispatchQueue.main.async() {
                    Constants.kAppDelegate?.setMainController()
                }
                completionHandler(false, nil)
            }
            
        }
        task.resume()
    }
}
