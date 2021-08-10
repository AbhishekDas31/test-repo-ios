//
//  ProofViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 17/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import AVKit
import Photos
import ActionSheetPicker_3_0
import DropDown

enum AttachmentType: String{
    case camera, video, photoLibrary
}

protocol UpdateProofDelegate : NSObjectProtocol {
    // MARK: - Protocol Metthods
    func tabOnUpdateButton(isUpdated: Bool, row: Int, screenType: String, data: ProofsModel)
}

class ProofViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> ProofViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! ProofViewController
    }
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var proofTableView: UITableView!{
        didSet{
            proofTableView.delegate = self
            proofTableView.dataSource = self
        }
    }
    
    let theme = ThemeManager.currentTheme()
    var docUploadRow = 0
    var isRFI = false
    let centeredDropDown = DropDown()
    let documentTypeDropDown = DropDown()
    var documentTypeArr:[String]?
    let selfieDocumentTypeArr = ["Selfie With ID"]
    lazy var dropDowns: [DropDown] = {
        return [
            self.centeredDropDown
        ]
    }()
    var popover:UIPopoverController!
    var screenTitle = ""
    var screenType = ""
    var rfiData = RFIDetailsModel()
    var screenID = 0
    var picker = UIImagePickerController()
    var proofsDataModelObj = ProofsModel()
    weak var delegate: UpdateProofDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTheme()
        configureCell()
        if screenType == ProofScreenType.ID.rawValue{
            self.getCustomerInfo()
            assignDocTypeArray()

        }else{
            self.proofsDataModelObj.identificationType = ""
            self.proofsDataModelObj.identificationFileDocumentArray.removeAll()
            documentTypeDropDown.dataSource = selfieDocumentTypeArr
        }
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        subTitleLabel.textColor = theme.bottomSelectedTabButtonColor
        updateButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        backButton.setImage(theme.backImage,for: .normal)
        if isRFI {
            self.subTitleLabel.text = "\(self.rfiData.remarks)".uppercased()
        } else {
            self.subTitleLabel.text = "PLEASE UPLOAD A CLEAR IMAGE IN ORDER TO AVOID REJECTION"
        }
    }

    func assignDocTypeArray()
    {

        documentTypeArr = ["NRIC","Passport","FIN","GOVERNMENT ID","Driving Licence"]
        documentTypeDropDown.dataSource = documentTypeArr ?? []
    }
    
    func configureCell() {
        self.screenTitleLabel.text = screenTitle
        proofTableView.estimatedRowHeight = 60
        proofTableView.separatorStyle = .none
        proofTableView.separatorInset = UIEdgeInsets.zero
        proofTableView.sectionFooterHeight = 56
        proofTableView.rowHeight = UITableView.automaticDimension
        proofTableView.register(UINib(nibName: "ProofsTableViewCell", bundle: nil),forCellReuseIdentifier: "ProofsTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func updateButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.proofsDataModelObj.screenType = screenType
        var isDoubleDocument = false
        if screenType == ProofScreenType.ID.rawValue{
            isDoubleDocument = true
        }else{
            isDoubleDocument = false
        }
        if screenType == ProofScreenType.ID.rawValue{
        if ValidationHandler.validateIDProofScreenIDProof(form: self, data: self.proofsDataModelObj, isDoubleDocument: isDoubleDocument){
            if delegate != nil { delegate.tabOnUpdateButton(isUpdated: true, row: screenID, screenType: screenType, data: self.proofsDataModelObj) }
            self.navigationController?.popViewController(animated: true)
        }
        }
        else {
            if ValidationHandler.validateIDProofScreen(form: self, data: self.proofsDataModelObj, isDoubleDocument: isDoubleDocument){
                if delegate != nil { delegate.tabOnUpdateButton(isUpdated: true, row: screenID, screenType: screenType, data: self.proofsDataModelObj) }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProofViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenID == 1{
            return 9
        }else{
            return 8
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let proofsCell =  tableView.dequeueReusableCell(withIdentifier: "ProofsTableViewCell", for: indexPath) as? ProofsTableViewCell{
            if isRFI {
                self.proofsDataModelObj.identificationType = self.rfiData.rfiDescription
            }
            if screenType == ProofScreenType.ID.rawValue
            {
            proofsCell.configureCellIdProof(row: indexPath.row, data: self.proofsDataModelObj, isRfi: self.isRFI, rfiData: self.rfiData)
             }
            else{
                proofsCell.configureCell(row: indexPath.row, data: self.proofsDataModelObj, isRfi: self.isRFI, rfiData: self.rfiData)
            }
            proofsCell.dataTextField.delegate = self
            proofsCell.delegate = self
            return proofsCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ProofViewController: UITextFieldDelegate{
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if screenType == ProofScreenType.ID.rawValue
        {
        if textField.tag == 0 {
            self.proofsDataModelObj.identificationType = textField.text!
        } else if textField.tag == 1 {
            self.proofsDataModelObj.identificationValue = textField.text!
        } else if textField.tag == 2 {
            self.proofsDataModelObj.identificationDocHolderName = textField.text!
        } else if textField.tag == 3 {
            self.proofsDataModelObj.identificationIssuingAuthority = textField.text!
        } else if textField.tag == 5 {
            self.proofsDataModelObj.identificationIssuingDate = textField.text!
        }
        else if textField.tag == 6 {
            self.proofsDataModelObj.identificationDocExpiry = textField.text!
        }
        }
        else {
            if textField.tag == 0 {
                self.proofsDataModelObj.identificationType = textField.text!
            } else if textField.tag == 1 {
                self.proofsDataModelObj.identificationValue = textField.text!
            } else if textField.tag == 2 {
                self.proofsDataModelObj.identificationDocHolderName = textField.text!
            } else if textField.tag == 3 {
                self.proofsDataModelObj.identificationIssuingAuthority = textField.text!
            } else if textField.tag == 5 {
                self.proofsDataModelObj.identificationIssuingDate = textField.text!
            }
            else if textField.tag == 6 {
                self.proofsDataModelObj.identificationDocExpiry = textField.text!
            }
        }

    }
}


extension ProofViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    // MARK: - Method To show Permissions for Camera and Video Authorisation
    func authorisationStatus(attachmentTypeEnum: AttachmentType){
        if attachmentTypeEnum ==  AttachmentType.camera{
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status{
            case .authorized: // The user has previously granted access to the camera.
                self.openCamera()
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
            case .denied, .restricted:
                self.addAlertForSettings(attachmentTypeEnum)
                return
                
            default:
                break
            }
        }else if attachmentTypeEnum == AttachmentType.photoLibrary{
            let status = PHPhotoLibrary.authorizationStatus()
            switch status{
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary{
                    openGallary()
                }
            case .denied, .restricted:
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        // photo library access given
                        self.openGallary()
                    }
                })
            default:
                break
            }
        }
    }
    
    
    // MARK: - Alert for Redirecting to Seetings ,If permissions are denied.
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        self.navigationController?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
    // MARK: - Method to open camera when user chooses to upload image via camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            DispatchQueue.main.async {
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.present(self.picker, animated: true, completion: nil)
            }
        } else{
            openGallary()
        }
    }
    // MARK: - Method to open photo library when user chooses to upload image via gallery
    func openGallary(){
        DispatchQueue.main.async {
            self.picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.picker.allowsEditing  = true
            if UIDevice.current.userInterfaceIdiom == .phone{
                self.present(self.picker, animated: true, completion: nil)
            } else{
                self.popover = UIPopoverController(contentViewController: self.picker)
            }
        }
    }
    // MARK: - UIImagePickerControllerDelegate Method
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let strBase64 = convertImageToBase64String(img: image)
            
            var documntModel = ProofsDocumentFileModel()
            documntModel.fileType = "jpg"
            documntModel.document = strBase64
            documntModel.uploadImage = image
            let randomString = String.random()
            documntModel.fileName = "IMG_\(randomString).jpg"
