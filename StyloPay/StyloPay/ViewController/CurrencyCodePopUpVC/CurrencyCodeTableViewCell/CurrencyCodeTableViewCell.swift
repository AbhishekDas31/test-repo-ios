//
//  CurrencyCodeTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 09/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class CurrencyCodeTableViewCell: UITableViewCell {
    @IBOutlet weak var currncyCodeImage: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    let theme = ThemeManager.currentTheme()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
