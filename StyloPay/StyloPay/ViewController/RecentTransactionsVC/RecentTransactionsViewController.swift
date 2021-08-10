//
//  RecentTransactionsViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 23/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import MessageUI

class RecentTransactionsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> RecentTransactionsViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! RecentTransactionsViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var manageCardButton: UIButton!
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var exchangeMoneyButton: UIButton!
    @IBOutlet weak var recentTransactionsButton: UIButton!
    @IBOutlet weak var moreOptionsButton: UIButton!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var transactionMainView: UIView!
    
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDateButton: UIButton!
    
    @IBOutlet weak var walletBalanceView: UIView!
    @IBOutlet weak var walletBalanceBackgroundImage: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var downloadPDFButton: UIButton!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var mailPdfButton: UIButton!
    
    @IBOutlet weak var recentTransactionTableView: UITableView!{
        didSet{
            recentTransactionTableView.delegate = self
            recentTransactionTableView.dataSource = self
        }
    }
    @IBOutlet weak var headerLbl:UILabel!

    var isDataLoading = false
    var walletBalanceArray = [WalletBalanceModel]()
    let theme = ThemeManager.currentTheme()
    var transactionHistoryArray = [TransactionModel]()
    var filteredHistoryArray = [TransactionModel]()
    var currentPage = 0
    var totalPage = 0
    var totalElements = 0
    var arrRecentTransaction = NSMutableArray()
    var popover:UIPopoverController!
    var startdate = ""
    var toDate = Date()
    var fromDate = Date()
    var endDate = ""
    //var isFiltered = false
    var defaultAmount = ""
    var defaultCurrencyCode = ""
    var isAll = true
    var currencyCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyImageView.isHidden = true
        self.balanceLabel.text = "ALL"
        moreOptionsButton.isHidden = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateInFormat = dateFormatter.string(from: Date())
        let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -30, to: Date())
        let startdateInFormat = dateFormatter.string(from: thirtyDaysBeforeToday ?? Date())
        self.startdate = "\(startdateInFormat)"
        self.endDate = "\(dateInFormat)"

        let displaydateFormatter = dateFormatter
        displaydateFormatter.dateFormat = "dd MMM yyyy"
        let displaydateInFormat = displaydateFormatter.string(from: Date())
        let startdisplaydateInFormat = displaydateFormatter.string(from: thirtyDaysBeforeToday ?? Date())
        self.startDateLabel.text = "\(startdisplaydateInFormat)"
        self.endDateLabel.text = "\(displaydateInFormat)"
        configureTheme()
        configureCell()
        getWalletBalance()
    }

    func configureCell() {
     //   recentTransactionTableView.estimatedRowHeight = 60
        recentTransactionTableView.separatorStyle = .none
        recentTransactionTableView.separatorInset = UIEdgeInsets.zero
        recentTransactionTableView.sectionFooterHeight = 56
        recentTransactionTableView.rowHeight = UITableView.automaticDimension
        recentTransactionTableView.register(UINib(nibName: "RecentTransactionTableViewCell", bundle: nil),forCellReuseIdentifier: "RecentTransactionTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }

    func configureTheme(){
        transactionMainView.clipsToBounds = true
        transactionMainView.layer.cornerRadius = 30
        transactionMainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        transactionMainView.layer.borderWidth = 1.0
        transactionMainView.layer.borderColor = theme.borderColor.cgColor
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        startDateLabel.textColor = theme.bottomUnselectedTabButtonColor
        endDateLabel.textColor = theme.bottomUnselectedTabButtonColor
        headerLbl.textColor = theme.bottomUnselectedTabButtonColor


        let bellImage = AssetsImages.bellIconImage?.withRenderingMode(.alwaysTemplate)
        bellButton.setImage(bellImage, for: .normal)
        bellButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor

        arrowImageView.image = theme.doubleArrowImage
        downloadPDFButton.setImage(theme.downloadImage, for: .normal)
        walletBalanceBackgroundImage.image = theme.buttonsBackgroundImage
        let dropDownImage = AssetsImages.dropdownRedImage?.withRenderingMode(.alwaysTemplate)
        dropDownImageView.image = dropDownImage
        dropDownImageView.tintColor = UIColor.white
        walletBalanceView.layer.cornerRadius = 20
        walletBalanceView.clipsToBounds = true

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

        recentTransactionsButton.setImage(theme.selectedRecentImage, for: .normal)

        let moreOptionsImage = AssetsImages.moreUnselectedIconImage?.withRenderingMode(.alwaysTemplate)
        moreOptionsButton.setImage(moreOptionsImage, for: .normal)
        moreOptionsButton.imageView?.tintColor = theme.bottomUnselectedTabButtonColor

    }

    @IBAction func dropdownButtonPressed(_ sender: Any) {
        let currencyCodeVC = CurrencyCodePopUpViewController.storyboardInstance()
        currencyCodeVC.modalPresentationStyle = .overCurrentContext
        currencyCodeVC.walletBalanceArray = self.walletBalanceArray
        currencyCodeVC.delegate = self
        currencyCodeVC.isFilter = true
        self.navigationController?.present(currencyCodeVC, animated: true, completion: nil)
    }

    @IBAction func startDateButtonPressed(_ sender: Any) {
        //if fromDate < toDate {
            self.transactionDatePicker(isStartDate: true)
//        } else {
//            Global.
//        }
    }

    @IBAction func endDateButtonPressed(_ sender: Any) {
        self.transactionDatePicker(isStartDate: false)
    }

    @IBAction func downloadPDFButtonPressed(_ sender: Any) {
        if self.arrRecentTransaction.count != 0{
            let pdfData = self.recentTransactionTableView.exportAsPdfFromTable()
            let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }

    @IBAction func mailPDFButtonPressed(_ sender: Any) {
        if self.arrRecentTransaction.count != 0{
            sendEmail()
        }
    }

    func sendEmail() {
        let emailId = CustomUserDefaults.getEmailID()
        let pdfData = self.recentTransactionTableView.exportAsPdfFromTable() as Data
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(emailId)"])
            mail.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "Report.pdf")
            mail.setMessageBody("Report", isHTML: true)
            present(mail, animated: true)
        } else {
            showErrorMessage()
        }
    }

    func showErrorMessage() {
        let alertMessage = UIAlertController(title: "could not sent email", message: "check if your device have email support!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertAction.Style.default, handler: nil)
        alertMessage.addAction(action)
        self.present(alertMessage, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }


    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
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


    func filterData(currencyCode : String){
        self.getTransactionHistory(page: 0)
//        self.filteredHistoryArray.removeAll()
//        for index in  0..<arrRecentTransaction.count{
//            if let model = arrRecentTransaction[index] as? TransactionModel {
//                if currencyCode == model.billingCurrencyCode{
//                    self.filteredHistoryArray.append(model)
//                }
//            }
//        }
//        self.recentTransactionTableView.reloadData()
    }


    // MARK: - ScrollView Delegate Methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if refreshController.isRefreshing == true {
//            self.refreshTableView(refresh: self)
//        }
//        if isReload{
//            isReload = false
//        } else {
            if ((recentTransactionTableView.contentOffset.y + recentTransactionTableView.frame.size.height) >= recentTransactionTableView.contentSize.height) {
                if !isDataLoading{
                    isDataLoading = true
                    let totalElement = self.totalElements
                    let currentElements = self.arrRecentTransaction.count

                    if currentElements < totalElement{
                        self.currentPage = self.currentPage + 1
                        if self.currentPage < self.totalPage {
                            self.getTransactionHistory(page: self.currentPage)
                        }
                    }
                }
            }
        //}
    }
}


extension RecentTransactionsViewController: CurrencyCodeDelegate{
    func tabCountryCode(country: String, currencyCode: String, countryFlag: String, currencyIcon: String, currencySymbol: String,isTo: Bool, isFrom: Bool, isFiltered: Bool) {
        if currencyCode == "ALL"{
            self.currencyImageView.isHidden = true
            self.balanceLabel.text = "ALL"
            self.isAll = true
            self.currencyCode = ""
            //self.isFiltered = false
            self.getWalletBalance()
        }else{
            self.currencyImageView.isHidden = false
            self.isAll = false
            self.currencyCode = currencyCode
           // self.isFiltered = isFiltered
            var isExist = false
            let currencyImage = UIImage(named: currencyIcon)?.withRenderingMode(.alwaysTemplate)
            self.currencyImageView.image = currencyImage
            self.currencyImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            for i in 0..<self.walletBalanceArray.count{
                if self.walletBalanceArray[i].curSymbol == currencyCode{
                    self.balanceLabel.text = "\(walletBalanceArray[i].balance)"
                    isExist = true
                    break
                }else{
                    isExist = false
                }
            }
            if !isExist{
                self.balanceLabel.text = "0.00"
            }
            self.filterData(currencyCode: currencyCode)
        }
    }
}

extension RecentTransactionsViewController{

    fileprivate func dateValidation(isStartDate: Bool) {
        //if self.fromDate < self.toDate {
            self.getTransactionHistory(page: 0)
//        } else {
//            if isStartDate{
//                Global.showAlert(withMessage: "Please select a proper from date")
//            }else {
//                Global.showAlert(withMessage: "Please select a proper to date")
//            }
//            //Global.showAlert(withMessage: "Please Select a proper Date")
//        }
    }

    func transactionDatePicker(isStartDate:Bool){
        var datePickerTitle = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentDateTime : Date?
        if isStartDate{
            datePickerTitle = "Select Start Date"
            if !startdate.isEmpty{
                currentDateTime = dateFormatter.date(from: startdate)
            }else{
                currentDateTime = Date()
            }
        } else {
            datePickerTitle = "Select End Date"
            if !endDate.isEmpty{
                currentDateTime = dateFormatter.date(from: endDate)
            }else{
                currentDateTime = Date()
            }
        }
        let datePicker = ActionSheetDatePicker(title: datePickerTitle, datePickerMode: UIDatePicker.Mode.date, selectedDate: currentDateTime, doneBlock: {
            picker, value, index in
            let dateValue = value as! Date
            let dateInFormat = dateFormatter.string(from: dateValue)
            //let dateValue = value as! Date
            if isStartDate{
                self.fromDate = value as! Date
                //if dateValue < self.toDate {
                    self.startdate = "\(dateInFormat)"
                    let displaydateFormatter = DateFormatter()
                    displaydateFormatter.dateFormat = "dd MMM yyyy"
                    let displaydateInFormat = displaydateFormatter.string(from: value as! Date)
                    self.startDateLabel.text = "\(displaydateInFormat)"
                //}
//                self.startdate = "\(dateInFormat)"
//                self.fromDate = value
//                let displaydateFormatter = DateFormatter()
//                displaydateFormatter.dateFormat = "dd MMM yyyy"
//                let displaydateInFormat = displaydateFormatter.string(from: value as! Date)
//                self.startDateLabel.text = "\(displaydateInFormat)"
            }else{
                 self.toDate = value as! Date
               // if dateValue > self.fromDate {
                    self.endDate = "\(dateInFormat)"
                    let displaydateFormatter = DateFormatter()
                    displaydateFormatter.dateFormat = "dd MMM yyyy"
                    let displaydateInFormat = displaydateFormatter.string(from: dateValue)
                    self.endDateLabel.text = "\(displaydateInFormat)"
                //}
//                else {
//                    Global.showAlert(withMessage: "Please select a proper to date")
//                }
//                self.endDate = "\(dateInFormat)"
//                self.toDate = value
//                let displaydateFormatter = DateFormatter()
//                displaydateFormatter.dateFormat = "dd MMM yyyy"
//                let displaydateInFormat = displaydateFormatter.string(from: value as! Date)
//                self.endDateLabel.text = "\(displaydateInFormat)"
            }
            DispatchQueue.main.async {
                self.dateValidation(isStartDate: isStartDate)
            }
            return
        }, cancel: { _ in return }, origin: self.view)
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        if isStartDate{
            datePicker?.maximumDate = dateFormatter.date(from: self.endDate)
        } else {
            datePicker?.minimumDate = dateFormatter.date(from: self.startdate)

            datePicker?.maximumDate = Date()
        }

        if #available(iOS 13.0, *) {
            datePicker?.toolbarButtonsColor = .label
            datePicker?.pickerBackgroundColor = .systemGray6
            datePicker?.toolbarBackgroundColor = .systemGray3
        }
        else{
            datePicker?.toolbarButtonsColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        datePicker?.show()
    }
}

extension RecentTransactionsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRecentTransaction.count
//        if isFiltered{
//            return self.filteredHistoryArray.count
//        }else{
//            return self.arrRecentTransaction.count//self.transactionHistoryArray.count
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let recenttransactionCell =  tableView.dequeueReusableCell(withIdentifier: "RecentTransactionTableViewCell", for: indexPath) as? RecentTransactionTableViewCell{
            if let model = self.arrRecentTransaction[indexPath.row] as? TransactionModel{
                recenttransactionCell.configureCell(data: model)
            }
//            if isFiltered{
//                let model = self.filteredHistoryArray[indexPath.row]
//                recenttransactionCell.configureCell(data: model)
//            }else{
//                if let model = self.arrRecentTransaction[indexPath.row] as? TransactionModel{
//                    recenttransactionCell.configureCell(data: model)
//                }
//            }
            return recenttransactionCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let popupVC = TransactionDetailsPoUPViewController()

//        if isFiltered{
//            let model = self.filteredHistoryArray[indexPath.row]
//            popupVC.dataModel = model
//        }else{
            if let model = self.arrRecentTransaction[indexPath.row] as? TransactionModel{
                popupVC.dataModel = model
                self.present(popupVC, animated: true, completion: nil)
            }
        //}
       //popupVC.modalPresentationStyle = .overCurrentContext
       // popupVC.modalTransitionStyle = .crossDissolve

    }
}

