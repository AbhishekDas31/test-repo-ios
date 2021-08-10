//
//  PersonalnfoModel.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 18/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class PersonalnfoModel: NSObject {
    
    var username = ""
    var customerId = ""
    var walletHashId = ""
    var customerHashId = ""
    var email = ""
    var firstName = ""
    var middleName = ""
    var lastName = ""
    var dateOfBirth = ""
    var remittanceDOB = ""
    var preferredName = ""
    var nationality = ""
    var countryCode = ""
    var countryIsoCode = ""
    var mobileNumber = ""
    var code = ""
    var title = ""
    var country = ""
    
    var termsAndConditionAcceptanceFlag = false
    var deliveryAddress1 = ""
    var deliveryCountry = ""
    var deliveryAddress2 = ""
    var deliveryCity = ""
    var deliveryState = ""
    var deliveryLandmark = ""
    var deliveryZipCode = ""
    var billingAddress1 = ""
    var billingAddress2 = ""
    var billingCity = ""
    var billingCountry = ""
    var billingState = ""
    var billingLandmark = ""
    var billingZipCode = ""
    var correspondenceAddress1 = ""
    var correspondenceAddress2 = ""
    var correspondenceCity = ""
    var correspondenceCountry = ""
    var correspondenceState = ""
    var correspondenceZipCode = ""
    var correspondenceLandmark = ""
    var addressLine1 = ""
    var addressLine2 = ""
    var password = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var floorNumber = ""
    var blockNumber = ""
    var unitNumber = ""
    var buildingName = ""
    var streetName = ""
    var remittanceState = ""
    var remittanceCity = ""
    var complianceRemarks = ""
    var rfiDetailsArray = [RFIDetailsModel]()
    
    override init() {
        
    }
    
    convenience init(_ attributes: [AnyHashable: Any]) {
        self.init()
        firstName = attributes["firstName"] as? String ?? ""
        middleName = attributes["middleName"] as? String ?? ""
        lastName = attributes["lastName"] as? String ?? ""
        dateOfBirth = attributes["dateOfBirth"] as? String ?? ""
        preferredName = attributes["preferredName"] as? String ?? ""
        mobileNumber = attributes["mobile"] as? String ?? ""
        email = attributes["email"] as? String ?? ""
        
        customerId = attributes["customerId"] as? String ?? ""
        customerHashId = attributes["customerHashId"] as? String ?? ""
        walletHashId = attributes["walletHashId"] as? String ?? ""
        nationality = attributes["nationality"] as? String ?? ""
        countryIsoCode = attributes["countryCode"] as? String ?? ""
        termsAndConditionAcceptanceFlag = attributes["termsAndConditionAcceptanceFlag"] as? Bool ?? false
        
        correspondenceAddress1 = attributes["correspondenceAddress1"] as? String ?? ""
        correspondenceAddress2 = attributes["correspondenceAddress2"] as? String ?? ""
        correspondenceCity = attributes["correspondenceCity"] as? String ?? ""
        correspondenceCountry = attributes["correspondenceCountry"] as? String ?? ""
        correspondenceState = attributes["correspondenceState"] as? String ?? ""
        correspondenceZipCode = attributes["correspondenceZipCode"] as? String ?? ""
        correspondenceLandmark = attributes["correspondenceLandmark"] as? String ?? ""
        
        deliveryAddress1 = attributes["deliveryAddress1"] as? String ?? ""
        deliveryAddress2 = attributes["deliveryAddress2"] as? String ?? ""
        deliveryCountry = attributes["deliveryCountry"] as? String ?? ""
        deliveryCity = attributes["deliveryCity"] as? String ?? ""
        deliveryState = attributes["deliveryState"] as? String ?? ""
        deliveryZipCode = attributes["deliveryZipCode"] as? String ?? ""
        deliveryLandmark = attributes["deliveryLandmark"] as? String ?? ""
        
        billingAddress1 = attributes["billingAddress1"] as? String ?? ""
        billingAddress2 = attributes["billingAddress2"] as? String ?? ""
        billingCity = attributes["billingCity"] as? String ?? ""
        billingCountry = attributes["billingCountry"] as? String ?? ""
        billingState = attributes["billingState"] as? String ?? ""
        billingLandmark = attributes["billingLandmark"] as? String ?? ""
        billingZipCode = attributes["billingZipCode"] as? String ?? ""
        
        complianceRemarks = attributes["complianceRemarks"] as? String ?? ""
        
        if let rfiDetailsArray = attributes["rfiDetails"] as? [[String:Any]]{
            for rfiDetailsValue in rfiDetailsArray {
                let rfiDetailsObj = RFIDetailsModel(rfiDetailsValue)
                self.rfiDetailsArray.append(rfiDetailsObj)
            }
        }
    }
}


class RFIDetailsModel: NSObject {
    
    var rfiHashId = ""
    var mandatory = false
    var remarks = ""
    var documentType = ""
    var type = ""
    var rfiDescription = ""
    
    override init() {
    }
    
    convenience init(_ attributes: [AnyHashable: Any]) {
        self.init()
        rfiHashId = attributes["rfiHashId"] as? String ?? ""
        mandatory = attributes["mandatory"] as? Bool ?? false
        remarks = attributes["remarks"] as? String ?? ""
        documentType = attributes["documentType"] as? String ?? ""
        type = attributes["type"] as? String ?? ""
        rfiDescription = attributes["description"] as? String ?? ""
        
    }
}
