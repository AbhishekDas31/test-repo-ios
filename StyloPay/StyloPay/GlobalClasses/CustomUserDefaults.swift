//
//  CustomUserDefaults.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 15/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class CustomUserDefaults: NSObject {
    
    static let userDefault = UserDefaults.standard
    
    static  func setTokenID(data : String)  {
        userDefault.set(data, forKey: "access_token")
    }
    
    static  func getToken()-> String  {
        if let tokenId = userDefault.object(forKey: "access_token") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static func isTokenExit() -> Bool {
        if (userDefault.object(forKey: "access_token") != nil) {
            return true
        } else {
            return false
        }
    }
    
    static  func isBoardingScreenSkipped(data : Bool)  {
        userDefault.set(data, forKey: "isSkipped")
    }
    
    static  func getisBoardingScreenSkipped()-> Bool  {
        if let sourceId = userDefault.object(forKey: "isSkipped") {
            return sourceId as? Bool ?? false
        }
        return false
    }
    
    static  func isLoggedIn(data : Bool)  {
        userDefault.set(data, forKey: "isLoggedIn")
    }
    
    static  func getisLoggedIn()-> Bool  {
        if let sourceId = userDefault.object(forKey: "isLoggedIn") {
            return sourceId as? Bool ?? false
        }
        return false
    }
    
    static  func setEmailID(data : String)  {
        userDefault.set(data, forKey: "emailAddress")
    }
    
    static  func getEmailID()-> String  {
        if let tokenId = userDefault.object(forKey: "emailAddress") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
//    static  func setWalletUsername(data : String)  {
//        userDefault.set(data, forKey: "WalletUsername")
//    }
//    
//    static  func getWalletUsername()-> String  {
//        if let tokenId = userDefault.object(forKey: "WalletUsername") {
//            return tokenId as? String ?? ""
//        }
//        return ""
//    }
    
    static  func setMobileNumber(data : String)  {
        userDefault.set(data, forKey: "MobileNumber")
    }
    
    static  func getMobileNumber()-> String  {
        if let tokenId = userDefault.object(forKey: "MobileNumber") {
            return tokenId as? String ?? ""
        }
        return ""
    }

    static  func setPhoneNumberVerified(data : Bool)  {
        userDefault.set(data, forKey: "phone_number_verified")
    }

    static  func getPhoneNumberVerified()-> Bool  {
        if let tokenId = userDefault.object(forKey: "phone_number_verified") {
            return tokenId as? Bool ?? false
        }
        return false
    }
    
    static  func setIsdCode(data : String)  {
        userDefault.set(data, forKey: "IsdCode")
    }
    
    static  func getIsdCode()-> String  {
        if let tokenId = userDefault.object(forKey: "IsdCode") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setPassword(data : String)  {
        userDefault.set(data, forKey: "password")
    }
    
    static  func getPassword()-> String  {
        if let tokenId = userDefault.object(forKey: "password") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setAccessToken(data : String)  {
        userDefault.set(data, forKey: "accessToken")
    }
    
    static  func getAccessToken()-> String  {
        if let tokenId = userDefault.object(forKey: "accessToken") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setRefreshToken(data : String)  {
        userDefault.set(data, forKey: "refreshToken")
    }
    
    static  func getRefreshToken()-> String  {
        if let tokenId = userDefault.object(forKey: "refreshToken") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    //complianceStatus
    static  func setWalletAccessToken(data : String)  {
        userDefault.set(data, forKey: "walletaccessToken")
    }
    
    static  func getWalletAccessToken()-> String  {
        if let tokenId = userDefault.object(forKey: "walletaccessToken") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    static  func setComplianceStatus(data : String)  {
        userDefault.set(data, forKey: "complianceStatus")
    }
    
    static  func getComplianceStatus()-> String  {
        if let complianceStatus = userDefault.object(forKey: "complianceStatus") {
            return complianceStatus as? String ?? ""
        }
        return ""
    }
    static  func setkycPopUp(data : Bool)  {
        userDefault.set(data, forKey: "isKyc")
    }

    static  func getkycPopUp()-> Bool  {
        if let iskyc = userDefault.object(forKey: "isKyc") {
            return iskyc as? Bool ?? false
        }
        return false
    }
    static  func setisAuth(data : Bool)  {
        userDefault.set(data, forKey: "isAuth")
    }

    static  func getisAuth()-> Bool  {
        if let iskyc = userDefault.object(forKey: "isAuth") {
            return iskyc as? Bool ?? false
        }
        return false
    }
    static  func setWalletRefreshToken(data : String)  {
        userDefault.set(data, forKey: "walletrefreshToken")
    }
    
    static  func getWalletRefreshToken()-> String  {
        if let tokenId = userDefault.object(forKey: "walletrefreshToken") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setCustomerId(data : String)  {
        userDefault.set(data, forKey: "customerId")
    }
    
    static  func getCustomerId()-> String  {
        if let tokenId = userDefault.object(forKey: "customerId") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setIDDocId(data : String)  {
        userDefault.set(data, forKey: "documentId")
    }
    
    static  func getIDDocId()-> String  {
        if let tokenId = userDefault.object(forKey: "documentId") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setSelfieDocId(data : String)  {
        userDefault.set(data, forKey: "sdocumentId")
    }
    
    static  func getSelfieDocId()-> String  {
        if let tokenId = userDefault.object(forKey: "sdocumentId") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setCustomerHashId(data : String)  {
        userDefault.set(data, forKey: "customerHashId")
    }
    
    static  func getCustomerHashId()-> String  {
        if let tokenId = userDefault.object(forKey: "customerHashId") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setwalletHashId(data : String)  {
        userDefault.set(data, forKey: "walletHashId")
    }
    
    static  func getwalletHashId()-> String  {
        if let tokenId = userDefault.object(forKey: "walletHashId") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setCardHashId(data : String)  {
        userDefault.set(data, forKey: "cardHashId")
    }
    
    static  func getCardHashId()-> String  {
        if let tokenId = userDefault.object(forKey: "cardHashId") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setCardActivationSatus(data : String)  {
        userDefault.set(data, forKey: "cardActivationSatus")
    }
    
    static  func getCardActivationSatus()-> String  {
        if let tokenId = userDefault.object(forKey: "cardActivationSatus") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    
    static  func setFirstname(data : String)  {
        userDefault.set(data, forKey: "firstname")
    }
    
    static  func getFirstname()-> String  {
        if let tokenId = userDefault.object(forKey: "firstname") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setCountry(data : String)  {
        userDefault.set(data, forKey: "country")
    }
    
    static  func getCountry()-> String  {
        if let tokenId = userDefault.object(forKey: "country") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static  func setLastname(data : String)  {
        userDefault.set(data, forKey: "lastname")
    }
    
    static  func getLastname()-> String  {
        if let tokenId = userDefault.object(forKey: "lastname") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    static  func setMiddlename(data : String)  {
        userDefault.set(data, forKey: "middlename")
    }
    
    static  func getMiddlename()-> String  {
        if let tokenId = userDefault.object(forKey: "middlename") {
            return tokenId as? String ?? ""
        }
        return ""
    }
    
    static func removeMobileNumber(){
        userDefault.removeObject(forKey: "MobileNumber")
    }
    static func removePhoneNumberVerified(){
        userDefault.removeObject(forKey: "phone_number_verified")
    }

    static func removeisKyc(){
        userDefault.removeObject(forKey: "isKyc")
    }
    static func removeisIsAuth(){
        userDefault.removeObject(forKey: "isAuth")
    }
    static func removeIsdCode(){
        userDefault.removeObject(forKey: "IsdCode")
    }
//    static func removeWalletUsername(){
//        userDefault.removeObject(forKey: "WalletUsername")
//    }
    static func removeCustomerId(){
        userDefault.removeObject(forKey: "customerId")
    }
    static func removeRefreshToken(){
        userDefault.removeObject(forKey: "refreshToken")
    }
    static func removeCustomerHashId(){
        userDefault.removeObject(forKey: "customerHashId")
    }
    static func removeWalletHashId(){
        userDefault.removeObject(forKey: "walletHashId")
    }
    static func removeAccessToken(){
        userDefault.removeObject(forKey: "accessToken")
    }
    static func removeComplianceStatus(){
        userDefault.removeObject(forKey: "complianceStatus")
    }
    static func removeWalletAccessToken(){
        userDefault.removeObject(forKey: "walletaccessToken")
    }
    static func removetWalletRefreshToken(){
        userDefault.removeObject(forKey: "walletrefreshToken")
    }
    
    static func removeCardHashId(){
        userDefault.removeObject(forKey: "cardHashId")
    }
    static func removePassword(){
        userDefault.removeObject(forKey: "password")
    }
    static func removeEmailAddress(){
        userDefault.removeObject(forKey: "emailAddress")
    }
    static func removetFirstName(){
        userDefault.removeObject(forKey: "firstname")
    }
    static func removeLastName(){
        userDefault.removeObject(forKey: "lastname")
    }
    static func removeMiddleName(){
        userDefault.removeObject(forKey: "middlename")
    }
    static func removeCardActivationSatus(){
        userDefault.removeObject(forKey: "cardActivationSatus")
    }
}
