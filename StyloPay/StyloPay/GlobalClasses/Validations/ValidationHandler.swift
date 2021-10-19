//
//  ValidationHandler.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 14/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class ValidationHandler: NSObject {
    
    class func validateRegisterationForm(form object: RegisterViewController, email: String, password: String, confirmPassword: String, mobileNumber: String, username: String, isdcode: String) -> Bool{
        if Validation.isBlank(username){
            Global.showAlert(withMessage: ValidationError.OfType.emptyUsername.description, sender: object)
            return false
        }else if Validation.isBlank(email){
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmailAddress.description, sender: object)
            return false
        } else if Validation.isValid(email: email){
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else if Validation.isBlank(mobileNumber){
            Global.showAlert(withMessage: ValidationError.OfType.emptyMobileNumber.description, sender: object)
            return false
        }  else if mobileNumber.length < 6 || mobileNumber.length > 15 {
            Global.showAlert(withMessage: ValidationError.OfType.validMobileNumber.description, sender: object)
            return false
        } else if Validation.isBlank(password) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyPassword.description, sender: object)
            return false
        } else if Validation.isValidPassword(password: password) {
            Global.showAlert(withMessage: ValidationError.OfType.validPassword.description, sender: object)
            return false
        }else if (password != confirmPassword ){
            Global.showAlert(withMessage: ValidationError.OfType.passwordMismatch.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateVerifyAccount(form object: VerifyAccountViewController, otp: String) -> Bool{
        if Validation.isBlank(otp){
            Global.showAlert(withMessage: ValidationError.OfType.emptyOtp.description, sender: object)
            return false
        } else if (otp.length != 6){
            Global.showAlert(withMessage: "Enter the Correct OTP", sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateSigninScreen(form object: LoginViewController, email: String, password: String) -> Bool{
        if Validation.isBlank(email){
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmailAddress.description, sender: object)
            return false
        } else if Validation.isValid(email: email){
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else if Validation.isBlank(password) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyPassword.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateForgotPasswordScreen(form object: ForgotPasswordViewController, email: String) -> Bool{
        if Validation.isBlank(email){
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmailAddress.description, sender: object)
            return false
        } else if Validation.isValid(email: email){
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateResetPasswordScreen(form object: NewPasswordViewController, password: String, confirmPassword: String) -> Bool{
        if Validation.isBlank(password){
            Global.showAlert(withMessage: ValidationError.OfType.emptyPassword.description, sender: object)
            return false
        } else if Validation.isBlank(confirmPassword){
            Global.showAlert(withMessage: ValidationError.OfType.emptyConfirmPassword.description, sender: object)
            return false
        } else if Validation.isValidPassword(password: password) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyPassword.description, sender: object)
            return false
        } else if password != confirmPassword{
            Global.showAlert(withMessage: ValidationError.OfType.passwordMismatch.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateIDProofScreen(form object: ProofViewController, data: ProofsModel, isDoubleDocument: Bool) -> Bool{
        if Validation.isBlank(data.identificationType){
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentType.description, sender: object)
            return false
        }else if Validation.isBlank(data.identificationValue){
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentNumber.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationDocHolderName) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentHolderName.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingAuthority) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyIssuingAuthority.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingCountry) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyNationality.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationDocExpiry) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyExpiryDate.description, sender: object)
            return false
        }else if data.identificationFileDocumentArray.isEmpty {
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocImage.description, sender: object)
            return false
        }
        else if data.identificationFileDocumentArray.count == 1 {
            if isDoubleDocument{
                Global.showAlert(withMessage: ValidationError.OfType.emptyBackDocImage.description, sender: object)
                return false
            }else{
                return true
            }
        } else {
            return true
        }
    }

    class func validateIDProofScreenIDProof(form object: ProofViewController, data: ProofsModel, isDoubleDocument: Bool) -> Bool{
        if Validation.isBlank(data.identificationType){
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentType.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationValue){
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentNumber.description, sender: object)
            return false
            }
        else if Validation.isBlank(data.identificationDocHolderName) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentHolderName.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingAuthority) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyIssuingAuthority.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingCountry) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyNationality.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingDate) && Validation.isBlankIssueDate(data.identificationType) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyIssuanceDate.description, sender: object)
            return false
        }

        else if Validation.isBlank(data.identificationDocExpiry) && Validation.isBlankExpiryDate(data.identificationType) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyExpiryDate.description, sender: object)
            return false
        }

        else if data.identificationFileDocumentArray.isEmpty {
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocImage.description, sender: object)
            return false
        }else if data.identificationFileDocumentArray.count == 1 {
            if isDoubleDocument{
                Global.showAlert(withMessage: ValidationError.OfType.emptyBackDocImage.description, sender: object)
                return false
            }else{
                return true
            }
        } else {
            return true
        }
    }
    
    class func validateAddressProofScreen(form object: AddressProofViewController, data: ProofsModel) -> Bool{
        if Validation.isBlank(data.identificationType){
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentType.description, sender: object)
            return false
        }else if Validation.isBlank(data.identificationValue){
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentNumber.description, sender: object)
            return false
        }
