//
//  BeneficiaryListCollectionViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 22/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class BeneficiaryListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var beneficiaryNameLabel: UILabel!
    @IBOutlet weak var beneficiaryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        beneficiaryImageView.layer.cornerRadius = 25
        // Initialization code
    }

}
