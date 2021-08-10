//
//  CardCollectionViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 30/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol CardsActionDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabCardAddButton(cell: CardCollectionViewCell)
    func tabOnCard(cell: CardCollectionViewCell)
}

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardBackgroundImageView: UIImageView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardHolderName: UILabel!
    @IBOutlet weak var cardEnableDisableButton: UISwitch!
    @IBOutlet weak var cardTapButton: UIButton!
    @IBOutlet weak var expiryDateView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var chipImageView: UIImageView!
    @IBOutlet weak var stylopayLogoImageView: UIImageView!
    @IBOutlet weak var visaImageView: UIImageView!
    @IBOutlet weak var cardTypeLogo: UIImageView!
    @IBOutlet weak var cardStatus: UILabel!
    
    @IBOutlet weak var cvvLbl: UILabel!
    @IBOutlet weak var expiryLbl: UILabel!
    let theme = ThemeManager.currentTheme()
    weak var delegate: CardsActionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTheme()
    }
    
    func configureTheme(){
        cardView.layer.cornerRadius = 15.0
        cardBackgroundImageView.image = theme.cardBackgroundImage
        cardEnableDisableButton.onTintColor = theme.bottomSelectedTabButtonColor
        let logoImage = AssetsImages.stylopayWhiteLogoImage?.withRenderingMode(.alwaysTemplate)
        self.stylopayLogoImageView.image = logoImage
        let visaImage = AssetsImages.visaPayLogoImage?.withRenderingMode(.alwaysTemplate)
        self.visaImageView.image = visaImage
        
    }
    
    func configureCardsView(cardDetails : CardDetailsModel, cardType: String, isCardAvailable: Bool, row: Int) {
        self.cardTypeLabel.text = cardType
        self.configureCardTypeView(cardType: cardType)
        if isCardAvailable {
            self.configureAddedCard(cardDetails: cardDetails)
        } else {
            self.configureUnAddedCard(cardDetails: cardDetails)
        }
    }
    
    func configureCardTypeView(cardType:String) {
        if cardType == "Virtual Card"{
            self.chipImageView.isHidden = true
            self.cardTypeLogo.isHidden = true
        } else if cardType == "Add-On Card" {
            self.cardTypeLogo.isHidden = false
            self.chipImageView.isHidden = true
            self.cardTypeLogo.image = AssetsImages.addonLogoIcon
        } else if cardType == "Assigned Card" {
            self.cardTypeLogo.isHidden = false
            self.chipImageView.isHidden = false
            self.cardTypeLogo.image = AssetsImages.assignedLogoIcon
        } else {
            self.cardTypeLogo.isHidden = true
            self.chipImageView.isHidden = false
        }
    }
    
    func configureAddedCard(cardDetails: CardDetailsModel) {
        if cardDetails.cardStatus == "TEMP_BLOCK" || cardDetails.cardStatus == "P_BLOCK"
        {
            self.cardStatus.isHidden = false
          self.cardStatus.text = cardDetails.cardStatus != "TEMP_BLOCK" ? "BLOCKED" : "DISABLED"
            self.stylopayLogoImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.visaImageView.tintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.cardHolderName.isHidden = false
            self.cardHolderName.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.cardNumberTextField.textColor  = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.cardHolderName.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.cvvLbl.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.expiryLbl.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.cardNumberTextField.text = replaceMount(cardDetails.maskedCardNumber)
            self.cardHolderName.text = Constants.cardDisplayName//cardDetails.embossingLine1
            self.cardEnableDisableButton.isHidden = true
            self.cardTapButton.isHidden = false
        self.expiryDateView.isHidden = false
        }
        else {
            self.cardStatus.isHidden = true
            self.stylopayLogoImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.visaImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.cardHolderName.isHidden = false
            self.cardHolderName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.cardNumberTextField.textColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.cardHolderName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.cvvLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.expiryLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.cardNumberTextField.text = replaceMount(cardDetails.maskedCardNumber)
            self.cardHolderName.text = Constants.cardDisplayName//cardDetails.embossingLine1
            self.cardEnableDisableButton.isHidden = true
            self.cardTapButton.isHidden = false
            self.expiryDateView.isHidden = false
        }
    }
    
    func configureUnAddedCard(cardDetails: CardDetailsModel) {
        self.expiryDateView.isHidden = true
        self.cardTapButton.isHidden = true
        self.stylopayLogoImageView.tintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.visaImageView.tintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.cardHolderName.isHidden = true
        cardNumberTextField.text = "xxxx-xxxx-xxxx-xxxx"
        self.cardEnableDisableButton.isOn = false
        self.cardEnableDisableButton.isHidden = false
    }
    
    
    @IBAction func cardTapped(_ sender: Any) {
        if delegate != nil { delegate.tabOnCard(cell: self)}
    }
    
    @IBAction func switchButtonpressed(_ sender: Any) {
        
        if delegate != nil { delegate.tabCardAddButton(cell: self)}
    }

    func replaceMount(_ yourString:String) -> String?{
        let stringChange = "xxxxxxxxxxxx\(String(yourString.suffix(4)))"
        var resultString = String()

        // Loop through all the characters of your string

        stringChange.enumerated().forEach { (index, character) in

            // Add space every 4 characters

            if index % 4 == 0 && index > 0 {
                resultString += "-"
            }

            if index < 12 {

                // Replace the first 12 characters by *

                resultString += "x"

            } else {

                // Add the last 4 characters to your final string

                resultString.append(character)
            }

        }
        return resultString

    }

}


