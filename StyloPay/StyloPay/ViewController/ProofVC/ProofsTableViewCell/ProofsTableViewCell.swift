//
//  ProofsTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 17/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit


protocol ProofsActionDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabUploadDropdownButton(cell: ProofsTableViewCell)
    func tabOnCamera(cell: ProofsTableViewCell)
    func tabOnDropDownButton(cell: ProofsTableViewCell)
}


class ProofsTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroungImageView: UIImageView!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var uploadDropdownButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var cameraButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var uploadDropDownButtonWidth: NSLayoutConstraint!
    
    let color = #colorLiteral(red: 0.3607498705, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    let theme = ThemeManager.currentTheme()
    weak var delegate: ProofsActionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroungImageView.layer.cornerRadius = 5.0
        textfieldView.layer.cornerRadius = 5.0
        configureTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureTheme(){
        self.titleLabel.textColor = theme.bottomUnselectedTabButtonColor
        self.backgroungImageView.image = theme.buttonsBackgroundImage
        self.cameraButton.setImage(theme.cameraColorImage, for: .normal)
    }
    
    func configureCell(row: Int, data: ProofsModel, isRfi: Bool, rfiData: RFIDetailsModel){
        dataTextField.tag = row
        switch row {
        case 0:
            self.titleLabel.text = "DOCUMENT TYPE"
            mainButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.dropDownColorImage, for: .normal)
//            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = isRfi
            dataTextField.placeholder = "Select"
            dataTextField.isUserInteractionEnabled = false

            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 25
            if isRfi {
                dataTextField.text = "\(rfiData.rfiDescription)".uppercased()
            }
            else {
                dataTextField.text = "\(data.identificationType)"
            }

        case 1:
            self.titleLabel.text = "DOCUMENT NUMBER"
            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Enter Document Number"
            self.cameraButtonWidth.constant = 0
            dataTextField.text = "\(data.identificationValue)"
            dataTextField.isUserInteractionEnabled = true
            self.uploadDropDownButtonWidth.constant = 0

        case 2:
            self.titleLabel.text = "NAME AS PER DOCUMENT"
            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Enter Document Holder Name"
            self.cameraButtonWidth.constant = 0
            dataTextField.text = "\(data.identificationDocHolderName)"
            dataTextField.isUserInteractionEnabled = true
            self.uploadDropDownButtonWidth.constant = 0
            
        case 3:
            self.titleLabel.text = "ISSUING AUTHORITY \n\nFill in Country name if issuing authority is not avialable"
//            mainButton.isHidden = false
            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Enter Issuing Authority"
            dataTextField.text = "\(data.identificationIssuingAuthority)"
            dataTextField.isUserInteractionEnabled = true
            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 0

        case 4:
            self.titleLabel.text = "ISSUING COUNTRY"
            mainButton.isHidden = false
           // mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Select Country"
            dataTextField.text = "\(data.identificationIssuingCountry)"
            dataTextField.isUserInteractionEnabled = false
            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 25
        case 5:
            self.titleLabel.text = "ISSUANCE DATE"
            mainButton.isHidden = false
//            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.dropDownColorImage, for: .normal)
            dataTextField.placeholder = "Enter Date"
            dataTextField.text = "\(data.identificationIssuingDate)"
            dataTextField.isUserInteractionEnabled = false
            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 25
        case 6:
            self.titleLabel.text = "EXPIRY DATE"
            mainButton.isHidden = false
//            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.dropDownColorImage, for: .normal)
            dataTextField.placeholder = "Enter Date"
            self.cameraButtonWidth.constant = 0
            dataTextField.text = "\(data.identificationDocExpiry)"
            dataTextField.isUserInteractionEnabled = false
            self.uploadDropDownButtonWidth.constant = 25
        case 7:
            self.titleLabel.text = "UPLOAD DOCUMENT"
            self.cameraButton.isHidden = false
            mainButton.isHidden = true
            self.uploadDropdownButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.uploadColorImage, for: .normal)
          //  dataTextField.text = data.identificationFileDocumentArray[0].fileName
            if data.identificationFileDocumentArray.count >= 1
            {
                dataTextField.text = "Document_Image"
            }
            else {
                dataTextField.text = ""
            }
            //Document_Image_2
            dataTextField.placeholder = "Upload File"
            self.cameraButtonWidth.constant = 25
            self.uploadDropDownButtonWidth.constant = 25
            dataTextField.isUserInteractionEnabled = false
