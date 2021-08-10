//
//  MobileNoCell.swift
//  StyloPay
//
//  Created by Rohit Singh on 7/9/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit

class MobileNoCell: UITableViewCell {

    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var isoCodeLbl: UILabel!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet weak var verifiedView: UIView!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var unverifiedView: UIView!

    let color = #colorLiteral(red: 0.3607498705, green: 0.3608062863, blue: 0.3607375622, alpha: 1)
    let theme = ThemeManager.currentTheme()
    weak var delegate:OpenAccountactivation?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        verifyBtn.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        let arrowImage = UIImage(named: "tick")?.withRenderingMode(.alwaysTemplate)
        tickIcon.image = arrowImage
        tickIcon.tintColor = UIColor().colorFromHexString("008080")
        self.mainView.layer.cornerRadius = 8.0
        self.mainView.layer.borderColor = theme.borderColor.cgColor
        self.mainView.layer.borderWidth = 1.0
        // Initialization code
    }

    func configureView(_ isVerify:Bool)
    {
        if isVerify {
            unverifiedView.isHidden = true
            verifiedView.isHidden = false
        }
        else {
            unverifiedView.isHidden = false
            verifiedView.isHidden = true
        }
        numberField.placeholder = "MOBILE NUMBER*"
        numberField.text = "\(CustomUserDefaults.getMobileNumber())"
        numberField.isUserInteractionEnabled = false
        numberField.attributedPlaceholder = NSAttributedString(string: numberField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        numberField.tag = 6
        self.isoCodeLbl.text = "+ \(CustomUserDefaults.getIsdCode())"
    }

    
    @IBAction func verifyAction(_ sender: UIButton) {

        // verify phone Number if applicable
        delegate?.openAccountActivation()
    }
    
}
