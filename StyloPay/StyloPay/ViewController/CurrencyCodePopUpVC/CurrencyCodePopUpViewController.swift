//
//  CurrencyCodePopUpViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 09/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol CurrencyCodeDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabCountryCode(country: String, currencyCode: String, countryFlag: String, currencyIcon:String,currencySymbol:String, isTo: Bool, isFrom: Bool, isFiltered: Bool)
}

class CurrencyCodePopUpViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> CurrencyCodePopUpViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! CurrencyCodePopUpViewController
    }

    @IBOutlet weak var currencyListView: UIView!
    @IBOutlet weak var currencyCodeTableView: UITableView!{
        didSet{
            currencyCodeTableView.delegate = self
            currencyCodeTableView.dataSource = self
        }
    }

    var isFilter = false
    var walletBalanceArray = [WalletBalanceModel]()
   /* var currencyData = [
        ["country": "AUS","currencySymbol": "A$", "currencyCode": "AUD", "currencyIcon" : "AUD", "countryFlag": "australia", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "EUR","currencySymbol": "€", "currencyCode": "EUR", "currencyIcon" : "euro", "countryFlag" : "europe", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "SGP","currencySymbol": "S$", "currencyCode": "SGD", "currencyIcon" : "dollar12", "countryFlag": "singapore", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "GBR","currencySymbol": "£", "currencyCode": "GBP", "currencyIcon" : "GBP", "countryFlag" : "uk", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "IND", "currencySymbol": "₹","currencyCode": "INR", "currencyIcon" : "yenna", "countryFlag" : "india", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "USA","currencySymbol": "$", "currencyCode": "USD", "currencyIcon" : "USD", "countryFlag" : "usa", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "HKG","currencySymbol": "HK$", "currencyCode": "HKD", "currencyIcon" : "HKD", "countryFlag" : "hong-kong", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "IDN","currencySymbol": "Rp", "currencyCode": "IDR", "currencyIcon" : "rp", "countryFlag" : "indonesia", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "JPN","currencySymbol": "¥", "currencyCode": "JPY", "currencyIcon" : "yen", "countryFlag" : "japan", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "KOR","currencySymbol": "₩", "currencyCode": "KRW", "currencyIcon" : "KRW", "countryFlag" : "SKflag", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "MYS", "currencySymbol": "RM","currencyCode": "MYR", "currencyIcon" : "MYR", "countryFlag" : "malaysia", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "TWN","currencySymbol": "元", "currencyCode": "TWD", "currencyIcon" : "twd", "countryFlag" : "taiwan", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "THA","currencySymbol": "฿", "currencyCode": "THB", "currencyIcon" : "THB", "countryFlag" : "thailand", "isCurrencyAvailable": false, "walletBalance": 0.00],
        ["country": "VNM","currencySymbol": "₫", "currencyCode": "VND", "currencyIcon" : "VND", "countryFlag" : "vietnam", "isCurrencyAvailable": false, "walletBalance": 0.00],
    ]*/
    var sortedcurrencyData = [[String: Any]]()
    var isExchange = false
    var isFromCurrency = false
    var isToCurrency = false
    weak var delegate: CurrencyCodeDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCell()
    }
    
    func configureCell() {
        currencyCodeTableView.estimatedRowHeight = 60
        currencyCodeTableView.separatorStyle = .none
        currencyCodeTableView.separatorInset = UIEdgeInsets.zero
        currencyCodeTableView.sectionFooterHeight = 56
        currencyCodeTableView.rowHeight = UITableView.automaticDimension
        currencyCodeTableView.register(UINib(nibName: "CurrencyCodeTableViewCell", bundle: nil),forCellReuseIdentifier: "CurrencyCodeTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func configureView(){
        for index in 0..<currencyData.count{
            for walletIndex in 0..<self.walletBalanceArray.count{
                let currencycode = currencyData[index]["currencyCode"] as? String ?? ""
                if self.walletBalanceArray[walletIndex].curSymbol == currencycode{
                    currencyData[index]["isCurrencyAvailable"] = true
                    currencyData[index]["walletBalance"] = self.walletBalanceArray[walletIndex].balance
                    break
                }
            }
            
        }
        self.sortCurrencyList()
        self.currencyListView.layer.cornerRadius = 10.0
    }
    
    func sortCurrencyList(){
        self.sortedcurrencyData.removeAll()
        self.sortedcurrencyData = currencyData.sorted { $0["walletBalance"] as? Double ?? 0.0 > $1["walletBalance"] as? Double ?? 0.0 }
        print(" Sorted  : ", self.sortedcurrencyData)
    }
    
    @IBAction func dismissScreenTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CurrencyCodePopUpViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter{
            return self.sortedcurrencyData.count + 1
        }else{
            return self.sortedcurrencyData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let countryCodeCell =  tableView.dequeueReusableCell(withIdentifier: "CurrencyCodeTableViewCell", for: indexPath) as? CurrencyCodeTableViewCell{
            countryCodeCell.amountLabel.isHidden = true
            if isFilter{
                if indexPath.row == 0{
                    countryCodeCell.currencyCodeLabel.text = "All"
                    countryCodeCell.currncyCodeImage.isHidden = true
                    countryCodeCell.addButton.isHidden = true
                    countryCodeCell.amountLabel.isHidden = true
                    countryCodeCell.imageWidth.constant = 0.0
                }else{
                    let model = self.sortedcurrencyData[indexPath.row-1]
                    let code = model["currencyCode"] ?? ""
                    let countryFlag = model["countryFlag"] ?? ""
                    countryCodeCell.currencyCodeLabel.text = "CURRENCY: \(code)"
                    let imageName = "\(countryFlag)"
                    countryCodeCell.imageWidth.constant = 30.0
                    countryCodeCell.currncyCodeImage.image = UIImage(named: imageName)
                    countryCodeCell.addButton.isHidden = true
                    countryCodeCell.amountLabel.isHidden = true
                }
            }else{
                let model = self.sortedcurrencyData[indexPath.row]
                let code = model["currencyCode"] ?? ""
                let countryFlag = model["countryFlag"] ?? ""
                let imageName = "\(countryFlag)"
                countryCodeCell.currncyCodeImage.image = UIImage(named: imageName)
                let isCurrencyAvailable = model["isCurrencyAvailable"] as? Bool ?? false
                let walletBalance = model["walletBalance"] as? Double ?? 0.00
                if !isExchange{
                    countryCodeCell.addButton.isHidden = isCurrencyAvailable
                    countryCodeCell.amountLabel.isHidden = true
                    //countryCodeCell.amountLabel.text = "\(walletBalance)"
                    countryCodeCell.currencyCodeLabel.text = "CURRENCY: \(code)\nBALANCE: \(walletBalance)"
                }else{
                    countryCodeCell.addButton.isHidden = true
                    countryCodeCell.amountLabel.isHidden = true
                    countryCodeCell.currencyCodeLabel.text = "CURRENCY: \(code)"
                }
            }
            
            
            return countryCodeCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFilter{
            if indexPath.row == 0{
                if self.delegate != nil { self.delegate.tabCountryCode(country: "" , currencyCode: "ALL" ,countryFlag: "" , currencyIcon:"", currencySymbol: "" , isTo: false, isFrom: false, isFiltered: self.isFilter) }
            }else{
                let model = self.sortedcurrencyData[indexPath.row-1]
                if self.delegate != nil { self.delegate.tabCountryCode(country: model["country"] as? String ?? "" , currencyCode: model["currencyCode"]  as? String ?? "" ,countryFlag: model["countryFlag"]  as? String ?? "" , currencyIcon:model["currencyIcon"]  as? String ?? "", currencySymbol: model["currencySymbol"] as? String ?? "", isTo: self.isToCurrency, isFrom: self.isFromCurrency, isFiltered: self.isFilter) }
            }
            
            self.dismiss(animated: true, completion: nil)
        }else{
            let model = self.sortedcurrencyData[indexPath.row]
            if self.delegate != nil { self.delegate.tabCountryCode(country: model["country"] as? String ?? "" , currencyCode: model["currencyCode"]  as? String ?? "" ,countryFlag: model["countryFlag"]  as? String ?? "" , currencyIcon:model["currencyIcon"]  as? String ?? "", currencySymbol: model["currencySymbol"] as? String ?? "" , isTo: self.isToCurrency, isFrom: self.isFromCurrency, isFiltered: self.isFilter) }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
