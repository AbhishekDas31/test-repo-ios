//
//  AccountActivationTableViewCell.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 16/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class AccountActivationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var trackPathImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var nextImageView: UIImageView!
    
    let theme = ThemeManager.currentTheme()
    override func awakeFromNib() {
        super.awakeFromNib()
        let arrowImage = UIImage(named: "go")?.withRenderingMode(.alwaysTemplate)
        nextImageView.image = arrowImage
        nextImageView.tintColor = theme.bottomSelectedTabButtonColor
        titleLabel.textColor = theme.bottomUnselectedTabButtonColor
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureRow(data: [String:Any], row :Int){
        self.titleLabel.text = "\(data["title"] ?? "")"
        
        self.subTitleLabel.text = "\(data["subtitle"] ?? "")"
        if let istrackVisible = data["isTrackVisible"] as? Bool{
            self.trackPathImageView.isHidden = !istrackVisible
        }
        
        if let isDataUploaded = data["isDataUploaded"] as? Bool{
            let status = CustomUserDefaults.getComplianceStatus()
            if status == "REJECT" || status == "ERROR" {
                if row == 0{
                    let statusImage = AssetsImages.crossIconImage?.withRenderingMode(.alwaysTemplate)
                    self.statusImageView.image = statusImage
                    self.statusImageView.tintColor = theme.bottomSelectedTabButtonColor
                }else{
                    let statusImage = AssetsImages.dataNotUploadedImage?.withRenderingMode(.alwaysTemplate)
                    self.statusImageView.image = statusImage
                    self.statusImageView.tintColor = theme.bottomUnselectedTabButtonColor
                }
                let trackImage = AssetsImages.pendingTrackImage?.withRenderingMode(.alwaysTemplate)
                self.trackPathImageView.image = trackImage
                self.trackPathImageView.tintColor = theme.bottomUnselectedTabButtonColor
            }else{
                if isDataUploaded{
                    self.statusImageView.image = theme.dataUploadedIconColorImage
                    self.trackPathImageView.image = theme.completedTrackColorImage
                }else{
                    
                    let statusImage = AssetsImages.dataNotUploadedImage?.withRenderingMode(.alwaysTemplate)
                    self.statusImageView.image = statusImage
                    self.statusImageView.tintColor = theme.bottomUnselectedTabButtonColor
                    let trackImage = AssetsImages.pendingTrackImage?.withRenderingMode(.alwaysTemplate)
                    self.trackPathImageView.image = trackImage
                    self.trackPathImageView.tintColor = theme.bottomUnselectedTabButtonColor
                }
            }
        }
        
    }
}
