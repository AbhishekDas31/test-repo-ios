//
//  SendingOptionsViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 23/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class SendingOptionsViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> SendingOptionsViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! SendingOptionsViewController
    }

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var cobranderButton: UIButton!
    @IBOutlet weak var individualButton: UIButton!
    @IBOutlet weak var businessButton: UIButton!
    
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreOptionsButton.isHidden = true
        configureTheme()
    }
    
    func configureTheme(){
        
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        
        let grayWhiteColor = theme.bottomUnselectedTabButtonColor
        
        cobranderButton.setBackgroundImage(theme.borderColorImage, for: .normal)
        cobranderButton.setTitleColor(grayWhiteColor, for: .normal)
        individualButton.setBackgroundImage(theme.borderColorImage, for: .normal)
        individualButton.setTitleColor(theme.disableTextColor, for: .normal)
        businessButton.setBackgroundImage(theme.borderColorImage, for: .normal)
        businessButton.setTitleColor(theme.disableTextColor, for: .normal)
        
        let manageCardImage = AssetsImages.manageCardIconImage?.withRenderingMode(.alwaysTemplate)
        manageCardButton.setImage(manageCardImage, for: .normal)
        manageCardButton.imageView?.tintColor = grayWhiteColor
        
        transferMoneyButton.setImage(theme.selectedTransferImage, for: .normal)
        
        let exchangeImage = AssetsImages.exchangeUnselected?.withRenderingMode(.alwaysTemplate)
        exchangeMoneyButton.setImage(exchangeImage, for: .normal)
        exchangeMoneyButton.imageView?.tintColor = grayWhiteColor
        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = grayWhiteColor
        
        
        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = grayWhiteColor
        
        let sideMenuImage = AssetsImages.sideMenuIcon?.withRenderingMode(.alwaysTemplate)
        sideMenuButton.setImage(sideMenuImage, for: .normal)
        sideMenuButton.imageView?.tintColor = grayWhiteColor
        
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        notificationButton.setImage(bellImage, for: .normal)
        notificationButton.imageView?.tintColor = grayWhiteColor
    }
    
    @IBAction func cobranderButtonPressed(_ sender: Any) {
        let receiverEmailVC = ReciverEmailViewController.storyboardInstance()
        self.navigationController?.pushViewController(receiverEmailVC, animated: false)
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
}
