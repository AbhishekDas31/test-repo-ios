//
//  SwitchButtonTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 17/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol ProfileSwitchActionDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabCheckButton(cell: SwitchButtonTableViewCell)
}

class SwitchButtonTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tncLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    weak var delegate: ProfileSwitchActionDelegate!
    let theme = ThemeManager.currentTheme()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 8.0
        self.mainView.layer.borderColor = theme.borderColor.cgColor
        self.mainView.layer.borderWidth = 1.0
        self.checkBoxButton.setBackgroundImage(theme.uncheckBoxColorImage, for: .normal)
        tncLabel.textColor = theme.bottomSelectedTabButtonColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func checkboxButtonPressed(_ sender: Any) {
        if delegate != nil { delegate.tabCheckButton(cell: self)}
    }
}
