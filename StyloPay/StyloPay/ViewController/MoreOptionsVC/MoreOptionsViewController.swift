//
//  MoreOptionsViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 23/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class MoreOptionsViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> MoreOptionsViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! MoreOptionsViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreOptionsButton.isHidden = true
        configureTheme()
    }
    
    func configureTheme(){
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        themeLabel.textColor = theme.bottomUnselectedTabButtonColor
        
        let sidemenuImage = AssetsImages.sideMenuIcon?.withRenderingMode(.alwaysTemplate)
        sideMenuButton.setImage(sidemenuImage,for: .normal)
        sideMenuButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let manageCardImage = AssetsImages.manageCardUnselected?.withRenderingMode(.alwaysTemplate)
        manageCardButton.setImage(manageCardImage, for: .normal)
        manageCardButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let transferImage = AssetsImages.transferUnselected?.withRenderingMode(.alwaysTemplate)
        transferMoneyButton.setImage(transferImage, for: .normal)
        transferMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let exchangeImage = AssetsImages.exchangeUnselected?.withRenderingMode(.alwaysTemplate)
        exchangeMoneyButton.setImage(exchangeImage, for: .normal)
        exchangeMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        moreOptionsButton.setImage(theme.selectedMoreOptionsImage, for: .normal)
        if theme == .theme2{
            switchButton.setBackgroundImage(theme.switchOnImage, for: .normal)
        }else{
            switchButton.setBackgroundImage(AssetsImages.switchOffImage, for: .normal)
        }
        
    }
    
    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        
        let theme = ThemeManager.currentTheme()
        if theme == Theme.theme1{
            ThemeManager.applyTheme(theme: .theme2)
            switchButton.setBackgroundImage(theme.switchOnImage, for: .normal)
        }else{
            ThemeManager.applyTheme(theme: .theme1)
            switchButton.setBackgroundImage(AssetsImages.switchOffImage, for: .normal)
        }
        
        Constants.kAppDelegate?.setMainController()
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
