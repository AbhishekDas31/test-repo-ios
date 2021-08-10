//
//  SideMenuTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 23/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol ChangeTheme:NSObject {
    func changeTheme()

}

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var sideMenuLabel: UILabel!
    @IBOutlet weak var sideMenuImageView: UIImageView!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var `switch`: UIButton!

    let theme = ThemeManager.currentTheme()
    weak var delegate:ChangeTheme?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if theme == .theme2{
            `switch`.setBackgroundImage(theme.switchOnImage, for: .normal)
        }else{
            `switch`.setBackgroundImage(AssetsImages.switchOffImage, for: .normal)
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(section : Int, row: Int){
        if section == 0{
            sideMenuImageView.isHidden = false
            if row == 6 {
                `switch`.isHidden = false
            }
            else {
                `switch`.isHidden = true
            }
            labelLeadingConstraint.constant = 20
            if row == 0 || row == 1 || row == 2 || row == 3 || row == 6{
                sideMenuLabel.textColor = theme.bottomUnselectedTabButtonColor
            }else{
                sideMenuLabel.textColor = theme.disableTextColor
            }
            
            sideMenuLabel.font.withSize(14)
        }else if section == 1{
            `switch`.isHidden = true
            sideMenuImageView.isHidden = true
            labelLeadingConstraint.constant = 0
            sideMenuLabel.textColor = #colorLiteral(red: 0.5626897812, green: 0.5151575208, blue: 0.551443696, alpha: 1)
            sideMenuLabel.font.withSize(12)
        }else{
            `switch`.isHidden = true
            sideMenuImageView.isHidden = true
            labelLeadingConstraint.constant = 20
            sideMenuLabel.textColor = theme.disableTextColor
            sideMenuLabel.font.withSize(14)
        }
    }

    
    @IBAction func switchAction(_ sender: UIButton) {
        let theme = ThemeManager.currentTheme()
        if theme == Theme.theme1{
            ThemeManager.applyTheme(theme: .theme2)
            `switch`.setBackgroundImage(theme.switchOnImage, for: .normal)
        }else{
            ThemeManager.applyTheme(theme: .theme1)
            `switch`.setBackgroundImage(AssetsImages.switchOffImage, for: .normal)
        }
        delegate?.changeTheme()
    }
    
}
