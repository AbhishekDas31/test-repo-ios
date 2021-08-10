//
//  ValidationError.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 14/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class ValidationError: NSObject {
    
    public enum OfType : Error {
        case errorWithMessage(message: String)
        case empty
        case emptyUsername
        case validUsername
        case emptyEmailAddress
        case emptyDocumentType
        case emptyDocumentNumber
        case documentNumberLength
        case emptyIssuingAuthority
        case emptyIssuanceDate
        case emptyExpiryDate
        case emptyFrontDocImage
        case emptyDocImage
        case emptyBackDocImage
        case validEmail
        case validPassword
        case emptyPassword
        case emptyNewPassword
        case emptyConfirmPassword
        case passwordMismatch
        case emptyMobileNumber
        case emptyOtp
        case mobileLimit
        case emptyOtpNumber
        case validMobileNumber
        case termsNotAccepted
        case emptyAccountNumber
        case validAccountNumber
        case validLastDigits
        case emptyLastDigits
        case emptyFirstname
        case emptyLastname
        case emptyMiddlename
        case emptyPreferredName
        case emptyDOB
        case emptyNationality
        case emptyCurrencycode
        case emptyremittanceCity
        case emptyremittanceState
        case emptyStreetName
        case emptyBuildingname
        case emptyUnitNumber
        case emptyblocknumber
        case emptyFloorNumber
        case emptyZipcode
        case emptybillingAddress1
        case emptybillingAddress2
        case emptybillingCity
        case emptybillingState
        case emptybillingZipCode
        case emptydeliveryAddress1
        case emptydeliveryAddress2
        case emptydeliveryCity
        case emptydeliveryState
        case emptydeliveryZipCode
        case emptyCorrespondenceAddress1
        case emptyCorrespondenceAddress2
        case emptyCorrespondenceCity
        case emptyCorrespondenceState
        case emptyCorrespondenceZipCode
        case emptyDocumentHolderName
    }
}

extension ValidationError.OfType {
    var description: String {
        switch self {
        case .errorWithMessage(let message):
            return message
        case .empty:
            return "Cannot be blank"
        case .emptyMobileNumber:
            return "Phone number can't be blank"
        case .emptyOtp:
            return "OTP can't be blank"
        case .emptyPassword:
            return "Password can't be blank"
        case .emptyNewPassword:
            return "New Password can't be blank"
        case .emptyConfirmPassword:
            return "Confirm Password can't be blank"
        case .passwordMismatch:
            return "Password Mismatch"
        case .mobileLimit:
            return "Phone number must be between 8 and 12 digits"
        case .emptyOtpNumber:
            return "OTP number can't be blank"
        case .emptyAccountNumber:
            return "Account number can't be blank"
        case .validAccountNumber:
            return "Please enter valid account number"
        case .emptyLastDigits:
            return "Last 4-digits can't be blank"
        case .validLastDigits:
            return "Please enter last 4 digtis"
        case .validMobileNumber:
            return "Please enter valid mobile number"
        case .validPassword:
            return "Password should be min 8 characters long. Password must contain one small letter, one capital letter, one digit and one special character"
        case .emptyEmailAddress:
            return "Email address can't be blank"
        case .emptyUsername:
            return "Username can't be blank"
        case .emptyDocumentType:
            return "Please Select Document Type"
        case .emptyDocumentNumber:
            return "Document Number can't be blank"
        case .emptyDocumentHolderName:
            return "Document Holder Name can't be blank"
        case .documentNumberLength:
            return "Please Enter a Valid Document Number"
        case .emptyIssuingAuthority:
            return "Issuing Authority can't be blank"
        case .emptyIssuanceDate:
            return "Please Select Document Issuiance Date"
        case .emptyExpiryDate:
            return "Please Select Document Expiry Date"
        case .emptyFrontDocImage:
            return "Please attach image frontside of Document"
        case .emptyDocImage:
            return "Please attach Document Image"
        case .emptyBackDocImage:
            return "Please attach image of the otherside of the document"
        case .validEmail:
            return "Please enter a valid email address"
        case .termsNotAccepted:
            return "Please agree to our terms of use"
        case .emptyFirstname:
            return "First Name can't be blank"
        case .emptyLastname:
            return "Last Name can't be blank"
        case .emptyMiddlename:
            return "Middle Name can't be blank"
        case .emptyPreferredName:
            return "Preferred Name can't be blank"
        case .emptyDOB:
            return "Date of Birth can't be blank"
        case .emptyNationality:
            return "Please select a Country"
        case .emptyCurrencycode:
            return "Please select a Currency Code"
        case .emptyremittanceCity:
            return "City can't be blank"
        case .emptyremittanceState:
            return "State can't be blank"
        case .emptyStreetName:
            return "Street Name can't be blank"
        case .emptyBuildingname:
            return "Building Name can't be blank"
        case .emptyUnitNumber:
            return "Unit Number can't be blank"
        case .emptyblocknumber:
            return "Block Number can't be blank"
        case .emptyFloorNumber:
            return "Floor Number can't be blank"
        case .emptyZipcode:
            return "Zipcode can't be blank"
        case .emptybillingAddress1:
            return "Billing Address Line 1 can't be blank"
        case .emptybillingAddress2:
            return "Billing Address Line 2 can't be blank"
        case .emptybillingCity:
            return "Billing City can't be blank"
        case .emptybillingState:
            return "Billing City can't be blank"
        case .emptybillingZipCode:
            return "Billing Zipcode can't be blank"
        case .emptydeliveryAddress1:
            return "Delivery Address Line 1 can't be blank"
        case .emptydeliveryAddress2:
            return "Delivery Address Line 2 can't be blank"
        case .emptydeliveryCity:
            return "Delivery City can't be blank"
        case .emptydeliveryState:
            return "Delivery State can't be blank"
        case .emptydeliveryZipCode:
            return "Delivery Zipcode can't be blank"
        case .emptyCorrespondenceAddress1:
            return "Correspondence Address Line 1 can't be blank"
        case .emptyCorrespondenceAddress2:
            return "Correspondence Address Line 2 can't be blank"
        case .emptyCorrespondenceCity:
            return "Correspondence City can't be blank"
        case .emptyCorrespondenceState:
            return "Correspondence State can't be blank"
        case .emptyCorrespondenceZipCode:
            return "Correspondence Zipcode can't be blank"
        default:
            return ""
        }
    }
}
