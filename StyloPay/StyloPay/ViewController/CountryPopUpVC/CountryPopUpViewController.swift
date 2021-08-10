//
//  CountryPopUpViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 18/12/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol CountryCodeDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabCountryCode(country: String,row: Int)
}

class CountryPopUpViewController: UIViewController {

    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> CountryPopUpViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! CountryPopUpViewController
    }

    @IBOutlet weak var countryListView: UIView!
    @IBOutlet weak var textfieldCountry:UITextField!
    @IBOutlet weak var countryTableview: UITableView!{
        didSet{
            countryTableview.delegate = self
            countryTableview.dataSource = self
        }
    }

    weak var delegate: CountryCodeDelegate!
    var countryNameArray = [String]()
    var filtercountryNameArray = [String]()
    //var countryFlagArray = [String]()
    var isFilterApplied = false


    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
    }

    func configureCell() {
        self.filtercountryNameArray = countryNameArray
        textfieldCountry.delegate = self
        textfieldCountry.setLeftPaddingPoints(10.0)
        textfieldCountry.layer.borderColor = UIColor().colorFromHexString("25000000").cgColor
        textfieldCountry.layer.cornerRadius = 4
        textfieldCountry.layer.borderWidth = 1.0
        textfieldCountry.layer.masksToBounds = true
        textfieldCountry.placeholder    = "Search..."
        textfieldCountry.attributedPlaceholder = NSAttributedString(string: textfieldCountry.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor().colorFromHexString("B4B4B4")])
        textfieldCountry.returnKeyType  = .done
        countryTableview.estimatedRowHeight = 60
        countryTableview.separatorStyle = .none
        countryTableview.separatorInset = UIEdgeInsets.zero
        countryTableview.sectionFooterHeight = 56
        countryTableview.rowHeight = UITableView.automaticDimension
        countryTableview.register(UINib(nibName: "CurrencyCodeTableViewCell", bundle: nil),forCellReuseIdentifier: "CurrencyCodeTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CountryPopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        return filtercountryNameArray.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let countryCodeCell =  tableView.dequeueReusableCell(withIdentifier: "CurrencyCodeTableViewCell", for: indexPath) as? CurrencyCodeTableViewCell{
            let countryName = self.filtercountryNameArray[indexPath.row]
           // let countryImage = self.countryFlagArray[indexPath.row]
             let index =  countryNameArray.indexes(of: countryName)

                if index.count == 1 {
                    countryCodeCell.currencyCodeLabel.text = "\(countryName) +\(countryCodeList[index[0]])"
                    let imageName = "\(countryFlags[index[0]])"
                    countryCodeCell.currncyCodeImage.image = UIImage(named: imageName)
                }
            countryCodeCell.addButton.isHidden = true
            countryCodeCell.amountLabel.isHidden = true
            return countryCodeCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryName = self.filtercountryNameArray[indexPath.row]
        let index =  countryNameArray.indexes(of: countryName)
        if index.count == 1 {
        if self.delegate != nil { self.delegate.tabCountryCode(country: countryName, row: index[0]) }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: -textfield search methods
// MARK: -================================
extension CountryPopUpViewController : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if (range.location == 0 && string == " ") ||  textField.textInputMode == nil {return false}
              if (string == "\n") {
                  textField.resignFirstResponder()
              }
              guard let userEnteredString = textField.text else { return false }
              let newString = (userEnteredString as NSString).replacingCharacters(in: range, with: string) as NSString
              //let s = String(newString)

        if string.containsEmoji {
            return false
        }

//        guard let textD = textField.text else {return false}
//        guard !textD.isEmpty else {return false}
//
//        if string == " " {
//
//            return false
//        }


       // let newString = textField.replacingCaracter(in: range, with: string)
        let searchText = newString.trimmingCharacters(in: .whitespaces)
        if  !searchText.isEmpty {

            self.filtercountryNameArray.removeAll(keepingCapacity: false)
            filterContentForSearchText(searchText: searchText)
            self.isFilterApplied = true
            self.countryTableview.reloadData()
        } else {

            self.filtercountryNameArray.removeAll(keepingCapacity: false)
            self.filtercountryNameArray = self.countryNameArray
            self.isFilterApplied = false
            self.countryTableview.reloadData()
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // releasing the focus on the textField and hiding the keyboard
        self.textfieldCountry.resignFirstResponder()
        return true
    }

    func filterContentForSearchText(searchText: String) {

        filtercountryNameArray = countryNameArray.filter { item in


            return (item.lowercased().contains(searchText.lowercased()))
        }
    }
}
extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
