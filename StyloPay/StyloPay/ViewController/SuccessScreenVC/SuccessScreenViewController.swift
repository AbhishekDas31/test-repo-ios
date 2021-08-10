//
//  SuccessScreenViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 13/07/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class SuccessScreenViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> SuccessScreenViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! SuccessScreenViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var dashBoardButton: UIButton!
    @IBOutlet weak var cardviewBackgroundImage: UIImageView!
    
    let theme = ThemeManager.currentTheme()
    var isFromExchange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTheme()
        moreOptionsButton.isHidden = true
    }
    
    
    func configureTheme(){
        
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        cardviewBackgroundImage.image = theme.buttonsBackgroundImage
        dashBoardButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        backButton.setImage(theme.backImage,for: .normal)
        
        let manageCardImage = AssetsImages.manageCardUnselected?.withRenderingMode(.alwaysTemplate)
        manageCardButton.setImage(manageCardImage, for: .normal)
        manageCardButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor

        if isFromExchange {
            let transferImage = AssetsImages.transferUnselected?.withRenderingMode(.alwaysTemplate)
            transferMoneyButton.setImage(transferImage, for: .normal)
            transferMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor

            exchangeMoneyButton.setImage(theme.selectedExchangeImage, for: .normal)

        }
        else {
            transferMoneyButton.setImage(theme.selectedTransferImage, for: .normal)

            let exchangeImage = AssetsImages.exchangeUnselected?.withRenderingMode(.alwaysTemplate)
            exchangeMoneyButton.setImage(exchangeImage, for: .normal)
            exchangeMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        }
        

        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        
        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
    }
    
    @IBAction func dashboardButtonPressed(_ sender: Any) {
        let manageCardVC = ManageMyCardViewController.storyboardInstance()
        self.navigationController?.pushViewController(manageCardVC, animated: false)
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
        let exchangeVC = HomeViewController.storyboardInstance()
        self.navigationController?.pushViewController(exchangeVC, animated: false)
    }
    @IBAction func recentTransactionButtonPressed(_ sender: Any) {
        let recentTransactionVC = RecentTransactionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(recentTransactionVC, animated: false)
    }
    @IBAction func moreOptionButtonPressed(_ sender: Any) {
        let moreOptionVC = MoreOptionsViewController.storyboardInstance()
        self.navigationController?.pushViewController(moreOptionVC, animated: false)
    }

    @IBAction func goBack(_ send:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
