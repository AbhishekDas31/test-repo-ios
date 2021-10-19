//
//  AddressSetUpTableViewCell.swift
//  StyloPay
//
//  Created by Abhishek das on 30/09/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//




import UIKit

//protocol ProfileAddressActionDelegate : NSObjectProtocol {
//    // MARK: - Protocol Metthods
//   // func tabDropdownButton(cell: AddressDetailsTableViewCell)
//}

class AddressSetUpTableViewCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var noticeLabel: UILabel!
    
    
    @IBOutlet var fieldView: UIView!
    
    
    @IBOutlet var countryTextField: UITextField!
    
    @IBOutlet var countryButton: UIButton!
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var stateTextField: UITextField!
    
    @IBOutlet var addressLine1TextField: UITextField!
    
    @IBOutlet var addressLine2TextField: UITextField!
    
    @IBOutlet var pinCodeTextField: UITextField!
    
    let theme = ThemeManager.currentTheme()
        let color = #colorLiteral(red: 0.3607498705, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
               self.mainView.layer.cornerRadius = 8.0

       self.mainView.layer.borderColor = theme.borderColor.cgColor
      self.mainView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
   func configureTextFields(row: Int, data: PersonalnfoModel, isTextfieldEditable: Bool){

        switch row {
        case 1:
            self.noticeLabel.text = "Please enter address details as per your Address Proof Document(Govt. Letter/ Utility Bill/ Bank Statement)*"
            countryTextField.placeholder = "COUNTRY*"
            countryTextField.text = "\(data.billingCountry)"
            countryTextField.isUserInteractionEnabled = isTextfieldEditable
            countryTextField.attributedPlaceholder = NSAttributedString(string: countryTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
            countryTextField.tag = 7

            cityTextField.placeholder = "CITY*"
            cityTextField.text = "\(data.billingCity)"
            cityTextField.isUserInteractionEnabled = isTextfieldEditable
            cityTextField.attributedPlaceholder = NSAttributedString(string: cityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
            cityTextField.tag = 8

            stateTextField.placeholder = "STATE*"
            stateTextField.text = "\(data.billingState)"
            stateTextField.isUserInteractionEnabled = isTextfieldEditable
            stateTextField.attributedPlaceholder = NSAttributedString(string: stateTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
            stateTextField.tag = 9
            
            addressLine1TextField.placeholder = "ADDRESS LINE 1*"
            addressLine1TextField.text = "\(data.billingAddress1)"
            addressLine1TextField.isUserInteractionEnabled = isTextfieldEditable
            addressLine1TextField.attributedPlaceholder = NSAttributedString(string: addressLine1TextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
            addressLine1TextField.tag = 10

            addressLine2TextField.placeholder = "ADDRESS LINE 2(optional)"
            addressLine2TextField.text = "\(data.billingAddress2)"
            addressLine2TextField.isUserInteractionEnabled = isTextfieldEditable
            addressLine2TextField.attributedPlaceholder = NSAttributedString(string: addressLine2TextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
            addressLine2TextField.tag = 11

            pinCodeTextField.placeholder = "ZIPCODE / POSTCODE*"
            pinCodeTextField.text = "\(data.billingZipCode)"
            pinCodeTextField.isUserInteractionEnabled = isTextfieldEditable
            pinCodeTextField.attributedPlaceholder = NSAttributedString(string: pinCodeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
            pinCodeTextField.tag = 12
        default:
            break
        }

//    }
    
//    func configureRFITextFields(row: Int, data: PersonalnfoModel, description: String, remark: String){
//        self.dropdownButton.isHidden = true
//        self.dropdownImgeView.isHidden = true
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

    
   
    

}
}
