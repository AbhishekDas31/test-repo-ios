//
//  WalletBalanceModel.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 09/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class WalletBalanceModel: NSObject {
    var mccData = [Any]()
    var pocketName = ""
    var balance = 0.0
    var curSymbol = ""
    var defaultValue = false
    var withHoldingBalance = 0.0
    var isoCode = ""
    
    override init() {
        
    }
    
    convenience init(_ attributes: [AnyHashable: Any]) {
        self.init()
        if let mccDataArray = attributes["mccData"] as? [Any]{
            for data in mccDataArray{
                mccData.append(data)
            }
        }
        
        pocketName = attributes["pocketName"] as? String ?? ""
        curSymbol = attributes["curSymbol"] as? String ?? ""
        isoCode = attributes["isoCode"] as? String ?? ""
        balance = Global.getDouble(for: attributes["balance"] as? Double ?? 0.0)
        withHoldingBalance = Global.getDouble(for: attributes["withHoldingBalance"] as? Double ?? 0.0)
        if curSymbol == "USD"
        {
            defaultValue = true
        }
        else {
            defaultValue = false
        }
    }
}
