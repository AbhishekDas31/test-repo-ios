//
//  OnboardingViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 09/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> OnboardingViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! OnboardingViewController
    }

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var appNameTitleLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var boardingCollectionView: UICollectionView! {
        didSet {
            self.boardingCollectionView.delegate = self
            self.boardingCollectionView.dataSource = self
            self.boardingCollectionView.isPagingEnabled = true
        }
    }
    
    let theme = ThemeManager.currentTheme()
    var arrBoardingImage = NSMutableArray(array: [AssetsImages.firstOnBoarding! , AssetsImages.secondOnBoarding!])
    var titleArray = ["MAKING YOUR MONEY DIGITAL GLOBALLY","EASY, FAST AND SECURE PAYMENTS"]
    var subTitleArray = ["OR AUTHENTICATE\nUSING YOUR FINGERPRINT!","OR AUTHENTICATE\nUSING YOUR FINGERPRINT!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        configureTheme()
        boardingCollectionView.register(UINib(nibName: CollectionViewCellIdentifiers.onboardingCollectionViewCell, bundle: Bundle.main), forCellWithReuseIdentifier: CollectionViewCellIdentifiers.onboardingCollectionViewCell)
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        appNameTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        signInButton.setTitleColor(theme.bottomSelectedTabButtonColor, for: .normal)
        skipButton.setTitleColor(theme.bottomUnselectedTabButtonColor, for: .normal)
        registerButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        CustomUserDefaults.isBoardingScreenSkipped(data: true)
        let loginVC = LoginViewController.storyboardInstance()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    @IBAction func registerButtonClicked(_ sender: Any) {
        CustomUserDefaults.isBoardingScreenSkipped(data: true)
        let registerVC = RegisterViewController.storyboardInstance()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func skipButtonClicked(_ sender: Any) {
        CustomUserDefaults.isBoardingScreenSkipped(data: true)
        let loginVC = LoginViewController.storyboardInstance()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
}

extension OnboardingViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.onboardingCollectionViewCell, for: indexPath) as? OnboardingCollectionViewCell{
            let row = indexPath.row
            cell.headerImage.image = self.arrBoardingImage[row] as? UIImage
            cell.titleLabel.text = "\(self.titleArray[row])"
            cell.titleLabel.textColor = theme.bottomUnselectedTabButtonColor
            cell.subtitleLabel.textColor = theme.bottomUnselectedTabButtonColor
            cell.subtitleLabel.text = "\(self.subTitleArray[row])"
            if indexPath.row == 0{
                cell.firstPageIconImage.image = theme.currentPageIconColorImage
                cell.secondPageIconImage.image = theme.nextPageIconColorImage
            }else{
                cell.firstPageIconImage.image = theme.nextPageIconColorImage
                cell.secondPageIconImage.image = theme.currentPageIconColorImage
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.boardingPageController.currentPage = indexPath.row
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height:CGFloat =  collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    
}
