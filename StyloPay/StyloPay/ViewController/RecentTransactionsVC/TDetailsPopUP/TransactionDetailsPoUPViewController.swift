//
//  TransactionDetailsPoUPViewController.swift
//  StyloPay
//
//  Created by Rohit Singh on 5/31/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit

class TransactionDetailsPoUPViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imgaeView:UIImageView!
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var tNameLbl: UILabel!
    @IBOutlet weak var tAmountLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var reqAmtLbl: UILabel!
    @IBOutlet weak var cRateLbl: UILabel!
    @IBOutlet weak var tStatusLbl: UILabel!
    @IBOutlet weak var tIdLbl: UILabel!


    // MARK: - Properties
    var dataModel:TransactionModel?


    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imgaeView.layer.cornerRadius = 7.0
        self.tNameLbl.text = ""
        self.confiGureView()

        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bgView.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
    }

    // MARK: - Helpers
    private func confiGureView()
    {
//        /descriptionLbl.attributedText =

        if let data = dataModel {
            if data.merchantName.isEmpty{
                tNameLbl.attributedText = NSMutableAttributedString()
                    .bold("\(extractTypeName(type: data.transactionType))\n\n")
                    .normal(
                        data.transactionType == "Customer_Wallet_Debit_Fund_Transfer" || data.transactionType == "Customer_Wallet_Credit_Fund_Transfer" ?
                            data.debit == 1 ?"FUND TRANSFERRED TO \(data.receiverName)" : "FUND RECEIVED FROM \(data.senderName)" : "\(data.comments)"
                    )

            }else{
                tNameLbl.attributedText = NSMutableAttributedString()
                    .bold("")
                    .normal(
                        data.transactionType == "Customer_Wallet_Debit_Fund_Transfer" || data.transactionType == "Customer_Wallet_Credit_Fund_Transfer" ?
                            data.debit == 1 ?"FUND TRANSFERRED TO \(data.receiverName)" : "FUND RECEIVED FROM \(data.senderName)" : "\(data.comments)"
                    )
            }
            let currencySymbol = configureCurrencySymbol(countryCode: data.billingCurrencyCode)
            tAmountLbl.text = "\(currencySymbol) \(data.authAmount)"

            self.dateLbl.text = "\(data.createdAt.stringToStringDate("dd MMM yyyy") ?? "")"
            self.timeLbl.text = "\(data.createdAt.stringToStringDate("hh:mm a") ?? "")"
            self.tStatusLbl.text = data.status
            self.cRateLbl.text = "\(data.billingConversionRate)"
            self.tIdLbl.text = "\(data.retrievalReferenceNumber)"
            let tranScurrencySymbol = configureCurrencySymbol(countryCode: data.transactionCurrencyCode)
            self.reqAmtLbl.text = "\(tranScurrencySymbol) \(data.cardTransactionAmount)"
            self.view.layoutIfNeeded()
        }

    }

    func configureCurrencySymbol(countryCode: String) -> String{
        for index in 0..<currencyData.count{
            let currencyCode = currencyData[index]["currencyCode"] as? String ?? ""

            if countryCode == currencyCode{
                let currencySymbol = currencyData[index]["currencySymbol"] as? String ?? ""
                return currencySymbol
            }
        }
        return ""
    }

    func extractTypeName(type:String) -> String
    {
        switch type {
        case "Insufficient funds":
            return  "Insufficient funds"
        case "Wallet_Fund_Transfer":
            return  "Wallet Fund Exchange"
        case "Customer_Wallet_Debit_Fund_Transfer":
            return "Fund Transfer"
        case "Customer_Wallet_Credit_Fund_Transfer":
            return "Fund Received"
        default:
            return ""
        }
    }

}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return UIDevice.current.userInterfaceIdiom == .phone ? 16 : 25 }
    var boldFont:UIFont { return UIFont(name: "Barlow-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "Barlow-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

