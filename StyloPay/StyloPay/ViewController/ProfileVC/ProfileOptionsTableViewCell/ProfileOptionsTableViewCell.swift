//
//  ProfileOptionsTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 04/08/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class ProfileOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addBankView: UIView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var addBankBackgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var detailOptionLabel: UILabel!
    
    let theme = ThemeManager.currentTheme()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTheme()
    }
    
    func configureTheme(){
        self.profileImageview.image = theme.defaultProfileImage
        backgroundImageView.image = theme.buttonsBackgroundImage
        addBankBackgroundImageView.image = theme.buttonsBackgroundImage
        let image = AssetsImages.addBlueImage?.withRenderingMode(.alwaysTemplate)
        addImageView.image = image
        addImageView.tintColor = #colorLiteral(red: 0.9999126792, green: 1, blue: 0.9998814464, alpha: 1)
        mainView.layer.cornerRadius = 8.0
        addBankView.layer.cornerRadius = 8.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(row: Int){
        switch row {
        case 0:
            mainView.isHidden = false
            addBankView.isHidden = true
            detailOptionLabel.text = "PERSONAL DETAILS"
            break
        case 1:
            mainView.isHidden = false
            addBankView.isHidden = true
            detailOptionLabel.text = "ADDRESS DETAILS"
            break
        case 2:
            mainView.isHidden = false
            addBankView.isHidden = true
            detailOptionLabel.text = "KYC"
            break
        case 3:
            mainView.isHidden = true
            addBankView.isHidden = false
            break
        default:
            break
        }
    }
    
}