//            if docUploadRow == 5{
//
//            }else{
//                documntModel.fileName = "passport-back"
//            }
            var isexist = false
            if screenType == ProofScreenType.ID.rawValue{
                if self.proofsDataModelObj.identificationFileDocumentArray.isEmpty{
                    self.proofsDataModelObj.identificationFileDocumentArray.append(documntModel)
                }else{
                    for index in 0..<self.proofsDataModelObj.identificationFileDocumentArray.count{
                        if self.proofsDataModelObj.identificationFileDocumentArray[index].fileName == documntModel.fileName{
                            isexist = true
                            self.proofsDataModelObj.identificationFileDocumentArray.remove(at: index)
                            self.proofsDataModelObj.identificationFileDocumentArray.append(documntModel)
                            break
                        }else{
                            isexist = false
                        }
                    }
                    if !isexist {
                        self.proofsDataModelObj.identificationFileDocumentArray.append(documntModel)
                    }
                }
            }else{
                self.proofsDataModelObj.identificationFileDocumentArray.removeAll()
                self.proofsDataModelObj.identificationFileDocumentArray.append(documntModel)
            }
            self.proofsDataModelObj.uploadDocument = "Document"
            let cell = self.proofTableView.cellForRow(at: IndexPath(row: docUploadRow, section: 0)) as! ProofsTableViewCell
            if screenType == ProofScreenType.ID.rawValue
            {
                if docUploadRow == 7{
                    cell.dataTextField.text = "Document_Image_1"
                }else{
                    cell.dataTextField.text = "Document_Image_2"
                }
            }
            else {
                if docUploadRow == 7{
                    cell.dataTextField.text = "Document_Image"
                }else{
                    cell.dataTextField.text = "Document_Image_2"
                }
            }
        }
        dismiss(animated: true) {
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
        print("picker cancel.")
    }
}

