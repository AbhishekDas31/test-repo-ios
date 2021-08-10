//
//  SIngleLabelCell.swift
//  StyloPay
//
//  Created by Rohit Singh on 7/12/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit

class SIngleLabelCell: UITableViewCell {


    @IBOutlet weak var tittleLbl: UILabel!

    let theme = ThemeManager.currentTheme()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tittleLbl.textColor = theme.bottomUnselectedTabButtonColor
        self.selectionStyle = .none
        // Initialization code
    }


    
}
