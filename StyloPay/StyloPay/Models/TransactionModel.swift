//
//  TransactionModel.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 14/08/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import Foundation

class TransactionModel: NSObject {
    var acquirerCountryCode = ""
    var acquiringInstitutionCode = ""
    var authAmount = 0.0
    var authCode = ""
    var authCurrencyCode = ""
    var billingAmount = 0.0
    var billingCurrencyCode = ""
    var billingReplacementAmount = 0.0
    var cardHashID = ""
    var cardTransactionAmount = ""
    var createdAt = ""
    var currentWithHoldingBalance = 0
    var dateOfTransaction = ""
    var debit = 0
    var effectiveAuthAmount = 0
    var maskedCardNumber = ""
    var mcc = ""
    var merchantCity = ""
    var merchantCountry = ""
    var merchantID = ""
    var merchantName = ""
    var originalAuthorizationCode = ""
    var partnerReferenceNumber = ""
    var posConditionCode = ""
    var posEntryCapabilityCode = ""
    var previousBalance = 0
    var processingCode = ""
    var retrievalReferenceNumber = ""
    var rhaTransactionId = ""
    var settlementAmount = 0
    var settlementStatus = ""
    var status = ""
    var systemTraceAuditNumber = ""
    var terminalID = ""
    var transactionCurrencyCode = ""
    var transactionReplacementAmount = 0
    var transactionType = ""
    var updatedAt = ""
    var receiverCustomerHashId = ""
    var receiverName = ""
    var senderName = ""
    var billingConversionRate = ""
    var comments = ""

    override init() {

    }

    convenience init(_ attributes: [AnyHashable: Any]) {
        self.init()
        acquirerCountryCode = attributes["acquirerCountryCode"] as? String ?? ""
        acquiringInstitutionCode = attributes["acquiringInstitutionCode"] as? String ?? ""
        authAmount = Global.getDouble(for: attributes["authAmount"] ?? 0.0)
        billingConversionRate =  attributes["billingConversionRate"] as? String ?? ""
        authCode = attributes["authCode"] as? String ?? ""
        authCurrencyCode = attributes["authCurrencyCode"] as? String ?? ""
        billingAmount = Global.getDouble(for: attributes["billingAmount"] as? Double ?? 0.0)
        billingCurrencyCode = attributes["billingCurrencyCode"] as? String ?? ""
        billingReplacementAmount = Global.getDouble(for: attributes["billingReplacementAmount"] as? Double ?? 0.0)
        cardHashID = attributes["cardHashID"] as? String ?? ""
        comments = attributes["comments"] as? String ?? ""
        cardTransactionAmount =  "\(attributes["cardTransactionAmount"] as? Double ?? 0.0)"
        createdAt = attributes["createdAt"] as? String ?? ""
        currentWithHoldingBalance = Global.getInt(for: attributes["currentWithHoldingBalance"] as? Int ?? 0)
        dateOfTransaction = attributes["dateOfTransaction"] as? String ?? ""
        debit = Global.getInt(for: attributes["debit"] as? Int ?? 0)
        effectiveAuthAmount = Global.getInt(for: attributes["effectiveAuthAmount"] as? Int ?? 0)
        maskedCardNumber = attributes["maskedCardNumber"] as? String ?? ""
        mcc = attributes["mcc"] as? String ?? ""
        merchantCity = attributes["merchantCity"] as? String ?? ""
        merchantCountry = attributes["merchantCountry"] as? String ?? ""
        merchantID = attributes["merchantID"] as? String ?? ""
        merchantName = attributes["merchantName"] as? String ?? ""
        originalAuthorizationCode = attributes["originalAuthorizationCode"] as? String ?? ""
        partnerReferenceNumber = attributes["partnerReferenceNumber"] as? String ?? ""
        posConditionCode = attributes["posConditionCode"] as? String ?? ""
        posEntryCapabilityCode = attributes["posEntryCapabilityCode"] as? String ?? ""
        previousBalance = Global.getInt(for: attributes["previousBalance"] as? Int ?? 0)
        processingCode = attributes["processingCode"] as? String ?? ""
        retrievalReferenceNumber = attributes["retrievalReferenceNumber"] as? String ?? ""
        rhaTransactionId = attributes["rhaTransactionId"] as? String ?? ""
        settlementAmount = Global.getInt(for: attributes["settlementAmount"] as? Int ?? 0)
        settlementStatus = attributes["settlementStatus"] as? String ?? ""
        status = attributes["status"] as? String ?? ""
        systemTraceAuditNumber = attributes["systemTraceAuditNumber"] as? String ?? ""
        terminalID = attributes["terminalID"] as? String ?? ""
        transactionCurrencyCode = attributes["transactionCurrencyCode"] as? String ?? ""
        transactionReplacementAmount = Global.getInt(for: attributes["transactionReplacementAmount"] as? Int ?? 0)
        transactionType = attributes["transactionType"] as? String ?? ""
        updatedAt = attributes["updatedAt"] as? String ?? ""

        if let labelData = attributes["labels"] as? [String:Any]{
            receiverCustomerHashId = labelData["receiverCustomerHashId"] as? String ?? ""
            receiverName = "\(labelData["receiverFirstName"] as? String ?? "") \(labelData["receiverLastName"] as? String ?? "")"
            senderName = "\(labelData["senderFirstName"] as? String ?? "") \(labelData["senderLastName"] as? String ?? "")"
        }
    }
}
