//
//  LoadMoneyViewController.swift
//  
//
//  Created by Anmol Aggarwal on 28/12/20.
//

import UIKit

class LoadMoneyViewController: UIViewController, UITextFieldDelegate {
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> LoadMoneyViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! LoadMoneyViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var backroundImagevIew: UIImageView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var bellIconButton: UIButton!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstAmountButton: UIButton!
    @IBOutlet weak var secoundAmountButton: UIButton!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdAmountButton: UIButton!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fourthAmountButton: UIButton!
    @IBOutlet weak var walletArrowImage: UIImageView!
    @IBOutlet weak var walletIconImageView: UIImageView!
    @IBOutlet weak var stripeIconImageView: UIImageView!
    @IBOutlet weak var stripeArrowImageView: UIImageView!
    @IBOutlet weak var ibanIconImageView: UIImageView!
    @IBOutlet weak var ibanArrowImage: UIImageView!
    @IBOutlet weak var bankIconImageView: UIImageView!
    @IBOutlet weak var bankArrowImageView: UIImageView!
    
    
    let theme = ThemeManager.currentTheme()
    var amount = "50"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountTextfield.delegate = self
        self.configureView()
    }
    
    func configureView(){
        self.navigationController?.navigationBar.isHidden = true
        optionsView.layer.cornerRadius = 10.0
        optionsView.layer.borderColor = theme.borderColor.cgColor
        optionsView.layer.borderWidth = 1.0
        amountView.layer.cornerRadius = 10.0
        mainView.backgroundColor = theme.backgroundColor
        backroundImagevIew.isHidden = theme.backgroundImageHidden
        amountView.layer.cornerRadius = 15.0
        amountImageView.image = theme.cardBackgroundImage
        sideMenuButton.setImage(theme.backImage, for: .normal)
        let arrowImage = UIImage(named: "go")?.withRenderingMode(.alwaysTemplate)
        walletArrowImage.image = arrowImage
        walletArrowImage.tintColor = theme.bottomSelectedTabButtonColor
        stripeArrowImageView.image = arrowImage
        stripeArrowImageView.tintColor = theme.bottomSelectedTabButtonColor
        ibanArrowImage.image = arrowImage
        ibanArrowImage.tintColor = theme.bottomSelectedTabButtonColor
        bankArrowImageView.image = arrowImage
        bankArrowImageView.tintColor = theme.bottomSelectedTabButtonColor
        walletIconImageView.image = theme.selectedManageCardImage
        ibanIconImageView.image = theme.selectedManageCardImage
        stripeIconImageView.image = theme.selectedManageCardImage
        bankIconImageView.image = theme.selectedManageCardImage
        firstView.layer.borderColor = theme.borderColor.cgColor
        firstView.layer.borderWidth = 1.0
        firstView.layer.cornerRadius = 2.0
        firstView.backgroundColor = UIColor.white
        secondView.layer.borderColor = UIColor.white.cgColor
        secondView.layer.borderWidth = 1.0
        secondView.layer.cornerRadius = 2.0
        thirdView.layer.borderColor = UIColor.white.cgColor
        thirdView.layer.borderWidth = 1.0
        thirdView.layer.cornerRadius = 2.0
        fourthView.layer.borderColor = UIColor.white.cgColor
        fourthView.layer.borderWidth = 1.0
        fourthView.layer.cornerRadius = 2.0
        firstAmountButton.setTitleColor(UIColor.black, for: .normal)
        secoundAmountButton.setTitleColor(UIColor.white, for: .normal)
        thirdAmountButton.setTitleColor(UIColor.white, for: .normal)
        fourthAmountButton.setTitleColor(UIColor.white, for: .normal)
        self.amountTextfield.text = "50"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func firstAmountButtonPressed(_ sender: Any) {
        firstView.backgroundColor = UIColor.white
        secondView.backgroundColor = UIColor.clear
        thirdView.backgroundColor = UIColor.clear
        fourthView.backgroundColor = UIColor.clear
        firstAmountButton.setTitleColor(UIColor.black, for: .normal)
        secoundAmountButton.setTitleColor(UIColor.white, for: .normal)
        thirdAmountButton.setTitleColor(UIColor.white, for: .normal)
        fourthAmountButton.setTitleColor(UIColor.white, for: .normal)
        self.amountTextfield.text = "50"
        self.amount = "50"
    }
    
    @IBAction func secondAmountButtonPressed(_ sender: Any) {
        firstView.backgroundColor = UIColor.clear
        secondView.backgroundColor = UIColor.white
        thirdView.backgroundColor = UIColor.clear
        fourthView.backgroundColor = UIColor.clear
        firstAmountButton.setTitleColor(UIColor.white, for: .normal)
        secoundAmountButton.setTitleColor(UIColor.black, for: .normal)
        thirdAmountButton.setTitleColor(UIColor.white, for: .normal)
        fourthAmountButton.setTitleColor(UIColor.white, for: .normal)
        self.amountTextfield.text = "100"
        self.amount = "100"
    }
    
    @IBAction func thirdAmountButtonPressed(_ sender: Any) {
        firstView.backgroundColor = UIColor.clear
        secondView.backgroundColor = UIColor.clear
        thirdView.backgroundColor = UIColor.white
        fourthView.backgroundColor = UIColor.clear
        firstAmountButton.setTitleColor(UIColor.white, for: .normal)
        secoundAmountButton.setTitleColor(UIColor.white, for: .normal)
        thirdAmountButton.setTitleColor(UIColor.black, for: .normal)
        fourthAmountButton.setTitleColor(UIColor.white, for: .normal)
        self.amountTextfield.text = "500"
        self.amount = "500"
    }
    
    @IBAction func fourthAmountButtonPressed(_ sender: Any) {
        firstView.backgroundColor = UIColor.clear
        secondView.backgroundColor = UIColor.clear
        thirdView.backgroundColor = UIColor.clear
        fourthView.backgroundColor = UIColor.white
        firstAmountButton.setTitleColor(UIColor.white, for: .normal)
        secoundAmountButton.setTitleColor(UIColor.white, for: .normal)
        thirdAmountButton.setTitleColor(UIColor.white, for: .normal)
        fourthAmountButton.setTitleColor(UIColor.black, for: .normal)
        self.amountTextfield.text = "999"
        self.amount = "999"
    }
    
    
    @IBAction func loadMoneyFromWalletPressed(_ sender: Any) {
        self.view.endEditing(true)
        let homeVC = HomeViewController.storyboardInstance()
        homeVC.fromcurrencyamount = self.amount
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let amount = textField.text {
            self.amount = amount
        }
    }
    
}