//        case 8:
//            self.titleLabel.text = "UPLOAD DOCUMENT(BACK)"
//            self.cameraButton.isHidden = false
//            mainButton.isHidden = true
//            self.uploadDropdownButton.isHidden = false
//            self.uploadDropdownButton.setImage(theme.uploadColorImage, for: .normal)
//            if data.identificationFileDocumentArray.count > 1
//            {
//                dataTextField.text = "Document_Image_2"
//            }
//            else {
//                dataTextField.text = ""
//            }
//
//            dataTextField.placeholder = "Upload File"
//            self.cameraButtonWidth.constant = 25
//            self.uploadDropDownButtonWidth.constant = 25
//            dataTextField.isUserInteractionEnabled = false
        default:
            break
        }
        dataTextField.attributedPlaceholder = NSAttributedString(string: dataTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }

    func configureCellIdProof(row: Int, data: ProofsModel, isRfi: Bool, rfiData: RFIDetailsModel){
        dataTextField.tag = row
        switch row {
        case 0:
            self.titleLabel.text = "DOCUMENT TYPE"
            mainButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.dropDownColorImage, for: .normal)
//            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = isRfi
            dataTextField.placeholder = "Select"
            dataTextField.isUserInteractionEnabled = false

            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 25
            if isRfi {
                dataTextField.text = "\(rfiData.rfiDescription)".uppercased()
            }
            else {
                dataTextField.text = "\(data.identificationType)"
            }

        case 1:
            self.titleLabel.text = "DOCUMENT NUMBER"
            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Enter Document Number"
            self.cameraButtonWidth.constant = 0
            dataTextField.text = "\(data.identificationValue)"
            dataTextField.isUserInteractionEnabled = true
            self.uploadDropDownButtonWidth.constant = 0

        case 2:
            self.titleLabel.text = "NAME AS PER DOCUMENT"
            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Enter Document Holder Name"
            self.cameraButtonWidth.constant = 0
            dataTextField.text = "\(data.identificationDocHolderName)"
            dataTextField.isUserInteractionEnabled = true
            self.uploadDropDownButtonWidth.constant = 0

        case 3:
            self.titleLabel.text = "ISSUING AUTHORITY \n\nFill in Country name if issuing authority is not avialable"
//            mainButton.isHidden = false
            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Enter Issuing Authority"
            dataTextField.text = "\(data.identificationIssuingAuthority)"
            dataTextField.isUserInteractionEnabled = true
            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 0

        case 4:
            self.titleLabel.text = "ISSUING COUNTRY"
            mainButton.isHidden = false
           // mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = true
            dataTextField.placeholder = "Select Country"
            dataTextField.text = "\(data.identificationIssuingCountry)"
            dataTextField.isUserInteractionEnabled = false
            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 25

        case 5:
            self.titleLabel.text = "ISSUANCE DATE"
            mainButton.isHidden = false
//            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.dropDownColorImage, for: .normal)
            dataTextField.placeholder = "Enter Date"
            dataTextField.text = "\(data.identificationIssuingDate)"
            dataTextField.isUserInteractionEnabled = false
            self.cameraButtonWidth.constant = 0
            self.uploadDropDownButtonWidth.constant = 25
        case 6:
            self.titleLabel.text = "EXPIRY DATE"
            mainButton.isHidden = false
//            mainButton.isHidden = true
            self.cameraButton.isHidden = true
            self.uploadDropdownButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.dropDownColorImage, for: .normal)
            dataTextField.placeholder = "Enter Date"
            self.cameraButtonWidth.constant = 0
            dataTextField.text = "\(data.identificationDocExpiry)"
            dataTextField.isUserInteractionEnabled = false
            self.uploadDropDownButtonWidth.constant = 25
        case 7:
            self.titleLabel.text = "UPLOAD FRONT SIDE OF DOCUMENT"
            self.cameraButton.isHidden = false
            mainButton.isHidden = true
            self.uploadDropdownButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.uploadColorImage, for: .normal)
            dataTextField.placeholder = "Upload File"
            if data.identificationFileDocumentArray.count >= 1
            {
                dataTextField.text = "Document_Image_1"
            }
            else {
                dataTextField.text = ""
            }
            self.cameraButtonWidth.constant = 25
            self.uploadDropDownButtonWidth.constant = 25
            dataTextField.isUserInteractionEnabled = false
        case 8:
            self.titleLabel.text = "UPLOAD BACK SIDE OF DOCUMENT"
            self.cameraButton.isHidden = false
            mainButton.isHidden = true
            self.uploadDropdownButton.isHidden = false
            self.uploadDropdownButton.setImage(theme.uploadColorImage, for: .normal)
            if data.identificationFileDocumentArray.count > 1
            {
                dataTextField.text = "Document_Image_2"
            }
            else {
                dataTextField.text = ""
            }
            dataTextField.placeholder = "Upload File"
            self.cameraButtonWidth.constant = 25
            self.uploadDropDownButtonWidth.constant = 25
            dataTextField.isUserInteractionEnabled = false
        default:
            break
        }
        dataTextField.attributedPlaceholder = NSAttributedString(string: dataTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        if delegate != nil { delegate.tabOnCamera(cell: self) }
    }
    
    @IBAction func uploadDropdownButtonPressed(_ sender: Any) {
        if delegate != nil { delegate.tabUploadDropdownButton(cell: self)}
    }
    
    @IBAction func mainDropDownButtonPressed(_ sender: Any) {
        if delegate != nil { delegate.tabOnDropDownButton(cell: self)}
    }
}