//        else if data.identificationValue.length != 9{
//            Global.showAlert(withMessage: ValidationError.OfType.documentNumberLength.description, sender: object)
//            return false
//        }
        else if Validation.isBlank(data.identificationDocHolderName) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocumentHolderName.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingAuthority) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyIssuingAuthority.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingCountry) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyNationality.description, sender: object)
            return false
        }
        else if Validation.isBlank(data.identificationIssuingDate) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyIssuanceDate.description, sender: object)
            return false
        }else if Validation.isBlank(data.identificationDocExpiry) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyExpiryDate.description, sender: object)
            return false
        }else if data.identificationFileDocumentArray.isEmpty {
            Global.showAlert(withMessage: ValidationError.OfType.emptyDocImage.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateProfileSetupScreen(form object: ProfileSetUpViewController, data: PersonalnfoModel) -> Bool{
        if Validation.isBlank(data.firstName){
            Global.showAlert(withMessage: ValidationError.OfType.emptyFirstname.description, sender: object)
            return false
        } else if Validation.isBlank(data.lastName){
            Global.showAlert(withMessage: ValidationError.OfType.emptyLastname.description, sender: object)
            return false
        }else if Validation.isBlank(data.preferredName){
            Global.showAlert(withMessage: ValidationError.OfType.emptyPreferredName.description, sender: object)
            return false
        }else if Validation.isBlank(data.dateOfBirth){
            Global.showAlert(withMessage: ValidationError.OfType.emptyDOB.description, sender: object)
            return false
        }else if Validation.isBlank(data.mobileNumber){
            Global.showAlert(withMessage: ValidationError.OfType.emptyMobileNumber.description, sender: object)
            return false
        }else if data.mobileNumber.length < 6 || data.mobileNumber.length > 15 {
            Global.showAlert(withMessage: ValidationError.OfType.validMobileNumber.description, sender: object)
            return false
        }else if Validation.isBlank(data.nationality){
            Global.showAlert(withMessage: ValidationError.OfType.emptyNationality.description, sender: object)
            return false
        } else if Validation.isBlank(data.billingAddress1){
            Global.showAlert(withMessage: ValidationError.OfType.emptybillingAddress1.description, sender: object)
            return false
        } else if Validation.isBlank(data.billingCity){
            Global.showAlert(withMessage: ValidationError.OfType.emptybillingCity.description, sender: object)
            return false
        }else if Validation.isBlank(data.billingState){
            Global.showAlert(withMessage: ValidationError.OfType.emptybillingState.description, sender: object)
            return false
        }else if Validation.isBlank(data.billingZipCode){
            Global.showAlert(withMessage: ValidationError.OfType.emptybillingZipCode.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateReceiverEmail(form object: ReciverEmailViewController, email: String) -> Bool{
        if Validation.isBlank(email){
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmailAddress.description, sender: object)
            return false
        } else if Validation.isValid(email: email){
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    
        class func validateProfileUpdateScreen(form object: ProfileDetailsViewController, data: PersonalnfoModel) -> Bool{
            if Validation.isBlank(data.correspondenceAddress1){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryAddress1.description, sender: object)
                return false
            }else if Validation.isBlank(data.correspondenceCity){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryCity.description, sender: object)
                return false
            }else if Validation.isBlank(data.correspondenceState){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryState.description, sender: object)
                return false
            }else if Validation.isBlank(data.correspondenceZipCode){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryZipCode.description, sender: object)
                return false
            }else if Validation.isBlank(data.billingAddress1){
                Global.showAlert(withMessage: ValidationError.OfType.emptybillingAddress1.description, sender: object)
                return false
            }else if Validation.isBlank(data.billingCity){
                Global.showAlert(withMessage: ValidationError.OfType.emptybillingCity.description, sender: object)
                return false
            }else if Validation.isBlank(data.billingState){
                Global.showAlert(withMessage: ValidationError.OfType.emptybillingState.description, sender: object)
                return false
            }else if Validation.isBlank(data.billingZipCode){
                Global.showAlert(withMessage: ValidationError.OfType.emptybillingZipCode.description, sender: object)
                return false
            } else if Validation.isBlank(data.deliveryAddress1){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryAddress1.description, sender: object)
                return false
            }else if Validation.isBlank(data.deliveryCity){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryCity.description, sender: object)
                return false
            }else if Validation.isBlank(data.deliveryState){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryState.description, sender: object)
                return false
            }else if Validation.isBlank(data.deliveryZipCode){
                Global.showAlert(withMessage: ValidationError.OfType.emptydeliveryZipCode.description, sender: object)
                return false
            } else {
                return true
            }
        }
    
    
    class func validateOtpPopUpScreen(from object: OtpVerifyPopUpVC , otp: String)-> Bool {
        
        if Validation.isBlank(otp){
            Global.showAlert(withMessage: ValidationError.OfType.empty.description, sender: object)
            return false
        }
        
        else {
            return true
        }
        
      
    }
    
    
    
    
    
    class func validateAddonDetaildPopupScreen(form object: VirtualCardDetailsPopupViewController,firstName: String, lastName: String, emailId: String, mobileNumber: String) -> Bool{
        if Validation.isBlank(firstName){
            Global.showAlert(withMessage: ValidationError.OfType.emptyFirstname.description, sender: object)
            return false
        } else if Validation.isBlank(lastName){
            Global.showAlert(withMessage: ValidationError.OfType.emptyLastname.description, sender: object)
            return false
        }else if Validation.isBlank(emailId){
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmailAddress.description, sender: object)
            return false
        } else if Validation.isValid(email: emailId){
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else if Validation.isBlank(mobileNumber){
            Global.showAlert(withMessage: ValidationError.OfType.emptyMobileNumber.description, sender: object)
            return false
        }else if mobileNumber.length < 6 || mobileNumber.length > 15{
            Global.showAlert(withMessage: ValidationError.OfType.validMobileNumber.description, sender: object)
            return false
        } else {
            return true
        }
    }
    
    class func validateAsignedDetaildPopupScreen(form object: AssignedCardDetailsViewController,accountNumber: String, lastDigits: String) -> Bool{
        if Validation.isBlank(accountNumber){
            Global.showAlert(withMessage: ValidationError.OfType.emptyAccountNumber.description, sender: object)
            return false
        } else if accountNumber.length < 16 {
            Global.showAlert(withMessage: ValidationError.OfType.validAccountNumber.description, sender: object)
            return false
        } else if Validation.isBlank(lastDigits){
            Global.showAlert(withMessage: ValidationError.OfType.emptyLastDigits.description, sender: object)
            return false
        } else if lastDigits.length < 4 {
            Global.showAlert(withMessage: ValidationError.OfType.validLastDigits.description, sender: object)
            return false
        } else {
            return true
        }
    }
}
