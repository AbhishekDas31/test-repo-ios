//
//  ReciverEmailViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 10/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class ReciverEmailViewController: UIViewController{
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ReciverEmailViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ReciverEmailViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var subLbl:UILabel!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cardviewBackgroundImage: UIImageView!
    @IBOutlet weak var headerLbl:UILabel!
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.keyboardType = .emailAddress
            emailTextField.delegate = self
        }
    }
    
    let theme = ThemeManager.currentTheme()
    var ddestinationWalletHashID = ""
    var receiverEmailAddress = ""
    var receiverName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subLbl.text = "\(Constants.cardDisplayName) User Email".capitalized
        moreOptionsButton.isHidden = true
        emailTextField.delegate = self
        self.emailTextField.placeholder = "ENTER EMAIL"
        let color = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        self.emailTextField.isSecureTextEntry = false
        cardView.layer.cornerRadius = 8.0
        self.configureTheme()
    }
    
    func configureTheme(){
        
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        cardviewBackgroundImage.image = theme.buttonsBackgroundImage
        continueButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        headerLbl.textColor = theme.bottomUnselectedTabButtonColor

        
        let manageCardImage = AssetsImages.manageCardUnselected?.withRenderingMode(.alwaysTemplate)
        manageCardButton.setImage(manageCardImage, for: .normal)
        manageCardButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        transferMoneyButton.setImage(theme.selectedTransferImage, for: .normal)
        
        let exchangeImage = AssetsImages.exchangeUnselected?.withRenderingMode(.alwaysTemplate)
        exchangeMoneyButton.setImage(exchangeImage, for: .normal)
        exchangeMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor

        let sideMenuImage = AssetsImages.sideMenuIcon?.withRenderingMode(.alwaysTemplate)
        sideMenuButton.setImage(sideMenuImage, for: .normal)
        sideMenuButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        
        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
    }

    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let sendingOptionsVC = ReciverEmailViewController.storyboardInstance()//SendingOptionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(sendingOptionsVC, animated: false)
    }
    @IBAction func manageMyCardButtonPressed(_ sender: Any) {
        let manageCardVC = ManageMyCardViewController.storyboardInstance()
        self.navigationController?.pushViewController(manageCardVC, animated: false)
    }
    
    @IBAction func exchangeButtonPressed(_ sender: Any) {
        let homeVC = HomeViewController.storyboardInstance()
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    @IBAction func recentTransactionButtonPressed(_ sender: Any) {
        let recentTransactionVC = RecentTransactionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(recentTransactionVC, animated: false)
    }
    @IBAction func moreOptionButtonPressed(_ sender: Any) {
        let moreOptionVC = MoreOptionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(moreOptionVC, animated: false)
    }
    
//    @IBAction func backButtonPressed(_ sender: Any) {
//        self.navigationController?.popViewController(animated: false)
//    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if let email = emailTextField.text{
            if ValidationHandler.validateReceiverEmail(form: self, email: email){
                self.getAllCardsCustomerInfo(emailAddress: email)
            }
        }else{
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmailAddress.description, sender: self)
        }
    }
}

extension ReciverEmailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
}

extension ReciverEmailViewController{
    func getAllCardsCustomerInfo(emailAddress: String){
        var name = ""
        let url = "\(mainUrl)/api/v1/fetchCustomer?order=DESC&page=0&size=10&email=\(emailAddress)&mobile="
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            if error == nil {
                if let response = responseArray {
                    debugPrint("response:  \(response)")
                    for i in 0..<response.count{
                        
                        
                        if let firstName = response[i]["firstName"] as? String{
                            name = firstName
                        }
                        if let lastName = response[i]["lastName"] as? String{
                            name = "\(name) \(lastName)"
                        }
                        if let walletHashId = response[i]["walletHashId"] as? String{
                            let p2pTransfer = TransferViewController.storyboardInstance()
                            p2pTransfer.destinationWalletHashid = walletHashId
                            p2pTransfer.name = name
                            self.navigationController?.pushViewController(p2pTransfer, animated: false)
                        }
                    }
                } else {
                    if let status =  responseObject?["status"] as? String {
                        if status == "BAD_REQUEST"{
                            if let message = responseObject?["message"] as? String{
                                Global.showAlert(withMessage: "\(message)", sender: self)
                            }
                            
                        }
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                //Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
}
