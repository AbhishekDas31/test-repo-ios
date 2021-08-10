//
//  ManageMyCardViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 23/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import LocalAuthentication
import CenteredCollectionView


class ManageMyCardViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ManageMyCardViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ManageMyCardViewController
    }
    
    // MARK: - UI Outlet Variables
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardBottomView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var amountSignButton: UIButton!
    @IBOutlet weak var cardOptionsView: UIView!
    @IBOutlet weak var cardDetailsButton: UIButton!
    @IBOutlet weak var updatePInButton: UIButton!
    @IBOutlet weak var replaceCardButton: UIButton!
    @IBOutlet weak var disableCardButton: UIButton!
    @IBOutlet weak var blockCardButton: UIButton!
    @IBOutlet weak var toggleButtonImageview: UIImageView!
    @IBOutlet weak var activateToggleButton: UIButton!
    @IBOutlet weak var activateToggleImageView: UIImageView!
    @IBOutlet weak var currencyCodeOptionsView: UIView!
    @IBOutlet weak var firstCurrencyOptionamountLabel: UILabel!
    @IBOutlet weak var secondCurrencyOptionAmountLabel: UILabel!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var thirdCurrencyOptionAmountLabel: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var detailArrowIMageView: UIImageView!
    @IBOutlet weak var updatePinArrowImageView: UIImageView!
    @IBOutlet weak var replaeCardArrowImageView: UIImageView!
    @IBOutlet weak var blockCardArrowImageView: UIImageView!
    @IBOutlet weak var firstCurrnecyIconImage: UIImageView!
    @IBOutlet weak var moreIconImagw: UIImageView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var secindCurrencyIconImage: UIImageView!
    @IBOutlet weak var thirdCurrencyIconImage: UIImageView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var activateCardView: UIView!
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet weak var upatePinView: UIView!
    @IBOutlet weak var replaceCardView:UIView!
    @IBOutlet weak var disableCardView:UIView!
    @IBOutlet weak var blockCardView:UIView!
    
    // MARK: - Other Variables
    var sortedcurrencyData = [[String: Any]]()
    let emailAddress = CustomUserDefaults.getEmailID()
    var password = ""
    var complianceStatus = CustomUserDefaults.getComplianceStatus()
    let walletAccessToken = CustomUserDefaults.getWalletAccessToken()
    var maskedCardNumber = ""
    //let group = DispatchGroup()
    var selectedCurrenyIcon = UIImage(named: "USD")
    var cardDetailsArray = [CardDetailsModel]()
    var walletBalanceArray = [WalletBalanceModel]()
    //var cardDetailsObject = CardDetailsModel()
    var isCardOptionsVisible = false
    var isCurrencyVisible = false
    var cardTemporaryBlock = "unblock"
    var cardTypes = ["Virtual Card", "Physical Card","Add-On Card","Assigned Card"]
    var cardCodeType = ["GPR_VIR","GPR_PHY", "GPR_VIR","GPR_PHY"]
    let theme = ThemeManager.currentTheme()
    var profileDetails = PersonalnfoModel()
    var selectedRow = IndexPath()
    var nationality = ""
    var addonVirtualID = ""
    var addonPhysicallID = ""
    let group = DispatchGroup()
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        moreOptionsButton.isHidden = true
        cardDetailsArray.removeAll()
        walletBalanceArray.removeAll()
        sortedcurrencyData.removeAll()

        if let password = KeychainService.loadPassword(service: service, account: account){
            self.password = password
        }
        self.configureView()
        setUpFlowlayout()
        if complianceStatus.isEmpty{
            if walletAccessToken.isEmpty{
                self.getWalletAccessToken(emailAddress: emailAddress, password: password, isFetchToken: false)
               // self.callGetCard(false)
            }else{
                self.getAllCardsCustomerInfo()
                    { [weak self](flag) in
                        if flag {
                            self?.callCradInfoAPI()
                             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
                        }
                        // finishing the execution
                }
            }
        }else{
            self.getAllCardsCustomerInfo()
                { [weak self](flag) in
                    if flag {
                        self?.callCradInfoAPI()
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
                    }
                    // finishing the execution
            }
        }

    }

    fileprivate func setUpFlowlayout() {
        cardCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        // Assign delegate and data source
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: cardCollectionView.frame.size.height)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 1.0
        floawLayout.sideItemAlpha = 1.0	
        floawLayout.spacingMode = .fixed(spacing: 10.0)
        cardCollectionView.collectionViewLayout = floawLayout
    }
    
    func configureView(){
        self.navigationController?.navigationBar.isHidden = true
        cardView.layer.cornerRadius = 15.0
        cardBottomView.layer.cornerRadius = 10.0
        cardOptionsView.layer.cornerRadius = 10.0
        self.cardBottomView.isHidden = false
        self.currencyCodeOptionsView.isHidden = true
        cardOptionsView.isHidden = true
        currencyCodeOptionsView.clipsToBounds = true
        currencyCodeOptionsView.layer.cornerRadius = 10
        currencyCodeOptionsView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        configureTheme()
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        cardBottomView.backgroundColor = theme.cardOptionsBackgroundColor
        currencyCodeOptionsView.backgroundColor = theme.cardOptionsBackgroundColor
        amountLabel.textColor = theme.bottomUnselectedTabButtonColor
        subtitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        
        firstCurrencyOptionamountLabel.textColor = theme.bottomUnselectedTabButtonColor
        secondCurrencyOptionAmountLabel.textColor = theme.bottomUnselectedTabButtonColor
        thirdCurrencyOptionAmountLabel.textColor = theme.bottomUnselectedTabButtonColor
        moreLabel.textColor = theme.bottomUnselectedTabButtonColor
        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        manageCardButton.setImage(theme.selectedManageCardImage, for: .normal)
        
        let transferImage = AssetsImages.transferUnselected?.withRenderingMode(.alwaysTemplate)
        transferMoneyButton.setImage(transferImage, for: .normal)
        transferMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let sgddollarImage = AssetsImages.dollarSymbol?.withRenderingMode(.alwaysTemplate)
        amountSignButton.setImage(sgddollarImage, for: .normal)
        amountSignButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let exchangeImage =  AssetsImages.exchangeUnselected?.withRenderingMode(.alwaysTemplate)
        exchangeMoneyButton.setImage(exchangeImage, for: .normal)
        exchangeMoneyButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let recentTansactionImage = AssetsImages.moreOptionsIconImage?.withRenderingMode(.alwaysTemplate)
        recentTransactionsButton.setImage(recentTansactionImage, for: .normal)
        recentTransactionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        
        let addImage = UIImage(named: "add red")?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(addImage, for: .normal)
        addButton.imageView?.tintColor = theme.bottomSelectedTabButtonColor
        
        dropDownButton.setImage(theme.dropDownColorImage, for: .normal)
        
        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        moreIconImagw.image = moreOptionsImage
        moreIconImagw.tintColor = theme.bottomUnselectedTabButtonColor
        let sideMenuImage = AssetsImages.sideMenuIcon?.withRenderingMode(.alwaysTemplate)
        sideMenuButton.setImage(sideMenuImage, for: .normal)
        sideMenuButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        cardOptionsView.layer.borderColor = theme.borderColor.cgColor
        cardOptionsView.layer.borderWidth = 1.0
        
        let arrowImage = UIImage(named: "go")?.withRenderingMode(.alwaysTemplate)
        detailArrowIMageView.image = arrowImage
        detailArrowIMageView.tintColor = theme.bottomSelectedTabButtonColor
        updatePinArrowImageView.image = arrowImage
        updatePinArrowImageView.tintColor = theme.bottomSelectedTabButtonColor
        replaeCardArrowImageView.image = arrowImage
        replaeCardArrowImageView.tintColor = theme.bottomSelectedTabButtonColor
        blockCardArrowImageView.image = arrowImage
        blockCardArrowImageView.tintColor = theme.bottomSelectedTabButtonColor
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.cardCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        isCardOptionsVisible = false
        self.cardOptionsView.isHidden = !isCardOptionsVisible
        
        self.cardBottomView.isHidden = isCardOptionsVisible
    }
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
        }
    }

    func callCradInfoAPI()
    {
        Alert.showProgressHud(onView: self.view)
        self.getCardsInfo()
        self.getWalletBalance()

        group.notify(queue: DispatchQueue.main) {
            Alert.hideProgressHud(onView: self.view)
            self.cardCollectionView.reloadData()
            if !CustomUserDefaults.getkycPopUp() {
            self.showKycPopUp()
            }
        }
    }

    func showKycPopUp()
    {
        if complianceStatus == ComplianceStatusType.IN_PROGRESS.rawValue || complianceStatus.isEmpty {

            let kycVC = KycPopUPVC()
            kycVC.modalPresentationStyle = .overCurrentContext
            kycVC.descritptionString = "Please complete your profile"
            kycVC.delegate = self
            self.navigationController?.present(kycVC, animated: true, completion: nil)
        }else if complianceStatus == ComplianceStatusType.ACTION_REQUIRED.rawValue || complianceStatus == ComplianceStatusType.RFI_RESPONDED.rawValue{
            //   Global.showAlert(withMessage: "Your KYC is being processed and pending approval.", sender: self)
        }else if complianceStatus == ComplianceStatusType.COMPLETED.rawValue{
            //  Global.showAlert(withMessage: "Your KYC is approved", sender: self)
        }else if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue{
            let kycVC = KycPopUPVC()
            kycVC.modalPresentationStyle = .overCurrentContext
            kycVC.descritptionString = self.rfiStatusString()
            kycVC.delegate = self
            self.navigationController?.present(kycVC, animated: true, completion: nil)
        }
        else if complianceStatus == ComplianceStatusType.REJECT.rawValue ||  complianceStatus == ComplianceStatusType.ERROR.rawValue {
            let kycVC = KycPopUPVC()
            kycVC.modalPresentationStyle = .overCurrentContext
            kycVC.descritptionString = "KYC has been Rejected.\nKindly Reinitiate by filling up Profile Details"
            kycVC.delegate = self
            self.navigationController?.present(kycVC, animated: true, completion: nil)
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.cardCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }

    @IBAction func addAmountButtonPressed(_ sender: Any) {
        let loadAmountVC = LoadMoneyViewController.storyboardInstance()
        self.navigationController?.pushViewController(loadAmountVC, animated: true)
    }
    
    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    
    @IBAction func cardDetailsButtonPressed(_ sender: Any) {
        let cardData = self.configureCardDetailsData(index: selectedRow).0
        if cardData.cardStatus == "P_BLOCK" && self.extractedFunc(cardData.cardType,cardData.issuanceType) != "Virtual Card"{
            Global.showAlert(withMessage: "Your card hass been blocked permanently", sender: self)
        }else{
            let cardDetailsVC = CardDetailsOverLayViewController.storyboardInstance()
            cardDetailsVC.modalPresentationStyle = .overCurrentContext
            cardDetailsVC.cardHashId = cardData.cardHashId
            self.navigationController?.present(cardDetailsVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func updatePinButtonPressed(_ sender: Any) {
        let cardData = self.configureCardDetailsData(index: selectedRow).0
        if cardData.cardStatus == "P_BLOCK"{
            Global.showAlert(withMessage: "Your card has been blocked permanently", sender: self)
        }else{
           let updatePinVC = UpdateCardPINViewController.storyboardInstance()
           updatePinVC.cardHashID = cardData.cardHashId
           self.navigationController?.pushViewController(updatePinVC, animated: false)
        }
    }
    @IBAction func currencyViewDropdownPressed(_ sender: Any) {
        if !complianceStatus.isEmpty{
            if isCurrencyVisible{
                cardBottomView.layer.cornerRadius = 10.0
                currencyCodeOptionsView.layer.cornerRadius = 0.0
            }else{
                cardBottomView.layer.cornerRadius = 0.0
                currencyCodeOptionsView.layer.cornerRadius = 10.0
            }
            self.currencyCodeOptionsView.isHidden = isCurrencyVisible
            isCurrencyVisible = !isCurrencyVisible
        }
    }
    
    @IBAction func moreCurrencyOptionButtonPressed(_ sender: Any) {
        let currencyCodeVC = CurrencyCodePopUpViewController.storyboardInstance()
        currencyCodeVC.modalPresentationStyle = .overCurrentContext
        currencyCodeVC.walletBalanceArray = self.walletBalanceArray
        currencyCodeVC.delegate = self
        self.navigationController?.present(currencyCodeVC, animated: true, completion: nil)
    }
    
    @IBAction func replaceCardButtonPressed(_ sender: Any) {
        let cardData = self.configureCardDetailsData(index: selectedRow).0
        if cardData.cardStatus == "P_BLOCK"{
            let cardReplaceVC = CardReplaceOverlayViewController.storyboardInstance()
            cardReplaceVC.modalPresentationStyle = .overCurrentContext
            cardReplaceVC.cardHashId = cardData.cardHashId
            cardReplaceVC.delegate = self
            self.navigationController?.present(cardReplaceVC, animated: true, completion: nil)
        }else{
           Global.showAlert(withMessage: "Permanently Block the card first", sender: self)
        }
    }
    
    @IBAction func disableCardButtonPressed(_ sender: Any) {
        let cardData = self.configureCardDetailsData(index: selectedRow).0
        if cardData.cardStatus != "P_BLOCK" {
            if cardData.cardStatus == "TEMP_BLOCK"{
                self.postDisableEnableCard(blockUnblock: "unblock",cardData.cardHashId)
            }else{
                if cardData.cardType == "GPR_PHY" && cardData.cardStatus == "INACTIVE" {
                    Global.showAlert(withMessage: "Activate your card first", sender: self)
                } else {
                    self.postDisableEnableCard(blockUnblock: "temporaryBlock",cardData.cardHashId)
                }
            }
        } else {
            Global.showAlert(withMessage: "Card Permanently Blocked", sender: self)
        }
    }
    
    @IBAction func toggleActivateButtonPressed(_ sender: Any) {
        let cardData = self.configureCardDetailsData(index: selectedRow).0
        let cardStatus = cardData.cardStatus
        if cardStatus == "INACTIVE" {
            let activateCardVC = ActivateCardViewController.storyboardInstance()
            activateCardVC.modalPresentationStyle = .overCurrentContext
            activateCardVC.proxyNumber = cardData.proxyNumber
            activateCardVC.cardHashId = cardData.cardHashId
            activateCardVC.delegate = self
            self.navigationController?.present(activateCardVC, animated: true, completion: nil)
            //self.activateCardApi(cardHashId: cardData.cardHashId)
        } else if cardStatus == "ACTIVE" {
            Global.showAlert(withMessage: "Card Already Activated", sender: self)
        }
    }
    
    @IBAction func blockCardPressed(_ sender: Any) {
        let cardData = self.configureCardDetailsData(index: selectedRow).0
        if cardData.cardStatus == "P_BLOCK"{
            Global.showAlert(withMessage: "Your card has already been blocked permanently", sender: self)
        } else {
            let cardBlockVC = CardBlockOverLayViewController.storyboardInstance()
            cardBlockVC.delegate = self
            cardBlockVC.modalPresentationStyle = .overCurrentContext
            cardBlockVC.cardHashID = cardData.cardHashId
            if cardData.cardType == "GPR_PHY" && cardData.cardStatus == "INACTIVE" {
                Global.showAlert(withMessage: "Activate your card first", sender: self)
            } else {
                self.navigationController?.present(cardBlockVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func firstCurrencyOptionButtonPressed(_ sender: Any) {
        let tempimage = self.firstCurrnecyIconImage.image
        let amountText = self.firstCurrencyOptionamountLabel.text
        let image = selectedCurrenyIcon?.withRenderingMode(.alwaysTemplate)
        self.firstCurrnecyIconImage.image = image
        self.firstCurrnecyIconImage.tintColor = theme.bottomUnselectedTabButtonColor
        self.firstCurrencyOptionamountLabel.text = self.amountLabel.text
        selectedCurrenyIcon = tempimage
        self.amountSignButton.setImage(tempimage, for: .normal)
        if let amount = amountText{
            self.amountLabel.text = "\(amount)"
        }
        
    }
    
    @IBAction func secondCurrencyOptionButtonPressed(_ sender: Any) {
        let tempimage = self.secindCurrencyIconImage.image
        let amountText = self.secondCurrencyOptionAmountLabel.text
        let image = selectedCurrenyIcon?.withRenderingMode(.alwaysTemplate)
        self.secindCurrencyIconImage.image = image
        self.secindCurrencyIconImage.tintColor = theme.bottomUnselectedTabButtonColor
        self.secondCurrencyOptionAmountLabel.text = self.amountLabel.text
        selectedCurrenyIcon = tempimage
        self.amountSignButton.setImage(tempimage, for: .normal)
        if let amount = amountText{
            self.amountLabel.text = "\(amount)"
        }
    }
    @IBAction func thirdCurrencyOptionButtonPressed(_ sender: Any) {
        let tempimage = self.thirdCurrencyIconImage.image
        let amountText = self.thirdCurrencyOptionAmountLabel.text
        let image = selectedCurrenyIcon?.withRenderingMode(.alwaysTemplate)
        self.thirdCurrencyIconImage.image = image
        self.thirdCurrencyIconImage.tintColor = theme.bottomUnselectedTabButtonColor
        //self.thirdCurrencyIconImage.image = selectedCurrenyIcon
        self.thirdCurrencyOptionAmountLabel.text = self.amountLabel.text
        selectedCurrenyIcon = tempimage
        self.amountSignButton.setImage(tempimage, for: .normal)
        if let amount = amountText{
            self.amountLabel.text = "\(amount)"
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let sendingOptionsVC = ReciverEmailViewController.storyboardInstance()
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

extension ManageMyCardViewController{
    func configureCurrencyBottom(){
        for index in 0..<currencyData.count{
            for walletIndex in 0..<self.walletBalanceArray.count{
                let currencycode = currencyData[index]["currencyCode"] as? String ?? ""
                if self.walletBalanceArray[walletIndex].curSymbol == currencycode{
                    currencyData[index]["isCurrencyAvailable"] = true
                    currencyData[index]["walletBalance"] = self.walletBalanceArray[walletIndex].balance
                    break
                }
            }
        }
        self.sortCurrencyList()
        configureBottomCurrencyIcons()
    }
    
    func sortCurrencyList(){
        self.sortedcurrencyData.removeAll()
        self.sortedcurrencyData = currencyData.sorted { $0["walletBalance"] as? Double ?? 0.0 > $1["walletBalance"] as? Double ?? 0.0 }
    }
    
    func configureBottomCurrencyIcons(){
        var count = 0
        for sortedAmountIndex in 0..<sortedcurrencyData.count{
            let currencycode = sortedcurrencyData[sortedAmountIndex]["currencyCode"] as? String ?? ""
            let currencycodeImageName = sortedcurrencyData[sortedAmountIndex]["currencyIcon"] as? String ?? ""
            let walletbalance = sortedcurrencyData[sortedAmountIndex]["walletBalance"] as? Double ?? 0.00
            let isAvailable = sortedcurrencyData[sortedAmountIndex]["isCurrencyAvailable"] as? Bool ?? false
            for walletIndex in 0..<self.walletBalanceArray.count{
                if !self.walletBalanceArray[walletIndex].defaultValue && isAvailable && currencycode == self.walletBalanceArray[walletIndex].curSymbol{
                    let currencyImage = UIImage(named: currencycodeImageName)?.withRenderingMode(.alwaysTemplate)
                    if count == 0{
                        firstCurrnecyIconImage.image = currencyImage
                        firstCurrencyOptionamountLabel.text = "\(walletbalance)"
                        firstCurrnecyIconImage.tintColor = theme.bottomUnselectedTabButtonColor
                    }else if count == 1{
                        secindCurrencyIconImage.image = currencyImage
                        secondCurrencyOptionAmountLabel.text = "\(walletbalance)"
                        secindCurrencyIconImage.tintColor = theme.bottomUnselectedTabButtonColor
                    }else if count == 2{
                        thirdCurrencyIconImage.image = currencyImage
                        thirdCurrencyOptionAmountLabel.text = "\(walletbalance)"
                        thirdCurrencyIconImage.tintColor = theme.bottomUnselectedTabButtonColor
                    }
                    count = count + 1
                    break
                }else if self.walletBalanceArray[walletIndex].defaultValue && isAvailable && currencycode == self.walletBalanceArray[walletIndex].curSymbol{
                    self.amountLabel.text = "\(walletbalance)"
                    let currencyImage = UIImage(named: currencycodeImageName)?.withRenderingMode(.alwaysTemplate)
                    amountSignButton.setImage(currencyImage, for: .normal)
                    amountSignButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
                    break
                }
            }
            if count == 3{
                break
            }
        }
    }
}

extension ManageMyCardViewController: AddOnCardOptionsDelegate, AddOnCardDetilsDelegate, AssignedCardDetilsDelegate, ActivateCardDetilsDelegate {
    func activateCardDetailsUpdate(lastDigits: String, cardHashId: String) {
        if !cardHashId.isEmpty {
            self.activateCardApi(cardHashId: cardHashId)
        }
    }

    func assignedCardDetailsUpdate(accountNumber: String, lastDigits: String) {
        self.addAssignedCard(accountNumber: accountNumber, cardNumberLast4Digits: lastDigits)
    }
    
    func addonCardDetailsUpdate(options: String, row: Int) {
        let addOnCardDetailsVC = VirtualCardDetailsPopupViewController.storyboardInstance()
        addOnCardDetailsVC.modalPresentationStyle = .overCurrentContext
        addOnCardDetailsVC.delegate = self
        addOnCardDetailsVC.nationality = self.nationality
        self.navigationController?.present(addOnCardDetailsVC, animated: true, completion: nil)
    }
    
    func addonCardDetailsUpdate(firstName: String, middleName: String, lastname: String, emailId: String, mobileNumber: String, code: String) {
        self.addCard(cardType: "GPR_VIR", cardIssuanceAction: "ADD_ON", isDemogOverridden: true, aFName: firstName, aLName: lastname, aMName: middleName, aEmail: emailId, aCountryCode: code, aMobileNumber: mobileNumber)
    }
    
}

extension ManageMyCardViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,CardsActionDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.cardDetailsArray.count > 0 ? self.cardTypes.count + 1 : self.cardTypes.count

    }


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if section == 0 {
        if section != self.cardTypes.count {
            let mainArray  = cardDetailsArray.filter { item in
                return ((self.extractedFunc(item.cardType, item.issuanceType).contains(self.cardTypes[section])) && (item.cardStatus != "P_BLOCK"))

            }
            return (mainArray.count > 0 ? mainArray.count : section == 1 ? 0 : 1)
        }
        else {
            let blockCardArray  = cardDetailsArray.filter { item in
                return (item.cardStatus == "P_BLOCK")

            }
            return  blockCardArray.count
        }
    //}
      // return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "CardCollectionViewCell"), for: indexPath) as! CardCollectionViewCell
        cell.delegate = self
        if indexPath.section != self.cardTypes.count {
            let mainArray  = cardDetailsArray.filter { item in
                return ((self.extractedFunc(item.cardType, item.issuanceType).contains(self.cardTypes[indexPath.section])) && (item.cardStatus != "P_BLOCK"))
            }
            if mainArray.count > 0 {
                let cardType = extractedFunc(mainArray[indexPath.row].cardType,mainArray[indexPath.row].issuanceType)
                cell.configureCardsView(cardDetails: mainArray[indexPath.row], cardType: cardType, isCardAvailable: true, row: indexPath.row)
                return cell
            }
            else {
                cell.configureCardsView(cardDetails: CardDetailsModel(), cardType: self.cardTypes[indexPath.section], isCardAvailable: false, row: indexPath.row)
                return cell
            }
        }
        else {
            let blockCardArray  = cardDetailsArray.filter { item in
                return (item.cardStatus == "P_BLOCK")

            }
            if blockCardArray.count > 0 {
                let cardType = extractedFunc(blockCardArray[indexPath.row].cardType,blockCardArray[indexPath.row].issuanceType)
                cell.configureCardsView(cardDetails: blockCardArray[indexPath.row], cardType: cardType, isCardAvailable: true, row: indexPath.row)
                return cell
            }

            return UICollectionViewCell()

        }

    }
    
    
    func configureCardDetailsData(index: IndexPath) -> (CardDetailsModel,Bool){

        let cardData = CardDetailsModel()
        if index.section != self.cardTypes.count {
            let mainArray  = cardDetailsArray.filter { item in
                return ((self.extractedFunc(item.cardType, item.issuanceType).contains(self.cardTypes[index.section])) && (item.cardStatus != "P_BLOCK"))
                
            }
            if mainArray.count > 0 {
                return (mainArray[index.row],true)
            }
            else {

                return (cardData,false)
            }
        }
        else {
            let blockCardArray  = cardDetailsArray.filter { item in
                return (item.cardStatus == "P_BLOCK")

            }
            if blockCardArray.count > 0 {
                return (blockCardArray[index.row],true)
            }
        }

        return (cardData, false)
    }
    
    func tabCardAddButton(cell: CardCollectionViewCell) {
        guard let index = self.cardCollectionView.indexPath(for: cell) else { return }
        cell.cardEnableDisableButton.isOn = false
        if complianceStatus.isEmpty{
            cell.cardEnableDisableButton.isOn = false
            let kycVC = KycPopUPVC()
            kycVC.modalPresentationStyle = .overCurrentContext
            kycVC.descritptionString = "Please complete your profile, inorder to add card"
            kycVC.delegate = self
            self.navigationController?.present(kycVC, animated: true, completion: nil)
        }else if complianceStatus == "ACTION_REQUIRED" || complianceStatus == ComplianceStatusType.RFI_RESPONDED.rawValue || complianceStatus == ComplianceStatusType.COMPLETED.rawValue{
            self.addCardHandling(index: index, cell: cell)
        }else if complianceStatus == "IN_PROGRESS"{
            let kycVC = KycPopUPVC()
            kycVC.modalPresentationStyle = .overCurrentContext
            kycVC.descritptionString = "Please complete your profile"
            kycVC.delegate = self
            self.navigationController?.present(kycVC, animated: true, completion: nil)
        }else if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue{
            self.getCustomerInfo()
        }else if complianceStatus == ComplianceStatusType.REJECT.rawValue || complianceStatus == ComplianceStatusType.ERROR.rawValue{
            let kycVC = KycPopUPVC()
            kycVC.modalPresentationStyle = .overCurrentContext
            kycVC.descritptionString = "KYC has been Rejected!\nKindly Reinitiate by filling up Profile Details"
            kycVC.delegate = self
            self.navigationController?.present(kycVC, animated: true, completion: nil)
        }
    }
    
    func addCardHandling(index: IndexPath ,cell: CardCollectionViewCell){
        let cardData = self.configureCardDetailsData(index: index).0
        //let cardType = extractedFunc(cardData.cardType, cardData.issuanceType)
        switch index.section {
        case 0:
            self.addCard(cardType: "GPR_VIR", cardIssuanceAction: "new", isDemogOverridden: false, aFName: "", aLName: "", aMName: "", aEmail: "", aCountryCode: "", aMobileNumber: "")
            break
        case 1:
            var isPhysicalCardAdded = false
            if cardData.cardType == "GPR_PHY" && cardData.issuanceType == "primaryCard" {
                    isPhysicalCardAdded = true
                    self.addonPhysicallID = cardData.cardHashId

                }

            if isPhysicalCardAdded{
                self.addCard(cardType: "GPR_PHY", cardIssuanceAction: "ADD_ON", isDemogOverridden: false, aFName: "", aLName: "", aMName: "", aEmail: "", aCountryCode: "", aMobileNumber: "")
            } else {
                self.addCard(cardType: "GPR_PHY", cardIssuanceAction: "new", isDemogOverridden: false, aFName: "", aLName: "", aMName: "", aEmail: "", aCountryCode: "", aMobileNumber: "")
            }
            
            break
        case 2:
            var isVirtualCardAdded = false

            if cardData.cardType == "GPR_VIR" && cardData.issuanceType == "primaryCard" {
                isVirtualCardAdded = true
                self.addonVirtualID = cardData.cardHashId

            }
            if isVirtualCardAdded {
                let addOnCardOptionsVC = VirtualCardOptionsViewController.storyboardInstance()
                addOnCardOptionsVC.modalPresentationStyle = .overCurrentContext
                addOnCardOptionsVC.delegate = self
                self.navigationController?.present(addOnCardOptionsVC, animated: true, completion: nil)
            } else {
                cell.cardEnableDisableButton.isOn = false
                Global.showAlert(withMessage: "Please add Virtual Card First", sender: self)
            }
            break
        case 3:
            let assignedCardDetailsVC = AssignedCardDetailsViewController.storyboardInstance()
            assignedCardDetailsVC.modalPresentationStyle = .overCurrentContext
            assignedCardDetailsVC.delegate = self
            self.navigationController?.present(assignedCardDetailsVC, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func tabOnCard(cell: CardCollectionViewCell) {
        guard let index = self.cardCollectionView.indexPath(for: cell) else { return }
        selectedRow = index
        self.configureCardOptionView(row: index.row)
        if isCardOptionsVisible{
            isCardOptionsVisible = false
            self.cardOptionsView.isHidden = !isCardOptionsVisible
            self.cardBottomView.isHidden = isCardOptionsVisible
        }else{
            isCardOptionsVisible = true
            isCurrencyVisible = false
            self.cardOptionsView.isHidden = !isCardOptionsVisible
            currencyCodeOptionsView.isHidden = isCardOptionsVisible
            self.cardBottomView.isHidden = isCardOptionsVisible
        }
    }
    
    func configureCardOptionView(row: Int) {
        let cardData = self.configureCardDetailsData(index: selectedRow).0
        let isVirtualCard = (cardData.cardType == "GPR_VIR" && cardData.issuanceType != "additionalCard")
        
        self.cardDetailsView.isHidden = !isVirtualCard
        self.activateCardView.isHidden = isVirtualCard
        self.upatePinView.isHidden = isVirtualCard

        if cardData.cardStatus == "TEMP_BLOCK" {
            self.disableCardView.isUserInteractionEnabled = true
            self.disableCardView.alpha = 1
            upatePinView.isUserInteractionEnabled = false
            self.cardDetailsView.isUserInteractionEnabled = false
            self.activateCardView.isUserInteractionEnabled = false
            self.activateCardView.alpha = 0.3
            upatePinView.alpha = 0.3
            cardDetailsView.alpha = 0.3
            self.replaceCardView.isUserInteractionEnabled = false
            self.blockCardView.isUserInteractionEnabled = false
            self.replaceCardView.alpha = 0.3
            self.blockCardView.alpha = 0.3

        }

        else if cardData.cardStatus == "P_BLOCK" && extractedFunc(cardData.cardType, cardData.issuanceType) == "Virtual Card"
        {
            self.replaceCardView.alpha = 1
            self.replaceCardView.isUserInteractionEnabled = true
            upatePinView.isUserInteractionEnabled = false
            self.cardDetailsView.isUserInteractionEnabled = true
            cardDetailsView.alpha = 1
            self.activateCardView.isUserInteractionEnabled = false
            self.activateCardView.alpha = 0.3
            upatePinView.alpha = 0.3

            self.blockCardView.isUserInteractionEnabled = false
            self.blockCardView.alpha = 0.3
            self.disableCardView.isUserInteractionEnabled = false
            self.disableCardView.alpha = 0.3
        }

        else if cardData.cardStatus == "P_BLOCK"
        {
            self.replaceCardView.alpha = 1
            self.replaceCardView.isUserInteractionEnabled = true
            upatePinView.isUserInteractionEnabled = false
            self.cardDetailsView.isUserInteractionEnabled = false
            self.activateCardView.isUserInteractionEnabled = false
            self.activateCardView.alpha = 0.3
            upatePinView.alpha = 0.3
            cardDetailsView.alpha = 0.3
            self.blockCardView.isUserInteractionEnabled = false
            self.blockCardView.alpha = 0.3
            self.disableCardView.isUserInteractionEnabled = false
            self.disableCardView.alpha = 0.3
        }

        else {
            upatePinView.isUserInteractionEnabled = true
            self.cardDetailsView.isUserInteractionEnabled = true
            self.activateCardView.isUserInteractionEnabled = true
            self.activateCardView.alpha = 1
            upatePinView.alpha = 1
            cardDetailsView.alpha = 1
            self.replaceCardView.isUserInteractionEnabled = true
            self.blockCardView.isUserInteractionEnabled = true
            self.replaceCardView.alpha = 1
            self.blockCardView.alpha = 1
            self.disableCardView.isUserInteractionEnabled = true
            self.disableCardView.alpha = 1

        }
        
        if cardData.cardStatus == "TEMP_BLOCK" {
            self.toggleButtonImageview.image = self.theme.switchOnImage
        }else{
            self.toggleButtonImageview.image = UIImage(named: "switch(off)")
        }
        
        if cardData.cardStatus == "INACTIVE" && cardData.cardType == "GPR_PHY" {
            self.activateToggleImageView.image = UIImage(named: "switch(off)")
        }else{
            self.activateToggleImageView.image = self.theme.switchOnImage
        }
        
    }

    private func configureViewAfterchange()
    {
        if isCardOptionsVisible{
            isCardOptionsVisible = false
            self.cardOptionsView.isHidden = !isCardOptionsVisible
            self.cardBottomView.isHidden = isCardOptionsVisible
        }else{
            isCardOptionsVisible = true
            isCurrencyVisible = false
            self.cardOptionsView.isHidden = !isCardOptionsVisible
            currencyCodeOptionsView.isHidden = isCardOptionsVisible
            self.cardBottomView.isHidden = isCardOptionsVisible
        }
    }
}

extension ManageMyCardViewController: CardBlockDelegate, CardReplaceDelegate, CurrencyCodeDelegate {
    
    func tabCountryCode(country: String, currencyCode: String, countryFlag: String, currencyIcon: String,currencySymbol: String, isTo: Bool, isFrom: Bool, isFiltered: Bool) {
        var isExist = false
        let currencyImage = UIImage(named: currencyIcon)?.withRenderingMode(.alwaysTemplate)
        self.selectedCurrenyIcon = currencyImage
        self.amountSignButton.setImage(currencyImage, for: .normal)
        amountSignButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
        for i in 0..<self.walletBalanceArray.count{
            if self.walletBalanceArray[i].curSymbol == currencyCode{
                self.amountLabel.text = "\(self.walletBalanceArray[i].balance)"
                isExist = true
                return
            }else{
                isExist = false
            }
        }
        if !isExist{
            self.amountLabel.text = "0.00"
        }
    }
    
    func cardReplace(cardHashId: String, maskedCardNumber: String) {
        if !cardHashId.isEmpty{
            self.configureViewAfterchange()
            self.callCradInfoAPI()
        }
    }
    
    func cardBlocked(status: String) {
        if status == "Success"{
            self.configureViewAfterchange()
            self.callCradInfoAPI()
        }
    }
}

extension ManageMyCardViewController{
    func getWalletAccessToken(emailAddress: String, password: String, isFetchToken: Bool){
      //  group.enter()
        AmplifyManager.getWalletAccessToken { (isSuccess,error) in
            if isSuccess ?? false{
                if !isFetchToken{
                    self.getAllCardsCustomerInfo()
                        { [weak self](flag) in
                            if flag {
                                self?.callCradInfoAPI()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
                            }
                            // finishing the execution
                    }
                }else{
                    DispatchQueue.main.async {
                        self.callCradInfoAPI()
                    }
                }

            }else{
                if error == "Bad credentials"{
                    DispatchQueue.main.async {
                        if !CustomUserDefaults.getkycPopUp() {
                        self.showKycPopUp()
                        }

                    }
                }
                else{
                    DispatchQueue.main.async {
                        Global.showAlert(withMessage: "\(error ?? "")", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in

                        })
                    }
                }
            }
        }

    }
    
    
    func getAllCardsCustomerInfo(handler: @escaping ((Bool)->Void)){
        print("getAllCardsCustomerInfo")
        let url = "\(mainUrl)/api/v1/fetchCustomer?order=DESC&page=0&size=10&email=\(emailAddress)&mobile="
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            if error == nil {
                if let response = responseArray {
                    debugPrint("response:  \(response)")
                    for i in 0..<response.count{
                        if let complianceStatus = response[i]["complianceStatus"] as? String{
                            self.complianceStatus = complianceStatus
                            CustomUserDefaults.setComplianceStatus(data: complianceStatus)
                            if let customerHashId = response[i]["customerHashId"] as? String{
                                CustomUserDefaults.setCustomerHashId(data: customerHashId)
                            }
                            if let walletHashId = response[i]["walletHashId"] as? String{
                                CustomUserDefaults.setwalletHashId(data: walletHashId)
                            }
                            if let firstName = response[i]["firstName"] as? String{
                                CustomUserDefaults.setFirstname(data: firstName)
                            }
                            if let lastName = response[i]["lastName"] as? String{
                                CustomUserDefaults.setLastname(data: lastName)
                            }
                            if let middleName = response[i]["middleName"] as? String{
                                CustomUserDefaults.setMiddlename(data: middleName)
                            }
                            if let nationality = response[i]["nationality"] as? String{
                                self.nationality = nationality
                            }

                                let profiledata = PersonalnfoModel(response[i])
                                self.profileDetails = profiledata
                               // self.showKycPopUp()

                            handler(true)
                           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
                            //self.callCradInfoAPI()
                        }
                    }
                } else {
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(emailAddress: self.emailAddress, password: self.password, isFetchToken: false)
                           // self.callGetCard(false)
                        }else{
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }else{
                        if let error =  responseObject?["message"] as? String {
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }
                }
            } else {
                handler(false)
                let strError : String =  (error?.localizedDescription)!
                print(strError)
            }
        }
    }
    
    
    func getCardsInfo(){
        print("getAllCardsCustomerInfo")
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/getCard/\(customerHashId)/\(walletHashId)"
        //Alert.showProgressHud(onView: self.view)
        group.enter()
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
           // Alert.hideProgressHud(onView: self.view)
            self.group.leave()
            if error == nil {
               if let response = responseObject{
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(emailAddress: self.emailAddress, password: self.password, isFetchToken: true)
                            //self.callGetCard(true)
                        }
                    }else{
                        if let totalElements = response["totalElements"] as? Int{
                            if totalElements != 0{
                                print("Cards List: \(response)")
                                self.cardDetailsArray.removeAll()
                                if let content = response["content"] as? [[String:Any]]{
                                    for data in content{
                                        let cardData = CardDetailsModel(data)
                                        //self.cardDetailsObject = cardData
                                        self.cardDetailsArray.append(cardData)
                                    }
                                }

                               // self.cardDetailsArray =  self.groupArray(array: self.cardDetailsArray)

                               // self.getWalletBalance()
                            }
                        }
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }

  

    fileprivate func moveBlockinlast(array:[CardDetailsModel]) -> [CardDetailsModel]
    {
        var firstArray = [CardDetailsModel]()
        var lastArray = [CardDetailsModel]()
        for data in array{
            if data.cardStatus == "P_BLOCK"
            {
                lastArray.append(data)
            }
            else {
                firstArray.append(data)
            }
        }

        return firstArray + lastArray
    }

    
    func getWalletBalance(){
        print("getWalletBalance")
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/getWalletBalance/\(customerHashId)/\(walletHashId)"
       // Alert.showProgressHud(onView: self.view)
        group.enter()
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            self.group.leave()
           // Alert.hideProgressHud(onView: self.view)
            if error == nil {
               if let response = responseObject{
                    if let error =  response["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(emailAddress: self.emailAddress, password: self.password, isFetchToken: true)
                           // self.callGetCard(true)
                        }
                    }
               }else{
                self.walletBalanceArray.removeAll()
                if let walletBalanceresponse = responseArray{
                    for data in walletBalanceresponse{
                        let walletBalanceData = WalletBalanceModel(data)
                        self.walletBalanceArray.append(walletBalanceData)
                        if walletBalanceData.defaultValue{
                            self.setupDefaultIcon(walletBalanceData: walletBalanceData)
                        }
                    }
                    self.configureCurrencyBottom()
                }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
    
    
    func setupDefaultIcon(walletBalanceData: WalletBalanceModel){
        self.amountLabel.text = "\(walletBalanceData.balance)"
        for i in 0..<currencyData.count{
            let icon = currencyData[i]["currencyIcon"] as? String ?? ""
            let code = currencyData[i]["currencyCode"] as? String ?? ""
            if walletBalanceData.curSymbol == code{
                let image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                amountSignButton.setImage(image, for: .normal)
                amountSignButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor
                break
            }
        }
    }
    
    func addCard(cardType: String, cardIssuanceAction: String, isDemogOverridden: Bool, aFName:String,aLName:String, aMName:String,aEmail:String, aCountryCode:String, aMobileNumber:String) {
        self.view.endEditing(true)
        var firstname = ""
        var lastname = ""
        if cardType == "GPR_VIR" && cardIssuanceAction == "ADD_ON"{
            firstname = aFName
            lastname = aLName
        } else {
            firstname = CustomUserDefaults.getFirstname()
            lastname = CustomUserDefaults.getLastname()
        }
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/addCard/\(customerHashId)/\(walletHashId)"
        var walletUsername = ""
        if CustomUserDefaults.getEmailID().isEmpty {
            walletUsername = "\(emailAddress)"
        } else {
            walletUsername = CustomUserDefaults.getEmailID()
        }
        var parameters : [String : Any] = ["agent_code": "\(agentCode)","sub_agent_code": "\(subAgentCode)","client_agent_subAgent_name" : "\(clientAgentSubagentName)" , "nonPerso": true, "issuanceMode": "NORMAL_DELIVERY_LOCAL", "logoId": "100",
            "cardFeeCurrencyCode": "SGD", "username": "\(walletUsername)",
            "cardIssuanceAction": "\(cardIssuanceAction)",
            "cardType": "\(cardType)",
            "embossingLine1": "\(firstname) \(lastname)",
            "embossingLine2": "\(firstname) \(lastname)",
            "plasticId": "\(plasticID)"]
        if cardType == "GPR_VIR" {
            parameters.updateValue("1122", forKey: "cardExpiry")
        }
        if cardIssuanceAction == "ADD_ON"{
            if cardType != "GPR_VIR" {
                parameters.updateValue(isDemogOverridden, forKey: "demogOverridden")
                parameters.updateValue("\(self.addonPhysicallID)", forKey: "cardHashId")
            } else {
                parameters.updateValue("\(self.addonVirtualID)", forKey: "cardHashId")
            }
        }
        if isDemogOverridden{
            parameters.updateValue(isDemogOverridden, forKey: "demogOverridden")
            parameters.updateValue("\(aFName)", forKey: "firstName")
            parameters.updateValue("\(aLName)", forKey: "lastName")
            parameters.updateValue("\(aEmail)", forKey: "email")
            parameters.updateValue("\(aCountryCode)", forKey: "countryCode")
            parameters.updateValue("\(aMobileNumber)", forKey: "mobile")
        }
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject , stringResponse, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(emailAddress: self.emailAddress, password: self.password, isFetchToken: true)
                            //self.callGetCard(true)
                        }
                    } else {
                        if let _ = response["cardHashId"] as? String, let _ = response["cardActivationStatus"] as? String, let _ = response["maskedCardNumber"] as? String{
                            self.callCradInfoAPI()
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
    
    func postDisableEnableCard(blockUnblock: String,_ cardHashId:String){
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let strUrl = "\(mainUrl)/api/v1/blockUnblock/\(customerHashId)/\(walletHashId)/\(cardHashId)"
        let parameters : [String : Any] = ["blockAction":"\(blockUnblock)"]
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequest(urlString: strUrl, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject , stringResponse, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(emailAddress: self.emailAddress, password: self.password, isFetchToken: true)
                           // self.callGetCard(true)
                        }else if error == "Not Found"{
                            if let message = response["message"] as? String{
                                Global.showAlert(withMessage: "\(message)", sender: self)
                            }
                        }
                    }else if (response["errors"] != nil) {
                        if let message = response["message"] as? String {
                            Global.showAlert(withMessage: "\(message)", sender: self)
                        }
                    } else{
                        print(response)
                        if let status = response["status"] as? String{
                            if status == "Success"{
                                var message = ""
                                if blockUnblock == "unblock"{
                                    message = "Card Unblocked"

                                }else{
                                    message = "Card Temporarily Blocked"

                                }
                                
                                Global.showAlert(withMessage: message, setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                    self.configureViewAfterchange()
                                    self.callCradInfoAPI()
                                    self.cardTemporaryBlock = blockUnblock
                                    if blockUnblock == "unblock"{
                                        self.toggleButtonImageview.image = UIImage(named: "switch(off)")
                                    }else{
                                        self.toggleButtonImageview.image = self.theme.switchOnImage
                                    }
                                })
                            }
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
    
    
    func getCustomerInfo(){
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let url = "\(mainUrl)/api/v1/getCustomer/\(customerHashId)"
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            if error == nil {
                if let response = responseObject as? [String : Any]{
                    debugPrint("response:  \(response)")
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            AmplifyManager.getWalletAccessToken{(isSuccess, error) in
                                debugPrint(isSuccess ?? false)
                            }
                        }
                    }else{
                        if let error =  responseObject?["message"] as? String {
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }
                    
                    if let complianceStatus = response["complianceStatus"] as? String{
                        CustomUserDefaults.setComplianceStatus(data: complianceStatus)
                        self.complianceStatus = complianceStatus
                        let profiledata = PersonalnfoModel(response)
                        self.profileDetails = profiledata
                        self.showKycPopUp()
                    }
                    
                } else {
                    if let error =  responseObject?["error"] as? String {
                        if error == "invalid_token"{
                            AmplifyManager.getWalletAccessToken{ (isSuccess, error) in
                                debugPrint(isSuccess ?? false)
                            }
                        }
                    }else{
                        if let error =  responseObject?["message"] as? String {
                            Global.showAlert(withMessage: "\(error)", sender: self)
                        }
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                //Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
    
    func addAssignedCard(accountNumber: String, cardNumberLast4Digits: String) {
        self.view.endEditing(true)
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/assignCard/\(customerHashId)/\(walletHashId)"
        let parameters : [String : Any] = ["accountNumber":"\(accountNumber)", "cardNumberLast4Digits": "\(cardNumberLast4Digits)"]
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject , stringResponse, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if let error =  response["error"] as? String {
                        if error == "invalid_token"{
                            self.getWalletAccessToken(emailAddress: self.emailAddress, password: self.password, isFetchToken: true)
                           // self.callGetCard(true)
                        } else {
                            if let message = response["message"] as? String {
                                Global.showAlert(withMessage: "\(message)", sender: self)
                            }
                        }
                    }else{
                        debugPrint(response)
                        if let _ = response["cardHashId"] as? String, let _ = response["cardActivationStatus"] as? String, let _ = response["maskedCardNumber"] as? String{
                            self.callCradInfoAPI()
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
    
    func rfiStatusHandle(){
        let accountActivation = AccountActivationViewController.storyboardInstance()
        accountActivation.rfiDetailsArray = self.profileDetails.rfiDetailsArray
        accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = true
        accountActivation.accountVerificationDataArray[1]["isDataUploaded"] = true
        accountActivation.accountVerificationDataArray[2]["isDataUploaded"] = true
        accountActivation.accountVerificationDataArray[3]["isDataUploaded"] = true
        accountActivation.profileDetails = self.profileDetails
        for items in profileDetails.rfiDetailsArray {
            if items.type == "document" {
                let documenttype = items.documentType.lowercased()
                let discription = items.rfiDescription.lowercased()
                if documenttype == "poi" && discription == "selfiewithid"{
                    accountActivation.selfieRfiHashId = items.rfiHashId
                    accountActivation.isPOI = true
                    accountActivation.accountVerificationDataArray[2]["isDataUploaded"] = false
                }
                else if documenttype == "poi" && discription != "selfiewithid"{
                    accountActivation.accountVerificationDataArray[1]["isDataUploaded"] = false
                    accountActivation.idRfiHashId = items.rfiHashId
                    accountActivation.isPOI = true
                }else if documenttype == "poa"{
                    accountActivation.addressRfiHashID = items.rfiHashId
                    accountActivation.isPOA = true
                    accountActivation.accountVerificationDataArray[3]["isDataUploaded"] = false
                }
            } else {
                accountActivation.profileRfiHashId = items.rfiHashId
                accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = false

            }
        }
        self.navigationController?.pushViewController(accountActivation, animated: true)
    }

    func rfiStatusString() -> String {
        var messageArray = [String]()
        var sequencedArray = [String]()
        messageArray.removeAll()

        for items in profileDetails.rfiDetailsArray {
            if items.type == "document" {


                messageArray.append("\(items.remarks)")
            } else {

                messageArray.append("\(items.remarks)")
            }
        }
        sequencedArray.removeAll()
        for index in 0..<messageArray.count{
            sequencedArray.append("\(index+1). \(messageArray[index])")
        }
        return sequencedArray.joined(separator: "\n")
    }
    
    func configureToggleButton(status: String){
        if status == "TEMP_BLOCK"{
            self.toggleButtonImageview.image = theme.switchOnImage
        }else{
            self.toggleButtonImageview.image = UIImage(named: "switch(off)")
        }
    }

    fileprivate func extractedFunc(_ type: String, _ issuanceType: String) -> String {
        if type ==  "GPR_VIR" && issuanceType != "additionalCard"
        {
            return "Virtual Card"
        }
        else  if type == "GPR_PHY"
        {
            return "Physical Card"
        }
        else if type ==  "GPR_VIR" && issuanceType == "additionalCard"
        {
            return "Add-On Card"
        }
        else  if type == "Assign_card"
        {
            return "Assigned Card"
        }
        else {
            return ""
        }
    }


    
    func activateCardApi(cardHashId: String) {
        self.view.endEditing(true)
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/activateCard/\(customerHashId)/\(walletHashId)/\(cardHashId)"
        let parameters : [String : Any] = [:]
        Alert.showProgressHud(onView: self.view)
        WebServices.postRequest(urlString: url, paramDict: parameters, isWalletUser: true, isAuth: true, xAPIKey: liveWalletXAPIKey){ (responseObject , stringResponse, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if (response["error"] as? String) != nil {
                        if let message = response["message"] as? String {
                            Global.showAlert(withMessage: "\(message)", sender: self)
                        }
                    } else {
                        print(response)
                        if let status = response["status"] as? String{
                            if status == "Active"{
                                Global.showAlert(withMessage: "Card Activated Successfully", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
                                    self.callCradInfoAPI()
                                    self.activateToggleImageView.image = self.theme.switchOnImage
                                })
                            }
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

extension ManageMyCardViewController:OpenAccountactivation{
    func openAccountActivation() {
        CustomUserDefaults.setkycPopUp(data: true)
        if complianceStatus.isEmpty{
            CustomUserDefaults.setisAuth(data: false)
            let accountActivation = AccountActivationViewController.storyboardInstance()
            self.navigationController?.pushViewController(accountActivation, animated: true)

        }
        else if complianceStatus == ComplianceStatusType.IN_PROGRESS.rawValue{
            CustomUserDefaults.setisAuth(data: false)
            let accountActivation = AccountActivationViewController.storyboardInstance()
            accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = true
            self.navigationController?.pushViewController(accountActivation, animated: true)

        }else if complianceStatus == ComplianceStatusType.ACTION_REQUIRED.rawValue || complianceStatus == ComplianceStatusType.RFI_RESPONDED.rawValue{
            //     Global.showAlert(withMessage: "Your KYC is being processed and pending approval.", sender: self)
        }
        else if complianceStatus == ComplianceStatusType.COMPLETED.rawValue{
            // Global.showAlert(withMessage: "Your KYC is approved", sender: self)
        }
        else if complianceStatus == ComplianceStatusType.RFI_REQUESTED.rawValue{
            CustomUserDefaults.setisAuth(data: true)
            self.rfiStatusHandle()
        }
        else if complianceStatus == ComplianceStatusType.REJECT.rawValue ||  complianceStatus == ComplianceStatusType.ERROR.rawValue {
            CustomUserDefaults.setisAuth(data: false)
            let accountActivation = AccountActivationViewController.storyboardInstance()
            accountActivation.accountVerificationDataArray[0]["isDataUploaded"] = false
            self.navigationController?.pushViewController(accountActivation, animated: true)
        }
    }
}
