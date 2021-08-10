//
//  AddressProofViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 25/06/20.
//  Copyright © 2020 Anmol Aggarwal. All rights reserved.
//

import UIKit
import AVKit
import Photos
import ActionSheetPicker_3_0
import DropDown

class AddressProofViewController: UIViewController {
    
    // MARK: - StoryBoard Instance
    static func storyboardInstance() -> AddressProofViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! AddressProofViewController
    }

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainBackgroundImageView: UIImageView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addressProofTableView: UITableView!{
        didSet{
            addressProofTableView.delegate = self
            addressProofTableView.dataSource = self
        }
    }
    
    let theme = ThemeManager.currentTheme()
    let centeredDropDown = DropDown()
    let documentTypeDropDown = DropDown()
    let documentTypeArr = ["Utility Bill", "Govt. Letter", "Bank Statement"]
    lazy var dropDowns: [DropDown] = {
        return [
            self.centeredDropDown
        ]
    }()
    var picker = UIImagePickerController()
    var proofsDataModelObj = ProofsModel()
    var proofsDataModelObjArray = [ProofsModel]()
    var requestDataArray = [[String: Any]]()
    var subrequestDataArray = [[String: Any]]()
    var popover:UIPopoverController!
    var rfiData = RFIDetailsModel()
    var isRfi = false
    var screenType = ""
    var screenID = 0
    var docUploadRow = 0
    weak var delegate: UpdateProofDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentTypeDropDown.dataSource = documentTypeArr
        configureCell()
        configureTheme()
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        mainBackgroundImageView.isHidden = theme.backgroundImageHidden
        screenTitleLabel.textColor = theme.bottomUnselectedTabButtonColor
        subTitleLabel.textColor = theme.bottomSelectedTabButtonColor
        updateButton.setBackgroundImage(theme.buttonsBackgroundImage, for: .normal)
        backButton.setImage(theme.backImage,for: .normal)
        if isRfi {
            self.subTitleLabel.text = "\(self.rfiData.remarks)".uppercased()
        } else {
            self.subTitleLabel.text = "PLEASE UPLOAD A CLEAR IMAGE IN ORDER TO AVOID REJECTION"
        }
    }
    
    func configureCell() {
        addressProofTableView.estimatedRowHeight = 60
        addressProofTableView.separatorStyle = .none
        addressProofTableView.separatorInset = UIEdgeInsets.zero
        addressProofTableView.sectionFooterHeight = 56
        addressProofTableView.rowHeight = UITableView.automaticDimension
        addressProofTableView.register(UINib(nibName: "ProofsTableViewCell", bundle: nil),forCellReuseIdentifier: "ProofsTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.proofsDataModelObj.screenType = screenType
        
        if ValidationHandler.validateAddressProofScreen(form: self, data: self.proofsDataModelObj){
            if delegate != nil { delegate.tabOnUpdateButton(isUpdated: true, row: screenID, screenType: screenType, data: self.proofsDataModelObj) }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension AddressProofViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let proofsCell =  tableView.dequeueReusableCell(withIdentifier: "ProofsTableViewCell", for: indexPath) as? ProofsTableViewCell{
            if isRfi {
                self.proofsDataModelObj.identificationType = self.rfiData.rfiDescription
            }
            proofsCell.configureCell(row: indexPath.row, data: self.proofsDataModelObj, isRfi: self.isRfi, rfiData: self.rfiData)
            proofsCell.dataTextField.delegate = self
            proofsCell.delegate = self
            return proofsCell
        }
        return UITableViewCell()
    }
}
extension AddressProofViewController: UITextFieldDelegate{
    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 0 {
//            self.proofsDataModelObj.identificationType = textField.text!
//        } else if textField.tag == 1 {
//            self.proofsDataModelObj.identificationValue = textField.text!
//        } else if textField.tag == 2 {
//            self.proofsDataModelObj.identificationIssuingAuthority = textField.text!
//        } else if textField.tag == 3 {
//            self.proofsDataModelObj.identificationIssuingDate = textField.text!
//        } else if textField.tag == 4 {
//            self.proofsDataModelObj.identificationDocExpiry = textField.text!
//        }
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
//        else if textField.tag == 5 {
//            self.proofsDataModelObj.uploadDocument = textField.text!
//        }
    }
}
extension AddressProofViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
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
            let randomString = String.random()
            documntModel.fileName = "IMG_\(randomString).jpg"
            documntModel.uploadImage = image
            self.proofsDataModelObj.identificationFileDocumentArray.removeAll()
            self.proofsDataModelObj.identificationFileDocumentArray.append(documntModel)
            self.proofsDataModelObj.uploadDocument = "Document"
            if let cell = self.addressProofTableView.cellForRow(at: IndexPath(row: docUploadRow, section: 0)) as? ProofsTableViewCell{
                cell.dataTextField.text = "Document_Image"
            }
            
        }
        dismiss(animated: true) {
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
}

extension AddressProofViewController: ProofsActionDelegate{
    func tabOnDropDownButton(cell: ProofsTableViewCell) {
        guard let index = self.addressProofTableView.indexPath(for: cell) else { return }
        if index.row == 0{
            if !isRfi {
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
    }
    
    func docTypeShow(cell: ProofsTableViewCell){
        documentTypeDropDown.anchorView = cell.mainButton
        documentTypeDropDown.direction = .bottom
        // Action triggered on selection
        documentTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            cell.dataTextField.text = "\(self.documentTypeArr[index])"
            self.proofsDataModelObj.identificationType = "\(self.documentTypeArr[index])"
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
            let cell = self.addressProofTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ProofsTableViewCell
            cell.dataTextField.text = "\(dateInFormat)"
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
            if let cell = self.addressProofTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ProofsTableViewCell{
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
        }
        else{
           datePicker?.toolbarButtonsColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        datePicker?.show()
    }
    
    func tabUploadDropdownButton(cell: ProofsTableViewCell) {
        guard let index = self.addressProofTableView.indexPath(for: cell) else { return }
        self.docUploadRow = index.row
        self.authorisationStatus(attachmentTypeEnum: AttachmentType.photoLibrary)
        picker.delegate = self
        picker.allowsEditing = true
    }
    
    func tabOnCamera(cell: ProofsTableViewCell) {
        guard let index = self.addressProofTableView.indexPath(for: cell) else { return }
        self.docUploadRow = index.row
        self.authorisationStatus(attachmentTypeEnum: AttachmentType.camera)
        picker.delegate = self
        picker.allowsEditing = true
    }
}
extension AddressProofViewController:CountryCodeDelegate{

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
        self.addressProofTableView.reloadData()
    }
}
