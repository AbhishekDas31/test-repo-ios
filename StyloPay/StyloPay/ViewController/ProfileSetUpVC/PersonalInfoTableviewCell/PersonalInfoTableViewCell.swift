//
//  PersonalInfoTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 16/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class PersonalInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var personalInfoTitle: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var dateOfBirthButton: UIButton!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    
    let color = #colorLiteral(red: 0.3607498705, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    let theme = ThemeManager.currentTheme()
    let nationalityArr = ["SG","AU","DE","HK","IN","ID","JP","MY","KR","TW","TH","GB","US","VN"]
    let countryCodeArr = ["65","61","49","852","91","62","81","60","82","886","66","44","1","84"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.layer.cornerRadius = 8.0
        self.mainView.layer.borderColor = theme.borderColor.cgColor
        self.mainView.layer.borderWidth = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureTextFields(data: PersonalnfoModel, isTextfieldEditable: Bool, isProfile:Bool, isfromProfileView :Bool = false){
        if isfromProfileView {
        self.mobileNumberView.isHidden = true
        }
        else{
            self.mobileNumberView.isHidden = !isProfile
        }
        self.noticeLabel.isHidden = isProfile
        if isProfile {
            self.noticeLabel.text = ""
        } else {
            self.noticeLabel.text = "Please enter personal info as per your identity document(Passport/ NRIC/ FIN)* \n\nFIRST NAME more than 20 characters? Use MIDDLE NAME or LAST NAME"
        }
        firstNameTextField.placeholder = "FIRST NAME*"
        firstNameTextField.text = "\(data.firstName)"
        firstNameTextField.isUserInteractionEnabled = isTextfieldEditable
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        firstNameTextField.tag = 1
        middleNameTextField.placeholder = "MIDDLE NAME"
        middleNameTextField.text = "\(data.middleName)"
        middleNameTextField.isUserInteractionEnabled = isTextfieldEditable
        middleNameTextField.attributedPlaceholder = NSAttributedString(string: middleNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        middleNameTextField.tag = 2
        lastNameTextField.placeholder = "LAST NAME*"
        lastNameTextField.text = "\(data.lastName)"
        lastNameTextField.isUserInteractionEnabled = isTextfieldEditable
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        lastNameTextField.tag = 3
        genderView.isHidden = false
        genderTextField.placeholder = "PREFERRED NAME*"
        genderTextField.isUserInteractionEnabled = isTextfieldEditable
        genderTextField.text = "\(data.preferredName)"
        genderTextField.attributedPlaceholder = NSAttributedString(string: genderTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        genderTextField.tag = 4
        birthDateTextField.placeholder = "BIRTH DATE*"
        birthDateTextField.isUserInteractionEnabled = isTextfieldEditable
        birthDateTextField.text = "\(data.dateOfBirth)"
        birthDateTextField.attributedPlaceholder = NSAttributedString(string: birthDateTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        birthDateTextField.tag = 5
        mobileNumberTextField.placeholder = "MOBILE NUMBER*"
        mobileNumberTextField.text = "\(CustomUserDefaults.getMobileNumber())"
        mobileNumberTextField.isUserInteractionEnabled = isTextfieldEditable
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: mobileNumberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        mobileNumberTextField.tag = 6
        
        emailTextfield.placeholder = "EMAIL*"
        emailTextfield.text = "\(data.email)"
        emailTextfield.isUserInteractionEnabled = isTextfieldEditable
        emailTextfield.attributedPlaceholder = NSAttributedString(string: mobileNumberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        emailTextfield.tag = 0
        emailView.isHidden = !isProfile
        if isProfile{
            self.countryCodeLabel.text = "+ \(CustomUserDefaults.getIsdCode())"
        }
    }
    
    func configureRfiTextFields(remark: String, data: PersonalnfoModel, description: String, isProfile:Bool){
        self.mobileNumberView.isHidden = true
        self.noticeLabel.text = "\(remark)"
        firstNameTextField.placeholder = "FIRST NAME*"
        firstNameTextField.text = "\(data.firstName)"
        firstNameTextField.isUserInteractionEnabled = (description == "firstName")
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        firstNameTextField.tag = 1
        middleNameTextField.placeholder = "MIDDLE NAME"
        middleNameTextField.text = "\(data.middleName)"
        middleNameTextField.isUserInteractionEnabled = (description == "middleName")
        middleNameTextField.attributedPlaceholder = NSAttributedString(string: middleNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        middleNameTextField.tag = 2
        lastNameTextField.placeholder = "LAST NAME*"
        lastNameTextField.text = "\(data.lastName)"
        lastNameTextField.isUserInteractionEnabled = (description == "lastName")
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        lastNameTextField.tag = 3
        genderView.isHidden = false
        genderTextField.placeholder = "PREFERRED NAME*"
        genderTextField.isUserInteractionEnabled = (description == "preferredName")
        genderTextField.text = "\(data.preferredName)"
        genderTextField.attributedPlaceholder = NSAttributedString(string: genderTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        genderTextField.tag = 4
        birthDateTextField.placeholder = "BIRTH DATE*"
        birthDateTextField.isUserInteractionEnabled = false
        birthDateTextField.text = "\(data.dateOfBirth)"
        birthDateTextField.attributedPlaceholder = NSAttributedString(string: birthDateTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        birthDateTextField.tag = 5
        mobileNumberTextField.placeholder = "MOBILE NUMBER*"
        mobileNumberTextField.text = "\(data.mobileNumber)"
        mobileNumberTextField.isUserInteractionEnabled = (description == "mobileNumber")
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: mobileNumberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        mobileNumberTextField.tag = 6
        
        emailTextfield.placeholder = "EMAIL*"
        emailTextfield.text = "\(data.email)"
        emailTextfield.isUserInteractionEnabled = (description == "email")
        emailTextfield.attributedPlaceholder = NSAttributedString(string: mobileNumberTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        emailTextfield.tag = 0
        emailView.isHidden = true
        if isProfile{
            self.countryCodeLabel.text = "+ \(data.countryCode)"
        }
    }
}