extension RecentTransactionsViewController{
    func getWalletBalance(){
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/getWalletBalance/\(customerHashId)/\(walletHashId)"
        Alert.showProgressHud(onView: self.view)
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if let error =  response["error"] as? String {
                        if error == "invalid_token"{
                            AmplifyManager.getWalletAccessToken { (isSuccess, error) in
                                if error != nil {
                                    if error == "Bad credentials"{
                                        DispatchQueue.main.async {
                                            Global.showAlertWithTwoHandler(strMessage: "Please complete your profile", strActionOne: "OK", strActionTwo: "Skip", okBlock: {
                                                CustomUserDefaults.setisAuth(data: false)
                                                let vc = AccountActivationViewController.storyboardInstance()
                                                self.navigationController?.pushViewController(vc, animated: false)
                                            }, cancelBlock: {})
                                        }
                                    }
                                }else{
                                    if isSuccess ?? false{
                                        self.getWalletBalance()
                                    }
                                }
                            }
                        }
                    }
                } else{
                    self.walletBalanceArray.removeAll()
                    if let walletBalanceresponse = responseArray{
                        for data in walletBalanceresponse{
                            let walletBalanceData = WalletBalanceModel(data)
                            self.walletBalanceArray.append(walletBalanceData)
                            if walletBalanceData.defaultValue{
                                self.setupDefaultIcon(walletBalanceData: walletBalanceData)
                            }
                        }
                    }
                    self.getTransactionHistory(page: 0)
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }

