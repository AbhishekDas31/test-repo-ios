//
//  SideMenuViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 23/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import MFSideMenu
import Amplify

class SideMenuViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> SideMenuViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! SideMenuViewController
    }
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var versionLbl:UILabel!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userProflleImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sideMenuTableView: UITableView!{
        didSet{
            sideMenuTableView.delegate = self
            sideMenuTableView.dataSource = self
        }
    }
    
    let theme = ThemeManager.currentTheme()
    
    let sideMenuData = [["numberOfRows": 7, "rowLabels": ["DASHBOARD", "TRANSACTIONS","WALLET TRANSFER", "EXCHANGE CURRENCY", "NOTIFICATIONS", "ADD IBAN","LIGHT THEME"]],["numberOfRows": 1, "rowLabels": ["OTHERS"]],["numberOfRows": 4, "rowLabels": ["CONTACT US", "RATE US", "SHARE & EARN", "ABOUT US"]]]
    let sideMenuImage = [AssetsImages.dashboardIconImage,AssetsImages.moreOptionsIconImage, AssetsImages.transferRedImage,  AssetsImages.manageCardIconImage, AssetsImages.bellIconImage, AssetsImages.idAddBanIconImage,AssetsImages.sun,AssetsImages.moreIconImage]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuContainerViewController.shadow.enabled = true
        configureCell()
        configureTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(userProfile), name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
    }
    
    func configureCell() {
        sideMenuTableView.estimatedRowHeight = 60
        sideMenuTableView.separatorStyle = .none
        sideMenuTableView.separatorInset = UIEdgeInsets.zero
        sideMenuTableView.sectionFooterHeight = 56
        sideMenuTableView.rowHeight = UITableView.automaticDimension
        sideMenuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil),forCellReuseIdentifier: "SideMenuTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func configureTheme(){
        userProflleImage.image = theme.defaultProfileImage
        usernameLabel.textColor = theme.bottomUnselectedTabButtonColor
        self.logoutButton.layer.borderWidth = 1.0
        self.logoutButton.layer.cornerRadius = 5.0
        self.logoutButton.layer.borderColor = theme.bottomSelectedTabButtonColor.cgColor
        let buttonTextColor = theme.bottomUnselectedTabButtonColor
        self.logoutButton.setTitleColor(buttonTextColor, for: .normal)
        self.usernameLabel.textColor = theme.bottomUnselectedTabButtonColor
        versionLbl.textColor = theme.bottomUnselectedTabButtonColor
        versionLbl.text = versionName
        
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
    }
    
    @objc func userProfile() {
        let firstname = CustomUserDefaults.getFirstname()
        let lastname = CustomUserDefaults.getLastname()
        self.usernameLabel.text = "\(firstname) \(lastname)"
    }

    @IBAction func profileButtonPressed(_ sender: Any) {
        //let profileVC = ProfileViewController.storyboardInstance()
        
        let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
        navigationControllers.viewControllers = [ProfileViewController.storyboardInstance()]
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        Global.showAlertWithTwoHandler(strMessage: "Do you want to logout?", strActionOne: "YES", strActionTwo: "NO", okBlock: {
            _ = Amplify.Auth.signOut() { result in
                switch result {
                case .success:
                    removeCredentials()
                    DispatchQueue.main.async {
                        Constants.kAppDelegate?.setControllers()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        Global.showAlert(withMessage: "\(error.errorDescription)", sender: self)
                    }
                }
            }
        }, cancelBlock: {})
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sideMenuData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = sideMenuData[section]["numberOfRows"] as? Int{
            return numberOfRows
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sideMenuData[indexPath.section]
        let sideMenuCell =  tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        sideMenuCell.configureCell(section: indexPath.section, row: indexPath.row)
        sideMenuCell.delegate = self
        if let sectionData = model["rowLabels"] as? [String]{
            sideMenuCell.sideMenuLabel.text = "\(sectionData[indexPath.row])"
            //sideMenuCell.sideMenuLabel.textColor = theme.bottomUnselectedTabButtonColor
        }
        if indexPath.section == 0{
            let sideMenuImage = self.sideMenuImage[indexPath.row]?.withRenderingMode(.alwaysTemplate)
            
            sideMenuCell.sideMenuImageView.image = sideMenuImage
            sideMenuCell.sideMenuImageView.tintColor = theme.bottomSelectedTabButtonColor
        }
        return sideMenuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.menuContainerViewController.menuState = MFSideMenuStateClosed
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
                navigationControllers.viewControllers = [ManageMyCardViewController.storyboardInstance()]
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                break
            case 1 :
                let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
                navigationControllers.viewControllers = [RecentTransactionsViewController.storyboardInstance()]
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                break
            case 2 :
                let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
                navigationControllers.viewControllers = [ReciverEmailViewController.storyboardInstance()]
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                break
            case 3:
                let navigationControllers = self.menuContainerViewController.centerViewController as! UINavigationController
                navigationControllers.viewControllers = [HomeViewController.storyboardInstance()]
                self.menuContainerViewController.menuState = MFSideMenuStateClosed
                break
            default:
                break
            }
        }
    }
    
}

extension SideMenuViewController:ChangeTheme
{
    func changeTheme() {
        Constants.kAppDelegate?.setMainController()
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
    }
}
