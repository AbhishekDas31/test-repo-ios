//
//  KycPopUPVC.swift
//  StyloPay
//
//  Created by Rohit Singh on 7/7/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//
import Foundation
import UIKit

protocol OpenAccountactivation:NSObject {
    func openAccountActivation()
}



class KycPopUPVC: UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notinMoodBtn: UIButton!
    @IBOutlet weak var okayBtn: UIButton!
    
    let theme = ThemeManager.currentTheme()
    var descritptionString = ""
    weak var delegate:OpenAccountactivation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        
        
    }
    
    func initialSetup()
    {
        descriptionLabel.text = descritptionString
        self.backView.layer.cornerRadius = 8.0
        self.configureTheme()
    }
    
    func configureTheme()
    {
        okayBtn.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        notinMoodBtn.setBackgroundImage(theme.borderColorImage, for: .normal)
    }
    
    
    @IBAction func actionBtn(_ sender: UIButton) {
        
        if sender.tag == 22 {
            
            self.dismiss(animated: false, completion: {
                self.delegate?.openAccountActivation()
            })
            
        }
        else {
            CustomUserDefaults.setkycPopUp(data: true)
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
}