extension ProofViewController: ProofsActionDelegate{
    func tabOnDropDownButton(cell: ProofsTableViewCell) {
        guard let index = self.proofTableView.indexPath(for: cell) else { return }
//        if screenType == ProofScreenType.ID.rawValue
//        {
        if index.row == 0{
            if !isRFI {
                docTypeShow(cell: cell)
            }
        }
        else if index.row == 4{
            //country
            openCountrySelector()
    }
        else if index.row == 5{
            issueDatePicker(row: index.row)
        }else if index.row == 6{
            expiryDatePicker(row: index.row)
        }
      //  }
//        else {
//            if index.row == 0{
//                if !isRFI {
//                    docTypeShow(cell: cell)
//                }
//            }else if index.row == 3{
//                issueDatePicker(row: index.row)
//            }else if index.row == 4{
//                expiryDatePicker(row: index.row)
//            }
//        }
        
    }
    // model view controller
    
    func docTypeShow(cell: ProofsTableViewCell){
        documentTypeDropDown.anchorView = cell.mainButton
        documentTypeDropDown.direction = .bottom
        // Action triggered on selection
        documentTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.screenType == ProofScreenType.ID.rawValue{
                cell.dataTextField.text = "\(self.documentTypeArr?[index] ?? "")"
                self.proofsDataModelObj.identificationType = "\(self.documentTypeArr?[index] ?? "")"
            }else{
                cell.dataTextField.text = "\(self.selfieDocumentTypeArr[index])"
                self.proofsDataModelObj.identificationType = "\(self.selfieDocumentTypeArr[index])"
            }
            
        }
        documentTypeDropDown.show()
    }
    
    func issueDatePicker(row:Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        let currentDateTime : Date?
        if proofsDataModelObj.identificationIssuingDate != "" {
            
            currentDateTime = dateFormatter.date(from: proofsDataModelObj.identificationIssuingDate)
        } else {
            currentDateTime = Date()
        }
        let datePicker = ActionSheetDatePicker(title: "Select Date of Issuance", datePickerMode: UIDatePicker.Mode.date, selectedDate: currentDateTime, doneBlock: {
            picker, value, index in
            let dateInFormat = dateFormatter.string(from: value as! Date)
            self.proofsDataModelObj.identificationIssuingDate = "\(dateInFormat)"
            if let cell = self.proofTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ProofsTableViewCell{
                cell.dataTextField.text = "\(dateInFormat)"
            }
            return
        }, cancel: { _ in return }, origin: self.view)
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        datePicker?.maximumDate = Date()
        if #available(iOS 14.0, *) {
            datePicker?.datePickerStyle = .automatic
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
    
    func expiryDatePicker(row:Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        let currentDateTime : Date?
        if proofsDataModelObj.identificationDocExpiry != "" {
            
            currentDateTime = dateFormatter.date(from: proofsDataModelObj.identificationDocExpiry)
        } else {
            currentDateTime = Date()
        }
        let datePicker = ActionSheetDatePicker(title: "Select Date of Expiry", datePickerMode: UIDatePicker.Mode.date, selectedDate: currentDateTime, doneBlock: {
            picker, value, index in
            let dateInFormat = dateFormatter.string(from: value as! Date)
            self.proofsDataModelObj.identificationDocExpiry = "\(dateInFormat)"
            if let cell = self.proofTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ProofsTableViewCell{
                cell.dataTextField.text = "\(dateInFormat)"
            }
            return
        }, cancel: { _ in return }, origin: self.view)
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        datePicker?.minimumDate = Date()
        if #available(iOS 14.0, *) {
            datePicker?.datePickerStyle = .automatic
        }
        if #available(iOS 13.0, *) {
            datePicker?.toolbarButtonsColor = .label
            datePicker?.pickerBackgroundColor = .systemGray6
            datePicker?.toolbarBackgroundColor = .systemGray3
        } else {
            datePicker?.toolbarButtonsColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        datePicker?.show()
    }
    
    func tabUploadDropdownButton(cell: ProofsTableViewCell) {
        guard let index = self.proofTableView.indexPath(for: cell) else { return }
        print("Row Tapped : \(index.row)")
        //if index.row == 4{
        self.docUploadRow = index.row
        self.authorisationStatus(attachmentTypeEnum: AttachmentType.photoLibrary)
        picker.delegate = self
        picker.allowsEditing = true
        //}
    }
    
    func tabOnCamera(cell: ProofsTableViewCell) {
        guard let index = self.proofTableView.indexPath(for: cell) else { return }
        print("camera Row Tapped : \(index.row)")
        self.docUploadRow = index.row
        self.authorisationStatus(attachmentTypeEnum: AttachmentType.camera)
        picker.delegate = self
        picker.allowsEditing = true
    }
}

