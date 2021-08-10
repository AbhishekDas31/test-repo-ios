//
//  RemittanceAddressDetailTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 19/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol PermanentAddressActionDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabcheckBoxButton(cell: RemittanceAddressDetailTableViewCell)
}

class RemittanceAddressDetailTableViewCell: UITableViewCell {
    
    let color = #colorLiteral(red: 0.3607498705, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var nationalityButton: UIButton!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var codeDropdownButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var buildingNameTextField: UITextField!
    @IBOutlet weak var unitNUmberTextField: UITextField!
    @IBOutlet weak var blockNumber: UITextField!
    @IBOutlet weak var floorNumber: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var singaporeResidenceButton: UIButton!
    
    weak var delegate: PermanentAddressActionDelegate!
    let theme = ThemeManager.currentTheme()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 8.0
        self.mainView.layer.borderColor = theme.borderColor.cgColor
        self.mainView.layer.borderWidth = 1.0
        singaporeResidenceButton.setBackgroundImage(theme.uncheckBoxColorImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(){
        nationalityTextField.placeholder = "NATIONALITY"
        nationalityTextField.attributedPlaceholder = NSAttributedString(string: nationalityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        nationalityTextField.tag = 6
        mobileNumberTextField.placeholder = "MOBILE NUMBER"
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: mobileNumberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        mobileNumberTextField.tag = 7
        codeTextField.placeholder = "CURRENCY CODE"
        codeTextField.attributedPlaceholder = NSAttributedString(string: codeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        codeTextField.tag = 8
        cityTextField.placeholder = "CITY"
        cityTextField.attributedPlaceholder = NSAttributedString(string: cityTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        cityTextField.tag = 9
        
        stateTextField.placeholder = "STATE"
        stateTextField.attributedPlaceholder = NSAttributedString(string: stateTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        stateTextField.tag = 10
        streetNameTextField.placeholder = "STREET NAME"
        streetNameTextField.attributedPlaceholder = NSAttributedString(string: streetNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        streetNameTextField.tag = 11
        
        buildingNameTextField.placeholder = "BUILDING NAME"
        buildingNameTextField.attributedPlaceholder = NSAttributedString(string: buildingNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        buildingNameTextField.tag = 12
        unitNUmberTextField.placeholder = "UNIT NUMBER"
        unitNUmberTextField.attributedPlaceholder = NSAttributedString(string: unitNUmberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        unitNUmberTextField.tag = 13
        blockNumber.placeholder = "BLOCK NUMBER"
        blockNumber.attributedPlaceholder = NSAttributedString(string: blockNumber.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        blockNumber.tag = 14
        floorNumber.placeholder = "FLOOR NUMBER"
        floorNumber.attributedPlaceholder = NSAttributedString(string: floorNumber.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        floorNumber.tag = 15
        zipcodeTextField.placeholder = "ZIPCODE/POSTCODE"
        zipcodeTextField.attributedPlaceholder = NSAttributedString(string: zipcodeTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        zipcodeTextField.tag = 16
    }
    
    @IBAction func checkBoxButtonPressed(_ sender: Any) {
        if delegate != nil { delegate.tabcheckBoxButton(cell: self)}
    }
    
}
