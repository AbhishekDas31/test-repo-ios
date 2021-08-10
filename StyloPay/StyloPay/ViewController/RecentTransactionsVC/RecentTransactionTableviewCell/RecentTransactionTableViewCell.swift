//
//  RecentTransactionTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 13/08/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class RecentTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(data : TransactionModel){
        self.dateTimeLabel.text = "\(data.createdAt.stringToStringDate("dd MMM yyyy hh:mm a") ?? "")"
        orderIDLabel.text = "\(data.retrievalReferenceNumber)"
        let currencySymbol = configureCurrencySymbol(countryCode: data.billingCurrencyCode)
        if data.merchantName.isEmpty{
            titleLabel.text = "\(data.transactionType)"
        }else{
            titleLabel.text = "\(data.merchantName)"
        }

        switch data.debit {
        case 1:
            transactionAmountLabel.text = "(-) \(currencySymbol) \(data.authAmount)"
            switch data.status {
            case "Pending", "Rejected", "Declined", "Blocked":
                let excamalation = AssetsImages.excamalation
                iconImage.image = excamalation
                iconImage.tintColor = nil

            default:
                if #available(iOS 13.0, *) {
                    let upArrow = AssetsImages.downArrow?.withRenderingMode(.alwaysTemplate)
                    iconImage.image = upArrow
                    iconImage.tintColor = UIColor.blue
                } else {
                    // Fallback on earlier versions
                }

            }
        default:
            transactionAmountLabel.text = "(+) \(currencySymbol) \(data.authAmount)"
            switch data.status {
            case "Pending", "Rejected", "Declined", "Blocked":

                let excamalation = AssetsImages.excamalation
                iconImage.image = excamalation
                iconImage.tintColor = nil

            default:
                if #available(iOS 13.0, *) {
                    let upArrow = AssetsImages.upArrow?.withRenderingMode(.alwaysTemplate)
                    iconImage.image = upArrow
                    iconImage.tintColor = UIColor.green
                } else {
                    // Fallback on earlier versions
                }
            }
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
}

extension String
{
    func stringToStringDate(_ format:String) -> String?
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // convert your string to date
        let yourDate = formatter.date(from: self)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = format
        // again convert your date to string
        return formatter.string(from: yourDate!)
    }
}