    func setupDefaultIcon(walletBalanceData: WalletBalanceModel){
        if !isAll
        {
        self.defaultAmount = "\(walletBalanceData.balance)"
        self.defaultCurrencyCode = "\(walletBalanceData.curSymbol)"
        self.balanceLabel.text = "\(walletBalanceData.balance)"
        for i in 0..<currencyData.count{
            let icon = currencyData[i]["currencyIcon"] as? String ?? ""
            let code = currencyData[i]["currencyCode"] as? String ?? ""
            if walletBalanceData.curSymbol == code{
                self.currencyImageView.isHidden = false
                let image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                self.currencyImageView.image = image
                self.currencyImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                break
            }
        }
        }
        else {
            self.balanceLabel.text = "ALL"
            self.currencyImageView.isHidden = true

        }
    }

    func getTransactionHistory(page: Int) {
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let walletHashId = CustomUserDefaults.getwalletHashId()
        let url = "\(mainUrl)/api/v1/getTransaction/\(customerHashId)/\(walletHashId)?endDate=\(self.endDate)&startDate=\(self.startdate)&page=\(page)&size=10&authCurrency=\(self.currencyCode)"
        print(url)
        Alert.showProgressHud(onView: self.view)
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject, responseArray, error)  in
            Alert.hideProgressHud(onView: self.view)
            if error == nil {
                if let response = responseObject{
                    if let error =  response["error"] as? String {
                        if error == "invalid_token"{
                            AmplifyManager.getWalletAccessToken { (isSuccess, error) in
                                if error != nil {
                                    if error == "Bad credentials"{
                                        DispatchQueue.main.async {
                                            Global.showAlertWithTwoHandler(strMessage: "Please complete your profile", strActionOne: "OK", strActionTwo: "Skip", okBlock: {
                                                CustomUserDefaults.setisAuth(data: false)
                                                let vc = AccountActivationViewController.storyboardInstance()
                                                self.navigationController?.pushViewController(vc, animated: false)
                                            }, cancelBlock: {})
                                        }
                                    }
                                }else{
                                    if isSuccess ?? false{
                                        self.currentPage = 0
                                        self.getTransactionHistory(page: 0)
                                    }
                                }
                            }
                        }
                    } else{
                        print(responseObject as! [String: Any])
                        if page == 0{ self.arrRecentTransaction.removeAllObjects() }
                        //self.transactionHistoryArray.removeAll()
                        if let transactionHistoryResponse = responseObject as? [String: Any]{
                            if let totalPages = transactionHistoryResponse["totalPages"] as? Int {
                                self.totalPage = totalPages
                            }
                            if let totalElements = transactionHistoryResponse["totalElements"] as? Int {
                                self.totalElements = totalElements
                            }
                            if let transactionHistoryDataArray = transactionHistoryResponse["content"] as? [[String:Any]]{
                                for data in transactionHistoryDataArray{
                                    let transactionData = TransactionModel(data)
                                    //self.transactionHistoryArray.append(transactionData)
                                    self.arrRecentTransaction.add(transactionData)
                                }
                            }
                        }
                        if self.arrRecentTransaction.count == 0 {
                            self.downloadPDFButton.isEnabled = false
                        }else {
                            self.downloadPDFButton.isEnabled = true
                        }
                        self.recentTransactionTableView.reloadData()
                    }
                } else {
                    let strError : String =  (error?.localizedDescription)!
                    Global.showAlert(withMessage: "\(strError)", sender: self)
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
}