extension ProofViewController{
    func getCustomerInfo(){
        let customerHashId = CustomUserDefaults.getCustomerHashId()
        let url = "\(mainUrl)/api/v1/getCustomer/\(customerHashId)"
        WebServices.getRequest(urlString: url, isAuth: true, isWalletUser: true, xAPIKey: liveWalletXAPIKey) { (responseObject,responseArray, error) in
            if error == nil {
                if let response = responseObject {
                    debugPrint("response:  \(response)")

                        self.proofsDataModelObj.identificationDocHolderName = "\(response["firstName"] as? String ?? "") \(response["lastName"] as? String ?? "")"

                    if let countryCode = response["countryCode"] as? String{
                        let index = isoCode2.indexes(of: countryCode)
                        if index.count == 1
                        {
                            self.proofsDataModelObj.identificationIssuingCountry = countryList[index[0]]
                            self.reloadViewForCountry()
                        }
                        self.proofsDataModelObj.identificationDocIssuanceCountry = countryCode
                    }
                } else {
                    if responseObject?["message"] != nil {
                        //Global.showAlert(withMessage: "\(responseObject?["message"] ?? "Something Went Wrong")", sender: self)
                    }
                }
            } else {
                let strError : String =  (error?.localizedDescription)!
                //Global.showAlert(withMessage: "\(strError)", sender: self)
            }
        }
    }
}

extension ProofViewController:CountryCodeDelegate{

    func openCountrySelector()
    {
        let countryCodeVC = CountryPopUpViewController.storyboardInstance()
        countryCodeVC.modalPresentationStyle = .overCurrentContext
        countryCodeVC.countryNameArray = countryList//self.countryNameArr
       // countryCodeVC.countryFlagArray = countryFlags//self.countryFlagArr
        countryCodeVC.delegate = self
        self.navigationController?.present(countryCodeVC, animated: true, completion: nil)
    }

    func tabCountryCode(country: String, row: Int) {

        self.proofsDataModelObj.identificationIssuingCountry = countryList[row]
        reloadViewForCountry()


    }

    func reloadViewForCountry()
    {
        //assignDocTypeArray()
       // self.proofsDataModelObj.identificationType = ""
        self.proofTableView.reloadData()
    }
}

