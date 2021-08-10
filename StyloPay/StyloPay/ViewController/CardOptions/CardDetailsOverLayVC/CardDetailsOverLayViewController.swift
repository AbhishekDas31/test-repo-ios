//
//  CardDetailsOverLayViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 07/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class CardDetailsOverLayViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> CardDetailsOverLayViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! CardDetailsOverLayViewController
    }
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var expirydateLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    
    let customerHashID = CustomUserDefaults.getCustomerHashId()
    let walletHashID = CustomUserDefaults.getwalletHashId()
    var cardHashId = ""
    var unmaskedNumber = ""
    var cvv = ""
    var expiry = ""
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLabels(cardNumber: " ", cvv: " ", expiryDate: " ")
        self.getUnmaskedCardNumber()
        modalView.layer.cornerRadius = 10.0
        okayButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
    }
    
    
    func configureLabels(cardNumber: String, cvv: String, expiryDate: String){
        self.cardNumberLabel.text = "CARD NUMBER : \(cardNumber)"
        self.cvvLabel.text = "CVV : \(cvv)"
        let formatedDate = expiryDate.inserting(separator: "/", every: 2)
        let newStr = String(formatedDate.reversed())
        self.expirydateLabel.text = "EXPIRY DATE : \(newStr)"
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CardDetailsOverLayViewController{
    func getUnmaskedCardNumber(){
        Alert.showProgressHud(onView: self.view)
        let strUrl = "\(mainUrl)/api/v1/unmaskCard/\(customerHashID)/\(walletHashID)/\(cardHashId)"
        
        WebServices.getRequest(urlString: strUrl, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey){ (responseObject, responseArray, error)  in
            if error == nil {
                print(responseObject as Any)
                if let response = responseObject {
                    if let unmaskedNumber = response["unMaskedCardNumber"] as? String{
                        self.unmaskedNumber = unmaskedNumber
                        self.getCVVExpiryDate()
                    }
                }
            } else {
                Alert.hideProgressHud(onView: self.view)
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
    
    func getCVVExpiryDate(){
        let strUrl = "\(mainUrl)/api/v1/getCVV/\(customerHashID)/\(walletHashID)/\(cardHashId)"
        WebServices.getRequest(urlString: strUrl, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey){ (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject {
                    if let cvv = response["cvv"] as? String{
                        let cvv = decodeBase64String(base64Encoded: cvv)
                        self.cvv = cvv
                    }
                    if let expiry = response["expiry"] as? String{
                        let expiryDate = decodeBase64String(base64Encoded: expiry)
                        self.expiry = expiryDate
                    }
                    DispatchQueue.main.async {
                        self.configureLabels(cardNumber: self.unmaskedNumber, cvv: self.cvv, expiryDate: self.expiry)
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
               // Global.showAlert(withMessage: "\(strError)", sender: self)
                self.cardNumberLabel.text = "CARD NUMBER : \(self.unmaskedNumber)"
            }
        }
    }
}


