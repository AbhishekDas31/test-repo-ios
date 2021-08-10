//
//  CardBlockOverLayViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 07/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import DropDown

protocol CardBlockDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func cardBlocked(status: String)
}


class CardBlockOverLayViewController: UIViewController {

    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> CardBlockOverLayViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! CardBlockOverLayViewController
    }
    
    @IBOutlet weak var blockReasonLabel: UILabel!
    @IBOutlet weak var blockReasonsDropdownButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var modalView: UIView!
    
    weak var delegate: CardBlockDelegate!
    let theme = ThemeManager.currentTheme()
    let centeredDropDown = DropDown()
    let blockReasonsDropDown = DropDown()
    let blockReasonsArr = ["fraud", "cardLost", "cardStolen", "damaged"]
    var cardHashID = ""
    let customerHashID = CustomUserDefaults.getCustomerHashId()
    let walletHashID = CustomUserDefaults.getwalletHashId()
    lazy var dropDowns: [DropDown] = {
        return [
            self.centeredDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blockReasonLabel.text = "Select a Reason"
        blockReasonsDropDown.dataSource = blockReasonsArr
        okayButton.setBackgroundImage(theme.borderColorImage, for: .normal)
        let arrowImage = UIImage(named: "go")?.withRenderingMode(.alwaysTemplate)
        nextImage.image = arrowImage
        modalView.layer.cornerRadius = 10.0
        nextImage.tintColor = theme.bottomSelectedTabButtonColor
    }
    
    @IBAction func blockDropDownButtonPressed(_ sender: Any) {
        blockReasonsDropDown.anchorView = blockReasonsDropdownButton
        blockReasonsDropDown.direction = .bottom
        // Action triggered on selection
        blockReasonsDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.blockReasonLabel.text = "\(self.blockReasonsArr[index])"
        }
        blockReasonsDropDown.show()
    }
    
    @IBAction func closeControllerButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        if let reason = self.blockReasonLabel.text{
            if reason == "Select a Reason" {
                Global.showAlert(withMessage: "Please select a reason to block the card", sender: self, buttonTitle: "OK")
            }else{
                self.postBlockCard(reason: reason)
            }
        }
        
    }
    
}

extension CardBlockOverLayViewController{
    
    func postBlockCard(reason: String){
        Alert.showProgressHud(onView: self.view)
        let strUrl = "\(mainUrl)/api/v1/blockUnblock/\(customerHashID)/\(walletHashID)/\(cardHashID)"
        let parameters = [ "reason":"\(reason)", "blockAction":"permanentBlock"]
        WebServices.postRequest(urlString: strUrl, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject , stringResponse, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject {
                    debugPrint("response:  \(response)")
                    if let status = response["status"] as? String{
                        if status == "Success"{
                            Global.showAlert(withMessage: "Card Blocked Permanently", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                if self.delegate != nil { self.delegate.cardBlocked(status: status)}
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                } else if let errorString = stringResponse {
                    Alert.hideProgressHud(onView: self.view)
                    Global.showAlert(withMessage: "\(errorString)", sender: self)
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
        
    }
}
