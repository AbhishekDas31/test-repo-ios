//
//  VirtualCardOptionsViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 08/01/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import UIKit

protocol AddOnCardOptionsDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func addonCardDetailsUpdate(options: String,row: Int)
}

class VirtualCardOptionsViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> VirtualCardOptionsViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! VirtualCardOptionsViewController
    }

    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var corporateIconImageView: UIImageView!
    @IBOutlet weak var familyIconImageView: UIImageView!
    
    var accountNumber = ""
    var lastdigits = ""
    var row = 0
    weak var delegate: AddOnCardOptionsDelegate!
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsView.layer.cornerRadius = 10.0
        self.familyIconImageView.image = theme.familyImage
        self.corporateIconImageView.image = theme.corporateImage
    }
    
    @IBAction func friendFamilyOptionPressed(_ sender: Any) {
        self.dismiss(animated: true) { [self] in
            if self.delegate != nil { self.delegate.addonCardDetailsUpdate(options: "friends", row: self.row)}
        }
    }
    
    @IBAction func corporateEmployeeOptionPressed(_ sender: Any) {
        self.dismiss(animated: true) { [self] in
            if self.delegate != nil { self.delegate.addonCardDetailsUpdate(options: "corporate", row: self.row)}
        }
    }
    
    
    @IBAction func dismissViewPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
