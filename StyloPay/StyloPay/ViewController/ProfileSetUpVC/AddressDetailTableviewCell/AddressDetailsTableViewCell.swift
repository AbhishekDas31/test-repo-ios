//
//  AddressDetailsTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 16/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import Amplify
import Foundation

protocol ProfileAddressActionDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func updateBtn(isSuccess: Bool)
}

class AddressDetailsTableViewCell: UITableViewCell  {
    
  
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var mainTitle: UILabel!
    
    @IBOutlet var updateButton: UIButton!
    
    @IBOutlet var homeImage: UIImageView!
    
    
    
    //@IBOutlet weak var noticeLabel: UILabel!
    //@IBOutlet weak var landmarkTextField: UITextField!
    //@IBOutlet weak var firstAddressLineTextField: UITextField!
    //@IBOutlet weak var secondAddressLineTextField: UITextField!
    //@IBOutlet weak var cityTextField: UITextField!
    //@IBOutlet weak var statesTextField: UITextField!
   // @IBOutlet weak var zipcodeTextField: UITextField!
   // @IBOutlet weak var countryButton: UIButton!
//    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var dropdownImgeView: UIImageView!
  //  @IBOutlet weak var fieldsView: UIView!

    let theme = ThemeManager.currentTheme()
    let color = #colorLiteral(red: 0.3607498705, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    weak var delegate: ProfileAddressActionDelegate!
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        
        self.mainView.layer.cornerRadius = 8.0
       //self.homeImage.image = theme.dropDownColorImage
        self.mainView.layer.borderColor = theme.borderColor.cgColor
        self.mainView.layer.borderWidth = 1.0
//        self.titleLabel.numberOfLines = 0
//        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.titleLabel.lineBreakMode = .byWordWrapping
//        self.titleLabel.frame.size.width = 300
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func updateButtonClicked(_ sender: Any) {
    
        if delegate != nil { delegate.updateBtn(isSuccess: true)}
    
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
    
    
    
    
//    @IBAction func dropdownButton(_ sender: Any) {
//        if delegate != nil { delegate.tabDropdownButton(cell: self)}
//    }
    
//    func configureTextFields(row: Int, data: PersonalnfoModel, isTextfieldEditable: Bool){
//       // self.dropdownButton.isHidden = true
//       // self.dropdownImgeView.isHidden = true
//        switch row {
//        case 1:
//            self.noticeLabel.text = "Please enter address details as per your Address Proof Document(Govt. Letter/ Utility Bill/ Bank Statement)*"
//            firstAddressLineTextField.placeholder = "COUNTRY*"
//            firstAddressLineTextField.text = "\(data.billingCountry)"
//            firstAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            firstAddressLineTextField.attributedPlaceholder = NSAttributedString(string: firstAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            firstAddressLineTextField.tag = 7
//
//            secondAddressLineTextField.placeholder = "CITY*"
//            secondAddressLineTextField.text = "\(data.billingCity)"
//            secondAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            secondAddressLineTextField.attributedPlaceholder = NSAttributedString(string: secondAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            secondAddressLineTextField.tag = 8
//
//            cityTextField.placeholder = "STATE*"
//            cityTextField.text = "\(data.billingState)"
//            cityTextField.isUserInteractionEnabled = isTextfieldEditable
//            cityTextField.attributedPlaceholder = NSAttributedString(string: cityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            cityTextField.tag = 9
//            landmarkTextField.placeholder = "ADDRESS LINE 1*"
//            landmarkTextField.text = "\(data.billingAddress1)"
//            landmarkTextField.isUserInteractionEnabled = isTextfieldEditable
//            landmarkTextField.attributedPlaceholder = NSAttributedString(string: landmarkTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            landmarkTextField.tag = 10
//
//            statesTextField.placeholder = "ADDRESS LINE 2(optional)"
//            statesTextField.text = "\(data.billingAddress2)"
//            statesTextField.isUserInteractionEnabled = isTextfieldEditable
//            statesTextField.attributedPlaceholder = NSAttributedString(string: statesTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            statesTextField.tag = 11
//
//            zipcodeTextField.placeholder = "ZIPCODE / POSTCODE*"
//            zipcodeTextField.text = "\(data.billingZipCode)"
//            zipcodeTextField.isUserInteractionEnabled = isTextfieldEditable
//            zipcodeTextField.attributedPlaceholder = NSAttributedString(string: zipcodeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            zipcodeTextField.tag = 12
//        default:
//            break
//        }
//
//    }
    
//    func configureRFITextFields(row: Int, data: PersonalnfoModel, description: String, remark: String){
//       // self.dropdownButton.isHidden = true
//      //  self.dropdownImgeView.isHidden = true
//        switch row {
//        case 1:
//            self.noticeLabel.text = "\(remark)"
//            firstAddressLineTextField.placeholder = "COUNTRY*"
//            firstAddressLineTextField.text = "\(data.billingCountry)"
//            firstAddressLineTextField.isUserInteractionEnabled = (description == "billingCountry" || description == "correspondenceCountry" || description == "deliveryCountry"  || description == "all")
//            firstAddressLineTextField.attributedPlaceholder = NSAttributedString(string: firstAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            firstAddressLineTextField.tag = 7
//
//            secondAddressLineTextField.placeholder = "CITY*"
//            secondAddressLineTextField.text = "\(data.billingCity)"
//            secondAddressLineTextField.isUserInteractionEnabled = (description == "billingCity" || description == "correspondenceCity" || description == "deliveryCity"  || description == "all")
//            secondAddressLineTextField.attributedPlaceholder = NSAttributedString(string: secondAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            secondAddressLineTextField.tag = 8
//
//            cityTextField.placeholder = "STATE*"
//            cityTextField.text = "\(data.billingState)"
//            cityTextField.isUserInteractionEnabled = (description == "billingState" || description == "correspondenceState" || description == "deliveryState" || description == "all")
//            cityTextField.attributedPlaceholder = NSAttributedString(string: cityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            cityTextField.tag = 9
//            landmarkTextField.placeholder = "ADDRESS LINE 1*"
//            landmarkTextField.text = "\(data.billingAddress1)"
//            landmarkTextField.isUserInteractionEnabled = (description == "billingAddress1" || description == "correspondenceAddress1" || description == "deliveryAddress1"  || description == "all")
//            landmarkTextField.attributedPlaceholder = NSAttributedString(string: landmarkTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            landmarkTextField.tag = 10
//
//            statesTextField.placeholder = "ADDRESS LINE 2(optional)"
//            statesTextField.text = "\(data.billingAddress2)"
//            statesTextField.isUserInteractionEnabled = (description == "billingAddress2" || description == "correspondenceAddress2" || description == "deliveryAddress2"  || description == "all")
//            statesTextField.attributedPlaceholder = NSAttributedString(string: statesTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            statesTextField.tag = 11
//
//            zipcodeTextField.placeholder = "ZIPCODE / POSTCODE*"
//            zipcodeTextField.text = "\(data.billingZipCode)"
//            zipcodeTextField.isUserInteractionEnabled = (description == "billingZipCode" || description == "correspondenceZipCode" || description == "deliveryZipCode" || description == "all")
//            zipcodeTextField.attributedPlaceholder = NSAttributedString(string: zipcodeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            zipcodeTextField.tag = 12
//        default:
//            break
//        }
//
//    }
    
//    func configureView(isCorrespondence: Bool, isMailing: Bool, isBilling: Bool, row: Int){
//        switch row {
//        case 0:
//            if isCorrespondence {
//                self.heightConstraint.constant = 375
//            } else {
//                self.heightConstraint.constant = 60
//            }
//            self.fieldsView.isHidden = !isCorrespondence
//        case 1:
//            if isBilling {
//                self.heightConstraint.constant = 375
//            } else {
//                self.heightConstraint.constant = 60
//            }
//            self.fieldsView.isHidden = !isBilling
//        case 2:
//            if isMailing {
//                self.heightConstraint.constant = 375
//            } else {
//                self.heightConstraint.constant = 60
//            }
//            self.fieldsView.isHidden = !isMailing
//        default:
//            break
//        }
//    }
  
        
    
    func configureMyProfileTextFields(row: Int, data: PersonalnfoModel, isTextfieldEditable: Bool){

      //  self.noticeLabel.text = ""
       // self.dropdownButton.isHidden = false
       self.homeImage.isHidden = false
       // self.countryButton.isHidden = true
        var str = "\(data.correspondenceAddress1),\n"+"\(data.correspondenceAddress2),\n"+"\(data.correspondenceCity),\n"+"\(data.correspondenceState),\n"+"\(data.correspondenceLandmark)"
        
        debugPrint(str)
        switch row {
        case 0:
            //self.heightConstraint.constant = 60
            self.updateButton.isHidden = true
            mainTitle.text = "CORRESPONDENCE ADDRESS DETAILS"
            titleLabel.text = str
            //self.titleLabel.sizeToFit()
//            firstAddressLineTextField.placeholder = "CORRESPONDENCE ADDRESS LINE 1*"
//            firstAddressLineTextField.text = str
//            firstAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            firstAddressLineTextField.attributedPlaceholder = NSAttributedString(string: firstAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            firstAddressLineTextField.tag = 7
//
//            secondAddressLineTextField.placeholder = "CORRESPONDENCE ADDRESS LINE 2(optional)"
//            secondAddressLineTextField.text = "\(data.correspondenceAddress2)"
//            secondAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            secondAddressLineTextField.attributedPlaceholder = NSAttributedString(string: secondAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            secondAddressLineTextField.tag = 8
//
//            cityTextField.placeholder = "CORRESPONDENCE STATE*"
//            cityTextField.text = "\(data.correspondenceState)"
//            cityTextField.isUserInteractionEnabled = isTextfieldEditable
//            cityTextField.attributedPlaceholder = NSAttributedString(string: cityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            cityTextField.tag = 9
//
//            landmarkTextField.placeholder = "CORRESPONDENCE CITY*"
//            landmarkTextField.text = "\(data.correspondenceCity)"
//            landmarkTextField.isUserInteractionEnabled = isTextfieldEditable
//            landmarkTextField.attributedPlaceholder = NSAttributedString(string: landmarkTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            landmarkTextField.tag = 10
//
//            statesTextField.placeholder = "CORRESPONDENCE LANDMARK"
//            statesTextField.text = "\(data.correspondenceLandmark)"
//            statesTextField.isUserInteractionEnabled = isTextfieldEditable
//            statesTextField.attributedPlaceholder = NSAttributedString(string: statesTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            statesTextField.tag = 11
//
//            zipcodeTextField.placeholder = "CORRESPONDENCE ZIPCODE / POSTCODE*"
//            zipcodeTextField.text = "\(data.correspondenceZipCode)"
//            zipcodeTextField.isUserInteractionEnabled = isTextfieldEditable
//            zipcodeTextField.attributedPlaceholder = NSAttributedString(string: zipcodeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            zipcodeTextField.tag = 12
        case 2:
            mainTitle.text = "MAILING ADDRESS DETAILS"
            titleLabel.text = """
                \(data.deliveryAddress1)
                \(data.deliveryAddress2)
                \(data.deliveryState)
                \(data.deliveryCity)
                \(data.deliveryLandmark)
                \(data.deliveryZipCode)
                """
//            firstAddressLineTextField.placeholder = "MAILING ADDRESS LINE 1*"
//            firstAddressLineTextField.text = "\(data.deliveryAddress1)"
//            firstAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            firstAddressLineTextField.attributedPlaceholder = NSAttributedString(string: firstAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            firstAddressLineTextField.tag = 13
//
//            secondAddressLineTextField.placeholder = "MAILING ADDRESS LINE 2(optional)"
//            secondAddressLineTextField.text = "\(data.deliveryAddress2)"
//            secondAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            secondAddressLineTextField.attributedPlaceholder = NSAttributedString(string: secondAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            secondAddressLineTextField.tag = 14
//
//            cityTextField.placeholder = "MAILING STATE*"
//            cityTextField.text = "\(data.deliveryState)"
//            cityTextField.isUserInteractionEnabled = isTextfieldEditable
//            cityTextField.attributedPlaceholder = NSAttributedString(string: cityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            cityTextField.tag = 15
//
//            landmarkTextField.placeholder = "MAILING CITY*"
//            landmarkTextField.text = "\(data.deliveryCity)"
//            landmarkTextField.isUserInteractionEnabled = isTextfieldEditable
//            landmarkTextField.attributedPlaceholder = NSAttributedString(string: landmarkTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            landmarkTextField.tag = 16
//
//            statesTextField.placeholder = "MAILING LANDMARK"
//            statesTextField.text = "\(data.deliveryLandmark)"
//            statesTextField.isUserInteractionEnabled = isTextfieldEditable
//            statesTextField.attributedPlaceholder = NSAttributedString(string: statesTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            statesTextField.tag = 17
//
//            zipcodeTextField.placeholder = "MAILING ZIPCODE / POSTCODE*"
//            zipcodeTextField.text = "\(data.deliveryZipCode)"
//            zipcodeTextField.isUserInteractionEnabled = isTextfieldEditable
//            zipcodeTextField.attributedPlaceholder = NSAttributedString(string: zipcodeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            zipcodeTextField.tag = 18
            
        case 1:
            self.updateButton.isHidden = true
            mainTitle.text = "BILLING ADDRESS DETAILS"
            titleLabel.text = """
                \(data.billingAddress1)
                \(data.billingAddress2)
                \(data.billingState)
                \(data.billingCity)
                \(data.billingLandmark)
                \(data.billingZipCode)
                """
          //  self.titleLabel.sizeToFit()
//            firstAddressLineTextField.placeholder = "BILLING ADDRESS LINE 1*"
//            firstAddressLineTextField.text = "\(data.billingAddress1)"
//            firstAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            firstAddressLineTextField.attributedPlaceholder = NSAttributedString(string: firstAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            firstAddressLineTextField.tag = 19
//            
//            secondAddressLineTextField.placeholder = "BILLING ADDRESS LINE 2(optional)"
//            secondAddressLineTextField.text = "\(data.billingAddress2)"
//            secondAddressLineTextField.isUserInteractionEnabled = isTextfieldEditable
//            secondAddressLineTextField.attributedPlaceholder = NSAttributedString(string: secondAddressLineTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            secondAddressLineTextField.tag = 20
//            
//            cityTextField.placeholder = "BILLING STATE*"
//            cityTextField.text = "\(data.billingState)"
//            cityTextField.isUserInteractionEnabled = isTextfieldEditable
//            cityTextField.attributedPlaceholder = NSAttributedString(string: cityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            cityTextField.tag = 21
//            
//            landmarkTextField.placeholder = "BILLING CITY*"
//            landmarkTextField.text = "\(data.billingCity)"
//            landmarkTextField.isUserInteractionEnabled = isTextfieldEditable
//            landmarkTextField.attributedPlaceholder = NSAttributedString(string: landmarkTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            landmarkTextField.tag = 22
//            
//            statesTextField.placeholder = "BILLING LANDMARK"
//            statesTextField.text = "\(data.billingLandmark)"
//            statesTextField.isUserInteractionEnabled = isTextfieldEditable
//            statesTextField.attributedPlaceholder = NSAttributedString(string: statesTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            statesTextField.tag = 23
//            
//            zipcodeTextField.placeholder = "BILLING ZIPCODE / POSTCODE*"
//            zipcodeTextField.text = "\(data.billingZipCode)"
//            zipcodeTextField.isUserInteractionEnabled = isTextfieldEditable
//            zipcodeTextField.attributedPlaceholder = NSAttributedString(string: zipcodeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
//            zipcodeTextField.tag = 24
        default:
            break
        }
        
    }
    
    
    
    
    
}

