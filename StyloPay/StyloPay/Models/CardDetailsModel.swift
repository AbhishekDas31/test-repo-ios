//
//  CardDetailsModel.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 07/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class CardDetailsModel: NSObject {
    
    var blockReason = ""
    var cardHashId = ""
    var cardStatus = ""
    var cardType = ""
    var countryCode = ""
    var createdAt = ""
    var emailId = ""
    var embossingLine1 = ""
    var embossingLine2 = ""
    var firstName = ""
    var isNonPerso = true
    var issuanceMode = ""
    var issuanceType = ""
    var lastName = ""
    var logoId = 0
    var maskedCardNumber = ""
    var middleName = ""
    var mobileNumber = ""
    var plasticId = ""
    var proxyNumber = ""
    var regionCode = ""
    var replacedOn = ""
    var updatedAt = ""
    
    override init() {
        
    }
    
    convenience init(_ attributes: [AnyHashable: Any]) {
        self.init()
        
        blockReason = attributes["blockReason"] as? String ?? ""
        cardHashId = attributes["cardHashId"] as? String ?? ""
        cardStatus = attributes["cardStatus"] as? String ?? ""
        cardType = attributes["cardType"] as? String ?? ""
        countryCode = attributes["countryCode"] as? String ?? ""
        createdAt = attributes["createdAt"] as? String ?? ""
        emailId = attributes["emailId"] as? String ?? ""
        embossingLine1 = attributes["embossingLine1"] as? String ?? ""
        embossingLine2 = attributes["embossingLine2"] as? String ?? ""
        firstName = attributes["firstName"] as? String ?? ""
        issuanceMode = attributes["issuanceMode"] as? String ?? ""
        issuanceType = attributes["issuanceType"] as? String ?? ""
        lastName = attributes["lastName"] as? String ?? ""
        maskedCardNumber = attributes["maskedCardNumber"] as? String ?? ""
        middleName = attributes["middleName"] as? String ?? ""
        plasticId = attributes["plasticId"] as? String ?? ""
        proxyNumber = attributes["proxyNumber"] as? String ?? ""
        regionCode = attributes["regionCode"] as? String ?? ""
        replacedOn = attributes["replacedOn"] as? String ?? ""
        updatedAt = attributes["updatedAt"] as? String ?? ""
        isNonPerso = attributes["isNonPerso"] as? Bool ?? true
        logoId = Global.getInt(for: attributes["logoId"] as? Int ?? 0)
    }
}
